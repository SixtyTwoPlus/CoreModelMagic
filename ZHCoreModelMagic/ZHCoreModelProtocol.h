//
//  ZHCoreModelProtocol.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import <MagicRecord/MargicRecord.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHCoreModelProtocol <NSObject>

+ (BOOL)deleteAll;

+ (BOOL)deleteWithPredicate:(NSPredicate *)predicate;

+ (NSArray *)queryAll;

+ (NSArray *)queryAllWithPredicate:(NSPredicate *)predicate;

#pragma mark - 子类必须重写的方法

+ (Class)coreDataEntity;

+ (void)packageEntityData:(NSManagedObject *)objc;

+ (instancetype)reversePackagingWithEntityData:(NSManagedObject *)objc;


@end

NS_ASSUME_NONNULL_END
