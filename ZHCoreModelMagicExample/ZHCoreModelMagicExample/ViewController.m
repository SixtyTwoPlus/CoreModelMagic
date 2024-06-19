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
    
    NSArray * ab = [ZHCoreModelExample zh_queryAll];
    
    [ZHCoreModelExample zh_deleteAll];
    
    [ZHCoreModelMagic zh_setupCoreDataNotifyWith:ZHCoreModelExample.class sortedBy:@"text" ascending:YES groupBy:nil predicate:[NSPredicate predicateWithValue:YES] delegate:self];
    
    NSArray *arr3 = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < 10; i ++) {
        ZHCoreModelExample *example = [ZHCoreModelExample new];
        example.content = arr3[i];
        example.count = i;
        [arr addObject:example];
    }
    [arr makeObjectsPerformSelector:@selector(zh_saveOrUpdate)];
    
    NSArray * a =  [ZHCoreModelExample zh_quertWithKey:@"count" value:@(5)];
    NSLog(@"");
    
}

- (void)zh_coreModelObserverCoreDataDidChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath changeType:(NSFetchedResultsChangeType)changeType newIndexPath:(NSIndexPath *)newIndexPath{
    
    
    NSLog(@"");
}

- (void)zh_coreModelObserverCoreDataListDidChanged:(NSArray *)array{
    
    NSLog(@"");
    
}

@end
