//
//  ZHCoreModelObserver.h
//  ZHCoreModelMagicExample
//
//  Created by ZHL on 2023/7/19.
//

#import <Foundation/Foundation.h>
#import "ZHCoreModelActionProtocol.h"
#import "ZHCoreModelMacroTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHCoreModelObserver : NSObject

ZH_SHAREINSTANCE(ZHCoreModelObserver);

- (void)obsSetupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate delegate:(id <ZHCoreModelMagicObsDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
