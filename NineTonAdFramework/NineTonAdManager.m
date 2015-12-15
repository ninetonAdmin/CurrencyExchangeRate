//
//  NineTonAdManager.m
//  AdAnimationDemo
//
//  Created by admin on 14/12/24.
//  Copyright (c) 2014年 youloft. All rights reserved.
//

#import "NineTonAdManager.h"
#import "CRToast.h"
#import "SDWebImageManager.h"
#import "NineTonConfigManager.h"

#define kNineTonAdLaunchCount @"kNineTonAdLaunchCount"

@interface NSDate (NineTonAdDate)

/**
 * 标准时间转字符串
 * @method stringWithdateFormatter
 * @para aDateFormatter 时间格式
 * @return 时间字符串
 */
- (NSString *)stringWithdateFormatter:(NSString *)aDateFormatter;

@end

@implementation NSDate (NineTonAdDate)

- (NSString *)stringWithdateFormatter:(NSString *)aDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:aDateFormatter];
    return [dateFormatter stringFromDate:self];
}

@end

@interface NineTonPlugAdView ()

@end

@implementation NineTonAdManager
{
    NineTonPlugAdView *adView;
    UIView *transBlackView;
    UIWindow *window;
    NSMutableArray *plugDataArray;
    NSMutableArray *crtoastDataArray;
    NSArray *timeArray;
    NSInteger launchCount;
    NSInteger timeIndex;
    BOOL lastAdTypeFlag;
    BOOL isForeground;
    NSInteger maxLaunchCount;
}

+ (NineTonAdManager *)sharedInstance
{
    static NineTonAdManager *_obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_obj) {
            _obj = [[NineTonAdManager alloc] init];
        }
    });
    return _obj;
}

#pragma mark - public
- (void)prepare
{
    [self initializeDataLayer];
    window = [UIApplication sharedApplication].keyWindow;
    transBlackView = [[UIView alloc] initWithFrame:CGRectMake(window.center.x, window.center.y, 1, 1)];
    [transBlackView setBackgroundColor:[UIColor blackColor]];
    [transBlackView setAlpha:0.7];
    [transBlackView setHidden:YES];
    [window addSubview:transBlackView];
    __weak UIView *safeView = transBlackView;
    __weak UIWindow *safeWindow = window;
    __weak NineTonAdManager *safeSelf = self;
    adView = [[NineTonPlugAdView alloc] initWithFrame:CGRectMake(window.center.x, window.center.y, 1, 1)];
    [adView setShowAnimationBlock:^{
        [safeView setHidden:NO];
        [safeView setFrame:CGRectMake(0, 0, safeWindow.frame.size.width, safeWindow.frame.size.height)];
       
    }];
    [adView setDismissAnimationBlock:^{
        [safeView setFrame:CGRectMake(safeWindow.center.x, safeWindow.center.y, 0, 0)];
       
    }];
    [adView setDidDismissEventBlock:^{
        [safeSelf performSelector:@selector(firstShowAD)];
    }];
    [window addSubview:adView];
}

- (void)setDelegate:(id<NineTonPlugADViewDelegate>)delegate
{
    [adView setDelegate:delegate];
}

- (void)startReloadAdDataSourse:(NSArray *)dataSourse
{
    [adView prepareLoadAdDataSourse:dataSourse];
}

- (void)setCRToastDataSourse:(NSArray *)crArray andPlugDataSourse:(NSArray *)plugArray
{
    if (crArray != nil && ![crArray isKindOfClass:[NSNull class]] && crArray.count != 0) {
        [crtoastDataArray addObjectsFromArray:crArray];
    }
    if (plugArray != nil && ![plugArray isKindOfClass:[NSNull class]] && plugArray.count != 0) {
        [plugDataArray addObjectsFromArray:plugArray];
    }
    [adView prepareLoadAdDataSourse:plugDataArray];
    
}

- (void)firstShowAD
{
    [self performSelector:@selector(showAd) withObject:nil afterDelay:[[timeArray objectAtIndex:timeIndex] integerValue]];
}

- (void)showAd
{
    if (isForeground == YES) {
        if (launchCount >= maxLaunchCount) {
            //当天不能再显示广告
        }else{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                if (crtoastDataArray.count != 0 && plugDataArray.count != 0) {
                    if (lastAdTypeFlag) {
                        [adView adWillAppear];
                    }else{
                        [self showCRToast];
                    }
                    lastAdTypeFlag = !lastAdTypeFlag;
                }else if (crtoastDataArray.count != 0 && plugDataArray.count == 0){
                    [self showCRToast];
                }else if (crtoastDataArray.count == 0 && plugDataArray.count != 0){
                    [adView adWillAppear];
                }
            }else{
                [adView adWillAppear];
                
            }
            timeIndex ++;
            launchCount ++;
            [self storeLaunchCount];
        }
    }
}

- (void)dismissAd
{
    [adView execAdDisAppear];
    [self clear];
}

- (void)setForegroundFlag:(BOOL)flag
{
    if (flag == NO) {
        timeIndex = 0;
    }
    if (flag == YES && isForeground == NO) {
        if (adView.hidden == YES) {
            [self firstShowAD];
        }
    }
    isForeground = flag;
}

- (void)clear
{
    timeIndex = 0;
}

#pragma mark - private

- (void)showCRToast
{
    __weak NineTonAdManager *safeSelf = self;
    NSInteger random = arc4random()%crtoastDataArray.count;
    NSDictionary *dic = [crtoastDataArray objectAtIndex:random];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [CRToastManager showNotificationWithOptions:[self optionsWithRequestDic:dic andIconImage:image]
                                     apperanceBlock:^(void) {
                                         NSLog(@"Appeared");
                                     }
                                    completionBlock:^(void) {
                                        NSLog(@"Completed");
                                        [safeSelf performSelector:@selector(firstShowAD)];
                                    }];
    }];
}

- (void)initializeDataLayer
{
    [[NineTonConfigManager sharedInstance] getConfigWithCid:@"maxlaunchcount" andCompletionBlock:^(NSInteger statusCode, id response) {
        if (statusCode == 200 && [[response objectForKey:@"status"] integerValue] == 1) {
            NSString *result = [response objectForKey:@"content"];
            if (result != nil && ![result isKindOfClass:[NSNull class]] && result.length > 0) {
                maxLaunchCount = [result integerValue];
            }else{
                maxLaunchCount = 2;
            }
        }else{
            maxLaunchCount = 2;
        }
    } andFailBlock:^(NSError *error) {
        maxLaunchCount = 2;
    }];
    timeArray = @[@"10", @"60", @"400", @"800", @"1700",@"2100",@"2500",@"3000"];
    timeIndex = 0;
    crtoastDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    plugDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger random = arc4random()%2 + 1;
    if (random == 1) {
        lastAdTypeFlag = YES;
    }else{
        lastAdTypeFlag = NO;
    }
    isForeground = YES;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kNineTonAdLaunchCount];
    if (dic == nil || [dic isKindOfClass:[NSNull class]]) {
        launchCount = 0;
        [self storeLaunchCount];
    }else{
        if ([[self getNowDateFormatterString] isEqualToString:[dic objectForKey:@"date"]]) {
            launchCount = [[dic objectForKey:@"count"] integerValue];
        }else{
            launchCount = 0;
            [self storeLaunchCount];
        }
    }
}

- (NSString *)getNowDateFormatterString
{
    return [[NSDate date] stringWithdateFormatter:@"yyyy-MM-dd"];
}

- (void)storeLaunchCount
{
    NSDictionary *dic = @{@"count" : [NSNumber numberWithInteger:launchCount],
                          @"date"  : [self getNowDateFormatterString]};
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kNineTonAdLaunchCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary*)optionsWithRequestDic:(NSDictionary *)dic andIconImage:(UIImage *)image
{
    __weak NineTonPlugAdView *safeADView = adView;
    
    NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeNavigationBar),
                                      kCRToastNotificationPresentationTypeKey   : @(CRToastPresentationTypePush),
                                      kCRToastUnderStatusBarKey                 : @(1),
                                      kCRToastTextKey                           : [dic objectForKey:@"title"],
                                      kCRToastTextColorKey                      : [UIColor whiteColor],
                                      kCRToastTextAlignmentKey                  : @(NSTextAlignmentLeft),
                                      kCRToastTimeIntervalKey                   : @([[dic objectForKey:@"showtime"] floatValue]),
                                      kCRToastAnimationInTypeKey                : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey               : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey           : @([[dic objectForKey:@"animInDirection"] integerValue]),
                                      kCRToastAnimationOutDirectionKey          : @([[dic objectForKey:@"animOutDirection"] integerValue]),
                                      kCRToastBackgroundColorKey                : [UIColor blackColor],
                                      kCRToastSubtitleTextColorKey              : [UIColor whiteColor]} mutableCopy];
    if (image != nil) {
        options[kCRToastImageKey] = image;
    }
    if (![[dic objectForKey:@"subtitle"] isEqualToString:@""]) {
        options[kCRToastSubtitleTextKey] = [dic objectForKey:@"subtitle"];
        options[kCRToastSubtitleTextAlignmentKey] = @(NSTextAlignmentLeft);
    }
    options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap
                                                                                                  automaticallyDismiss:YES
                                                                                                                 block:^(CRToastInteractionType interactionType){
                                                                                                                     [safeADView loadRequestWithLink:[dic objectForKey:@"linkurl"]];
                                                                                                                     
                                                                                                                 }]];
    options[kCRToastTextColorKey] = [UIColor blackColor];
    return [NSDictionary dictionaryWithDictionary:options];
}

@end
