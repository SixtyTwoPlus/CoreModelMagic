//
//  ZHCoreModelTool.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ZHCoreModelTool.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import <YYCache/YYCache.h>

@implementation ZHCoreModelTool

+ (BOOL)zh_isStrNull:(NSString *)str{
    if (str == nil || [str isEqual:[NSNull null]] || str.length == 0 || str == NULL) {
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL)validateAndCacheMethodSignatureForClass:(Class)class selector:(SEL)selector argumentTypes:(NSArray *)argumentTypes {
    
    NSMethodSignature *signature = [class methodSignatureForSelector:selector];
    
    static YYCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYCache cacheWithName:@"MethodSignatureCache"];
    });
    
    NSString *cacheKey = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(class), NSStringFromSelector(selector)];
    NSNumber *cacheResult = (NSNumber *)[cache objectForKey:cacheKey];
    
    if (cacheResult) {
        return cacheResult.boolValue;
    }
    
    NSUInteger numberOfArguments = [signature numberOfArguments];
    if (numberOfArguments - 2 != argumentTypes.count) {
        return NO;
    }
    
    NSUInteger argumentIndex = 2;
    BOOL isValid = YES;
    for (id argument in argumentTypes) {
        const char *expectedArgumentType = [signature getArgumentTypeAtIndex:argumentIndex];
        
        if (expectedArgumentType[0] == '@') {
            Class expectedClass = nil;
            if (strlen(expectedArgumentType) > 3) {
                char className[256];
                strncpy(className, expectedArgumentType + 2, strlen(expectedArgumentType) - 3);
                className[strlen(expectedArgumentType) - 3] = '\0';
                expectedClass = objc_getClass(className);
            }
            
            if (expectedClass && ![argument isKindOfClass:expectedClass]) {
                isValid = NO;
                break;
            }
        } else {
            const char *providedArgumentType = object_getClassName(argument);
            if (strcmp(expectedArgumentType, providedArgumentType) != 0) {
                isValid = NO;
                break;
            }
        }
        argumentIndex++;
    }
    
    [cache setObject:@(isValid) forKey:cacheKey];
    return isValid;
}

+ (void)classExecute:(Class)classs WithSelector:(SEL)selector argumentTypes:(NSArray *)argumentTypes resultValue:(void *)resultValue {
    if (![classs isSubclassOfClass:NSManagedObject.class]) {
        NSAssert(NO, @"The method of operationEntity must be a subclass of NSManagedObject");
        return;
    }
    
    if(![classs respondsToSelector:selector]){
        NSAssert(NO, @"The class did'n have method of %@",NSStringFromSelector(selector));
        return;
    }
    
    BOOL isValid = [self validateAndCacheMethodSignatureForClass:classs selector:selector argumentTypes:argumentTypes];
    if (!isValid) {
        NSAssert(NO, @"The argument types do not match the expected argument types");
        return;
    }
    
    NSMethodSignature *signature = [classs methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:classs];
    
    NSUInteger argumentIndex = 2;
    for (Class argumentType in argumentTypes) {
        [invocation setArgument:&argumentType atIndex:argumentIndex];
        argumentIndex++;
    }
    
    [invocation invoke];
    [invocation getReturnValue:resultValue];
}

@end
