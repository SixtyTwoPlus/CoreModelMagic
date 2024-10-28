//
//  ZHCoreModelObserver.m
//  ZHCoreModelMagicExample
//
//  Created by ZHL on 2023/7/19.
//

#import "ZHCoreModelObserver.h"
#import "ZHCoreModelAbstruct.h"
#import "ZHCoreModelTool.h"
#import <MagicalRecord/MagicalRecord.h>

#define CONTROLLER_DELEGATES_KEY @"delegates"
#define CONTROLLER_KEY @"controller"
#define CONTROLLER_MODEL_KEY @"model"

@interface ZHCoreModelObserver()<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSMutableDictionary <NSString *, NSDictionary *> *controllers;
@property (nonatomic,strong) NSHashTable <id <ZHCoreModelMagicObsDelegate>>   *delegates;

@end

@implementation ZHCoreModelObserver

ZH_SHAREINSTANCE_IMPLEMENT(ZHCoreModelObserver)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegates = [NSHashTable weakObjectsHashTable];
        _controllers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - setup controller

- (void)resetupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate{
    
    id entity = [modelClass performSelector:@selector(zh_coreDataEntity)];
    NSString *entityClsName = NSStringFromClass([entity class]);
    
    if(![self.controllers.allKeys containsObject:entityClsName]){
        return;
    }
    
    NSString *groupObjc = ([ZHCoreModelTool zh_isStrNull:groupBy] ? sortedBy : groupBy);
    NSArray * arguments = @[sortedBy,@(ascending),predicate,groupObjc,self,[NSManagedObjectContext MR_rootSavingContext]];
    __autoreleasing NSFetchedResultsController *controller;
    [ZHCoreModelTool classExecute:entity WithSelector:@selector(MR_fetchAllSortedBy:ascending:withPredicate:groupBy:delegate:inContext:) argumentTypes:arguments resultValue:&controller];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.controllers[entityClsName]];
    [dictM setValue:controller forKey:CONTROLLER_KEY];
    
    [self.controllers setValue:dictM forKey:entityClsName];
}

- (void)obsSetupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate delegate:(id <ZHCoreModelMagicObsDelegate>)delegate{
    if(![modelClass isSubclassOfClass:ZHCoreModelAbstruct.class]){
        NSAssert(NO, @"classmust be subClass of ZHCoreModelAbstruct");
        return;
    }
    if(![modelClass respondsToSelector:@selector(zh_coreDataEntity)]){
        NSAssert(NO, @"Subclass must override zh_CoreDataEntity method");
        return;
    }
    [self.delegates addObject:delegate];
    
    id entity = [modelClass performSelector:@selector(zh_coreDataEntity)];
    NSString *entityClsName = NSStringFromClass([entity class]);
    
    NSString *delegateName = NSStringFromClass(delegate.class);
    
    if([self.controllers.allKeys containsObject:entityClsName]){
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.controllers[entityClsName]];
        NSMutableArray *delegeteNames = [NSMutableArray arrayWithArray:dictM[CONTROLLER_DELEGATES_KEY]];
        if(![delegeteNames containsObject:delegateName]){
            [delegeteNames addObject:delegateName];
        }
        [dictM setValue:delegeteNames forKey:CONTROLLER_DELEGATES_KEY];
        [self.controllers setValue:dictM forKey:entityClsName];
        
        return;
    }
    
    NSString *groupObjc = ([ZHCoreModelTool zh_isStrNull:groupBy] ? sortedBy : groupBy);
    NSArray * arguments = @[sortedBy,@(ascending),predicate,groupObjc,self,[NSManagedObjectContext MR_rootSavingContext]];
    
    __autoreleasing NSFetchedResultsController *controller;
    [ZHCoreModelTool classExecute:entity WithSelector:@selector(MR_fetchAllSortedBy:ascending:withPredicate:groupBy:delegate:inContext:) argumentTypes:arguments resultValue:&controller];
    
    NSDictionary *dict = @{
        CONTROLLER_KEY:controller,
        CONTROLLER_MODEL_KEY:NSStringFromClass(modelClass),
        CONTROLLER_DELEGATES_KEY:@[delegateName]
    };
    
    [self.controllers setValue:dict forKey:entityClsName];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    NSString *anObjctClsName = NSStringFromClass([anObject class]);
    
    NSDictionary *dict = self.controllers[anObjctClsName];
    Class modelClass = NSClassFromString(dict[CONTROLLER_MODEL_KEY]);
    NSArray * delegateNames = dict[CONTROLLER_DELEGATES_KEY];
    
    id model = [modelClass performSelector:@selector(zh_reversePackagingWithEntityData:) withObject:anObject];
    
    for (id <ZHCoreModelMagicObsDelegate> delegate in self.delegates) {
        NSString * itemClsName = NSStringFromClass(delegate.class);
        BOOL needNotify = [delegateNames containsObject:itemClsName] && [delegate respondsToSelector:@selector(zh_coreModelObserverCoreDataDidChangeObject:atIndexPath:changeType:newIndexPath:)];
        if(!needNotify){
            continue;
        }
        [delegate zh_coreModelObserverCoreDataDidChangeObject:model atIndexPath:indexPath changeType:type newIndexPath:newIndexPath];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    NSString *anObjctClsName = NSStringFromClass([controller.fetchedObjects.firstObject class]);
    
    NSDictionary *dict = self.controllers[anObjctClsName];
    NSArray * delegateNames = dict[CONTROLLER_DELEGATES_KEY];
    
    for (id <ZHCoreModelMagicObsDelegate> delegate in self.delegates) {
        NSString * itemClsName = NSStringFromClass(delegate.class);
        BOOL needNotify = [delegateNames containsObject:itemClsName] && [delegate respondsToSelector:@selector(zh_coreModelObserverCoreDataDidChangeSection:atIndex:forChangeType:)];
        if(!needNotify){
            continue;
        }
        [delegate zh_coreModelObserverCoreDataDidChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSDictionary *value;
    for (NSDictionary *dict in self.controllers.allValues) {
        if(dict[CONTROLLER_KEY] == controller){
            value = dict;
            break;
        }
    }
    if(!value){
        return;
    }
    NSArray * delegateNames = value[CONTROLLER_DELEGATES_KEY];
    Class modelClass = NSClassFromString(value[CONTROLLER_MODEL_KEY]);
    
    for (id <ZHCoreModelMagicObsDelegate> delegate in self.delegates) {
        NSString * itemClsName = NSStringFromClass(delegate.class);
        BOOL needNotify = [delegateNames containsObject:itemClsName] && [delegate respondsToSelector:@selector(zh_coreModelObserverCoreDataListDidChanged:)];
        if(!needNotify){
            continue;
        }
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSManagedObject * obj in controller.fetchedObjects) {
            id modelObj = [modelClass performSelector:@selector(zh_reversePackagingWithEntityData:) withObject:obj];
            [mutableArr addObject:modelObj];
        }
        [delegate zh_coreModelObserverCoreDataListDidChanged:mutableArr];
    }
}

@end
