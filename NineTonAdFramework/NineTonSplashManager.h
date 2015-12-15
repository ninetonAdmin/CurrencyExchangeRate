//
//  NineTonSplashManager.h
//  CurrencyExchangeRate
//
//  Created by LeungJR on 15/6/10.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NineTonSplashView;
@class GDTNativeAd;
@class GDTNativeAdData;

@interface NineTonSplashManager : NSObject

@property (nonatomic, strong) NineTonSplashView *nineTonSplashview;
@property (nonatomic, strong) GDTNativeAd     *nativeAd;
@property (nonatomic, strong) NSArray         *nativeDataArray;
@property (nonatomic, strong) GDTNativeAdData *currentAd;

@property (nonatomic, strong) UIImage *glGdtSplash;

+ (NineTonSplashManager *)sharedInstance;
- (void)prepareWithViewController:(UIViewController *)viewController;
- (void)reloadNineTonSplashDataOnInternet;

- (void)systemWillEnterBackground;
- (void)systemWillEnterForeground;


@end
