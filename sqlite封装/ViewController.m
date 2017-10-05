//
//  ViewController.m
//  sqlite封装
//
//  Created by luofeng on 2017/1/15.
//  Copyright © 2017年 lf. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"

#import "WXHomeModel.h"
#import "VideoTopicModel.h"
#import "LFSqliteTool.h"
#import "LFSqliteModelTool.h"
#import "LFModelTool.h"

#import "NSDictionary+PropertyCode.h"
#import "NSObject+printAllPropertyValue.h"

//#import "sqlite3.h"
//sqlite3 *ppDb = nil;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // /Users/fengluo/Library/Developer/CoreSimulator/Devices/39D77240-6ED8-4FF2-BD81-165260E8C771/data/Containers/Data/Application/03854E2B-2B52-403A-B3A7-E9E43111ED8D
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self fetchData];
}

- (void)fetchData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlString = @"http://c.m.163.com/nc/video/home/0-10.html";
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject class:%@",NSStringFromClass([responseObject class]));
        NSDictionary *dic = (NSDictionary *)responseObject;
        //  videoHomeSid,
        //  videoList,
        //  videoSidList
        NSLog(@"dic allKeys:%@",[dic allKeys]);
        NSLog(@"\n");
        
        // 取出videoList
        NSArray *videoListArray = [dic valueForKey:@"videoList"];
//        NSLog(@"videoListArray;%@",videoListArray);
        
        // debuger:把description去掉试试看（结果是去掉返回的description后，字典转模型就不会报警找不到description这个key了）
//        NSMutableArray *mutArray = [NSMutableArray array];
//        for (NSDictionary *singleDict in videoListArray) {
//            
//            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:singleDict];
//            [mutDict removeObjectForKey:@"description"];
//            [mutArray addObject:mutDict];
//        }
        
        
        
        // 字典转模型
        [WXHomeModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"descp" : @"description"
                     };
        }];
        
        NSArray <WXHomeModel *>*dataArray = [WXHomeModel mj_objectArrayWithKeyValuesArray:videoListArray];
        
        // 打印所有属性
        WXHomeModel *firstModel = dataArray.firstObject;
//        [firstModel pringAllPropertyAndValue];
        
        
        // sqlite本地化
        for (WXHomeModel *model in dataArray) {
            BOOL isSaveOrUpdate = [LFSqliteModelTool saveOrUpdateModel:model uid:[LFModelTool tableName:[WXHomeModel class]]];
            NSLog(@"isSaveOrUpdate:%i",isSaveOrUpdate);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
    
    
}



@end
