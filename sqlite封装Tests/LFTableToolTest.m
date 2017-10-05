//
//  LFTableToolTest.m
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LFTableTool.h"
#import "LFStu.h"

@interface LFTableToolTest : XCTestCase

@end

@implementation LFTableToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTableSortedColumnNames {
    NSArray *names = [LFTableTool tableSortedColumnNames:[LFStu class] uid:nil];
    NSLog(@"%@", names);

//    (
//     age,
//     b,
//     name,
//     score,
//     stunum
//     )
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


@end
