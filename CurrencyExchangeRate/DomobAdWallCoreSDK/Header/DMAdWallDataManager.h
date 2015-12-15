//
//  DMAdWallDataManager.h
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-12-14.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMAdWallDataManager;
@class DMAWAdInfo;
@class DMAdDetail;
@class DMAWConrtolInfo;
@class DMAWHotWord;

@protocol DMAdWallDataManagerDelegate <NSObject>

/**
 *  推广墙请求广告信息成功后，回调该方法
 *
 *  @param manager     DMAdWallDataManager
 *  @param adList      NSArray
 *  @param controlInfo DMAWConrtolInfo
 *  @param bannerList  NSArray
 *  @param extendList  NSArray
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
           didReceiveAdList:(NSArray *)adList
                controlInfo:(DMAWConrtolInfo *)controlInfo
                 bannerList:(NSArray *)bannerList
                 extendList:(NSArray *)extendList;
/**
 *  推广墙请求广告信息失败后，回调该方法
 *
 *  @param manager DMAdWallDataManager
 *  @param error   NSError
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
        requestAdDataFailed:(NSError *)error;

@end

typedef enum {
    
    kActivityEnterReport = 1,// 进入广告列表界面
    kActivityExitReport      // 退出广告列表界面
}eActivityReprotType;

typedef enum {
    
    kDMAWClickTypeBanner = 1,
    kDMAWClickTypeListItem = 2,
    kDMAWClickTypeListButton = 3,
}eDMAWClickType;//点击类型

@interface DMAdWallDataManager : NSObject

@property(nonatomic,assign)id<DMAdWallDataManagerDelegate>delegate;

/**
 *  使用PublisherID和广告位placementId初始化DMAdWallDataManager
 *
 *  @param publisherId publisherId
 *  @param placementId placementId
 *  @param rootViewController controller
 *
 *  @return DMAdWallDataManager
 */
- (id)initWithPublisherId:(NSString *)publisherId
              placementId:(NSString *)placementId
       rootViewController:(UIViewController *)controller;



/**
 *  请求广告信息，包含广告列表、控制信息、bannner列表、扩展类广告
 */
- (void)requsetAdData;

/**
 *  触发点击事件
 *
 *  @param info     广告信息
 *  @param type     点击类型
 *  @param position 广告位置
 */
- (void)onClickAdItemWithInfo:(DMAWAdInfo *)info
                         type:(eDMAWClickType)type
                     position:(NSInteger)position;

/**
 *  列表展现后调用发送报告
 *
 *  @param adList 展现的广告列表
 */
- (void)sendImpressionReportWithAdList:(NSArray *)adList;

/**
 *  发送行为类报告
 *
 *  @param type 报告类型，详见eActivityReprotType定义
 */
- (void)sendActivityReport:(eActivityReprotType)type;

@end
