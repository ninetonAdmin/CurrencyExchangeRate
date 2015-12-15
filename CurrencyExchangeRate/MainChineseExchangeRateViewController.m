//
//  MainChineseExchangeRateViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-29.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "MainChineseExchangeRateViewController.h"
#import "DetailChineseExchangeRateViewController.h"
#import "GlobleObject.h"
#import <QuartzCore/QuartzCore.h>
#import "MyUtilities.h"
#import "UIView+SnapShot.h"
#import "UMSocial.h"
#import "RateNoticeViewController.h"
#import "HistoryTrendViewController.h"
#import "Notice.h"
#import "NoticeDetailController.h"
#import "UserGuideViewController.h"

NSUInteger showAlterViewTag1 = 124365;
NSUInteger showAlterViewTag2 = 124465;

@interface MainChineseExchangeRateViewController ()<UMSocialUIDelegate, UIAlertViewDelegate>
{
    BOOL isScrollingFromPageControl;
    BOOL isPaseChineseRate;//标志当前是否在解析（网络请求返回时）
    BOOL isPaseAllRate;
    NSInteger totalPage;
    NSInteger currentPage;
}

@property (nonatomic, strong) HistoryTrendViewController *historyTrendViewController;
@property (nonatomic, weak) DetailChineseExchangeRateViewController *selectController;//历史走势动画的view
@property (nonatomic) CGRect originFrame;

@property (nonatomic, strong) GlobleObject *globleObject;

- (void)loadScrollViewWithPage:(NSInteger)page;
- (void)currentChineseRatesChangedHandler;
- (void)reloadSubviewsInScrollView;

@end

@implementation MainChineseExchangeRateViewController

@synthesize subViewsOfScrollView = _subViewsOfScrollView;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *) subViewsOfScrollView
{
    if (!_subViewsOfScrollView) {
        _subViewsOfScrollView = [[NSMutableArray alloc] init];
    }
    return _subViewsOfScrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.globleObject = [GlobleObject getInstance];
    
    [self setupSubviews];
    
    [self requestNoticeList];
    [self initDate];
    
    [self registerNotification];
    
}

#pragma mark  ---------- 配置subviews ----------

- (void)setupSubviews
{
    self.myScrollView.width = DEVICE_WIDTH - 65;
    self.myScrollView.x = 40;
    self.myClipView.scrollView = self.myScrollView;
    
    // Added by LY on 2015-06-11
    [self.navigationBarView setImage:[UIImage imageNamed:@"v2-navigationbar-bg.png"]];
    
    [self.showMenuButton setImage:[UIImage imageNamed:@"v2-altert-normal.png"] forState:UIControlStateNormal];
    [self.showMenuButton setImage:[UIImage imageNamed:@"v2-altert-active.png"] forState:UIControlStateHighlighted];
    
    /*
     * Deleted By LY 0n 2015-06-11
     *
    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"main-menu-icon-normal.png"] forState:UIControlStateNormal];
    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"main-menu-icon-active.png"] forState:UIControlStateHighlighted];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    */
    
    self.updateButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.updateButton.layer.shadowOffset = CGSizeMake(0, -2);
    self.updateButton.layer.shadowOpacity = 0.5;
    self.updateButton.layer.shadowRadius = 2.0;
    
    self.shareButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shareButton.layer.shadowOffset = CGSizeMake(0, -2);
    self.shareButton.layer.shadowOpacity = 0.5;
    self.shareButton.layer.shadowRadius = 2.0;
    
    //init the scrollview and pagecontrol
    //self.myScrollView.contentSize = CGSizeMake(255*5, self.myScrollView.frame.size.height);
    self.myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH - 65)*5, 0);

    
    totalPage = 5;
    currentPage = 1;
    self.pageLabel.text = @"1/5";
    
    // Added By LY on 2015-06-11
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    
    self.clipView.clipsToBounds = YES;
    
    //  add calcviewcontroller to calrview
    UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MenuViewController *mvc = [sd instantiateViewControllerWithIdentifier:@"Menu"];
    self.menuController = mvc;
    CGRect frame1 = self.menuController.view.frame;
    
    if (CURRENT_DEVICE < 7.0f)
    {
        frame1.origin.y -= 20;
    }
    
    self.menuController.view.frame = frame1;
    
    self.mainView.clipsToBounds = YES;
    
    //定时器每10分钟更新一次汇率
    self.timer = [NSTimer scheduledTimerWithTimeInterval:autorefreshTimeInterval target:self selector:@selector(runTimerForRequest) userInfo:nil repeats:YES];

    self.animateImageView.layer.masksToBounds = YES;
    self.animateImageView.layer.cornerRadius = 10.f;
    UIImage *shadowImage = [UIImage imageNamed:@"exchange-box-shadow.png"];
    shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    self.animateBackImageView.image = shadowImage;
}

-(void) setScrollViewAndPageControlerWithPage:(NSInteger)page
{
    self.myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH - 65)*page, 0);
//    self.myPageControl.numberOfPages = page;
    totalPage = page;
    
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, (long)totalPage];
    
    // Added By LY on 2015-06-11
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = currentPage - 1;
    
    
//    NSString *string = self.pageLabel.text;
//    NSRange range = [string rangeOfString:@"/"];
//    self.pageLabel.text = [[string substringToIndex:range.location] stringByAppendingString:[NSString stringWithFormat:@"%d", page]];
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
    UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DetailChineseExchangeRateViewController *dcervc = [sd instantiateViewControllerWithIdentifier:@"chineseRateBox"];
    
    dcervc.countryCodeIdentifier = [self.globleObject.currentChineseRates objectAtIndex:page];
    
    //CGRect frame = self.myScrollView.frame;
    CGRect frame = dcervc.view.frame;
    if (page == 0) {
        frame.origin.x = 0;
    } else {
        frame.origin.x = (DEVICE_WIDTH - 65)*page;
    }
    
    frame.origin.y = 0;
    
    dcervc.view.frame = frame;
    
    if ([dcervc.view.layer respondsToSelector:@selector(setShouldRasterize:)]) {
        dcervc.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [dcervc.view.layer setShouldRasterize:YES];
    }
    
    [self.myScrollView addSubview:dcervc.view];
    
    [[self subViewsOfScrollView] insertObject:dcervc atIndex:page];
}

#pragma mark  ---------- 注册通知 ----------

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentChineseRatesChangedHandler) name:@"TheCurrenyChineseRateIsChange" object:nil];
    
    //响应用户取消菜单界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMenuHandler:) name:@"DisMissMenu" object:nil];
    
    //响应用户在侧边栏打开状态下点击右侧页面，右侧页面向左滑，隐藏侧边栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuLeftSwipeHandler:) name:@"MenuLeftSwipe" object:nil];
    
    //响应用户点击了其他界面（非即时汇率界面）的菜单按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(othersMenuButtonDown:) name:@"OtherMenuButtonDown" object:nil];
    
    //响应用户点击了快速添加时，禁止上面几个按钮的响应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deInteractionTitleButtons) name:@"DeInteractionTitleButtons" object:nil];
    
    //响应用户不再快速添加时，不要禁止上面几个按钮的响应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interactionTitleButtons) name:@"InteractionTitleButtons" object:nil];
    
    //在appdelegete中的becomeactive被回调时，发出这个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:@"AppBecomeActive" object:nil];
    
    //相应汇率提醒中添加或者编辑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeEditHandler:) name:@"RingBoxEditNotification" object:nil];
    
    //历史走势按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trendButtonPressed:) name:@"TrendButtonPressedNotification" object:nil];
    
    //分享按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButtonPressed:) name:@"ShareButtonPressedNotification" object:nil];
    
    //获取到用户汇率提醒设置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNewNotice) name:@"RateNoticeDidUpdate" object:nil];
}

//在appBecomeActive中主要是关于更新数据的操作
-(void)appBecomeActive
{
//    DLog(@"appBecomeActive-------------");
    [self runTimerForRequest];
}

#pragma mark  ---------- 初始化数据 ----------

-(void) initDate
{
    //获取本地缓存的数据
    BOOL haveChineseRatesFile = NO;//标示是否保存了ChineseRates.plist这个文件
    bool haveAllRatesFile = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    if (!documentsDirectoryPath) {

    } else {
        //获取人民币现汇数据-------------
        NSString *chinesesRatesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"ChineseRates.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:chinesesRatesFile])
        {
            haveChineseRatesFile = YES;
            self.globleObject.chineseRates = [NSMutableDictionary dictionaryWithContentsOfFile:chinesesRatesFile];
            
            self.globleObject.updateTimeForChineseRate = [AppUtility getObjectForKey:@"updateTimeForChineseRate"];
            self.updateLable.text = self.globleObject.updateTimeForChineseRate;

            //再请求一次，相当与每次打开都更新一次
            [self requestChineseRateClearCache:NO];
        }else
        {
            //网络请求
            [self requestChineseRateClearCache:NO];
        }
        
        //获取相对汇率相关数据-------------
        NSString *allRatesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"AllRates.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:allRatesFile])
        {

            haveAllRatesFile = YES;
            self.globleObject.theRates = [NSMutableDictionary dictionaryWithContentsOfFile:allRatesFile];
            
            self.globleObject.updateTimeForCalc = [AppUtility getObjectForKey:@"updateTimeForCalc"];
            //再请求一次，相当与每次打开都更新一次
            [self requestAllRate];
        }else
        {
            //网络请求
            [self requestAllRate];
        }
        
        //获取人民币现汇用户定义显示的国家--------
        NSString *currentChinesesRatesCountryFile = [documentsDirectoryPath stringByAppendingPathComponent:@"CurrentChineseRatesCountry.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:currentChinesesRatesCountryFile])
        {
            self.globleObject.currentChineseRates = [NSMutableArray arrayWithContentsOfFile:currentChinesesRatesCountryFile];
            //注意：若没有找到相关文件，则使用默认的国家
        }
        
        //加载滑动的人民币详细界面--
        if (haveChineseRatesFile) {
            [self setScrollViewAndPageControlerWithPage:[self.globleObject.currentChineseRates count]];
            for (int a = 0; a <= [self.globleObject.currentChineseRates count] -1; a++)
            {
                [self loadScrollViewWithPage:a];
            }
        }
        
        //获取（汇率计算器）用户定义显示的国家--------
         NSString *calcRatesCountryFile = [documentsDirectoryPath stringByAppendingPathComponent:@"CalcRatesCountry.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:calcRatesCountryFile])
        {
            self.globleObject.currenteCalcRates = [NSMutableArray arrayWithContentsOfFile:calcRatesCountryFile];
            //注意：若没有找到相关文件，则使用默认的国家
        }
    }
}

//设置自动更新时间间隔
-(void) runTimerForRequest
{
    NSDate *lastUpdateDate = [AppUtility getObjectForKey:@"LastUpdateDate"];
//    DLog(@"lastUpdateDate = %@", lastUpdateDate);
    
    if ([lastUpdateDate  isEqual:@""]) {
        lastUpdateDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
//    return;
    NSTimeInterval interval = [lastUpdateDate timeIntervalSinceNow];
//    DLog(@"interval = %f", interval);
    
    //当距离上次更新时间大于5分钟时才更新
    int time = -autorefreshTimeInterval + 10;

    if (interval < time) {
        [self requestNoticeList];
        [self requestChineseRateClearCache:NO];
        [self requestAllRate];
    }
}

#pragma mark  ---------- 数据请求和代理 ----------

- (void)requestNoticeList
{
    if ([GlobleObject getInstance].notices || ![MyUtilities deviceToken]) {
        return;
    }
    
    NSString *deviceToken = [MyUtilities deviceToken];
    NSString *path = [NSString stringWithFormat:@"%@%@", NOTICE_URL, deviceToken];
    NSURL *url = [NSURL URLWithString:path];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:@"RequestNoticeList"];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) requestChineseRateClearCache:(BOOL)clear
{
    if (isPaseChineseRate) {
//        DLog(@"isPaseChineseRate!!!!!!!!!!!!");
        return;
    } else {
//        DLog(@"isNotPaseChineseRate!!!!!!!!!!!!");
        isPaseChineseRate = YES;
    }
    
    NSURL *url = nil;
    if (clear) {
        url = [NSURL URLWithString:@"http://currency.51wnl.com/APIS/GetDetailRateInfo?clearCache=1"];
    } else {
        NSDate *date = [NSDate date];
        NSTimeInterval interval = [date timeIntervalSince1970];
        NSString *strUrl = [NSString stringWithFormat:@"http://currency.51wnl.com/APIS/GetDetailRateInfo?clearCache=0&currentDate=%f", interval];
        url = [NSURL URLWithString:strUrl];
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:@"ChineseRate"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestAllRate
{
    if (isPaseAllRate) {
//        DLog(@"isPaseAllRate!!!!!!!!!!!!");
        return;
    } else {
//        DLog(@"isNotPaseAllRate!!!!!!!!!!!!");
        isPaseAllRate = YES;
    }
    //NSURL *url = [NSURL URLWithString:@"http://download.finance.yahoo.com/d/quotes.txt?f=sl1d1t1&s=EURCNY=x+EURUSD=x+EURGBP=x+EURJPY=x+EURAUD=x+EUREUR=x+EURCAD=x+EURKRW=x+EURHKD=x+EURTWD=x+EURMOP=x+EURARS=x+EUREGP=x+EURAED=x+EURBHD=x+EURBRL=x+EURPKR=x+EURPLN=x+EURDKK=x+EURRUB=x+EURFJD=x+EURPHP=x+EURKZT=x+EURCZK=x+EURHRK=x+EURKES=x+EURKWD=x+EURQAR=x+EURMYR=x+EURMXN=x+EURPEN=x+EURNPR=x+EURNGN=x+EURNOK=x+EURZAR=x+EURSEK=x+EURCHF=x+EURSAR=x+EURSCR=x+EURLKR=x+EURTRY=x+EURTHB=x+EURBND=x+EURUAH=x+EURVND=x+EURNZD=x+EURSGD=x+EURINR=x+EURIDR=x+EURILS=x+EURJMD=x+EURCLP=x"];
    NSURL *url = [NSURL URLWithString:@"http://currency.51wnl.com/apis/GetYooHData"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:@"TheRate"];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
//    DLog(@"requese name = %@", request.username);
    
    @try {
        if ([request.username isEqualToString:@"RequestNoticeList"]) {
            NSString *responseString = request.responseString;
            DLog(@"responseString = %@",responseString);
            NSDictionary *dict = [responseString objectFromJSONString];
            //        DLog(@"dict = %@", dict);
            if ([dict isKindOfClass:[NSDictionary class]] && ![dict[@"isok"] boolValue])
            {
                NSArray *datas = dict[@"msg"];
                [GlobleObject getInstance].totalNoticeCount = datas.count;
                [GlobleObject getInstance].notices = datas;
            }
        } else if ([request.username isEqualToString:@"ChineseRate"]) {
            
            NSString *str = [request responseString];
            
            //简单判断返回的数据字符串是否有效
            NSRange range = [str rangeOfString:@"countryCode"];
            if (range.location == NSNotFound) {
                [AppUtility showMBLodingWithMessage:@"返回数据错误，请稍后再试" andInView:self.view];
                    self.updateButton.enabled = YES;
                    return;
            }
            
//            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:request.responseData options:NULL error:&error];
//            DLog(@"array = %@", array);

            if (array == nil) {
                [AppUtility showMBLodingWithMessage:@"返回数据解析错误，请稍后再试" andInView:self.view];
                [self.updateButton stopAnimating];
                self.updateButton.enabled = YES;
                return ;
            }

            for (NSDictionary *object in array) {
               
                NSString *name = [object stringAttribute:@"countryCode"];

                if (name && [name length] == 3) {
                    [self.globleObject.chineseRates setValue:object forKey:name];
                }
            }
            
            //更新时间
            NSDictionary *tempData = [array objectAtIndex:0];
            NSString *date = [tempData stringAttribute:@"date"];
            NSString *time = [tempData stringAttribute:@"time"];
            
            NSString *updateTime = [[NSString alloc] initWithFormat:@"更新于 %@ %@", date, time];
//            DLog(@"人民币汇率更新时间  02 = %@", updateTime);
            self.globleObject.updateTimeForChineseRate = updateTime;
            self.updateLable.text = self.globleObject.updateTimeForChineseRate;
            
            [AppUtility storeObject:self.globleObject.updateTimeForChineseRate forKey:@"updateTimeForChineseRate"];
//            DLog(@"人民币汇率更新时间  03 = %@", [AppUtility getObjectForKey:@"updateTimeForChineseRate"]);
            
            //保存数据
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryPath = [paths objectAtIndex:0];
            if (!documentsDirectoryPath) {
//                DLog(@"documentsDirectoryPath is not found!!!!!!!!");
            } else {
                NSString *chinesesRatesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"ChineseRates.plist"];
                if ([self.globleObject.chineseRates writeToFile:chinesesRatesFile atomically:NO]) {
//                    DLog(@"chineseRates = %@", _globleObject.chineseRates);
//                    DLog(@"ChineseRates.plist is save!!!!!!!!");
                }
            }
            
            //避免多次添加
            if ([self.myScrollView subviews].count == 0) {
                [self setScrollViewAndPageControlerWithPage:[self.globleObject.currentChineseRates count]];
                for (int a = 0; a <= [self.globleObject.currentChineseRates count] -1; a++) {
                    [self loadScrollViewWithPage:a];
                }
            } else {
                //更新数据
                [self reloadSubviewsInScrollView];
            }
        
            [self checkNewNotice];
            
            [AppUtility showMBLodingWithMessage:@"更新成功" andInView:self.view];
            [self.updateButton stopAnimating];
            self.updateButton.enabled = YES;
            isPaseChineseRate = NO;
        }
        else
        {
            [self.updateButton stopAnimating];
            self.updateButton.enabled = YES;
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
            if ( array == nil || array.count == 0) {
                [AppUtility showMBLodingWithMessage:@"返回数据错误，请稍后再试" andInView:self.view];
            }
            /*
            //简单判断返回的数据字符串是否有效
            NSRange range = [str rangeOfString:@"EUR"];
//            DLog(@"range.location = %d", range.location);
            
            if (range.location == NSNotFound) {
                [AppUtility showMBLodingWithMessage:@"返回数据错误，请稍后再试" andInView:self.view];
//                [MyUtilities showMessage:@"返回数据错误，请稍后重试" withTitle:@"提示"];
                return ;
            }
            
            NSArray *countryArray = [str componentsSeparatedByString:@"\n"];
            
            if (countryArray == nil || countryArray.count == 0) {
                [AppUtility showMBLodingWithMessage:@"返回数据解析错误，请稍后再试" andInView:self.view];
//                [MyUtilities showMessage:@"返回数据解析错误，请稍后重试" withTitle:@"提示"];
                return ;
            }
             */
            NSArray *countryArray = array;
            
            for (NSString *countryInfoStr in countryArray) {
                NSArray *countryRateInfoArray = [countryInfoStr componentsSeparatedByString:@","];

                if (countryRateInfoArray.count > 1) {
                    NSString *countryCode = [countryRateInfoArray objectAtIndex:0];
                    countryCode = [countryCode substringWithRange:NSMakeRange(3, 3)];
                    NSString *rateStr = [countryRateInfoArray objectAtIndex:1];

                    float rate = rateStr.floatValue;
                    rate = roundf(rate*10000)/10000.0;

                    NSNumber *num = [[NSNumber alloc] initWithFloat:rate];
                    [self.globleObject.theRates setValue:num forKey:countryCode];
                }
            }
            
            //更新时间 雅虎借口返回的时间貌似不是中国时区，不知道是哪个时区，故采用本地时间
            //        NSString *countryInfoStr = [countryArray objectAtIndex:0];
            //        NSArray *countryRateInfoArray = [countryInfoStr componentsSeparatedByString:@","];
            //
            //        NSString *dateInfo = [countryRateInfoArray objectAtIndex:2];
            //        NSArray *subDateInfo  = [dateInfo componentsSeparatedByString:@"/"];
            //        NSString *date = [[NSString alloc] initWithFormat:@"%@-%@-%@", [subDateInfo objectAtIndex:2], [subDateInfo objectAtIndex:0], [subDateInfo objectAtIndex:1]];
            //
            //        NSString *timeInfo = [countryRateInfoArray objectAtIndex:3];
            //更新时间
            NSDateFormatter *frt = [[NSDateFormatter alloc] init];
            [frt setDateStyle:kCFDateFormatterShortStyle];
            [frt setDateFormat:@"更新于 yyyy-MM-dd HH:mm:ss"];
            NSString *tmp = [frt stringFromDate:[NSDate date]];
            
            self.globleObject.updateTimeForCalc = tmp;
            self.updateLable.text = tmp;
            
            //保存
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryPath = [paths objectAtIndex:0];
            if (!documentsDirectoryPath) {
//                DLog(@"documentsDirectoryPath is not found!!!!!!!!");
            }else
            {
                NSString *allRatesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"AllRates.plist"];
                if ([self.globleObject.theRates writeToFile:allRatesFile atomically:NO]) {
//                    DLog(@"AllRates.plist is save!!!!!!!!");
                }
            }
            isPaseAllRate = NO;
        }
        
        //保存这次更新的时间
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:@"LastUpdateDate"];
    }
    @catch (NSException *exception) {
        [AppUtility showMBLodingWithMessage:@"更新数据出错，请稍后再试" andInView:self.view];

        //保存一个时间，表示这次更新数据出错了
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"LastUpdateDate"];
        isPaseChineseRate = NO;
        isPaseAllRate = NO;
        DLog(@"isPaseChineseRate finished!!!!!!!!!!!");
    }
    @finally {
        
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    DLog(@"requestFailed.request.name = %@", request.username);
    [AppUtility showMBLodingWithMessage:@"更新失败" andInView:self.view];
    [self.updateButton stopAnimating];
    [self.updateButton setEnabled:YES];
    if ([request.username isEqualToString:@"ChineseRate"]) {
        isPaseChineseRate = NO;
    }else
    {
       isPaseAllRate = NO; 
    }
    
    //保存一个时间，表示这次更新数据出错了
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"LastUpdateDate"];
    
    if ([request.username isEqualToString:@"ChineseRate"]) {
        if ([self.myScrollView subviews].count == 0) {
        }
    }
}

// 是否有新的汇率提示
- (void)checkNewNotice
{
    @try {
        NSArray *noticeArray = [GlobleObject getInstance].notices;
        for (NSDictionary *rowData in noticeArray)
        {
            BOOL hasNewNotice = NO;
            Notice *notice = [[Notice alloc] initWithCheckItem:rowData[@"checkitem"]
                                                   compareType:rowData[@"comparetype"]
                                                   countryCode:rowData[@"countrycode"]
                                                      ringrate:rowData[@"ringrate"]];
            notice.noticeId = rowData[@"id"];
            
//            JPY =     {
//                country = "\U65e5\U5143";
//                countryCode = JPY;
//                date = "2015-11-18";
//                ratemiddle = "5.1706";
//                time = "14:37:41";
//                xcmc = "5.1964";
//                xcmr = "5.0009";
//                xhmc = "5.1964";
//                xhmr = "5.1602";
//            };
            NSDictionary *dictAll = self.globleObject.chineseRates;
//            NSLog(@"%@", dictAll);
            NSEnumerator *enumerator = [dictAll keyEnumerator];
            NSString *key;
            while ((key = [enumerator nextObject]))
            {
                if ([key isEqualToString:notice.countryCode])
                {
                    NSDictionary *dict = dictAll[key];
                    
                    CGFloat ratePrice = [notice.price floatValue];
                    CGFloat newValue = 0.0;
                    
                    if (notice.noticeType == NoticeTypeSpotExchangeBuy) {
                        newValue = [dict[@"xhmr"] floatValue];
                    } else if(notice.noticeType == NoticeTypeSpotExchangeSale) {
                        newValue = [dict[@"xhmc"] floatValue];
                    }
                    
                    if ((notice.compareType == CompareTypeHigher && newValue > ratePrice) ||
                        (notice.compareType == CompareTypeLower && newValue < ratePrice) )
                    {
                        hasNewNotice = YES;
                        break;
                    }
                }
            }
            
            if (hasNewNotice)
            {
                UIImageView *dotImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v2-dot.png"]];
                dotImgView.tag = 1;
                [dotImgView setFrame: CGRectMake(16, 8, 8, 8)];
                [self.showMenuButton addSubview:dotImgView];
                break;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


#pragma mark  ---------- IBAction ----------

//编辑按钮响应方法
- (IBAction)editButtonDown {
        [self performSegueWithIdentifier:@"ShowChineseExchangeRate" sender:self];
        //[self performSegueWithIdentifier:@"ShowCalcRate" sender:self];
}

//侧边栏按钮响应方法
- (IBAction)menuButtonDown {
//    self.myBlindView.hidden = NO;
//    self.menuController.menuTableview.userInteractionEnabled = YES;
//    
//    [self.menuController rightMoveShadow];
//    [UIView beginAnimations:@"ShowMenu" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    
//    CGRect frame1 = self.mainView.frame;
//    frame1.origin.x += 275;
//    self.mainView.frame = frame1;
//    
//    [UIView commitAnimations];
//    


//    [self performSegueWithIdentifier:@"ShowRateNotice" sender:self];
    
    [self checkDeviceToken];
    
    for (UIView *subview in [self.showMenuButton subviews])
    {
        if (1 == subview.tag)
        {
            [subview removeFromSuperview];
        }
    }
}

- (void)checkDeviceToken
{
    if (CURRENT_DEVICE >= 8.0) {
        BOOL isRemoteNotify = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
        if (!isRemoteNotify) {
            [self showAltertSetNotification];
        } else {
            [self skipToRateNotice];
        }
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //        int typeBadge = (type & UIRemoteNotificationTypeBadge);
        //        int typeSound = (type & UIRemoteNotificationTypeSound);
        //        int typeAlert = (type & UIRemoteNotificationTypeAlert);
        //        BOOL ret =  !typeBadge || !typeSound || !typeAlert;
        
        if (type == UIRemoteNotificationTypeNone) {
            [self showAltertSetNotification];
        } else {
            [self skipToRateNotice];
        }
    }
}

- (void)skipToRateNotice
{
    NSString *deviceToken = [MyUtilities deviceToken];
    if (deviceToken) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *rateNoticeVC = [board instantiateViewControllerWithIdentifier:@"RateNotice"];
        [self.navigationController pushViewController:rateNoticeVC animated:YES];
    } else {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"亲，我们暂时无法获取到你的ID，请稍后重试，或关闭程序后再次启动！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alterView show];
    }
}

- (void)showAltertSetNotification
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"设置汇率提醒，需要先打开通知推送，是否现在设置？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置", nil];
        alterView.tag = showAlterViewTag1;
        [alterView show];
    } else {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"设置汇率提醒，需要先打开通知推送，请到【设置】-【通知】-【即时汇率】中打开允许通知开关。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alterView.tag = showAlterViewTag2;
        [alterView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == showAlterViewTag1) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

//分享按钮响应方法
- (IBAction)shareButtonPressed:(id)sender
{
    UIImage *snapShotImage = [self.view capture];
    
    @try {
        
//        [UMSocialData defaultData].extConfig.appUrl = @"https://itunes.apple.com/cn/app/ji-shi-hui-lu/id570604441?mt=8";
//        UMSocialData *socialData = [UMSocialData defaultData];
//        socialData.title = @"即时汇率分享";
//        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeOther;
//        WXWebpageObject *webObject = [WXWebpageObject object];
//        webObject.webpageUrl = @"https://itunes.apple.com/cn/app/ji-shi-hui-lu/id570604441?mt=8";
//        socialData.extConfig.wxMediaObject = webObject;

        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"50ad9a9e52701542b900007d"
                                          shareText:@"即时汇率是一款汇率即时查询软件，独有的人民币汇率查询，为国内用户贴心设计：https://itunes.apple.com/cn/app/ji-shi-hui-lu/id570604441?mt=8"
                                         shareImage:snapShotImage
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToRenren, UMShareToSms, UMShareToEmail, nil]
                                           delegate:self];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception);
        DLog(@"UMSocialData initialize failed!");
    }
    @finally {
        
    }
}

//更新按钮响应方法
- (IBAction)updateButtonPressed:(id)sender
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:autorefreshTimeInterval target:self selector:@selector(runTimerForRequest) userInfo:nil repeats:YES];
    [self requestChineseRateClearCache:YES];
//    [self requestAllRate];
    
    AnimateButton *button = sender;
    self.updateButton = button;
    [button startAnimating];
    button.enabled = NO;
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.fromValue = [NSNumber numberWithFloat:0];
//    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
////    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.duration = 0.7f;
//    animation.repeatCount = CGFLOAT_MAX;
////    animation.autoreverses
//    [button.layer addAnimation:animation forKey:@"transform.rotation"];
}


#pragma mark  ---------- scrollViewDelegate ----------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isScrollingFromPageControl) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;

    int page;
    if (scrollView.contentOffset.x <= 120) {
        page = 0;
    }else{
        page = floor((scrollView.contentOffset.x - 120) / pageWidth) + 1;
    }

    currentPage = page + 1;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, (long)totalPage];
    
    // Added By LY on 2015-06-11
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isScrollingFromPageControl = NO;
}

//- (IBAction)changePage:(id)sender {
//    int page = self.myPageControl.currentPage;
//    // update the scroll view to the appropriate page
//    CGRect frame = self.myScrollView.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    
//    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
//    isScrollingFromPageControl = YES;
//    
//    [self.myScrollView scrollRectToVisible:frame animated:YES];
//    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
//}



-(void)currentChineseRatesChangedHandler
{
    DLog(@"currentChineseRatesChangedHandler is execute");
    
    if (self.subViewsOfScrollView.count == self.globleObject.currentChineseRates.count) {
        //只是变化了显示顺序
        for (int i = 0; i < self.subViewsOfScrollView.count; i++) {
            [(DetailChineseExchangeRateViewController *)([self.subViewsOfScrollView objectAtIndex:i]) setCountryCodeIdentifier:[self.globleObject.currentChineseRates objectAtIndex:i]];
        }
    } else if(self.subViewsOfScrollView.count > self.globleObject.currentChineseRates.count) {
        //用户删除了一些显示国家
        NSInteger count = self.subViewsOfScrollView.count - self.globleObject.currentChineseRates.count;
        
        //remove the subview in scroll view  ---fist
        for (NSInteger i = self.globleObject.currentChineseRates.count ; i < self.subViewsOfScrollView.count ; i++) {
            DetailChineseExchangeRateViewController *dcervc = [self.subViewsOfScrollView objectAtIndex:i];
            UIView *view = dcervc.view;
            [view removeFromSuperview];
        }
        
        //remove object at subViewsOfScrollView  ---second
        for (int j = 0; j < count; j++) {
            [self.subViewsOfScrollView removeLastObject];
        }
        
        //refresh  ---thrid
        for (int a = 0; a < self.subViewsOfScrollView.count; a++) {
            [(DetailChineseExchangeRateViewController *)([self.subViewsOfScrollView objectAtIndex:a]) setCountryCodeIdentifier:[self.globleObject.currentChineseRates objectAtIndex:a]];
        }
        
        [self setScrollViewAndPageControlerWithPage:self.subViewsOfScrollView.count];
    } else {
    //用户添加了一些国家
        NSInteger count = self.subViewsOfScrollView.count;
        
        //add the subview in scroll view  ---fist
        for (NSInteger i = count ; i < self.globleObject.currentChineseRates.count ; i++) {
            [self loadScrollViewWithPage:i];
        }
        
        //refresh  ---second
        for (int a = 0; a < count; a++) {
            [(DetailChineseExchangeRateViewController *)([self.subViewsOfScrollView objectAtIndex:a]) setCountryCodeIdentifier:[self.globleObject.currentChineseRates objectAtIndex:a]];
        }
        
        [self setScrollViewAndPageControlerWithPage:self.subViewsOfScrollView.count];
    }
    
    [self reloadSubviewsInScrollView];
    
    //保存当前用户定义要展示的国家
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    if (!documentsDirectoryPath) {
        DLog(@"documentsDirectoryPath is not found!!!!!!!!");
    } else {
        NSString *calcRatesCountryFile = [documentsDirectoryPath stringByAppendingPathComponent:@"CurrentChineseRatesCountry.plist"];
        if ([self.globleObject.currentChineseRates writeToFile:calcRatesCountryFile atomically:NO]) {
            DLog(@"CurrentChineseRatesCountry.plist is save!!!!!!!!");
        }
    }
}

- (void)reloadSubviewsInScrollView
{
    for (DetailChineseExchangeRateViewController  *object in self.subViewsOfScrollView) {
        [object reloadTheViews];
    }
}

- (void)othersMenuButtonDown:(NSNotification *)notification
{
    self.menuController.menuTableview.userInteractionEnabled = YES;
    
    [self.menuController rightMoveShadow];
    [UIView beginAnimations:@"ShowMenu" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [UIView commitAnimations];
}


#pragma mark  ---------- 侧边栏操作动画 ----------
-(void)leftMoveMainView
{    
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveLinear animations:^(){
        CGRect frame = self.mainView.frame;
        frame.origin.x -= 320;
        self.mainView.frame = frame;
    } completion:^(BOOL result){
    }];
}



#pragma mark  ---------- 更新数据提醒动画 ----------

//- (void)beginUpdateBtnAnimation:(NSString *)text
//{
//    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//        self.updateLable.y -= 20;
//    } completion:^(BOOL finished) {
//        self.updateLable.text = text;
//        self.updateLable.y += 60;
//        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//            self.updateLable.y -= 35;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:ANIMATION_DURATION * 10 animations:^{
//                self.updateLable.y -= 10;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//                    self.updateLable.y -= 15;
//                } completion:^(BOOL finished) {
//                    self.updateLable.text = self.globleObject.updateTimeForChineseRate;
//                    self.updateLable.y += 60;
//                    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//                        self.updateLable.y -= 40;
//                    }];
//                }];
//            }];
//        }];
//    }];
//}

#pragma mark  ---------- 通知响应的方法 ----------


//主窗口的位移动画
- (void)moveView:(UIView *)theView distance:(CGFloat)distance
{
    CGRect frame = theView.frame;
    frame.origin.x = 275.f + distance;
    if (frame.origin.x > 0)
    {
        theView.frame = frame;
        frame = self.menuController.shadowView.frame;
        frame.origin.x = 245.f + distance;
        self.menuController.shadowView.frame = frame;
    }
}


//停止滑动的时候改变主窗口位置动画
- (void)animationView:(UIView *)theView toLeft:(BOOL)shouldMoveToLeft
{
    [UIView beginAnimations:@"LeftSwipeMenuAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    if (shouldMoveToLeft)
        [UIView setAnimationDidStopSelector:@selector(dismissMenuAnimated)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect frame = theView.frame;
    if (shouldMoveToLeft) {
        frame.origin.x = 0;
    } else {
        frame.origin.x = 275.f;
    }
    theView.frame = frame;
    frame = self.menuController.shadowView.frame;
    if (shouldMoveToLeft) {
        frame.origin.x = -30.f;
    } else {
        frame.origin.x = 245.f;
    }
    
    self.menuController.shadowView.frame = frame;
    [UIView commitAnimations];
}

-(UIImage *) imageFromView:(UIView *) theView
{
    CGSize size = theView.bounds.size;
    UIGraphicsBeginImageContext(size);
    if (&UIGraphicsBeginImageContextWithOptions != nil) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }
    
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIImage * saver = nil;
//    CGImageRef image = theImage.CGImage;
//    
//    size_t cWidth = CGImageGetWidth(image);
//    size_t cHeight = CGImageGetHeight(image);
//    size_t bitsPerComponent = 8;
//    size_t bytesPerRow = 4 * cWidth;
//    
//    //Now we build a Context with those dimensions.
//    CGContextRef context = CGBitmapContextCreate(nil, cWidth, cHeight, bitsPerComponent, bytesPerRow, CGColorSpaceCreateDeviceRGB(), CGImageGetBitmapInfo(image));
//    
//    //The location where you draw your image on the context is not always the same location you have in your UIView,
//    //this could change and you need to calculate that position according to the scale between you images real size, and the size of the UIImage being show on the UIView. Hence the mod floats...
//    CGContextDrawImage(context, CGRectMake(0, 0, cWidth,cHeight), image);
//    
//    float mod = cWidth/(size.width);
//    float modTwo = cHeight/(size.height);
//    
//    //Make the drawing right with coordinate switch
//    CGContextTranslateCTM(context, 0, cHeight);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CGContextClipToMask(context, CGRectMake(theView.layer.mask.frame.origin.x * mod, theView.layer.mask.frame.origin.y * modTwo, theView.layer.mask.frame.size.width * mod,theView.layer.mask.frame.size.height * modTwo), nil);
//    
//    //Reverse the coordinate switch
//    CGAffineTransform ctm = CGContextGetCTM(context);
//    ctm = CGAffineTransformInvert(ctm);
//    CGContextConcatCTM(context, ctm);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, cWidth,cHeight), mosaicLayer.image.CGImage);
//    
//    CGImageRef mergeResult  = CGBitmapContextCreateImage(context);
//    saver = [[UIImage alloc] initWithCGImage:mergeResult];
//    CGContextRelease(context);
//    CGImageRelease(mergeResult);
    return theImage;
}

-(UIImage *) imageFromView:(UIView *)theView atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

-(void) deInteractionTitleButtons
{
    self.editButton.userInteractionEnabled = NO;
    self.showMenuButton.userInteractionEnabled = NO;
}

-(void) interactionTitleButtons
{
    self.editButton.userInteractionEnabled = YES;
    self.showMenuButton.userInteractionEnabled = YES;
}

#pragma mark ---------- UMSocialUIDelegte Methods ----------

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        DLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)trendButtonPressed:(NSNotification *)notifacation
{
//    [self performSegueWithIdentifier:@"TrendViewTransition" sender:notifacation.object];
    //添加一层截图
    DetailChineseExchangeRateViewController *detaiController = notifacation.object;
    self.selectController = detaiController;
    
    UIImage *image = [detaiController.contentView capture];
    CGFloat originX = 32.f;
    CGFloat originY = self.clipView.frame.origin.y - 8.f;
    CGRect frame = CGRectMake(originX, originY, detaiController.shadowImg.frame.size.width, detaiController.shadowImg.frame.size.height);
    self.animateView.frame = frame;
    self.originFrame = frame;

    frame = CGRectMake(8.f, 8.f, detaiController.shadowImg.frame.size.width - 16.f, detaiController.shadowImg.frame.size.height - 16.f);
    self.animateImageView.frame = frame;
    self.animateImageView.image = image;
    self.animateView.hidden = NO;
    
    //隐藏真实的汇率视图
    detaiController.contentView.hidden = YES;
    detaiController.shadowImg.hidden = YES;

    //实例化走势图controller
    UIStoryboard *mainStroryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    HistoryTrendViewController *controller = [mainStroryBoard instantiateViewControllerWithIdentifier:@"HistoryTrend"];
    NSArray *currentChineseRates = self.globleObject.currentChineseRates;
    NSInteger index = [currentChineseRates indexOfObject:detaiController.countryCodeIdentifier];
    controller.currentPageIndex = index;
    if (DeviceSystemMajorVersion() < 7)
    {
        CGRect frame =  controller.view.frame;
        frame.origin.y -= 20.f;
        controller.view.frame = frame;
    }
    self.historyTrendViewController = controller;
    
    // 在下一秒调用动画，因为到等当前runloop停止，否则动画效果不一样
    [self performSelector:@selector(animateTrendView) withObject:nil afterDelay:0.001f];
}

- (void)animateTrendView
{
    //动画添加走势图的view
    [UIView animateWithDuration:0.5f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(){
                         self.animateView.frame = self.view.bounds;
                         [self.animateView addSubview:self.historyTrendViewController.view];
                         [self.historyTrendViewController.backButton addTarget:self action:@selector(historyTrendBack:) forControlEvents:UIControlEventTouchUpInside];
                         
                         //动画测试
                         CATransition *anima = [CATransition animation];
                         anima.duration = 0.5f;
                         anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                         anima.type = @"oglFlip";
                         anima.subtype = kCATransitionFromLeft;
                         anima.delegate = self;
                         // UIView *view = [self.view.subviews objectAtIndex:0];
                         // view.layer addAnimation:anima forKey:nil];
                         [self.animateView.layer addAnimation:anima forKey:nil];
                     }
                     completion:nil];
}

- (void)historyTrendBack:(id)sender
{
    //动画移除走势图的view
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^()
     {
         self.animateView.frame = self.originFrame;
         UIView *theView = [(UIButton *)sender superview];
         [theView removeFromSuperview];
         
         //动画测试
         CATransition *anima = [CATransition animation];
         anima.duration = 0.5f;
         anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
         anima.type = @"oglFlip";
         anima.subtype = kCATransitionFromRight;
         anima.delegate = self;
         //         UIView *view = [self.view.subviews objectAtIndex:0];
         //         [view.layer addAnimation:anima forKey:nil];
         [self.animateView.layer addAnimation:anima forKey:nil];
         
     }completion:^(BOOL finished){//动画完成后隐藏显示动画的那个view，显示真实的汇率视图
         self.historyTrendViewController = nil;
         self.animateView.hidden = YES;
         self.selectController.contentView.hidden = NO;
         self.selectController.shadowImg.hidden = NO;
     }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark  ---------- MemoryWarning ----------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Added by LY on 2015-06-11
    self.navigationController.navigationBarHidden = YES;
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.showMenuButton];
//    //把左右两个按钮添加入导航栏集合中
//    [self.navigationItem setRightBarButtonItem:rightButton];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
////    [self.navigationItem setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sPLN.png"]]];
//    self.title = @"人民币汇率";
    
    [self requestNoticeList];
}

- (void)viewDidUnload {
    [self setClipView:nil];
    [self setMyBgImg:nil];
    [self setMainView:nil];
    [self setUpdateLable:nil];
    [super viewDidUnload];
}

@end
