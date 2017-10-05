//
//  LFSqliteToolTest.m
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LFSqliteTool.h"

@interface LFSqliteToolTest : XCTestCase

@end

@implementation LFSqliteToolTest


/**
    测试是否可以正常执行sql语句
 */
- (void)testExample {

    // 创建表格的语句
    NSString *sql = @"create table if not exists t_stuTest(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [LFSqliteTool deal:sql uid:nil];
    
    // 断言result是否为YES.
    XCTAssertEqual(result, YES);
    
    
}


/**
 测试查询, 是否可以返回处理好的结果集
 */
- (void)testQuery {

    // 删除所有记录
    NSString *deleteSql = @"delete from t_stu";
    BOOL deleteSqlR = [LFSqliteTool deal:deleteSql uid:nil];
    XCTAssertTrue(deleteSqlR);

    // 追加两条记录
    NSString *insertSql1 = @"insert into t_stu(id, name, age, score) values (1, 'sz', 18, 0)";
    BOOL insertSqlR1 = [LFSqliteTool deal:insertSql1 uid:nil];
    XCTAssertTrue(insertSqlR1);

    NSString *insertSql2 = @"insert into t_stu(id, name, age, score) values (2, 'zs', 81, 1)";
    BOOL insertSqlR2 = [LFSqliteTool deal:insertSql2 uid:nil];
    XCTAssertTrue(insertSqlR2);

    NSString *sql = @"select * from t_stu";
    NSMutableArray *result = [LFSqliteTool querySql:sql uid:nil];


    // 给定结果验证
    NSArray *successR = @[@{
                              @"age": @18,
                              @"id": @1,
                              @"name": @"sz",
                              @"score": @0
                              },
                          @{
                              @"age": @81,
                              @"id": @2,
                              @"name": @"zs",
                              @"score": @1
                              }];

    XCTAssertTrue([result isEqualToArray:successR]);

    
}



@end
