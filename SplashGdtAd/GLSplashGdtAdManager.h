//
//  GLSplashGdtAdManager.h
//  GLCalendarHL
//
//  Created by gaolong on 15/9/11.
//  Copyright (c) 2015年 Nineton Tech Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeAd.h"

@class GLSplashGdtAdManager;

@protocol GLSplashGdtAdManagerDelegate <NSObject>

@optional
-(void)splashAdManager:(GLSplashGdtAdManager*)manager requestResult:(BOOL)result;

@end

//把广点通用到开屏广告上
@interface GLSplashGdtAdManager : NSObject<GDTNativeAdDelegate>{

    GDTNativeAd* _gdtAd;
    NSString* _appkey;
    NSString* _placementID;
    UIViewController* _baseCon;
    BOOL _isRequestAd;
}

@property(nonatomic,strong) GDTNativeAdData* adData;
@property(nonatomic,strong) NSMutableArray* needDownloadPictureAdDataArr;
@property(nonatomic,weak) id<GLSplashGdtAdManagerDelegate> delegate;

@property(nonatomic,strong) UIImage* splashImage;

-(id)initGdtAdWith:(NSString*)appkey placement:(NSString*)placement baseCon:(UIViewController*)baseCon;
-(void)attachNativeAdTo:(UIView*)view withAdData:(GDTNativeAdData*)adData;
-(void)clickNativeAd:(GDTNativeAdData*)adData;

-(void)loadSpashGdtAd;

@end
