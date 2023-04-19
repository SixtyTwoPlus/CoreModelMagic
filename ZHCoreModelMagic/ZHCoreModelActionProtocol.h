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

+ (BOOL)zh_deleteWithPredicate:(NSPredicate *)predicate;

+ (NSArray *)zh_queryAll;

+ (NSArray *)zh_queryAllWithPredicate:(NSPredicate *)predicate;

@end


@protocol ZHCoreModelProviderProtocol <NSObject>

+ (Class)zh_coreDataEntity;

+ (void)zh_packageEntityData:(NSManagedObject *)objc;

+ (instancetype)zh_reversePackagingWithEntityData:(NSManagedObject *)objc;


@end

NS_ASSUME_NONNULL_END
