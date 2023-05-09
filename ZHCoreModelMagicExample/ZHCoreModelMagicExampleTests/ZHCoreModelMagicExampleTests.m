//
//  ZHCoreModelMagicExampleTests.m
//  ZHCoreModelMagicExampleTests
//
//  Created by 周海林 on 2023/4/20.
//

#import <XCTest/XCTest.h>
#import "ZHCoreModelMagic.h"
#import "ZHCoreModelExample.h"

@interface ZHCoreModelMagicExampleTests : XCTestCase <ZHCoreModelObserverDelegate>

@end

@implementation ZHCoreModelMagicExampleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [ZHCoreModelObserver setupCoreDataWithName:@"ZHCoreModel"];
    [[ZHCoreModelObserver sharedInstance] setresultControllerWith:@[ZHCoreModelExample.class] sortedBy:@"id" ascending:YES groupBy:@"" predicate:ZH_EMPTY_PREDICATE];
    [[ZHCoreModelObserver sharedInstance] addDelegate:self];
    
//    [ZHCoreModelExample zh_deleteAll];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Override point for customization after application launch.
    
    NSArray * initalizeArr = [ZHCoreModelExample zh_queryAll];
    
    NSArray *arr3 = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < 10; i ++) {
        ZHCoreModelExample *example = [ZHCoreModelExample new];
        example.text2 = @"1";
        example.text = arr3[i];
        [arr addObject:example];
    }
    [arr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHCoreModelExample *example = (ZHCoreModelExample *)obj;
        [example zh_saveOrUpdate];
    }];
}

- (void)zhCoreModelObserverCoreDataListDidChanged:(NSDictionary *)dict{
    NSArray *arr = dict.allValues;
    for (ZHCoreModelExample * e in arr.firstObject) {
        NSLog(@"%@",e.text);
    }
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
