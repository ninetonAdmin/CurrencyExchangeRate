//
//  DMAdConrtolInfo.h
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-12-14.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    kAdWallSortOwn = 1,//自助广告优先，默认
    kAdWallSortDomob ,//多盟广告优先
    kAdWallSortCustom//自定义
    
}AdWallSortMode;

@interface DMAWConrtolInfo : NSObject

//是否更新入口图片
@property(nonatomic)BOOL updateEntrnaceImage;
//入口图片url
@property(nonatomic,retain)NSString *entranceImageUrl;
//入口显示更新
@property(nonatomic)BOOL showUpdate;
//banner轮播时间
@property(nonatomic,retain)NSNumber *bannerPlayInterval;
//每页显示广告数目，默认15
@property(nonatomic,retain)NSNumber *adListNumber;
//广告列表排序模式
@property(nonatomic)AdWallSortMode type;
//应用列表分类显示，如游戏、应用
@property(nonatomic)BOOL showWithCategory;
//每个广告显示的上限，默认10，达到上限后将该广告所在广告位的所有广告记录发送给服务端
@property(nonatomic,retain)NSNumber *presentAdLimit;
//是否显示banner
@property(nonatomic)BOOL showBanner;
//广告过期时间，需重新请求
@property(nonatomic,retain)NSNumber *timeOutInterval;
//新添加的广告是否显示new
@property(nonatomic)BOOL showListItemNew;
//是否提供搜索广告功能
@property(nonatomic)BOOL showSearchEntrance;

@end
