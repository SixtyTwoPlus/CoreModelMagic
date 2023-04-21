//
//  ZHCoreModelManager.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ZHCoreModelObserver.h"
@import MagicalRecord;
#import "ZHCoreModelAbstruct.h"
#import "ZHCoreModelTool.h"

#define ZH_DEFAULT_STORE_NAME @"ZHCoreModelMagic.sqlite"

@interface ZHCoreModelObserver()<NSFetchedResultsControllerDelegate>

@property (nonatomic,assign) BOOL                                            setuped;
@property (nonatomic,assign) BOOL                                            isSetupController;

@property (nonatomic,strong) NSMutableArray                                  *controllers;
@property (nonatomic,strong) NSHashTable <id <ZHCoreModelObserverDelegate>>   *delegates;
@property (nonatomic,copy) NSArray <Class>                                   *notifyObjcs;

@end

@implementation ZHCoreModelObserver

ZH_SHAREINSTANCE_IMPLEMENT(ZHCoreModelObserver)

+ (void)setupCoreDataWithName:(NSString *)name{
    [MagicalRecord setupCoreDataStackWithStoreNamed:name];
    [ZHCoreModelObserver sharedInstance].setuped = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _setuped = NO;
        _isSetupController = NO;
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - method

- (void)setNotificationObjects:(NSArray <Class> *)objects{
    self.notifyObjcs = objects;
}

#pragma mark - setup controller

- (void)setresultControllerWith:(NSArray <Class> *)class sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
    NSString *groupObjc = [ZHCoreModelTool zh_isStrNull:groupBy] ? sortedBy : groupBy;
    [self setupControllers:class  selector:@selector(MR_fetchAllSortedBy:ascending:withPredicate:groupBy:delegate:inContext:) argumentTypes:@[sortedBy,@(ascending),predicate,groupObjc,self,context]];
}

- (void)setResultControllerWith:(NSArray <Class> *)class groupBy:(NSString *)groupBy sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending predicate:(NSPredicate *)predicate{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];
    NSString *sortedByObj = [ZHCoreModelTool zh_isStrNull:sortedBy] ? groupBy : sortedBy;
    [self setupControllers:class selector:@selector(MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending:delegate:inContext:) argumentTypes:@[groupBy,predicate,sortedByObj,@(ascending),self,context]];
}

- (void)setupControllers:(NSArray *)classs selector:(SEL)selector argumentTypes:(NSArray *)argumentTypes{
    if(!self.setuped || self.isSetupController){
        return;
    }
    BOOL canCountinue = YES;
    for (Class cls in classs) {
        if(![cls isSubclassOfClass:NSManagedObject.class]){
            canCountinue = NO;
            break;
        }
    }
    if(!canCountinue){
        NSAssert(NO, @"All class item must be subClass of NSManagedObject");
        return;
    }
    for (Class cls in classs) {
        __autoreleasing NSFetchedResultsController *controller;
        [ZHCoreModelTool classExecute:cls WithSelector:selector argumentTypes:argumentTypes resultValue:&controller];
        [self.controllers addObject:controller];
    }
    self.isSetupController = YES;
}

#pragma mark - delegate

- (void)addDelegate:(id<ZHCoreModelObserverDelegate>)delegate{
    [self.delegates addObject:delegate];
    [self fetchAllData];
}

- (void)removeDelegate:(id<ZHCoreModelObserverDelegate>)delegate{
    [self.delegates removeObject:delegate];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self fetchAllData];
}

- (void)fetchAllData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (Class cls in self.notifyObjcs) {
        if(![cls isSubclassOfClass:ZHCoreModelAbstruct.class]){
            NSAssert(NO, @"The method of setNotificationObjects parameter must be subClass of ZHCoreModelAbstruct");
            return;
        }
        id result = [cls performSelector:@selector(zh_queryAll)];
        [dict setValue:result forKey:NSStringFromClass(cls)];
    }
    for (id delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(zhCoreModelObserverCoreDataListDidChanged:)]){
            [delegate zhCoreModelObserverCoreDataListDidChanged:dict];
        }
    }
}

#pragma mark - getter

- (NSMutableArray *)controllers{
    if(!_controllers){
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

- (BOOL)setuped{
    if(!_setuped){
        [ZHCoreModelObserver setupCoreDataWithName:ZH_DEFAULT_STORE_NAME];
        _setuped = YES;
    }
    return _setuped;
}

@end
