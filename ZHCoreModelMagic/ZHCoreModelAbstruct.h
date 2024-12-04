//
//  ZHCoreModelAbstruct.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "ZHCoreModelActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHCoreModelAbstruct : NSObject <ZHCoreModelActionProtocol>

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSDate   *createDate;

- (BOOL)zh_deleteThisData;

- (void)zh_asyncSaveOrUpdate;

- (void)zh_asyncSaveOrUpdateWithComplete:(dispatch_block_t _Nullable)complete;

@end

NS_ASSUME_NONNULL_END
