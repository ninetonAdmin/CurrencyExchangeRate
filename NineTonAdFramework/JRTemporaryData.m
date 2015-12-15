//
//  JRTemporaryData.m
//  NewDianDianProj
//
//  Created by LeungJR on 15/11/11.
//  Copyright © 2015年 GL. All rights reserved.
//

#import "JRTemporaryData.h"
#import "MobClick.h"

@implementation JRTemporaryData

+ (JRTemporaryData *)sharedInstance
{
    static JRTemporaryData *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!obj) {
            obj = [[JRTemporaryData alloc] init];
        }
    });
    return obj;
}

- (void)prepare
{
    NSString *shortBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *currentReviewVersion = [MobClick getConfigParams:@"currentReviewVersion"];
    if ([currentReviewVersion isEqualToString:shortBundleVersion]) {
        //审核中
        self.isReview = YES;
        self.showGLGDTSplash = NO;
        self.showGDTContent = NO;
        self.showYD = NO;
    }else{
        //通过
        NSString *UMGDTSplash = [MobClick getConfigParams:@"showGLGDTSplash"];
        if (UMGDTSplash != nil && [UMGDTSplash isEqualToString:@"1"]) {
            self.showGLGDTSplash = YES;
        }else{
            self.showGLGDTSplash = NO;
        }
        
        NSString *UMGDTContent = [MobClick getConfigParams:@"showGDTContent"];
        if (UMGDTContent != nil && [UMGDTContent isEqualToString:@"1"]) {
            self.showGDTContent = YES;
        }else{
            self.showGDTContent = NO;
        }
        
        NSString *UMYD = [MobClick getConfigParams:@"showYD"];
        if (UMYD != nil && [UMYD isEqualToString:@"1"]) {
            self.showYD = YES;
        }else{
            self.showYD = NO;
        }
        
        NSString *umGDTAppKey = [MobClick getConfigParams:@"dynamic_gdt_appid"];
        NSString *umGDTPlaceId = [MobClick getConfigParams:@"dynamic_gdt_placeid"];
        if (umGDTAppKey != nil && umGDTAppKey.length != 0 && umGDTPlaceId != nil && umGDTPlaceId.length != 0) {
            NSArray *appkey = [umGDTAppKey componentsSeparatedByString:@","];
            NSArray *placeId = [umGDTPlaceId componentsSeparatedByString:@","];
            self.gdtSplashAppkey = appkey[0];
            self.gdtSplashPlaceId = placeId[0];
            self.gdtContentAppkey = appkey[1];
            self.gdtContentPlaceId = placeId[1];
        }else{
            self.gdtSplashAppkey = @"1104974840";
            self.gdtSplashPlaceId = @"3070904678391413";
            self.gdtContentAppkey = @"1104974840";
            self.gdtContentPlaceId = @"6050606629318531";
        }
    }
}


@end
