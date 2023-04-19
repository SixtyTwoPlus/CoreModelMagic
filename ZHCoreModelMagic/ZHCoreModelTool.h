//
//  ZHCoreModelTool.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "ZHCoreModelMacroTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHCoreModelTool : NSObject

+ (BOOL)zh_isStrNull:(NSString *)str;

+ (void)classExecute:(Class)classs WithSelector:(SEL)selector argumentTypes:(NSArray *)argumentTypes resultValue:(void *)resultValue;

@end

NS_ASSUME_NONNULL_END
