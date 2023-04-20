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



#endif /* ZHCoreModelMacroTool_h */
