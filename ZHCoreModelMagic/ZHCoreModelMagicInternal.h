//
//  ZHCoreModelMagicInternal.h
//  ZHCoreModelMagicExample
//
//  Created by ZHL on 2023/7/19.
//

#import <Foundation/Foundation.h>
#import "ZHCoreModelActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHCoreModelMagic : NSObject

+ (void)zh_setupCoreDataWithName:(NSString *)name;

#pragma mark - obs

+ (void)zh_setupCoreDataNotifyWith:(Class)modelClass sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString * _Nullable)groupBy predicate:(NSPredicate *)predicate delegate:(id <ZHCoreModelMagicObsDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
