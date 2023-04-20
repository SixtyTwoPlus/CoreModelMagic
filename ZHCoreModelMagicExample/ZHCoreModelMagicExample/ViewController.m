//
//  ViewController.m
//  ZHCoreModelMagicExample
//
//  Created by 周海林 on 2023/4/19.
//

#import "ViewController.h"
#import "ZHCoreModelExample.h"
#import "ZHCoreModelMagic.h"

@interface ViewController ()<ZHCoreModelManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [[ZHCoreModelObserver sharedInstance] addDelegate:self];
    
    ZHCoreModelExample *example = [ZHCoreModelExample new];
    example.text = @"hhhh";
    [example zh_saveOrUpdate];
    
    NSLog(@"");
    
}


- (void)zhCoreModelObserverCoreDataListDidChanged:(NSDictionary *)dict{
    
    NSLog(@"");
}

@end
