//
//  ZHCoreModelMacroTool.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#ifndef ZHCoreModelMacroTool_h
#define ZHCoreModelMacroTool_h

#pragma mark - exception
#define ZH_OVERRIDE_EXCEPTION [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];

#define ZH_INIT_EXCEPTION             [NSException raise:NSInternalInconsistencyException format:@"You must not create instances of the abstract class %@. Subclass it instead.", NSStringFromClass([self class])];

#pragma mark - predicate
#define ZH_EMPTY_PREDICATE [NSPredicate predicateWithValue:YES]

#define ZH_PREDICATE(format, ...) [NSPredicate predicateWithFormat:(format), ##__VA_ARGS__]

#pragma mark - shareinstance
#define ZH_SHAREINSTANCE(_ClassName) \
\
+(_ClassName *)sharedInstance

#define ZH_SHAREINSTANCE_IMPLEMENT(_ClassName) \
\
+(_ClassName *)sharedInstance\
{\
static _ClassName *sharedInstance = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
sharedInstance = [[_ClassName alloc] init];\
});\
return sharedInstance;\
}

#pragma mark - 不可被继承

#define ZH_OBJC_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))

#pragma mark - other

#define WEAK_SELF __weak typeof(self)weakSelf = self;

#pragma mark - 调试
#ifdef DEBUG
// 定义是输出Log
#define ZHLog(format, ...) NSLog(@"Line[%d] %s " format, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
// 定义是输出Log
#define ZHLog(format, ...)
#endif

#endif /* ZHCoreModelMacroTool_h */
