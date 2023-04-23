//
//  ZHCoreModelManager.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "ZHCoreModelMacroTool.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZHCoreModelObserverDelegate <NSObject>

- (void)zhCoreModelObserverCoreDataListDidChanged:(NSDictionary *)dict;

@end

ZH_OBJC_SUBCLASSING_RESTRICTED
@interface ZHCoreModelObserver : NSObject

ZH_SHAREINSTANCE(ZHCoreModelObserver);

@property (nonatomic,assign,readonly) BOOL setuped;

+ (void)setupCoreDataWithName:(NSString *)name;

#pragma mark - setup controller
- (void)setresultControllerWith:(NSArray <Class> *)class sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending groupBy:(NSString *)groupBy predicate:(NSPredicate *)predicate;

- (void)setResultControllerWith:(NSArray <Class> *)class groupBy:(NSString *)groupBy sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending predicate:(NSPredicate *)predicate;

#pragma mark - delegate
- (void)addDelegate:(id <ZHCoreModelObserverDelegate>)delegate;

- (void)removeDelegate:(id <ZHCoreModelObserverDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
