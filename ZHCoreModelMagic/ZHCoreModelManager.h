//
//  ZHCoreModelManager.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "ZHCoreModelTool.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZHCoreModelManagerDelegate <NSObject>



@end

@interface ZHCoreModelManager : NSObject

ZH_SHAREINSTANCE(ZHCoreModelManager);

@property (nonatomic,assign,readonly) BOOL setuped;

- (void)addDelegate:(id <ZHCoreModelManagerDelegate>)delegate;

- (void)removeDelegate:(id <ZHCoreModelManagerDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
