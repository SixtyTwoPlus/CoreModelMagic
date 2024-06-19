//
//  ZHCoreModelMagicInternal.m
//  ZHCoreModelMagicExample
//
//  Created by ZHL on 2023/7/19.
//

#import "ZHCoreModelMagicInternal.h"
#import "ZHCoreModelObserver.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation ZHCoreModelMagic

+ (void)zh_setupCoreDataWithName:(NSString *)name{
    [MagicalRecord setupCoreDataStackWithStoreNamed:name];
}

+ (void)zh_setupCoreDataWithAutoMigratingSqliteName:(NSString *)name{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:name];
}

+ (void)zh_setupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate delegate:(id<ZHCoreModelMagicObsDelegate>)delegate{
    [[ZHCoreModelObserver sharedInstance] obsSetupCoreDataNotifyWith:modelClass sortedBy:sortedBy ascending:ascending groupBy:groupBy predicate:predicate delegate:delegate];
}

@end
