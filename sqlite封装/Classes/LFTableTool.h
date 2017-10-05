//
//  LFTableTool.h
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFTableTool : NSObject


/**
 获取表格中所有的排序后字段
 （使用场景：表格中的字段，跟模型中的字段比较，确定是否需要更新表格结构）

 @param cls 类名
 @param uid 用户唯一标识
 @return 字段数组
 */
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid;



+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid;




@end
