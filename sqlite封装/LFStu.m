//
//  LFStu.m
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import "LFStu.h"

@implementation LFStu

+ (NSString *)primaryKey {
    return @"stuNum";
}


+ (NSArray *)ignoreColumnNames {
    return @[@"score2", @"b"];
}

+ (NSDictionary *)newNameToOldNameDic {
    return @{@"age2": @"age"};
}

@end
