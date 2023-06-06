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

#define FORGETINIT \
if(![ZHCoreModelObserver sharedInstance].setuped){\
    NSAssert(NO, @"Default context is nil! Did you forget to initialize the Core Data Stack?");\
}

#define WEAK_SELF __weak typeof(self)weakSelf = self;

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
    FORGETINIT
    return [self.class zh_deleteWithPredicate:ZH_PREDICATE(@"id = %@",self.identifier)];
}

- (void)zh_saveOrUpdate{
    FORGETINIT
    [self zh_asyncSaveOrUpdate];
}

- (void)zh_asyncSaveOrUpdate{
    [self zh_asyncSaveOrUpdateWithComplete:nil];
}

- (void)zh_asyncSaveOrUpdateWithComplete:(dispatch_block_t)complete{
    WEAK_SELF
    dispatch_async_and_wait([ZHCoreModelAbstruct serialQueue], ^{
        NSManagedObjectContext *context = [ZHCoreModelAbstruct context];
        NSManagedObject *obj = [weakSelf getOrCreateObjectWithContext:context];
        [weakSelf zh_packageEntityData:obj];
        [context MR_saveToPersistentStoreAndWait];
        if(complete){
            complete();
        }
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
    FORGETINIT
    return [self zh_deleteWithPredicate:ZH_EMPTY_PREDICATE];
}

+ (BOOL)zh_deleteWithKey:(NSString *)key value:(NSString *)value{
    return [self zh_deleteWithPredicate:ZH_PREDICATE(@"%@ = %@",key,value)];
}

+ (NSArray *)zh_queryAll{
    FORGETINIT
    return [self zh_queryAllWithPredicate:ZH_EMPTY_PREDICATE];
}

+ (NSArray *)zh_quertWithKey:(NSString *)key value:(id)value{
    return [self zh_queryAllWithPredicate:ZH_PREDICATE([self generatePredicateStrWithKey:key value:value])];
}

+ (NSArray *)zh_quertWithKey:(NSString *)key value:(id)value sorted:(NSString *)sorted ascending:(BOOL)ascending{
    return [self zh_queryAllWithPredicate:ZH_PREDICATE([self generatePredicateStrWithKey:key value:value]) sorted:sorted ascending:ascending];
}

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate{
    FORGETINIT
    return [self zh_queryAllWithPredicate:predicate sorted:nil ascending:NO];
}

#pragma mark - core method

+ (BOOL)zh_deleteWithPredicate:(NSPredicate *)predicate{
    FORGETINIT
    BOOL result = NO;
    NSManagedObjectContext *context = [self context];
    [ZHCoreModelTool classExecute:[self zh_coreDataEntity] WithSelector:@selector(MR_deleteAllMatchingPredicate:inContext:) argumentTypes:@[predicate,context] resultValue:&result];
    [context MR_saveToPersistentStoreAndWait];
    return result;
}

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate sorted:(NSString *)sorted ascending:(BOOL)ascending{
    FORGETINIT
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

+ (dispatch_queue_t)serialQueue{
    static dispatch_queue_t queue;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        queue = dispatch_queue_create("com.SixtyTwoPlus.ZHCoreModelMagic.SerialQueue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
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

+ (NSManagedObjectContext *)context{
    static NSManagedObjectContext *context;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        context = [NSManagedObjectContext MR_context];
    });
    return context;
}

+ (NSString *)generatePredicateStrWithKey:(NSString *)key value:(id)value{
    return [NSString stringWithFormat:@"%@ = '%@'",key,value];
}

@end
