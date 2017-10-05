//
//  LFModelProtocol.h
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LFModelProtocol <NSObject>

@required


/**
 操作模型必须实现的方法, 通过这个方法获取主键信息

 @return 主键字符串
 */
+ (NSString *)primaryKey;

@optional

/**
 忽略的字段数组
 （使用场景：不想存入数据库的字段。比如只想保存大部分成员属性，而全部成员变量和部分成员属性不想要存入数据库，这个时候需要）

 @return 忽略的字段数组
 */
+ (NSArray *)ignoreColumnNames;


/**
 新字段名称-> 旧的字段名称的映射表格 
 （使用场景：表格结构更新的时候使用，即数据迁移）

 @return 映射表格
 */
+ (NSDictionary *)newNameToOldNameDic;

@end
