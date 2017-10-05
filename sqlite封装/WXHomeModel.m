//
//  WXHomeModel.m
//  sqlite封装
//
//  Created by Feng Luo on 2017/9/28.
//  Copyright © 2017年 lf. All rights reserved.
//

#import "WXHomeModel.h"


@implementation WXHomeModel


+ (NSString *)primaryKey {
    return @"myHome";
}

//+ (NSDictionary *)newNameToOldNameDic {
//    
//}

//找未找到的Key
- (id) valueForUndefinedKey:(NSString *)key
{
    
    NSLog(@"Undefined Key: %@",key);
    return nil;
}
//设置未找到的Key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    NSLog(@"Undefined Key: %@",key);
}

@end
