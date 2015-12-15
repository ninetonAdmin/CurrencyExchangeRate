//
//  NineTonSplashView.m
//  CurrencyExchangeRate
//
//  Created by LeungJR on 15/6/10.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import "NineTonSplashView.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "NineTonSplashManager.h"
#import "GDTNativeAd.h"
#import "GLWebViewController.h"
#import "MainChineseExchangeRateAppDelegate.h"

@interface NineTonSplashView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView   *loadWebView;
@property (nonatomic, strong) UIImageView *placeHolderImageView;
@property (nonatomic, strong) UIImageView *gdtPlaceHolderImageView;
@property (nonatomic, strong) NSString    *rootUrl;
@property (nonatomic, assign) BOOL        rootFlag;
@property (nonatomic, assign) CGFloat     splashDuration;

@property (nonatomic, strong) NSString    *appId;
@property (nonatomic, strong) NSString    *type;//0无链接,1.安装文件链接,2.AppStore链接,3.活动链接
@property (nonatomic, strong) NSString    *link;
@property (nonatomic, strong) NSString    *splashId;
@property (nonatomic, assign) BOOL        successLoadImage;
@property (nonatomic, assign) GDTNativeAdData *currentAdData;

@end

@implementation NineTonSplashView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //um 获取splashDuration时间
        NSString *umDuration = [MobClick getConfigParams:@"splashDuration"];
        if (umDuration == nil || umDuration.length == 0) {
            self.splashDuration = 3;
        }else{
            self.splashDuration = umDuration.floatValue;
        }
        [self registerNotification];
        [self setupViews];
    }
    return self;
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gdtSuccess) name:kSplashGDTSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gdtFail) name:kSplashGDTFailNotification object:nil];
}

- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.loadWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [_loadWebView setDelegate:self];
    
    self.gdtPlaceHolderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_gdtPlaceHolderImageView setBackgroundColor:[UIColor clearColor]];
    [_gdtPlaceHolderImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_gdtPlaceHolderImageView setAlpha:1.0];
    [_gdtPlaceHolderImageView setUserInteractionEnabled:YES];
    [self addSubview:_gdtPlaceHolderImageView];
    
    UITapGestureRecognizer *tapGdt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gdtImageViewRecognzier:)];
    [_gdtPlaceHolderImageView addGestureRecognizer:tapGdt];
    
    self.placeHolderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_placeHolderImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_placeHolderImageView setUserInteractionEnabled:YES];
    [_placeHolderImageView setAlpha:1.0f];
    [_placeHolderImageView setImage:[self placeHolderImageWithDevice]];
    [self addSubview:_placeHolderImageView];
    
    UITapGestureRecognizer *tapPlaceImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeImageViewRecognzier:)];
    [_placeHolderImageView addGestureRecognizer:tapPlaceImage];
    
    
    
    
}

#pragma mark - Public

- (void)loadTJData:(NSDictionary *)aTJData
{
    if (aTJData == nil || aTJData.count == 0) {
        [self hiddenSplashViewWithAnimation:YES];
        return;
    }
    self.splashId = [aTJData objectForKey:@"id"];
    self.type = [aTJData objectForKey:@"pictype"];
    NSString *imagePath = [self handleImagePath:aTJData];
    NSString *activityLink = [aTJData objectForKey:@"link"];
    if ([activityLink hasPrefix:@"http://"])
    {
        self.link = activityLink;
    }
    else
    {
        self.link = [NSString stringWithFormat:@"%@%@",@"http://",activityLink];
    }
    if ([activityLink hasPrefix:@"https://"])
    {
        self.link = activityLink;
    }
    
    if ([_type isEqualToString:@"2"] || [_type isEqualToString:@"3"]) {
        [self webViewRequestLoadWithLink:_link];
    }
    [self loadImageWithPath:imagePath];
}

- (void)gdtSuccess
{
    NSArray *array = [NineTonSplashManager sharedInstance].nativeDataArray;
    self.currentAdData = [array objectAtIndex:arc4random()%array.count];
    [self loadImageWithPath:[_currentAdData.properties objectForKey:GDTNativeAdDataKeyImgUrl]];
}

- (void)gdtFail
{
    [self hiddenSplashViewWithAnimation:YES];
}

- (void)loadFutureTJImageData:(NSDictionary *)data
{
    NSString *imagePath = [[self handleImagePath:data] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imagePath] options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
    }];
}

- (void)loadImageWithPath:(NSString *)imagePath
{
    self.successLoadImage = NO;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __weak UIImageView *safeImageView = _placeHolderImageView;
    //__block BOOL safeSuccessLoadImage = _successLoadImage;
    __weak NineTonSplashView *safeSelf = self;
    
    [queue addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:imagePath];
        [safeImageView sd_setImageWithURL:url placeholderImage:[self placeHolderImageWithDevice] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            safeSelf.successLoadImage = YES;
            if (error) {
                [safeSelf hiddenSplashViewWithAnimation:YES];
                return;
            }
            if (_splashStatus == kSplashStatusGDT) {
                [safeImageView setImage:image];
                [[NineTonSplashManager sharedInstance].nativeAd attachAd:_currentAdData toView:self];
            }else if (_splashStatus == kSplashStatusTj){
                [safeImageView setImage:image];
            }
            [safeSelf performSelector:@selector(switchGDTViewController) withObject:nil afterDelay:_splashDuration];
        }];
    }];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerOutLoadImageView:) userInfo:queue.operations.firstObject repeats:NO];
}

- (void)timerOutLoadImageView:(NSTimer *)timer
{
    if (_successLoadImage == YES) {
        return;
    }
    NSOperation *loadImageOperation = [timer userInfo];
    [loadImageOperation cancel];
    [self hiddenSplashViewWithAnimation:YES];
}

- (void)switchGDTViewController
{
    if ([NineTonSplashManager sharedInstance].glGdtSplash != nil) {
        [_gdtPlaceHolderImageView setImage:[NineTonSplashManager sharedInstance].glGdtSplash];
        MainChineseExchangeRateAppDelegate *appDelegate = (MainChineseExchangeRateAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.splashAdManager attachNativeAdTo:_gdtPlaceHolderImageView withAdData:appDelegate.splashAdManager.adData];
        [UIView animateWithDuration:0.5 animations:^{
            //[_gdtPlaceHolderImageView setAlpha:1.0f];
            [_placeHolderImageView setAlpha:0.0];
        } completion:^(BOOL finished) {
            if (finished == YES) {
                [self performSelector:@selector(hiddenSplashViewWithAnimation:) withObject:nil afterDelay:3.0f];
            }
        }];
    }else{
        [self hiddenSplashViewWithAnimation:YES];
    }
    
}

- (void)hiddenSplashViewWithAnimation:(BOOL)animation
{
    if (animation == YES) {
        [UIView animateWithDuration:0.6 animations:^{
            [self setAlpha:0.0];
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.6 animations:^{
            [self setAlpha:0.0];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)webViewRequestLoadWithLink:(NSString *)aLink
{
    [_loadWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aLink]]];
}

- (NSString *)handleImagePath:(NSDictionary *)loadData
{
    NSString *result = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
            result = [loadData objectForKey:@"ipad_pic_y"];
        }else{
            result = [loadData objectForKey:@"ipad_pic_x"];
        }
    }else{
        if ([NineTonSplashView isiPhone6] || [NineTonSplashView isiPhone6Plus]) {
            result = [loadData objectForKey:@"iphone_pic_big"];
        }else{
            result = [loadData objectForKey:@"iphone_pic_small"];
        }
    }
    return result;
}

#pragma mark - UIwebView Delegate method


- (BOOL)isStoreUrl:(NSString*)url
{
    return ([url hasPrefix:@"https://itunes.apple.com"] || [url hasPrefix:@"http://itunes.apple.com"]);
}

- (NSString*)iTunesIdViaUrlStr:(NSString*)urlStr {
    NSAssert(([urlStr hasPrefix:@"https://itunes.apple"] || [urlStr hasPrefix:@"http://itunes.apple"]), @"Parameter should be a valid store link");
    NSString *result = nil;
    @try {
        NSRange begin = [urlStr rangeOfString:@"/id"];
        NSRange end = [urlStr rangeOfString:@"?" options:NSBackwardsSearch];
        if (0 == end.length || end.location < begin.location) {
            end.location = [urlStr length];
        }
        NSInteger index = begin.location+begin.length;
        NSInteger len = end.location-(begin.location+begin.length);
        result = [urlStr substringWithRange:NSMakeRange(index,len)];
        
    }
    @catch (NSException *exception) {
        result = nil;
    }
    return result;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url1=[[request URL] absoluteString];
    NSLog(@"new url = %@", url1);
    if([self isStoreUrl:url1]){
        NSString *itunesId=[self iTunesIdViaUrlStr:url1];
        if (itunesId) {
            self.appId = itunesId;
            return NO;
        }
    }
    if ([self isSetupPackageUrl:url1]) {
        self.rootUrl = url1;
        if (self.rootFlag == YES) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

- (BOOL)isSetupPackageUrl:(NSString *)url
{
    if ([url hasPrefix:@"itms-services://"] || [url hasPrefix:@"itms-service://"]) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if (_splashStatus == kSplashStatusTj) {
//        [self tappedTJ];
//    }else if (_splashStatus == kSplashStatusGDT){
//        [self tappedGDT];
//    }
}

- (void)placeImageViewRecognzier:(UITapGestureRecognizer *)tap
{
    if (_splashStatus == kSplashStatusTj) {
        [self tappedTJ];
    }else if (_splashStatus == kSplashStatusGDT){
        [self tappedGDT];
    }
}

- (void)gdtImageViewRecognzier:(UITapGestureRecognizer *)tap
{
    MainChineseExchangeRateAppDelegate *appDelegate = (MainChineseExchangeRateAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.splashAdManager clickNativeAd:appDelegate.splashAdManager.adData];
    [self hiddenSplashViewWithAnimation:YES];
}

- (void)tappedTJ
{
    if ([self.type isEqualToString:@"0"])
    {
        return;
    }
    else if ([self.type isEqualToString:@"1"])
    {
        [MobClick event:@"v4_splash_click"];
//        if ([[JRWeatherTemporaryData sharedInstance] onSplashFlag].integerValue == 1) {
//            [[NineTonConfigManager sharedInstance] onClickSplashID:_splashId];
//        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:kSplashViewControllerDidGetActivityURLNotification object:self.link];
        if ([_nineTonSplashDelegate respondsToSelector:@selector(tapTJSplashActivityURL:)]) {
            [_nineTonSplashDelegate tapTJSplashActivityURL:_link];
        }
        [self hiddenSplashViewWithAnimation:YES];
    }
    
    else if ([self.type isEqualToString:@"2"])
    {
        
        [MobClick event:@"v4_splash_click"];
        if (self.appId)
        {
//            if ([[JRWeatherTemporaryData sharedInstance] onSplashFlag].integerValue == 1) {
//                [[NineTonConfigManager sharedInstance] onClickSplashID:_splashId];
//            }
          //  [[NSNotificationCenter defaultCenter] postNotificationName:kSplashViewControllerDidGetAppIDNotification object:self.appId];
            if ([_nineTonSplashDelegate respondsToSelector:@selector(tapTJSplashAppId:)]) {
                [_nineTonSplashDelegate tapTJSplashAppId:_appId];
            }
            [self hiddenSplashViewWithAnimation:YES];
        }
        else
        {
        }
        
        return;
    }
    else if ([self.type isEqualToString:@"3"])
    {
        self.rootFlag = YES;
//        if ([[JRWeatherTemporaryData sharedInstance] onSplashFlag].integerValue == 1) {
//            [[NineTonConfigManager sharedInstance] onClickSplashID:_splashId];
//        }
        [self webViewRequestLoadWithLink:_rootUrl];
        [self hiddenSplashViewWithAnimation:YES];
        return;
    }
}

- (void)tappedGDT
{
    [[NineTonSplashManager sharedInstance].nativeAd clickAd:_currentAdData];
}

- (void)clearSplashViews
{
    [self setAlpha:1.0f];
    self.splashId = @"";
    [_placeHolderImageView setImage:[self placeHolderImageWithDevice]];
    [_placeHolderImageView setAlpha:1.0f];
    [_gdtPlaceHolderImageView setAlpha:1.0f];
    self.link = @"";
    self.appId = @"";
    self.type = @"";
    self.rootUrl = @"";
    self.rootFlag = NO;
    self.splashStatus = kSplashStatusNone;
}


#pragma mark - private

- (UIImage *)placeHolderImageWithDevice
{
    //配置各个尺寸开屏静态图
    UIImage *result = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([NineTonSplashView isiPhone4]) {
            result = [UIImage imageNamed:@"Default"];
        }else if ([NineTonSplashView isiPhone5]){
            result = [UIImage imageNamed:@"Default-568h"];
        }else if ([NineTonSplashView isiPhone6]){
            result = [UIImage imageNamed:@"Default750x1334"];
        }else if ([NineTonSplashView isiPhone6Plus]){
            result = [UIImage imageNamed:@"Default"];
        }
    }else{
        if (self.frame.size.width >= 1024) {
            //lan
        }else{
            //por
        }
    }
    return result;
}

+ (BOOL)isiPhone4
{
    return [[UIScreen mainScreen] bounds].size.height == 480;
}

+ (BOOL)isiPhone5
{
    return [[UIScreen mainScreen] bounds].size.height == 568;
}
+ (BOOL)isiPhone6
{
    return [[UIScreen mainScreen] bounds].size.height == 667;
}
+ (BOOL)isiPhone6Plus
{
    return ([[UIScreen mainScreen] bounds].size.height == 736);
}


@end
