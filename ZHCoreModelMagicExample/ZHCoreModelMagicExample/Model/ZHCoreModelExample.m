//
//  ZHCoreModelExample.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/20.
//

#import "ZHCoreModelExample.h"

@implementation ZHCoreModelExample


+ (Class)zh_coreDataEntity{
    return Entity.class;
}

//- (NSArray *)zh_coreDataStoreKeys{
//    return @[@"id",@"text",@"count"];
//}

- (NSDictionary *)zh_coreDataStoreCustomKeys{
    return @{
        @"id" : @"id",
        @"content" : @"text",
        @"count" : @"count",
    };
}

@end
