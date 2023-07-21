//
//  ZHCoreModelExample.h
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/20.
//

#import "ZHCoreModelAbstruct.h"
#import "Entity+CoreDataClass.h"
#import "Entity+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHCoreModelExample : ZHCoreModelAbstruct

@property (nonatomic,copy,nullable) NSString *text;
@property (nonatomic,assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
