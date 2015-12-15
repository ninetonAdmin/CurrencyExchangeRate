//
//  MainChineseExchangeRateAppDelegate.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-29.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "MainChineseExchangeRateAppDelegate.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "GlobleObject.h"
#import "CustomReceiptVerificatior.h"
#import "MyUtilities.h"
#import "ASIHTTPRequest.h"
#import "NineTonConfigManager.h"
#import "NineTonAdManager.h"
#import <StoreKit/StoreKit.h>
#import "NineTonSplashManager.h"
#import "UserGuideViewController.h"
#import "JRTemporaryData.h"

@interface MainChineseExchangeRateAppDelegate ()<NineTonPlugADViewDelegate, SKStoreProductViewControllerDelegate,GLSplashGdtAdManagerDelegate>

@property CustomReceiptVerificatior *receiptVerificator;
@property (nonatomic, assign) NSInteger currentSplashNumber;
@property (nonatomic, assign) BOOL    timeOutGDTSplash;

@end

@implementation MainChineseExchangeRateAppDelegate

@synthesize rateManager = _rateManager;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    * Added by LY on 2015-06-11
    *
    */
    // 检测是否是第一次使用该版本
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 如果是第一次启动的话,显示版本新特性，UserGuideViewController (用户引导页面) 作为根视图
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@ "MainStoryboard" bundle: nil ];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ugViewController"];
    }
    
    
    
    // Override point for customization after application launch.
    _receiptVerificator = [[CustomReceiptVerificatior alloc] init];
    [RMStore defaultStore].receiptVerificator = _receiptVerificator;
    
    //友盟统计
    [MobClick startWithAppkey:UMAppKey reportPolicy:BATCH channelId:nil];
    [MobClick updateOnlineConfig];
    [MobClick checkUpdate];
    
//    [[MobiSageManager getInstance] setPublisherID:@"a5ef32579e0642d99d644f95b64b5e6a"];
//    //开发者
//    YJFUserMessage *user = [[YJFUserMessage alloc]init];
//    [user setAppId:@"200"];//应用ID
//    [user setDevId:@"27"];//开发者ID
//    [user setAppKey:@"EMPAN4GE2U3YCD866XI30RDH3S0XBIP8NB"];//appKey
//    [user setChannel:@"IOS1.2.3"];//渠道号，默认当前SDK版本号
//    
//    //初始化
//    YJFInitServer *InitData  = [[YJFInitServer alloc]init];
//    [InitData  getInitEscoreData];
    
    
//    //友盟分享
    @try {
        [UMSocialData setAppKey:UMAppKey];
        
        //设置微信AppId
        [UMSocialWechatHandler setWXAppId:WECHAT_ID appSecret:WECHAT_SECRET url:APPSTORE_URL];
        
        //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
//        [UMSocialQQHandler setQQWithAppId:QQ_ID appKey:nil url:APPSTORE_URL];
        
        //没有客户端用WebView分享
//        [UMSocialQQHandler setSupportWebView:YES];
        
        //新浪微博SSO
//        [UMSocialSinaHandler openSSOWithRedirectURL:WEIBO_REDIRECT_URL];

    }
    @catch (NSException *exception) {

        DLog(@"UMSocialData initialize failed!");
    }
    @finally {
        
    }
    
    //提示评分
    if (MY_APP_ID && MY_APP_ID.length > 5) {
        NSString *ratingUrl = [NSString stringWithFormat:
                               @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", MY_APP_ID];
        if ([AppUtility systemVersion].floatValue >= 7.0) {
            //            ratingUrl = @"https://itunes.apple.com/cn/app/yi-tao-shi-shang-hui/id635194542?mt=8";
            ratingUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", MY_APP_ID];
        }
        NSString *msg = [NSString stringWithFormat:@"您的评分对我们非常重要，\n给%@打个分吧！", @" 即时汇率 "];
        self.rateManager = [[AppRateManager alloc] initWithTitle:msg URL:ratingUrl];
        [self.rateManager smartShow];
    }
    
#if debug
//    self.deviceToken = @"2d9c27352c6d372b95081bd3aaa4c40da6339437ec535607b954997f0bd79a48";//测试token
#endif
    
    if (CURRENT_DEVICE >= 8.0) {
        UIUserNotificationSettings *UserNotificationSettings=[UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:UserNotificationSettings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    if (launchOptions) {
        NSDictionary *remote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remote) {
            [self checkAndProcessRemotePushMessage:remote];
        }
    }
    
    [[JRTemporaryData sharedInstance] prepare];
    [self initSplashGdtAdManager];
    
    [self showNineTonAd];
    
    return YES;
}

- (void)checkNotification:(UIApplication *)application
{
    if (CURRENT_DEVICE >= 8.0) {
        UIUserNotificationSettings *UserNotificationSettings=[UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:UserNotificationSettings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}

- (void)initSplashGdtAdManager
{
    if (![[JRTemporaryData sharedInstance] showGLGDTSplash]) {
        return;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return;
    }
    _splashAdManager = [[GLSplashGdtAdManager alloc] initGdtAdWith:[[JRTemporaryData sharedInstance] gdtSplashAppkey] placement:[[JRTemporaryData sharedInstance] gdtSplashPlaceId] baseCon:self.window.rootViewController];
    [_splashAdManager setDelegate:self];
    [_splashAdManager loadSpashGdtAd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGLSplashData) name:kLoadGDTNotification object:nil];
}


- (void)refreshGLSplashData
{
    [_splashAdManager loadSpashGdtAd];
}

- (void)splashAdManager:(GLSplashGdtAdManager *)manager requestResult:(BOOL)result
{
    if (result == 1) {
        UIImage *image = manager.splashImage;
        [[NineTonSplashManager sharedInstance] setGlGdtSplash:image];
    }
}

- (void)showNineTonAd
{
    [[NineTonConfigManager sharedInstance] getConfigWithCid:@"showad" andCompletionBlock:^(NSInteger statusCode, id response) {
        if (statusCode == 200 && response != nil && [[response objectForKey:@"status"]integerValue] == 1) {
            NSString *result = [response objectForKey:@"content"];
            if (result != nil && ![result isKindOfClass:[NSNull class]] && result.length > 0 &&[result isEqualToString:@"1"]) {
                //开启广告
                [[NineTonAdManager sharedInstance] prepare];
                [[NineTonAdManager sharedInstance] setDelegate:self];
                [[NineTonConfigManager sharedInstance] getCRToastArrayAndPlugArrayCompletionBlock:^(NSArray *toastArray, NSArray *plugArray) {
                    //NSLog(@"--->%@",toastArray);
                    [[NineTonAdManager sharedInstance] setCRToastDataSourse:toastArray andPlugDataSourse:plugArray];
                    [[NineTonAdManager sharedInstance] firstShowAD];
                } andFailBlock:^(NSError *error) {
                }];
            }else{
                //关闭广告
            }
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}


- (void)getiTunesAppId:(NSString *)itunesId
{
    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    SKStoreProductViewController * vc = [[SKStoreProductViewController alloc] init];
    [vc setDelegate:self];
    [navigationController presentViewController:vc animated:YES
                     completion:nil];
    [vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:itunesId}
                  completionBlock:^(BOOL result, NSError *error) {
                      if(error)
                      {
                          [vc dismissViewControllerAnimated:YES completion:nil];
                      }
                  }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = tokenStr;
    DLog(@"good luck! get deviceToken=%@", tokenStr);
    [self getNoticeListFromWeb];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"error = %@", error);
}

- (void)checkAndProcessRemotePushMessage:(NSDictionary *)message{
    
    if ([[message objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"汇率提醒"
                                                        message:[[message objectForKey:@"aps"] stringAttribute:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    [self getNoticeListFromWeb];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;//把icon上的标记数字设置为0,
    
    DLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    
    //注意：在程序在运行时，这句，会让主界面突然跳到下载页面去。
    [self checkAndProcessRemotePushMessage:userInfo];
}

- (void)getNoticeListFromWeb
{
    if (self.deviceToken) {
        NSString *path = [NSString stringWithFormat:@"%@%@", NOTICE_URL, self.deviceToken];
        NSURL *url = [NSURL URLWithString:path];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        request.delegate = self;
        [request startAsynchronous];
    }
}
    
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    //程序进入后台时保存汇率提醒
//    GlobleObject *object = [GlobleObject getInstance];
//    if ([object saveNotice])
//    {
//        DLog(@"save succeful!");
//    }
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NineTonSplashManager sharedInstance] systemWillEnterBackground];
    [[NineTonAdManager sharedInstance] setForegroundFlag:NO];
    if (_rateManager) {
        [NSObject cancelPreviousPerformRequestsWithTarget:_rateManager];
        [AppRateManager appDeactive];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NineTonSplashManager sharedInstance] systemWillEnterForeground];
    [[NineTonAdManager sharedInstance] setForegroundFlag:YES];
    [self getNoticeListFromWeb];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadGDTNotification object:nil];
    
    if (self.deviceToken == nil || self.deviceToken.length == 0) {
        [self checkNotification:application];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
    
    [AppRateManager appActive];
    NSNotification *notify = [NSNotification notificationWithName:@"AppBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

#pragma mark ASIHttpRequest Delegate Methods
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [AppUtility showMBLodingWithMessage:@"获取提醒列表失败"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NULL error:&error];
    
    
    if (![result[@"isok"] boolValue])//获取数据成功
    {
        NSArray *datas = result[@"msg"];
        GlobleObject *globle = [GlobleObject getInstance];
        globle.totalNoticeCount = datas.count;
        globle.notices = datas;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RateNoticeDidUpdate" object:nil];
    }
}
@end
