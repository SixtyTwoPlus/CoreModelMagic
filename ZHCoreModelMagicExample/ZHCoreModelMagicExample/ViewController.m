//
//  ViewController.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ViewController.h"
#import "ZHCoreModelExample.h"
#import "ZHCoreModelMagic.h"

@interface ViewController ()<ZHCoreModelMagicObsDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [ZHCoreModelMagic zh_setupCoreDataWithName:@"hhh"];
    [ZHCoreModelExample zh_deleteAll];
    
    [ZHCoreModelMagic zh_setupCoreDataNotifyWith:ZHCoreModelExample.class sortedBy:@"text" ascending:YES groupBy:nil predicate:[NSPredicate predicateWithFormat:@"userId = %@",@"123"] delegate:self];
    
    NSArray *arr3 = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < 10; i ++) {
        ZHCoreModelExample *example = [ZHCoreModelExample new];
        example.content = arr3[i];
        example.count = i;
        example.userId = @"123";
        [arr addObject:example];
    }
    [arr makeObjectsPerformSelector:@selector(zh_saveOrUpdate)];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [button setTitle:@"设置新id" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [ZHCoreModelMagic zh_resetupCoreDataNotifyWith:ZHCoreModelExample.class sortedBy:@"text" ascending:YES groupBy:nil predicate:[NSPredicate predicateWithFormat:@"userId = %@",@"456"]];
        
        NSArray *arr = [ZHCoreModelExample zh_queryAll];
        for (ZHCoreModelExample *e in arr) {
            e.userId = @"456";
            [e zh_saveOrUpdate];
        }
    }] forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    button.center = self.view.center;
}

- (void)zh_coreModelObserverCoreDataListDidChanged:(NSArray *)array{
    
    NSLog(@"");
    
}

@end
