//
//  LFSqliteModelTool.m
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import "LFSqliteModelTool.h"
#import "LFModelTool.h"
#import "LFSqliteTool.h"
#import "LFTableTool.h"


@implementation LFSqliteModelTool
/**
 根据一个模型类, 创建数据库表
 // 关于这个工具类的封装
 // 实现方案 2
 // 1. 基于配置
 // 2. runtime动态获取
 @param cls 类名
 @param uid 用户唯一标识
 @return 是否创建成功
 */
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid {
    
    // 1. 创建表格的sql语句给拼接出来
    // 尽可能多的, 能够自己获取, 就自己获取, 实在判定不了用的意图的, 只能让用户来告诉我们
    
    // create table if not exists 表名(字段1 字段1类型, 字段2 字段2类型 (约束),...., primary key(字段))
    // 1.1 获取表格名称
    NSString *tableName = [LFModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    
    NSString *primaryKey = [cls primaryKey];
    
    // 1.2 获取一个模型里面所有的字段, 以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [LFModelTool columnNamesAndTypesStr:cls], primaryKey];
    
    
    // 2. 执行
    return [LFSqliteTool deal:createTableSql uid:uid];

}


/**
 判断一个表格是否需要更新

 @param cls 类名
 @param uid 用户唯一标识
 @return 是否需要更新
 */
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid {
    // 1. 获取类对应的所有有效成员变量名称, 并排序
    NSArray *modelNames = [LFModelTool allTableSortedIvarNames:cls];

    // 2. 获取当前表格, 所有字段名称, 并排序
    NSArray *tableNames = [LFTableTool tableSortedColumnNames:cls uid:uid];

    // 3. 通过对比数据判定是否需要更新
    return ![modelNames isEqualToArray:tableNames];
}

/**
 更新表格

 @param cls 类名
 @param uid 用户唯一标识
 @return 是否更新成功
 */
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid {
    
    
    // 1. 创建一个拥有正确结构的临时表
    // 1.1 获取表格名称
    NSString *tmpTableName = [LFModelTool tmpTableName:cls];
    NSString *tableName = [LFModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *dropTmpTableSql = [NSString stringWithFormat:@"drop table if exists %@;", tmpTableName];
    [execSqls addObject:dropTmpTableSql];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [LFModelTool columnNamesAndTypesStr:cls], primaryKey];
    [execSqls addObject:createTableSql];
    // 2. 根据主键, 插入数据
    // insert into LFStu_tmp(stuNum) select stuNum from LFStu;
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    // 3. 根据主键, 把所有的数据更新到新表里面
    NSArray *oldNames = [LFTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [LFModelTool allTableSortedIvarNames:cls];
    
    // 4. 获取更名字典
    NSDictionary *newNameToOldNameDic = @{};
    //  @{@"age": @"age2"};
    if ([cls respondsToSelector:@selector(newNameToOldNameDic)]) {
        newNameToOldNameDic = [cls newNameToOldNameDic];
    }
    
    for (NSString *columnName in newNames) {
        NSString *oldName = columnName;
        // 找映射的旧的字段名称
        if ([newNameToOldNameDic[columnName] length] != 0) {
            oldName = newNameToOldNameDic[columnName];
        }
        // 如果老表包含了新的列明, 应该从老表更新到临时表格里面
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey]) {
            continue;
        }
        //        LFStu_tmp  age
        // update 临时表 set 新字段名称 = (select 旧字段名 from 旧表 where 临时表.主键 = 旧表.主键)
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@);", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@;", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@;", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
   
    
    return [LFSqliteTool dealSqls:execSqls uid:uid];

}


+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid {
    
    // 如果用户再使用过程中, 直接调用这个方法, 去保存模型
    // 保存一个模型
    Class cls = [model class];
    NSString *tableName = [LFModelTool tableName:cls];
    // 1. 判断表格是否存在, 不存在, 则创建（说明是第一次存数据）
    if (![LFTableTool isTableExists:cls uid:uid]) {
        BOOL isCreateSuccess = [self createTable:cls uid:uid];
        if (!isCreateSuccess) {
            NSLog(@"创建表格失败");
            return NO;
        } else {
            NSLog(@"创建表格成功 %@",tableName);
        }
    } else {
        //NSLog(@"表格已经存在 %@",tableName);
    }
    
    // 只有表格存在了，才有更新的需求
    // 2. 检测表格是否需要更新, 需要, 更新
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        BOOL updateSuccess = [self updateTable:cls uid:uid];
        if (!updateSuccess) {
            NSLog(@"更新数据库表结构失败: %@",tableName);
            return NO;
        } else {
            NSLog(@"更新数据库表结构成功: %@",tableName);
        }
    } else {
        //NSLog(@"不需要更新数据库表格结构: %@",tableName);
    }
    
    
    // 3. 判断记录是否存在, 主键
    // 从表格里面, 按照主键, 进行查询该记录, 如果能够查询到
    // （主键信息的判断写在这里感觉是多余的，因为上面创建表格已经用到过了）
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    
    // 查询该模型在表格中主键的值
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    // （经测试，sqlite3主键增长默认从 1 开始）
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [LFSqliteTool querySql:checkSql uid:uid];
    
    
    
    // 获取字段名称数组
    
    NSArray *columnNames = [LFModelTool classIvarNameTypeDic:cls].allKeys;
    // 如果是第一次存数据，把主键字段撇开，以免被赋值0，否则，每次都检测主键值为0时是否有数据，一直更新第一条；除非业务要求只存一条数据
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:columnNames];
    if (result.count <= 0) {
        [mutArray removeObject:primaryKey];
        columnNames = [NSArray arrayWithArray:mutArray];
    }
    
    
    
    // 获取值数组
    // model keyPath:
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {// 遍历模型中字段，取出对应的value
        id value = [model valueForKeyPath:columnName];
        
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            // 在这里, 把字典或者数组, 处理成为一个字符串, 保存到数据库里面去
            
            // 字典/数组 -> data
            if (![NSJSONSerialization isValidJSONObject:value]) {
                NSLog(@"警告：value of【%@】is not validJsonObject",columnName);
            }
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            
            // data -> nsstring
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        //处理value没值的情况，赋空值
        if (!value) {
            NSLog(@"columnName-%@,class-%@ value:%@",columnName,[model class],value);
            value = @"";
        }
        
        [values addObject:value];// addObject不能添加nil，所以添加value前需要做判断，否则崩。
    }
    
    
    
    // 遍历模型中的字段，拼接sql语句给字段赋值
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'", name, value];
        [setValueArray addObject:setStr];
    }
    
    // 更新
    // （看来看去，更新是要重写的，除非这张表只存一条数据）
    // 字段名称, 字段值
    // update 表名 set 字段1=字段1值,字段2=字段2的值... where 主键 = '主键值'
    NSString *execSql = @"";
    if (result.count > 0) {
        // (主键有值，不是第一次存数据，用update)
        // (这里检测到主键有值，就不能插入新的数据，只能更新，是有不对的)
        execSql = [NSString stringWithFormat:@"update %@ set %@  where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
        
    }else {// (主键没有值，是第一次存数据，用insert)
        // insert into 表名(字段1, 字段2, 字段3) values ('值1', '值2', '值3')
        // '   值1', '值2', '值3   '
        // 插入
        // text sz 'sz' 2 '2'
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
        
    }
    
    
    return [LFSqliteTool deal:execSql uid:uid];
}


+ (BOOL)deleteModel:(id)model uid:(NSString *)uid {
    
    Class cls = [model class];
    NSString *tableName = [LFModelTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    
    return [LFSqliteTool deal:deleteSql uid:uid];
    
}


+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid {
    
    NSString *tableName = [LFModelTool tableName:cls];
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@", tableName];
    if (whereStr.length > 0) {
        deleteSql = [deleteSql stringByAppendingFormat:@" where %@", whereStr];
    }
    
    return [LFSqliteTool deal:deleteSql uid:uid];
    
}



+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSString *tableName = [LFModelTool tableName:cls];
    
   
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'", tableName, name, self.ColumnNameToValueRelationTypeDic[@(relation)], value];
    
    // 假设肯定传
    
    return [LFSqliteTool deal:deleteSql uid:uid];
}

+ (BOOL)deleteAllDataForTable:(Class)cls uid:(NSString *)uid{
    
    // 删除t_student2所有数据的SQL语句
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@",[LFModelTool tableName:cls]];
    return [LFSqliteTool deal:deleteSql uid:uid];
}

+ (BOOL)deleteTable:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [LFModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"drop table %@", tableName];
    return [LFSqliteTool deal:sql uid:uid];
}

+ (BOOL)alterOldTableName:(NSString *)oldTableName ToNewTableName:(NSString *)newTableName uid:(NSString *)uid{
    
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@;", oldTableName, newTableName];
    return [LFSqliteTool deal:sql uid:uid];
}

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [LFModelTool tableName:cls];
    // 1. sql
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    
    // 2. 执行查询,
    // key value
    // 模型的属性名称, 和属性值
    // xx 字符串
    // oo 字符串
    NSArray <NSDictionary *>*results = [LFSqliteTool querySql:sql uid:uid];
    
    
    // 3. 处理查询的结果集 -> 模型数组
    return [self parseResults:results withClass:cls];;
    
}

+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSString *tableName = [LFModelTool tableName:cls];
    // 1. 拼接sql语句
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@' ", tableName, name, self.ColumnNameToValueRelationTypeDic[@(relation)], value];
    
    
    // 2. 查询结果集
     NSArray <NSDictionary *>*results = [LFSqliteTool querySql:sql uid:uid];
    
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid {
    
    // 2. 查询结果集
    NSArray <NSDictionary *>*results = [LFSqliteTool querySql:sql uid:uid];
    
    return [self parseResults:results withClass:cls];
    
}

// 把sqlite中取出来的数据，转成模型model
+ (NSArray *)parseResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls {

    // 3. 处理查询的结果集 -> 模型数组
    NSMutableArray *models = [NSMutableArray array];
    
    // 属性名称 -> 类型 dic [属性名，属性类型]
    NSDictionary *nameTypeDic = [LFModelTool classIvarNameTypeDic:cls];
    
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            // xx NSMutableArray
            // oo NSDictionary
//            [
//            "2",
//            "3"
//            ]
            NSString *type = nameTypeDic[key];
//            NSArray
//            NSMutableArray
//            NSDictionary
//            NSMutableDictionary
            id resultValue = obj;
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                
                // 字符串 ->
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
            }else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            [model setValue:resultValue forKeyPath:key];
            
        }];
    }
    
    return models;
}


+ (NSDictionary *)ColumnNameToValueRelationTypeDic {
    return @{
             @(ColumnNameToValueRelationTypeMore):@">",
             @(ColumnNameToValueRelationTypeLess):@"<",
             @(ColumnNameToValueRelationTypeEqual):@"=",
             @(ColumnNameToValueRelationTypeMoreEqual):@">=",
             @(ColumnNameToValueRelationTypeLessEqual):@"<="
             };
}


@end
