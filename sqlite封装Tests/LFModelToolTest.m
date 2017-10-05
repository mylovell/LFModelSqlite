//
//  LFModelToolTest.m
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LFModelTool.h"
#import "LFStu.h"

@interface LFModelToolTest : XCTestCase

@end

@implementation LFModelToolTest

- (void)testIvarNames {
    
    NSArray *ivarNames = [LFModelTool allTableSortedIvarNames:[LFStu class]];
    NSLog(@"%@", ivarNames);
    
}


@end
