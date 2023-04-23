//
//  ZHCoreModelProtocol.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHCoreModelActionProtocol <NSObject>

+ (BOOL)zh_deleteAll;

+ (BOOL)zh_deleteWithKey:(NSString *)key value:(NSString *)value;

+ (BOOL)zh_deleteWithPredicate:(NSPredicate *)predicate;

+ (NSArray *)zh_queryAll;

+ (NSArray *)zh_quertWithKey:(NSString *)key value:(id)value;

+ (NSArray *)zh_quertWithKey:(NSString *)key value:(id)value sorted:(NSString *)sorted ascending:(BOOL)ascending;

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate;

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate sorted:(NSString * _Nullable)sorted ascending:(BOOL)ascending;

@end


@protocol ZHCoreModelProviderProtocol <NSObject>

+ (Class)zh_coreDataEntity;

- (void)zh_packageEntityData:(NSManagedObject *)objc;

+ (instancetype)zh_reversePackagingWithEntityData:(NSManagedObject *)objc;


@end

NS_ASSUME_NONNULL_END
