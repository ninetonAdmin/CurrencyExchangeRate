//
//  MainChineseExchangeRateAppDelegate.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-29.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRateManager.h"
#import "GLSplashGdtAdManager.h"

@interface MainChineseExchangeRateAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppRateManager *rateManager;
@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, strong) GLSplashGdtAdManager *splashAdManager;

@end
