//
//  ZHCoreModelMagicInternal.m
//  ZHCoreModelMagicExample
//
//  Created by ZHL on 2023/7/19.
//

#import "ZHCoreModelMagicInternal.h"
#import "ZHCoreModelObserver.h"
@import MagicalRecord;

#define ZH_CORE_MODEL_INIT_KEY @"ZH_CORE_MODEL_INIT_KEY"

#define ZH_FORGETINIT \
if(![[NSUserDefaults standardUserDefaults] boolForKey:ZH_CORE_MODEL_INIT_KEY]){\
    NSAssert(NO, @"Default context is nil! Did you forget to initialize the Core Data Stack?");\
}

@implementation ZHCoreModelMagic

+ (void)zh_setupCoreDataWithName:(NSString *)name{
    [MagicalRecord setupCoreDataStackWithStoreNamed:name];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ZH_CORE_MODEL_INIT_KEY];
}

+ (void)zh_setupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate delegate:(id<ZHCoreModelMagicObsDelegate>)delegate{
    ZH_FORGETINIT;
    [[ZHCoreModelObserver sharedInstance] obsSetupCoreDataNotifyWith:modelClass sortedBy:sortedBy ascending:ascending groupBy:groupBy predicate:predicate delegate:delegate];
}

@end
