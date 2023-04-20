//
//  ZHCoreModelExample.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/20.
//

#import "ZHCoreModelExample.h"
#import "Entity+CoreDataClass.h"
#import "Entity+CoreDataProperties.h"

@implementation ZHCoreModelExample


+ (Class)zh_coreDataEntity{
    return Entity.class;
}

- (void)zh_packageEntityData:(NSManagedObject *)objc{
    if([objc isKindOfClass:Entity.class]){
        Entity *entity = (Entity *)objc;
        entity.text = self.text;
        entity.id = self.identifier;
    }
}

+ (instancetype)zh_reversePackagingWithEntityData:(NSManagedObject *)objc{
    ZHCoreModelExample *example = [ZHCoreModelExample new];
    if([objc isKindOfClass:Entity.class]){
        Entity *entity = (Entity *)objc;
        example.text = entity.text;
        example.identifier = entity.id;
    }
    return example;
}


@end
