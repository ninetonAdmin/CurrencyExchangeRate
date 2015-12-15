//
//  DetailChineseExchangeRateViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-30.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "DetailChineseExchangeRateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "MyUtilities.h"
#import "YLDomobWallViewController.h"
//#import "YLMobisageRecommendViewController.h"

@interface DetailChineseExchangeRateViewController ()

@property (nonatomic, weak) IBOutlet UIButton *commendBtn;

@end

@implementation DetailChineseExchangeRateViewController

- (IBAction)commendButtonPressed:(id)sender
{
    UINavigationController *rootVC = (UINavigationController *)[AppUtility getFrontViewController];

    YLDomobWallViewController *dwVC = [[YLDomobWallViewController alloc] initWithPublisherId:nil placementId:nil parentViewController:nil];
    [dwVC setWallCategory:DMWallCategoryAll];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dwVC];
    
    [rootVC presentViewController:nav animated:YES completion:^{

    }];
}

//-(BOOL)popMobisageWallById:(NSString*)idstr{
//    
//    @try {
//        
//        
//        
//        YLMobisageRecommendViewController *tmp = [[YLMobisageRecommendViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmp];
//         UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        [navigationController.viewControllers[0] presentModalViewController:nav animated:YES];
//        return YES;
//    }
//    @catch (NSException *exception) {
//        return NO;
//    }
//}
//@synthesize contentDic = _contentDic;

//-(void)setContentDic:(NSDictionary *)contentDic
//{
////    DLog(@"hhhhhh%@", contentDic);
//    _contentDic = contentDic;
//    
//    self.countryCodeIdentifier = [contentDic objectForKey:@"countryCode"];
////    DLog(@"setContentDic:self.countryCodeIdentifier = %@", self.countryCodeIdentifier);
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ringBoxBackButtonClick:) name:@"RingBoxBackButtonClick" object:nil];
    
    //顺序改变或者添加国家后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentChineseRatesChangedHandler) name:@"TheCurrenyChineseRateIsChange" object:nil];
    
    NSString *adWall = [AppUtility getOnlineParameter:@"adWall"];
    if (adWall == nil) {
        adWall = @"";
    }
    
    if ([adWall isEqualToString:@"1"]) {
        [self.commendBtn setHidden:NO];
    }
    
    UIView *view = [self.view.subviews objectAtIndex:1];
    view.layer.cornerRadius = 10.0;
    view.clipsToBounds = YES;
    
//    CALayer *l = [self.flagImg layer];
//    l.masksToBounds = YES;
//    [l setCornerRadius:9.0];
    
    UIImage *bkImage = [UIImage imageNamed:@"v2-exchange-box-background.png"];
    bkImage = [bkImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    self.backGroundImg.image = bkImage;
    
    /*
     * Deleted by LY on 2015-06-11
     *
    UIImage *shadowImage = [UIImage imageNamed:@"exchange-box-shadow.png"];
    shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    self.shadowImg.image = shadowImage;
    */
    
    [self.trendButton setBackgroundImage:[UIImage imageNamed:@"v2-chart-icon-normal.png"] forState:UIControlStateNormal];
    [self.trendButton setBackgroundImage:[UIImage imageNamed:@"v2-chart-icon-active.png"] forState:UIControlStateHighlighted];
    
    [self.ringButton setBackgroundImage:[UIImage imageNamed:@"v2-share-icon-normal.png"] forState:UIControlStateNormal];
    [self.ringButton setBackgroundImage:[UIImage imageNamed:@"v2-share-icon-active.png"] forState:UIControlStateHighlighted];
    //[self.ringButton setImage:[UIImage imageNamed:@"remind-icon-have.png"] forState:UIControlStateNormal];
    
//    UIView *view = [self.view.subviews objectAtIndex:0];
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(0, 0);
//    view.layer.shadowOpacity = 1.0f;
    
    self.ringBoxView.hidden = YES;
    
    [self reloadTheViews];
}

- (void)ringBoxBackButtonClick:(NSNotification *)noti
{
    RingBoxViewController * rbvc = noti.object;
    if (rbvc == self.ringBoxViewController) {
        //DLog(@"rbvc == self.ringBoxViewController! %@", noti);
        
        //动画测试
        CATransition *anima = [CATransition animation];
        anima.duration = 0.5f;
        anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        anima.type = @"oglFlip";
        anima.subtype = kCATransitionFromLeft;
        anima.delegate = self;
        UIView *view = [self.view.subviews objectAtIndex:0];
        [view.layer addAnimation:anima forKey:nil];
        [self.view.layer addAnimation:anima forKey:nil];
        view.hidden = NO;
        self.ringBoxView.hidden = YES;
        
        //移除ringbox
        UIView *view1 = [self.ringBoxView.subviews objectAtIndex:0];
        [view1 removeFromSuperview];
        self.ringBoxViewController = nil;
    }
}

- (void)currentChineseRatesChangedHandler
{
    UIView *view = [self.view.subviews objectAtIndex:0];
    view.hidden = NO;
    self.ringBoxView.hidden = YES;
    
    //移除ringbox
    if (self.ringBoxView.subviews.count)
    {
        UIView *view1 = [self.ringBoxView.subviews objectAtIndex:0];
        [view1 removeFromSuperview];
        self.ringBoxViewController = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadTheViews
{
//    NSLog(@"%@",[GlobleObject getInstance].chineseRates);
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.countryCodeIdentifier];
//    DLog(@"contentDic = %@", contentDic);
    if (![contentDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *countryCode = [contentDic stringAttribute:@"countryCode"];
    NSString *countryName = [[GlobleObject getInstance].countrysName objectForKey:countryCode];
    NSString *flagPath = [[NSString alloc] initWithFormat:@"b%@.png", countryCode];
    NSString *currenyPrice = [contentDic stringAttribute:@"xhmr"];
    float currenyPricef = currenyPrice.floatValue;
    if (currenyPricef == 0) {
        currenyPrice = @"--";
    }
    //DLog(@"1111111111-----%f", currenyPricef);
    NSString *cashPrice = [contentDic stringAttribute:@"xcmr"];
    float cashPricef = cashPrice.floatValue;
    if (cashPricef == 0) {
        cashPrice = @"--";
    }
    //DLog(@"2222222222-----%f", cashPricef);
    NSString *bankofferPrice = [contentDic stringAttribute:@"xhmc"];
    float bankofferPricef = bankofferPrice.floatValue;
    if (bankofferPricef == 0) {
        bankofferPrice = @"--";
    }
    //DLog(@"3333333333-----%f", bankofferPricef);
    NSString *bankbenchmarkPrice = [contentDic stringAttribute:@"xcmc"];
    float bankbenchmarkPricef = bankbenchmarkPrice.floatValue;
    if (bankbenchmarkPricef == 0) {
        bankbenchmarkPrice = @"--";
    }
    //DLog(@"4444444444-----%f", bankbenchmarkPricef);
    NSString *bankdiscountedPrice = [contentDic stringAttribute:@"ratemiddle"];
    float bankdiscountedPricef = bankdiscountedPrice.floatValue;
    if (bankdiscountedPricef == 0) {
        bankdiscountedPrice = @"--";
    }
    //DLog(@"5555555555-----%f", bankdiscountedPricef);
    
    //    DLog(@"DetailChineseExchangeRateViewController:viewDidLoad");
    //    DLog(@"self.contentDic = %@", self.contentDic);
    //    DLog(@"countryCode = %@", countryCode);
    //    DLog(@"flagPath = %@", flagPath);
    //    NSString *name = [self.contentDic objectForKey:@"country"];
    //    DLog(@"countryname = %@", name);
    //    DLog(@"currenyPrice = %@", currenyPrice);
    //    DLog(@"cashPrice = %@", cashPrice);
    //    DLog(@"bankofferPrice = %@", bankofferPrice);
    
    //set UI content
    self.flagImg.image = [UIImage imageNamed:flagPath];
//    [self.countryNameLable setText:countryName];
//    [self.countryCodeLable setText:countryCode];
    [self.currencyPriceLable setText:currenyPrice];
    [self.cashPriceLable setText:cashPrice];
    [self.bankOfferPriceLable setText:bankofferPrice];
    [self.bankBenchmarkPriceLable setText:bankbenchmarkPrice];
    [self.bankDiscountedPriceLable setText:bankdiscountedPrice];
    [self setCountryNameLabelWithName:countryName code:countryCode];
    
    //[self.view setNeedsDisplay];
    
}

// 设置货币名称和缩写编码
- (void)setCountryNameLabelWithName:(NSString *)name code:(NSString *)code
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", name, code]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, name.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(name.length, code.length + 1)];
    
    if (str.length <= 8) {
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:38.0] range:NSMakeRange(0, name.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(name.length, code.length + 1)];
    } else  {
        self.countryNameLable.adjustsFontSizeToFitWidth = YES;
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0] range:NSMakeRange(name.length, code.length + 1)];
    }
    
    self.countryNameLable.attributedText = str;
    self.countryNameLable.y = CGRectGetMaxY(self.flagImg.frame) - 55;
}

- (void)viewDidUnload {
    [self setRingButton:nil];
    [self setRingBoxView:nil];
    [self setShadowImg:nil];
    [super viewDidUnload];
}

- (IBAction)clikRingButton {
    
    // Added by LY on 2015-06-11
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareButtonPressedNotification" object:self];
    
    /*
     * Deleted by LY on 2015-06-11
     *
    self.ringBoxView.hidden = NO;
    if (self.ringBoxView.subviews.count == 0) {
        //加载ringbox界面
       // DLog(@"self.ringBoxView.subviews.count == 0");
        UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        self.ringBoxViewController = [sd instantiateViewControllerWithIdentifier:@"RingBox"];
        
        self.ringBoxViewController.countryCode = self.countryCodeLable.text;
        CGRect frame = self.ringBoxViewController.view.frame;
        frame.origin.y -= 20;
        self.ringBoxViewController.view.frame = frame;
        [self.ringBoxView addSubview:self.ringBoxViewController.view];
    }
    
    //动画测试
    CATransition *anima = [CATransition animation];
    anima.duration = 0.5f;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anima.type = @"oglFlip";
    anima.subtype = kCATransitionFromRight;
    anima.delegate = self;
    UIView *view = [self.view.subviews objectAtIndex:0];
    [view.layer addAnimation:anima forKey:nil];
    [self.view.layer addAnimation:anima forKey:nil];
//    view.hidden = YES;
    
//    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    fadeAnim.fromValue = [NSNumber numberWithFloat:1.f];
//    fadeAnim.toValue = [NSNumber numberWithFloat:1.3f];
//    fadeAnim.delegate = self;
//    fadeAnim.duration = 0.5;
//    [self.view.layer addAnimation:fadeAnim forKey:@"transform.scale"];
//    self.view.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.3f);
     */
}

- (IBAction)trendButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TrendButtonPressedNotification" object:self];
}

@end
