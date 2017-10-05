//
//  LFSqliteModelTool.h
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFModelProtocol.h"


typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,
    ColumnNameToValueRelationTypeLess,
    ColumnNameToValueRelationTypeEqual,
    ColumnNameToValueRelationTypeMoreEqual,
    ColumnNameToValueRelationTypeLessEqual,
};


@interface LFSqliteModelTool : NSObject


/**
 根据一个模型类, 创建数据库表

 @param cls 类名
 @param uid 用户唯一标识
 @return 是否创建成功
 */
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;


/**
 判断一个表格是否需要更新

 @param cls 类名
 @param uid 用户唯一标识
 @return 是否需要更新
 */
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;


/**
 更新表格（这个方法对于）

 @param cls 类名（也是表名）
 @param uid 用户唯一标识
 @return 是否更新成功
 */
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;


/**
 需求一、针对同一个模型对象操作：保存或更新一条数据（更新数据场景：当这条数据被修改后，需要保存，注意模型对象还是哪个，否则取出来的主键值对不上）
 
 @param model 模型对象
 @param uid 用户唯一标识（也是数据库名）
 @return 是否保存或更新成功
 */
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;


/**
 需求二、保存或更新固定条数的数据（如比只存10条，每次请求10条就更新数据库原有10条；可以删掉表格中所存的10条，再插入新的10条）
 */



/**
 删除一条数据（根据这条数据的主键值）
 
 @param model 已存在表中的某个模型对象
 @param uid 用户唯一标识（也是数据库名）
 @return 是否删除成功
 */
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;

// 根据条件来删除
// age > 19
// score <= 10 and xxx
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;

// score > 10 or name = 'xx'
+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

/**
 删除某个表中的所有数据
 
 @param cls 模型类名（即表名）
 @param uid 用户唯一标识（也是数据库名）
 @return 是否删除成功
 */
+ (BOOL)deleteAllDataForTable:(Class)cls uid:(NSString *)uid;

// 删除uid数据库中的表cls。
+ (BOOL)deleteTable:(Class)cls uid:(NSString *)uid;

// 修改表名
+ (BOOL)alterOldTableName:(NSString *)oldTableName ToNewTableName:(NSString *)newTableName uid:(NSString *)uid;


/* 操作字段 */
//// 新增一个字段（及新增一列）（可以不需要这个方法，在数据迁移中就完成了，除非是自己想要额外添加字段）
//+ (BOOL)alterAddColumn:(NSString)columnName dataType:(NSString)dataType defaultData:(id)defaultData Table:(Class)cls uid:(NSString *)uid;
//// 删除一个字段（即删除一列）（想不到使用场景，除非是自己额外加上去的，然后想要删除）
//+ (BOOL)alterDropColumn:(NSString)columnName table:(Class)cls uid:(NSString *)uid;
//// 更新一个字段的数据类型（这个也暂时想不到使用场景）
//+ (BOOL)alterColumnDataTypeTo:(NSString *)dataType dropColumn:(NSString)columnName Table:(Class)cls uid:(NSString *)uid;

// 查找出某个字段的所有不同值(待实现)
// select distinct prodCategory from LocalModelTable;

// 查询某字段下的所有记录条数(只返回计数)(待实现)
// select count (*) from LocalModelTable where prodCategory = ?;






// sql
//+ (BOOL)deleteWithSql:(NSString *)sql uid:(NSString *)uid;

// @[@"score", @"name"] @[@">", @"="] @[@"10", @"xx"]
//+ (BOOL)deleteModels:(Class)cls columnNames:(NSArray *)names relations:(NSArray *)relations values:(NSArray *)values naos:(NSArray *)naos uid:(NSArray *)uid;

/**
 查询表中的所有数据
 
 @param cls 模型类名（即表名）
 @param uid 用户唯一标识（也是数据库名）
 @return 查询结果
 */
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;

/**
 查询表中的数据，根据某个字段的约束
 （缺陷，只能约束一个字段）
 
 @param cls 模型类名（即表名）
 @param columnName 字段名
 @param relation 关系，大于小于等于
 @param value 关系值
 @param uid 用户唯一标识（也是数据库名）
 @return 查询结果
 */
+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)columnName relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

// 根据sql语句来查询
+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid;


@end
