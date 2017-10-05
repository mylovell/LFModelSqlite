//
//  LFStu.h
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFModelProtocol.h"

@interface LFStu : NSObject <LFModelProtocol>
{
    int b;
}
@property (nonatomic, assign) int stuNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age2;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) float score2;
@property (nonatomic, strong) NSArray *xx;
@property (nonatomic, strong) NSDictionary *oo;

@end
