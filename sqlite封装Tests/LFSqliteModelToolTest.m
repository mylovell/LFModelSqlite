//
//  LFSqliteModelToolTest.m
//  sqlite封装
//
//  Created by luofeng on 17/2/4.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LFSqliteModelTool.h"
#import "LFStu.h"
#import "WXHomeModel.h"

@interface LFSqliteModelToolTest : XCTestCase

@end

@implementation LFSqliteModelToolTest


/**
 测试创建表格
 */
- (void)testCreateTable {
    BOOL result = [LFSqliteModelTool createTable:[LFStu class] uid:nil];
    XCTAssertTrue(result);
}

/**
 测试是否需要更新
 */
- (void)testRequiredUpdate {
    BOOL isUpdate = [LFSqliteModelTool isTableRequiredUpdate:[LFStu class] uid:nil];
    XCTAssertFalse(isUpdate);
}



- (void)testUpdateTable {
    BOOL update = [LFSqliteModelTool updateTable:[LFStu class] uid:nil];
    XCTAssertTrue(update);
}


- (void)testSaveModel {
    
    LFStu *stu = [[LFStu alloc] init];
    stu.stuNum = 1;
    stu.age2 = 99;
    stu.name = @"王二小2";
    stu.score = 999;
    
    [LFSqliteModelTool saveOrUpdateModel:stu uid:nil];
    
}
- (void)testDeleteModel {
    
    LFStu *stu = [[LFStu alloc] init];
    stu.stuNum = 1;
    stu.age2 = 99;
    stu.name = @"王二小2";
    stu.score = 999;
    
    [LFSqliteModelTool deleteModel:stu uid:nil];
    
}

- (void)testDeleteModelWhere {
    
    [LFSqliteModelTool deleteModel:[LFStu class] whereStr:@"score <= 4" uid:nil];
    
}

- (void)testDeleteModelWhere2 {
    
    [LFSqliteModelTool deleteModel:[LFStu class] columnName:@"name" relation:ColumnNameToValueRelationTypeEqual value:@444 uid:nil];
    
}

- (void)testQueryAllModels {
    
//    NSArray *array = [LFSqliteModelTool queryAllModels:[LFStu class] uid:nil];
//    NSLog(@"%@", array);
    
    NSArray *results = [LFSqliteModelTool queryModels:[LFStu class] columnName:@"name" relation:ColumnNameToValueRelationTypeEqual value:@"666" uid:nil];
    NSLog(@"%@", results);
    
    
}
// 删除表
- (void)testDeleteTable {
    
    BOOL isDeleteTable = [LFSqliteModelTool deleteTable:[LFStu class] uid:@"common"];
    XCTAssertTrue(isDeleteTable);
    
}
// 修改表名
- (void)testRenameForTable {
    // t_stuTest  /   t_goodStu
    BOOL isRenameForTable = [LFSqliteModelTool alterOldTableName:@"t_goodStu" ToNewTableName:@"t_stuTest" uid:@"common"];
    XCTAssertTrue(isRenameForTable);
}

@end
