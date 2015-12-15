//
//  MainChineseExchangeRateViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-29.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
#import "ClipView.h"
#import "ASIHTTPRequest.h"
#import "ChineseExchangeRateListViewController.h"
#import "RateCalcViewController.h"
#import "MenuViewController.h"
#import "TheListOfRateViewController.h"
#import "AboutUsViewController.h"
#import "RateNoticeViewController.h"
#import "AnimateButton.h"
#import "AboutCurrenyRateViewController.h"

@interface MainChineseExchangeRateViewController : UIViewController<UIScrollViewDelegate, ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet MyCustomButton *showMenuButton; //use outlet to init the button in viewDidLoad
@property (weak, nonatomic) IBOutlet MyCustomButton *editButton;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;

@property (nonatomic, weak) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray *subViewsOfScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *navigationBarView;

@property (weak, nonatomic) IBOutlet ClipView *myClipView;

@property (weak, nonatomic) IBOutlet ClipView *clipView;
@property (strong, nonatomic) MenuViewController *menuController;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *updateLable;
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, weak) IBOutlet UIView *animateView;
@property (nonatomic, weak) IBOutlet UIImageView *animateImageView;
@property (nonatomic, weak) IBOutlet UIImageView *animateBackImageView;

@property (nonatomic, weak) IBOutlet AnimateButton *updateButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;


- (IBAction)editButtonDown;

- (IBAction)menuButtonDown;

- (IBAction)shareButtonPressed:(id)sender;

//更新数据
- (IBAction)updateButtonPressed:(id)sender;


@end
