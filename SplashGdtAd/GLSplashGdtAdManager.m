//
//  GLSplashGdtAdManager.m
//  GLCalendarHL
//
//  Created by gaolong on 15/9/11.
//  Copyright (c) 2015年 Nineton Tech Co., Ltd. All rights reserved.
//

#import "GLSplashGdtAdManager.h"
//#import "StatisticHelper.h"
//#import "LTImageTool.h"
#import "UIImage+Extensions.h"
#import "GLDataCenter.h"
#import "GLDeviceUtility.h"
#import "GLNetworkUtility.h"
#import "SplashGdtAdView.h"
#import "MobClick.h"

@implementation GLSplashGdtAdManager

-(id)initGdtAdWith:(NSString *)appkey placement:(NSString *)placement baseCon:(UIViewController *)baseCon{
    
    if (self = [super init]) {
        _baseCon = baseCon;
        _appkey = appkey;
        _placementID = placement;
    }
    _gdtAd = [[GDTNativeAd alloc] initWithAppkey:_appkey placementId:_placementID];
    _gdtAd.controller = _baseCon;
    _gdtAd.delegate = self;
    return self;
}

-(void)attachNativeAdTo:(UIView *)view withAdData:(GDTNativeAdData *)adData{
    
    [_gdtAd attachAd:adData toView:view];
    //[StatisticHelper sendUmengEvent:@"splashGdtAdEvent" withID:@"show"];
}

-(void)clickNativeAd:(GDTNativeAdData *)adData{
    
    [_gdtAd clickAd:adData];
    //[StatisticHelper sendUmengEvent:@"splashGdtAdEvent" withID:@"click"];
}

-(void)loadSpashGdtAd{
    
    if (![GLNetworkUtility isNetAvaliable]||_isRequestAd) {
        return;
    }
    
    if ([GLNetworkUtility isNetAvaliable]) {
        
        int count = 1;
        if ([GLNetworkUtility isCurrentWifi]) {
            count = 5;
        }
        [_gdtAd loadAd:count];
        //[StatisticHelper sendUmengEvent:@"splashGdtAdEvent" withID:@"request"];
    }
    
}

-(void)buildSplashView{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        //下载图片
        NSString* dataurl = [self.adData.properties valueForKey:GDTNativeAdDataKeyImgUrl];
        NSString* dataPath = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:[[GLDeviceUtility md5:dataurl] stringByAppendingString:@".jpg"]];
        
        NSData* data = [NSData dataWithContentsOfFile:dataPath];
        if (data==nil) {
            
            if ([GLNetworkUtility isCurrentWifi]) {
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataurl]];
                if (data) {
                    [data writeToFile:dataPath atomically:YES];
                }
            }
        }
        UIImage* picture = [UIImage imageWithData:data];
        
        if (picture) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString* title = [self.adData.properties valueForKey:GDTNativeAdDataKeyTitle];
                
                Skin_Type type = Skin_Type_Default;
//                NSString* gdtAdKeywords_game = [StatisticHelper configValueForKey:@"gdtAdKeywords_game"];
//                NSString* gdtAdKeywords_girl = [StatisticHelper configValueForKey:@"gdtAdKeywords_girl"];
                NSString* gdtAdKeywords_game = [MobClick getConfigParams:@"gdtAdKeywords_game"];
                NSString* gdtAdKeywords_girl = [MobClick getConfigParams:@"gdtAdKeywords_girl"];
                NSArray* gameArr = [gdtAdKeywords_game componentsSeparatedByString:@","];
                NSArray* girlArr = [gdtAdKeywords_girl componentsSeparatedByString:@","];
                
                if (type==Skin_Type_Default) {
                    for (NSString* key in girlArr) {
                        if ([title rangeOfString:key].length>0) {
                            type = Skin_Type_lovely;
                            break;
                        }
                    }
                }
                
                if (type==Skin_Type_Default) {
                    for (NSString* key in gameArr) {
                        if ([title rangeOfString:key].length>0) {
                            type = Skin_Type_game;
                            break;
                        }
                    }
                }
                
                SplashGdtAdView* view = (SplashGdtAdView*)[[[NSBundle mainBundle] loadNibNamed:@"SplashGdtAdView" owner:nil options:nil] firstObject];
                title = [title stringByReplacingOccurrencesOfString:@"-" withString:@":"];
                title = [title stringByReplacingOccurrencesOfString:@"－" withString:@":"];
                NSArray* temp = [title componentsSeparatedByString:@":"];
                view.titleLabel.text = [temp firstObject];
                view.imgView.image = picture;
                [view resizeView:type];
                //self.splashImage = [LTImageTool getImageFromView:view WithSize:view.frame.size andBackImage:nil withScal:0];
                self.splashImage = [self imageFromView:view atFrame:view.frame];
                if ([self.delegate respondsToSelector:@selector(splashAdManager:requestResult:)]) {
                    [self.delegate splashAdManager:self requestResult:YES];
                }
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(splashAdManager:requestResult:)]) {
                    [self.delegate splashAdManager:self requestResult:NO];
                }
            });
        }
    });
}

- (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, 0);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return uiImage;
}

#pragma mark GDT Delegate 

-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    if (self.needDownloadPictureAdDataArr==nil) {
        self.needDownloadPictureAdDataArr = [NSMutableArray array];
    }
    
    //过滤掉麻痹的信用卡广告
    for (GDTNativeAdData* d in nativeAdDataArray) {
        if ([[d.properties valueForKey:@"title"] rangeOfString:@"信用卡"].length==0) {
            
            BOOL canAdd = YES;
            for (GDTNativeAdData* d2 in [GLDataCenter sharedInstance].allGdtNativeAdDatas) {
                if ([[d.properties valueForKey:GDTNativeAdDataKeyIconUrl] isEqualToString:[d2.properties valueForKey:GDTNativeAdDataKeyIconUrl]]) {
                    canAdd = NO;
                    break;
                }
            }
            if (canAdd) {
                self.adData = d;
                break;
            }
        }
    }
    _isRequestAd = NO;
    if (self.adData) {
        
        for (id d in nativeAdDataArray) {
            if (d!=self.adData) {
                [self.needDownloadPictureAdDataArr addObject:d];
            }
        }
        
        @synchronized([GLDataCenter sharedInstance]){
            [[GLDataCenter sharedInstance].allGdtNativeAdDatas addObject:self.adData];
        }
        //[StatisticHelper sendUmengEvent:@"splashGdtAdEvent" withID:@"requestSuccess"];
        //紧接着构建开屏广告图
        [self performSelectorOnMainThread:@selector(buildSplashView) withObject:nil waitUntilDone:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self downloadPicturesInBackgroundThread];
        });
    }
}

-(void)downloadPicturesInBackgroundThread{
    
    for (GDTNativeAdData* data in self.needDownloadPictureAdDataArr) {
        
        NSString* dataurl = [data.properties valueForKey:GDTNativeAdDataKeyImgUrl];
        NSString* dataPath = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:[[GLDeviceUtility md5:dataurl] stringByAppendingString:@".jpg"]];
        
        NSData* d = [NSData dataWithContentsOfFile:dataPath];
        if (d==nil) {
            
            if ([GLNetworkUtility isCurrentWifi]) {
                d = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataurl]];
                if (d) {
                    [d writeToFile:dataPath atomically:YES];
                }
            }
        }
    }
}

-(void)nativeAdFailToLoad:(int)errorCode
{
    _isRequestAd = NO;
    //  [StatisticHelper sendUmengEvent:@"splashGdtAdEvent" withID:@"requestError"];
    
    if ([self.delegate respondsToSelector:@selector(splashAdManager:requestResult:)]) {
        [self.delegate splashAdManager:self requestResult:NO];
    }
}

@end
