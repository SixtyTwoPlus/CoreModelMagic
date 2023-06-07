//
//  ViewController.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ViewController.h"
#import "ZHCoreModelExample.h"
#import "ZHCoreModelMagic.h"

@interface ViewController ()<ZHCoreModelObserverDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [ZHCoreModelObserver setupCoreDataWithName:@"ZHCoreModel"];
    [[ZHCoreModelObserver sharedInstance] setresultControllerWith:@[ZHCoreModelExample.class] sortedBy:@"id" ascending:YES groupBy:@"" predicate:ZH_EMPTY_PREDICATE];
    [[ZHCoreModelObserver sharedInstance] addDelegate:self];
    
    
    NSArray * initalizeArr = [ZHCoreModelExample zh_queryAll];
    
    NSArray *arr3 = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < 10; i ++) {
        ZHCoreModelExample *example = [ZHCoreModelExample new];
        example.text2 = @"1";
        example.text = arr3[i];
        [arr addObject:example];
    }
    [arr makeObjectsPerformSelector:@selector(zh_saveOrUpdate)];
}

- (void)zhCoreModelObserverCoreDataListDidChanged:(NSDictionary *)dict{
    NSArray *arr = dict.allValues;
    for (ZHCoreModelExample * e in arr.firstObject) {
        NSLog(@"%@",e.text);
    }
}
@end
