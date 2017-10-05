//
//  NSObject+printAllPropertyValue.m
//  sqlite封装
//
//  Created by Feng Luo on 2017/9/29.
//  Copyright © 2017年 lf. All rights reserved.
//

#import "NSObject+printAllPropertyValue.h"
#import <objc/message.h>

@implementation NSObject (printAllPropertyValue)

- (void)pringAllPropertyAndValue {
    
    // 1.获取模型中所有成员属性名Ivar:成员变量名
    // class:获取哪个类中成员属性名,仅限于当前类
    // count:成员属性总数
    unsigned int count = 0;
    // 获取成员属性数组
    Ivar *ivarList = class_copyIvarList([self class], &count);
    
    NSLog(@"------ begin log all property ------");
    
    for (int i = 0; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员属性名 C -> OC 字符串
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 获取字典key
        
        // 分：成员属性，还是成员变量
        NSString *firstIndexString = [ivarName substringToIndex:1];
        NSString *key;
        if ([firstIndexString isEqualToString:@"_"]) {
            key = [ivarName substringFromIndex:1];// 截取字符串，从第一个开始到租后一个
        } else {
            key = ivarName;
        }
        
        
        NSLog(@"%@ : %@",key,[self valueForKey:key]);
    }
    
    NSLog(@"------ end log ------");
    NSLog(@"总共打印属性个数：%i",count);
    NSLog(@"------------");
}

@end
