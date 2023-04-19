//
//  ZHCoreModelManager.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ZHCoreModelManager.h"
#import <MagicalRecord.h>

#define ZH_DEFAULT_STORE_NAME @"ZHCoreModelMagic.sqlite"

@interface ZHCoreModelManager()<NSFetchedResultsControllerDelegate>

@property (nonatomic,assign) BOOL setuped;
@property (nonatomic,assign) BOOL isSetupController;

@end

@implementation ZHCoreModelManager

ZH_SHAREINSTANCE_IMPLEMENT(ZHCoreModelManager)

+ (void)setupCoreDataWithName:(NSString *)name{
    [MagicalRecord setupCoreDataStackWithStoreNamed:name];
    [ZHCoreModelManager sharedInstance].setuped = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _setuped = NO;
        _isSetupController = NO;
    }
    return self;
}

- (void)setresultControllerWith:(NSArray <Class> *)class sortedBy:(NSString *)sortedBy predicate:(NSPredicate *)predicate{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_rootSavingContext]];
    [self setupControllers:class attribute:sortedBy selector:@selector(MR_fetchAllSortedBy:ascending:withPredicate:groupBy:delegate:inContext:) argumentTypes:@[sortedBy,predicate,@"",self,context]];
}


- (void)setupControllers:(NSArray *)classs attribute:(NSString *)attributed selector:(SEL)selector argumentTypes:(NSArray *)argumentTypes{
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
    }
    self.isSetupController = YES;
}

- (void)setPackageModels:(NSArray <Class> *)models{
    
}

- (void)addDelegate:(id<ZHCoreModelManagerDelegate>)delegate{
    
}

- (void)removeDelegate:(id<ZHCoreModelManagerDelegate>)delegate{
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
}

#pragma mark - getter

- (BOOL)setuped{
    if(!_setuped){
        [ZHCoreModelManager setupCoreDataWithName:ZH_DEFAULT_STORE_NAME];
        _setuped = YES;
    }
    return _setuped;
}

@end
