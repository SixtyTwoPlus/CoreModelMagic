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


- (void)zh_packageEntityData:(NSManagedObject *)objc{
    if([objc isKindOfClass:Entity.class]){
        Entity *entity = (Entity *)objc;
        entity.text = self.text;
        entity.id = self.identifier;
        entity.text2 = self.text2;
    }
}

+ (instancetype)zh_reversePackagingWithEntityData:(NSManagedObject *)objc{
    ZHCoreModelExample *example = [ZHCoreModelExample new];
    if([objc isKindOfClass:Entity.class]){
        Entity *entity = (Entity *)objc;
        example.text = entity.text;
        example.identifier = entity.id;
        example.text2 = entity.text2;
    }
    return example;
}


@end
