//
//  LFModelTool.h
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFModelTool : NSObject


/**
 根据类名, 获取表格名称

 @param cls 类名
 @return 表格名称
 */
+ (NSString *)tableName:(Class)cls;

/**
 根据类名, 获取临时表格名称

 @param cls 类名
 @return 临时表格名称
 */
+ (NSString *)tmpTableName:(Class)cls;


/**
 所有的有效成员变量, 以及成员变量对应的类型
 （忽略字段排除）

 @param cls 类名
 @return 所有的有效成员变量, 以及成员变量对应的类型
 */
+ (NSDictionary *)classIvarNameTypeDic:(Class)cls;


/**
 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 （使用场景：创建表格的sql语句用得上）

 @param cls 类名
 @return 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;


/**
 字段名称和sql类型, 拼接的用户创建表格的字符串

 @param cls 类名
 @return 字符串 如: name text,age integer,score real
 */
+ (NSString *)columnNamesAndTypesStr:(Class)cls;


/**
 获取表格中所有字段，排好序，放在数组中
 （使用场景：用于检验表格是否需要更新）

 @param cls 类名
 @return 成员变量数组,
 */
+ (NSArray *)allTableSortedIvarNames:(Class)cls;

@end
