//
//  ZHCoreModelAbstruct.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ZHCoreModelAbstruct.h"
#import <MagicalRecord/MagicalRecord.h>
#import <YYCache/YYCache.h>
@import ObjectiveC.runtime;
#import "ZHCoreModelTool.h"
#import "ZHCoreModelObserver.h"

#define WEAK_SELF __weak typeof(self)weakSelf = self;


@interface ZHCoreModelAbstructContext : NSObject

ZH_SHAREINSTANCE(ZHCoreModelAbstructContext);

@property (nonatomic,readonly) dispatch_queue_t         serialQueue;
@property (nonatomic,readonly) dispatch_semaphore_t     semaphore;
@property (nonatomic,readonly) NSManagedObjectContext   *context;

@end


@implementation ZHCoreModelAbstructContext

ZH_SHAREINSTANCE_IMPLEMENT(ZHCoreModelAbstructContext)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("com.SixtyTwoPlus.ZHCoreModelMagic.SerialQueue", DISPATCH_QUEUE_SERIAL);
        _semaphore = dispatch_semaphore_create(0);
        _context = [NSManagedObjectContext MR_context];
    }
    return self;
}

@end

@implementation ZHCoreModelAbstruct

- (instancetype)init
{
    self = [super init];
    if (self && [self isMemberOfClass:ZHCoreModelAbstruct.class]) {
        ZH_INIT_EXCEPTION;
    }
    if (![self conformsToProtocol:@protocol(ZHCoreModelProviderProtocol)]){
        [NSException raise:NSInternalInconsistencyException format:@"You must conforms to ZHCoreModelProviderProtocol"];
    }
    return self;
}

#pragma mark - public method

- (BOOL)zh_deleteThisData{
    return [self.class zh_deleteWithPredicate:ZH_PREDICATE(@"id = %@",self.id)];
}

- (void)zh_saveOrUpdate{
    [self zh_asyncSaveOrUpdate];
}

- (void)zh_asyncSaveOrUpdate{
    [self zh_asyncSaveOrUpdateWithComplete:nil];
}

- (void)zh_asyncSaveOrUpdateWithComplete:(dispatch_block_t)complete{
    NSManagedObjectContext *context = [ZHCoreModelAbstruct context];
    
    dispatch_block_t saveBlock = ^{
        dispatch_async(ZHCoreModelAbstructContext.sharedInstance.serialQueue, ^{
            [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                if(complete){
                    complete();
                }
                dispatch_semaphore_signal(ZHCoreModelAbstructContext.sharedInstance.semaphore);
            }];
            dispatch_semaphore_wait(ZHCoreModelAbstructContext.sharedInstance.semaphore, DISPATCH_TIME_FOREVER);
        });
    };
    
    NSManagedObject *obj = [self getOrCreateObjectWithContext:context];
    if ([self respondsToSelector:@selector(zh_coreDataStoreKeys)]) {
        NSArray *keys = [self performSelector:@selector(zh_coreDataStoreKeys)];
        NSDictionary *valueKeys = [self dictionaryWithValuesForKeys:keys];
        for (NSString *key in keys) {
            [obj setValue:valueKeys[key] forKey:key];
        }
        saveBlock();
        return;
    }
    if ([self respondsToSelector:@selector(zh_coreDataStoreCustomKeys)]) {
        NSDictionary *dict = [self performSelector:@selector(zh_coreDataStoreCustomKeys)];
        NSDictionary *valueKeys = [self dictionaryWithValuesForKeys:dict.allKeys];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            [obj setValue:valueKeys[key] forKey:value];
        }];
        saveBlock();
    }
}

#pragma mark - getter

- (NSString *)id{
    if([ZHCoreModelTool zh_isStrNull:_id]){
        _id = [[NSUUID UUID] UUIDString];
    }
    return _id;
}

- (NSDate *)createDate{
    if(!_createDate){
        _createDate = [NSDate date];
    }
    return _createDate;
}

#pragma mark - ZHCoreModelActionProtocol

+ (BOOL)zh_deleteAll{
    return [self zh_deleteWithPredicate:ZH_EMPTY_PREDICATE];
}

+ (BOOL)zh_deleteWithKey:(NSString *)key value:(NSString *)value{
    return [self zh_deleteWithPredicate:ZH_PREDICATE(@"%@ = %@",key,value)];
}

+ (NSArray *)zh_queryAll{
    return [self zh_queryAllWithPredicate:ZH_EMPTY_PREDICATE];
}

+ (NSArray *)zh_quertWithKey:(NSString *)key value:(id)value{
    return [self zh_queryAllWithPredicate:ZH_PREDICATE([self generatePredicateStrWithKey:key value:value])];
}

+ (NSArray *)zh_quertWithKey:(NSString *)key value:(id)value sorted:(NSString *)sorted ascending:(BOOL)ascending{
    return [self zh_queryAllWithPredicate:ZH_PREDICATE([self generatePredicateStrWithKey:key value:value]) sorted:sorted ascending:ascending];
}

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate{
    return [self zh_queryAllWithPredicate:predicate sorted:nil ascending:NO];
}

#pragma mark - core method

+ (BOOL)zh_deleteWithPredicate:(NSPredicate *)predicate{
    BOOL result = NO;
    NSManagedObjectContext *context = [self context];
    Class cls = [self performSelector:@selector(zh_coreDataEntity)];
    [ZHCoreModelTool classExecute:cls WithSelector:@selector(MR_deleteAllMatchingPredicate:inContext:) argumentTypes:@[predicate,context] resultValue:&result];
    [context MR_saveToPersistentStoreAndWait];
    return result;
}

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate sorted:(NSString *)sorted ascending:(BOOL)ascending{
    __autoreleasing NSArray *results;
    BOOL needSort = ![ZHCoreModelTool zh_isStrNull:sorted];
    NSArray *arr = @[predicate,[self context]];
    SEL method = @selector(MR_findAllWithPredicate:inContext:);
    //是否需要排序
    if(needSort){
        method = @selector(MR_findAllSortedBy:ascending:withPredicate:inContext:);
        arr = [@[sorted,@(ascending)] arrayByAddingObjectsFromArray:arr];
    }
    Class cls = [self performSelector:@selector(zh_coreDataEntity)];
    [ZHCoreModelTool classExecute:cls WithSelector:method argumentTypes:arr resultValue:&results];
    NSMutableArray *repackagineArray = [NSMutableArray array];
    for (NSManagedObject *obj in results) {
        id model = [self zh_reversePackagingWithEntityData:obj];
        [repackagineArray addObject:model];
    }
    return repackagineArray;
}

+ (instancetype)zh_reversePackagingWithEntityData:(NSManagedObject *)obj{
    id model = [[self alloc]init];
    if ([model respondsToSelector:@selector(zh_coreDataStoreKeys)]) {
        NSArray *keys = [model performSelector:@selector(zh_coreDataStoreKeys)];
        for (NSString *key in keys) {
            [model setValue:[obj valueForKey:key] forKey:key];
        }
        return model;
    }
    if ([model respondsToSelector:@selector(zh_coreDataStoreCustomKeys)]) {
        NSDictionary *dict = [model performSelector:@selector(zh_coreDataStoreCustomKeys)];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            [model setValue:[obj valueForKey:value] forKey:key];
        }];
    }
    return model;
}

#pragma mark - private method

+ (NSManagedObjectContext *)context{
    return [ZHCoreModelAbstructContext sharedInstance].context;
}

- (NSManagedObject *)getOrCreateObjectWithContext:(NSManagedObjectContext *)context{
    __autoreleasing NSManagedObject *obj;
    Class entityClass = [self.class zh_coreDataEntity];
    [ZHCoreModelTool classExecute:entityClass WithSelector:@selector(MR_findFirstWithPredicate:inContext:) argumentTypes:@[ZH_PREDICATE(@"id = %@",self.id),context] resultValue:&obj];
    if(!obj){
        [ZHCoreModelTool classExecute:entityClass WithSelector:@selector(MR_createEntityInContext:) argumentTypes:@[context] resultValue:&obj];
    }
    return obj;
}

+ (NSString *)generatePredicateStrWithKey:(NSString *)key value:(id)value{
    if([value isKindOfClass:NSArray.class] || [value isKindOfClass:NSDictionary.class] || [value isKindOfClass:NSSet.class]){
        NSAssert(NO, @"Value cannot be container objects");
        return nil;
    }
    if([value isKindOfClass:NSString.class]){
        return [NSString stringWithFormat:@"%@ = '%@'",key,value];
    }
    NSNumber *num = (NSNumber *)value;
    if (num.integerValue != num.floatValue) {
        CGFloat f = num.floatValue;
        return [NSString stringWithFormat:@"%@ = %f",key,f];
    } else {
        NSInteger i = num.integerValue;
        return [NSString stringWithFormat:@"%@ = %ld",key,i];
    }
}

@end
