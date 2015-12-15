//
//  NineTonSplashManager.m
//  CurrencyExchangeRate
//
//  Created by LeungJR on 15/6/10.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import "NineTonSplashManager.h"
#import "NineTonConfigManager.h"
#import "NineTonSplashView.h"
#import "MobClick.h"
#import <StoreKit/StoreKit.h>
#import "GDTNativeAd.h"
#import "JRTemporaryData.h"
#import "GLWebViewController.h"

#define CACH_DOCUMENTS_PATH(fileName) [CACHPATH stringByAppendingPathComponent:fileName]//缓存文件路径

@interface NineTonSplashManager ()<NineTonSplashViewDelegate, SKStoreProductViewControllerDelegate, GDTNativeAdDelegate>

@property (nonatomic, strong) NSDateFormatter  *dateFormatter;
@property (nonatomic, assign) NSInteger        currentSplashNumber;
@property (nonatomic, strong) UIViewController *splashViewController;


@property (nonatomic, assign) BOOL            timeOutGDTSplash;

@end

@implementation NineTonSplashManager

+ (NineTonSplashManager *)sharedInstance
{
    static NineTonSplashManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!obj) {
            obj = [[NineTonSplashManager alloc] init];
        }
    });
    return obj;
}

- (void)prepareWithViewController:(UIViewController *)viewController;
{
    NSLog(@"--->%f   %f",viewController.view.bounds.size.width, viewController.view.bounds.size.height);
    self.splashViewController = viewController;
    self.nineTonSplashview = [[NineTonSplashView alloc] initWithFrame:viewController.view.bounds];
    [_nineTonSplashview setNineTonSplashDelegate:self];
    [viewController.view addSubview:_nineTonSplashview];
}

- (void)reloadNineTonSplashDataOnInternet
{
    kSplashStatus status = [self getUmSplashStatus];
    if (status == kSplashStatusGDT) {
        [_nineTonSplashview setSplashStatus:status];
        [self loadGDTSplash];
    }else if (status == kSplashStatusTj){
        [_nineTonSplashview setSplashStatus:status];
        [self loadTJSplash];
    }else{
        [self removeSplashViewWithAnimation:YES];
    }
}


- (void)systemWillEnterForeground
{
    if (_nineTonSplashview != nil) {
        NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"splashenterbackground"];
        if ([[NSDate date] timeIntervalSinceDate:lastDate] > 600) {
//            if ([[NSDate date] timeIntervalSinceDate:lastDate] > 0) {
            [self reloadNineTonSplashDataOnInternet];
        }else
        {
            [self removeSplashViewWithAnimation:NO];
        }
    }
}

- (void)systemWillEnterBackground
{
    if (_nineTonSplashview != nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"splashenterbackground"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [_nineTonSplashview clearSplashViews];
        });
    }
}

#pragma mark - LoadGDT & Delegate
#pragma mark - GDTNativeDelegate

-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    /*广告数据拉取成功，存储并展示*/
    self.nativeDataArray = nativeAdDataArray;
    [self setExpireDateWithStatus:kSplashStatusGDT];
    if (_timeOutGDTSplash == NO) {
        _timeOutGDTSplash = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSplashGDTSuccessNotification object:nil];
    }
}

-(void)nativeAdFailToLoad:(int)errorCode
{
    /*广告数据拉取失败*/
    self.nativeDataArray = nil;
    if (_timeOutGDTSplash == NO) {
        _timeOutGDTSplash = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSplashGDTFailNotification object:nil];
        [self removeSplashViewWithAnimation:YES];
    }
}
/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen
{
    
}
/**
 *  原生广告点击之后应用进入后台时回调
 */
- (void)nativeAdApplicationWillEnterBackground
{
}

- (void)loadSplashGDTData
{
    _timeOutGDTSplash = NO;
    self.nativeAd = [[GDTNativeAd alloc] initWithAppkey:[[JRTemporaryData sharedInstance] gdtContentAppkey] placementId:[[JRTemporaryData sharedInstance] gdtContentPlaceId]];
    [_nativeAd setController:_splashViewController];
    [_nativeAd setDelegate:self];
    [_nativeAd loadAd:5];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timeoutLoadGDTSplash) userInfo:nil repeats:NO];
}

- (void)timeoutLoadGDTSplash
{
    if (_timeOutGDTSplash == NO) {
        _timeOutGDTSplash = YES;
        [self removeSplashViewWithAnimation:YES];
    }
}

#pragma mark - loadTJ

- (void)loadTJSplash
{
    if ([self needLoadDataFromSplashStatus:kSplashStatusTj]) {
        [[NineTonConfigManager sharedInstance] getSplashDataSourseCompletionBlock:^(NSInteger statusCode, id response) {
            if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
                NSDictionary *data = [response objectForKey:@"data"];
                if (data == nil) {
                    [self removeSplashViewWithAnimation:YES];
                }else{
                    [NSKeyedArchiver archiveRootObject:data toFile:CACH_DOCUMENTS_PATH(@"splash_tj.archive")];
                    [self setExpireDateWithStatus:kSplashStatusTj];
                    NSArray *nowArray = [data objectForKey:@"now"];
                    if ([self isNilOrNULLSplashArray:nowArray]) {
                        _currentSplashNumber = arc4random()%nowArray.count;
                    }
                    [self handleSplashDataSourse:data];
                }
            }else{
                [self removeSplashViewWithAnimation:YES];
            }
        } andFailBlock:^(NSError *error) {
            [self removeSplashViewWithAnimation:YES];
        }];
    }else{
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithFile:CACH_DOCUMENTS_PATH(@"splash_tj.archive")];
        if (data == nil) {
            [self removeSplashViewWithAnimation:YES];
        }else{
            [self handleSplashDataSourse:data];
        }
    }
}

- (void)loadGDTSplash
{
    if ([self needLoadDataFromSplashStatus:kSplashStatusGDT]) {
        [self loadSplashGDTData];
    }else{
        if (_nativeAd != nil && _nativeDataArray.count != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kSplashGDTSuccessNotification object:nil];
        }else{
            if (_nativeAd == nil) {
                [self loadSplashGDTData];
            }else{
                [self removeSplashViewWithAnimation:YES];
            }
            
        }
    }
}

- (BOOL)isNilOrNULLSplashArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSNull class]] && [array isKindOfClass:[NSArray class]] && [array count] != 0) {
        return YES;
    }else{
        return NO;
    }
}


- (void)handleSplashDataSourse:(NSDictionary *)originData
{
    NSArray *nowArray = [originData objectForKey:@"now"];
    NSArray *nextArray = [originData objectForKey:@"next"];
    
    if ([self isNilOrNULLSplashArray:nowArray]) {
        [self loadSplashData:nowArray isNow:YES];
        if ([self isNilOrNULLSplashArray:nextArray]) {
            [self loadSplashData:nextArray isNow:NO];
        }
    }else{
        [self removeSplashViewWithAnimation:YES];
    }
}

- (void)loadSplashData:(NSArray *)data isNow:(BOOL)flag
{
    if (flag == YES) {
        if (_currentSplashNumber > data.count - 1) {
            _currentSplashNumber = 0;
        }
        NSDictionary *nowDic = data[_currentSplashNumber];
        _currentSplashNumber ++;
        [_nineTonSplashview loadTJData:nowDic];
        for (NSInteger i= 0; i<data.count - 1; i ++) {
            if (i == _currentSplashNumber) {
                continue;
            }else{
                NSDictionary *loadImageDic = data[i];
                [_nineTonSplashview loadFutureTJImageData:loadImageDic];
            }
        }
    }else{
        for (NSDictionary *nextDic in data) {
           [_nineTonSplashview loadFutureTJImageData:nextDic];
        }
    }
}

- (NSString *)getRequestIdentifierWithSplashStatus:(kSplashStatus)status
{
    if (status == kSplashStatusTj) {
        return @"splash_tj_lasttime";
    }else if (status == kSplashStatusGDT){
        return @"splash_gdt_lasttime";
    }else{
        return @"";
    }
}

- (BOOL)needLoadDataFromSplashStatus:(kSplashStatus)status
{
    NSString *key = [self getRequestIdentifierWithSplashStatus:status];
    NSDate *expireDate = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (expireDate == nil) {
        return YES;
    }else{
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:expireDate];
        if (diff > 0) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

- (void)setExpireDateWithStatus:(kSplashStatus)status
{
    NSString *key = [self getRequestIdentifierWithSplashStatus:status];
    NSDate *expireDate = [NSDate dateWithTimeInterval:7200 sinceDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:expireDate forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeSplashViewWithAnimation:(BOOL)animation
{
    if (_nineTonSplashview != nil) {
        [self performSelector:@selector(waitToRemove) withObject:nil afterDelay:2.0f];
    }
}

- (void)waitToRemove
{
    [_nineTonSplashview switchGDTViewController];
}

- (kSplashStatus)getUmSplashStatus
{
    kSplashStatus result = kSplashStatusTj;
    NSString *getUM = [MobClick getConfigParams:@"splashstatus"];
    if (getUM == nil) {
        result = kSplashStatusTj;
    }else if (getUM != nil && [getUM isEqualToString:@"0"]){
        NSInteger random = arc4random()%2;
        if (random == 0) {
            result = kSplashStatusTj;
        }else{
            result = kSplashStatusGDT;
        }
    }else if (getUM != nil){
        if (getUM.integerValue == 1) {
            result = kSplashStatusTj;
        }else if (getUM.integerValue == 2){
            result = kSplashStatusGDT;
        }else{
            result = kSplashStatusTj;
        }
    }
    return result;
}

#pragma mark - SplashDelegate

- (void)tapTJSplashActivityURL:(NSString *)aUrl
{
    [self openWebViewByLink:aUrl];
}

- (void)tapTJSplashAppId:(NSString *)aAppId
{
    [self openAppStoreByAppId:aAppId];
}

- (void)openWebViewByLink:(NSString *)link
{
    GLWebViewController *viewController = [[GLWebViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewController setRequestUrl:link];
    [_splashViewController presentViewController:navi animated:YES completion:nil];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [_splashViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 应用内打开AppStore


- (void)openAppStoreByAppId:(NSString *)appId
{
    SKStoreProductViewController * vc = [[SKStoreProductViewController alloc] init];
    [vc setDelegate:self];
    [_splashViewController presentViewController:vc animated:YES
                     completion:nil];
    [vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId}
                  completionBlock:^(BOOL result, NSError *error) {
                      if(error)
                      {
                          [vc dismissViewControllerAnimated:YES completion:nil];
                      }
                  }];
}

@end


















