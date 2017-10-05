//
//  WXHomeModel.h
//  sqlite封装
//
//  Created by Feng Luo on 2017/9/28.
//  Copyright © 2017年 lf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFModelProtocol.h"
#import "VideoTopicModel.h"

@interface WXHomeModel : NSObject<LFModelProtocol>

{
    NSString *mycover;
}

//@property (nonatomic, strong) NSString * cover;
//@property (nonatomic, strong) NSString * descriptionDe;
//@property (nonatomic, assign) NSInteger  length;
//@property (nonatomic, strong) NSString * m3u8_url;
//@property (nonatomic, strong) NSString * m3u8Hd_url;
//@property (nonatomic, strong) NSString * mp4_url;
//@property (nonatomic, strong) NSString * mp4_Hd_url;
//@property (nonatomic, assign) NSInteger  playCount;
//@property (nonatomic, strong) NSString * playersize;
//@property (nonatomic, strong) NSString * ptime;
//@property (nonatomic, strong) NSString * replyBoard;
//@property (nonatomic, strong) NSString * replyCount;
//@property (nonatomic, strong) NSString * replyid;
//@property (nonatomic, strong) NSString * title;
//@property (nonatomic, strong) NSString * vid;
//@property (nonatomic, strong) NSString * videosource;


@property (nonatomic ,assign) int myHome;// 主键

@property (nonatomic ,assign) NSInteger sizeSHD;

@property (nonatomic ,strong) NSString *ptime;

@property (nonatomic ,strong) NSString *videosource;

@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) NSString *topicImg;

@property (nonatomic ,strong) NSString *topicSid;

@property (nonatomic ,strong) NSString *m3u8_url;

@property (nonatomic ,strong) NSString *vid;

@property (nonatomic ,strong) NSString *sectiontitle;

@property (nonatomic ,assign) NSInteger playersize;

@property (nonatomic ,strong) NSString *topicName;

@property (nonatomic ,assign) NSInteger votecount;

@property (nonatomic ,strong) NSString *cover;

@property (nonatomic ,assign) NSInteger replyCount;

@property (nonatomic ,strong) NSString *replyBoard;

@property (nonatomic ,assign) NSInteger sizeSD;

@property (nonatomic ,assign) NSInteger playCount;

@property (nonatomic ,assign) NSInteger length;

@property (nonatomic ,strong) NSString *topicDesc;

@property (nonatomic ,assign) NSInteger sizeHD;

@property (nonatomic ,strong) NSString *mp4Hd_url;

@property (nonatomic ,strong) NSString *replyid;

@property (nonatomic ,strong) NSString *m3u8Hd_url;

@property (nonatomic ,strong) NSString *mp4_url;

@property (nonatomic ,strong) NSString *descp;

@property (nonatomic ,strong) VideoTopicModel *videoTopic;



//@property (nonatomic, strong) NSArray * homeModels;

//+ (NSArray<WXHomeModel*>*)saveToHomeModelWithArray:(NSArray *)dataArray;

@end
