//
//  ZHCoreModelAbstruct.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ZHCoreModelAbstruct.h"
@import MagicalRecord;
@import YYCache;
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
    return self;
}

#pragma mark - public method

- (BOOL)zh_deleteThisData{
    return [self.class zh_deleteWithPredicate:ZH_PREDICATE(@"id = %@",self.identifier)];
}

- (void)zh_saveOrUpdate{
    [self zh_asyncSaveOrUpdate];
}

- (void)zh_asyncSaveOrUpdate{
    [self zh_asyncSaveOrUpdateWithComplete:nil];
}

- (void)zh_asyncSaveOrUpdateWithComplete:(dispatch_block_t)complete{
    NSManagedObjectContext *context = [ZHCoreModelAbstruct context];
    NSManagedObject *obj = [self getOrCreateObjectWithContext:context];
    [self zh_packageEntityData:obj];
    dispatch_async(ZHCoreModelAbstructContext.sharedInstance.serialQueue, ^{
        [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if(complete){
                complete();
            }
            dispatch_semaphore_signal(ZHCoreModelAbstructContext.sharedInstance.semaphore);
        }];
        dispatch_semaphore_wait(ZHCoreModelAbstructContext.sharedInstance.semaphore, DISPATCH_TIME_FOREVER);
    });
}

#pragma mark - getter

- (NSString *)identifier{
    if([ZHCoreModelTool zh_isStrNull:_identifier]){
        _identifier = [[NSUUID UUID] UUIDString];
    }
    return _identifier;
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
    [ZHCoreModelTool classExecute:[self zh_coreDataEntity] WithSelector:@selector(MR_deleteAllMatchingPredicate:inContext:) argumentTypes:@[predicate,context] resultValue:&result];
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
    [ZHCoreModelTool classExecute:[self zh_coreDataEntity] WithSelector:method argumentTypes:arr resultValue:&results];
    NSMutableArray *repackagineArray = [NSMutableArray array];
    for (NSManagedObject *obj in results) {
        id model = [self zh_reversePackagingWithEntityData:obj];
        [repackagineArray addObject:model];
    }
    return repackagineArray;
}

#pragma mark - ZHCoreModelProviderProtocol

+ (Class)zh_coreDataEntity{
    ZH_OVERRIDE_EXCEPTION
    return NULL;
}

- (void)zh_packageEntityData:(NSManagedObject *)objc{
    ZH_OVERRIDE_EXCEPTION
}

+ (instancetype)zh_reversePackagingWithEntityData:(NSManagedObject *)objc{
    ZH_OVERRIDE_EXCEPTION
    return nil;
}

#pragma mark - private method

+ (NSManagedObjectContext *)context{
    return [ZHCoreModelAbstructContext sharedInstance].context;
}

- (NSManagedObject *)getOrCreateObjectWithContext:(NSManagedObjectContext *)context{
    __autoreleasing NSManagedObject *obj;
    Class entityClass = [self.class zh_coreDataEntity];
    [ZHCoreModelTool classExecute:entityClass WithSelector:@selector(MR_findFirstWithPredicate:inContext:) argumentTypes:@[ZH_PREDICATE(@"id = %@",self.identifier),context] resultValue:&obj];
    if(!obj){
        [ZHCoreModelTool classExecute:entityClass WithSelector:@selector(MR_createEntityInContext:) argumentTypes:@[context] resultValue:&obj];
    }
    return obj;
}

+ (NSString *)generatePredicateStrWithKey:(NSString *)key value:(id)value{
    return [NSString stringWithFormat:@"%@ = '%@'",key,value];
}

@end
