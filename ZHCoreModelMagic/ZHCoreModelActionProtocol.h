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

+ (NSDictionary *)zh_queryAllWithPredicate:(NSPredicate *)predicate groupBy:(NSString *)group sorted:(NSString *)sorted ascending:(BOOL)ascending;

@end

@protocol ZHCoreModelProviderProtocol <NSObject>

+ (Class)zh_coreDataEntity;

@optional
- (NSDictionary *)zh_coreDataStoreCustomKeys;

- (NSArray *)zh_coreDataStoreKeys;

@end

@protocol ZHCoreModelMagicObsDelegate <NSObject>

@optional
- (void)zh_coreModelObserverCoreDataListDidChanged:(NSArray *)array;

- (void)zh_coreModelObserverCoreDataListGroupDidChanged:(NSDictionary *)data;

- (void)zh_coreModelObserverCoreDataDidChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath changeType:(NSFetchedResultsChangeType)changeType newIndexPath:(NSIndexPath *)newIndexPath;

- (void)zh_coreModelObserverCoreDataDidChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;

@end

NS_ASSUME_NONNULL_END
