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
    NSManagedObjectContext *context = [ZHCoreModelAbstruct context];
    NSManagedObject *obj = [self getOrCreateObjectWithContext:context];
    [self zh_packageEntityData:obj];
    [context MR_saveToPersistentStoreAndWait];
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

#pragma mark - override

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *methodName = NSStringFromSelector(sel);
    if([[self connotResolveMethods] containsObject:methodName]){
        return NO;
    }
    return [super resolveInstanceMethod:sel];
}

#pragma mark - ZHCoreModelActionProtocol

+ (BOOL)zh_deleteAll{
    FORGETINIT
    return [self zh_deleteWithPredicate:ZH_EMPTY_PREDICATE];
}

+ (NSArray *)zh_queryAll{
    FORGETINIT
    return [self zh_queryAllWithPredicate:ZH_EMPTY_PREDICATE]; 
}

+ (BOOL)zh_deleteWithPredicate:(NSPredicate *)predicate{
    FORGETINIT
    BOOL result = NO;
    NSManagedObjectContext *context = [self context];
    [ZHCoreModelTool classExecute:[self zh_coreDataEntity] WithSelector:@selector(MR_deleteAllMatchingPredicate:inContext:) argumentTypes:@[predicate,context] resultValue:&result];
    [context MR_saveToPersistentStoreAndWait];
    return result;
}

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate{
    FORGETINIT
    __autoreleasing NSArray *results;
    [ZHCoreModelTool classExecute:[self zh_coreDataEntity] WithSelector:@selector(MR_findAllWithPredicate:inContext:) argumentTypes:@[predicate,[self context]] resultValue:&results];
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
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    return context;
}

+ (NSArray *)connotResolveMethods{
    return @[
        NSStringFromSelector(@selector(zh_deleteAll)),
        NSStringFromSelector(@selector(zh_queryAll)),
        NSStringFromSelector(@selector(zh_queryAllWithPredicate:)),
        NSStringFromSelector(@selector(zh_deleteWithPredicate:)),
        NSStringFromSelector(@selector(zh_deleteThisData)),
        NSStringFromSelector(@selector(zh_saveOrUpdate)),
    ];
}

@end
