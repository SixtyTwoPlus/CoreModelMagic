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
    }
    return self;
}

- (void)setresultControllerWith:(NSArray <Class> *)class groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate{
    BOOL canCountinue = YES;
    for (Class cls in class) {
        if(![cls isSubclassOfClass:NSManagedObject.class]){
            canCountinue = NO;
            break;
        }
    }
    if(!canCountinue){
        NSAssert(NO, @"All class item must be subClass of NSManagedObject");
        return;
    }
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    for (Class cls in class) {
        __autoreleasing NSFetchedResultsController *controller;
        [ZHCoreModelTool classExecute:cls WithSelector:@selector(MR_fetchAllGroupedBy:withPredicate:sortedBy:ascending:delegate:inContext:) argumentTypes:@[groupBy,predicate,@"",@(NO),self,context] resultValue:&controller];
    }
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
