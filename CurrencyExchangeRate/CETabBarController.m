//
//  CETabBarController.m
//  CurrencyExchangeRate
//
//  Created by admin on 14/12/25.
//  Copyright (c) 2014年 HuangZhenPeng. All rights reserved.
//

#import "CETabBarController.h"
#import "MobClick.h"
#import <StoreKit/StoreKit.h>
#import "NineTonSplashManager.h"
#import "JRTemporaryData.h"

@interface CETabBarController ()<SKStoreProductViewControllerDelegate>


@end

@implementation CETabBarController
{
    NSMutableArray *tabBarArray;
    
    NSArray *titileArr;
    NSArray *imageNormalArr;
    NSArray *imageSelectedArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 按钮文本信息
    titileArr = [NSArray arrayWithObjects:@"人民币汇率", @"换算汇率", @"汇率列表", @"我的钱包", nil];
    // 按钮正常图标
    imageNormalArr = [NSArray arrayWithObjects:@"v2-tabbar-CNY.png", @"v2-tabbar-calculator.png", @"v2-tabbar-ratelist.png", @"v2-tabbar-myrate.png", nil];
    // 按钮选中图标
    imageSelectedArr = [NSArray arrayWithObjects:@"v2-tabbar-CNY.png", @"v2-tabbar-calculator.png", @"v2-tabbar-ratelist.png", @"v2-tabbar-myrate.png", nil];
    
    // 按钮背景图片
    UIImage *bgImageNormal = [UIImage imageNamed:@"v2-tabbar-bg-normal.png"];
    UIImage *bgImageSelected = [UIImage imageNamed:@"v2-tabbar-bg-selected.png"];
    UIImage *imgDivider = [UIImage imageNamed:@"v2-tabbar-divider.png"];
    
    // 中间点
    UIEdgeInsets edgeNormal = UIEdgeInsetsMake(bgImageNormal.size.height / 2, bgImageNormal.size.width / 2,
                                               bgImageNormal.size.height / 2, bgImageNormal.size.width / 2);
    UIEdgeInsets edgeSelected = UIEdgeInsetsMake(bgImageSelected.size.height / 2, bgImageSelected.size.width / 2,
                                                 bgImageSelected.size.height / 2, bgImageSelected.size.width / 2);
    
    // Do any additional setup after loading the view.
    //[self.tabBar setHidden:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.tabBar setBackgroundImage:[bgImageNormal resizableImageWithCapInsets:edgeNormal resizingMode:UIImageResizingModeTile]];
        [self.tabBar setContentMode:UIViewContentModeTop];
        [self.tabBar setClipsToBounds:YES];
    } else {
        [self.tabBar setHidden:YES];
    }
    
    // 单个按钮宽度
    int width = ceilf(self.tabBar.bounds.size.width / titileArr.count);
    
    tabBarArray = [[NSMutableArray alloc] initWithCapacity:0];
//    UIView *customBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 49 + 3, self.view.width, self.tabBar.height - 3)];
//    [customBar setBackgroundColor:[UIColor colorWithHexString:@"#e8e8e8"]];
//    [self.view addSubview:customBar];
    
    for (NSInteger i = 0; i < titileArr.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(width * i, self.view.height - self.tabBar.height, width, self.tabBar.height)];
        [button setTag:i];
        [tabBarArray addObject:button];
        
        [button setBackgroundImage:[bgImageNormal resizableImageWithCapInsets:edgeNormal resizingMode:UIImageResizingModeTile] forState:UIControlStateNormal];
        [button setBackgroundImage:[bgImageSelected resizableImageWithCapInsets:edgeSelected resizingMode:UIImageResizingModeTile] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[bgImageSelected resizableImageWithCapInsets:edgeSelected resizingMode:UIImageResizingModeTile] forState:UIControlStateSelected];
        
        [button setImage:[UIImage imageNamed:imageNormalArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageSelectedArr[i]] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:imageSelectedArr[i]]forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        button.imageEdgeInsets = UIEdgeInsetsMake(-5, 15, 9, button.titleLabel.bounds.size.width);
        
        [button setTitle:titileArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.titleEdgeInsets = UIEdgeInsetsMake(30, -button.titleLabel.bounds.size.width - 30, 0, 0);
        
        // Add by Luo On 2015-09-08
        CGSize imageSize = button.imageView.frame.size;
        CGSize titleSize = button.titleLabel.frame.size;
        CGFloat totalHeight = (imageSize.height + titleSize.height);
        button.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);
        
        if (i == 0) {
            [button setSelected:YES];
        }
        
        [self.view addSubview:button];
    }
    
    for (int i = 1; i < titileArr.count; i++) {
        UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, self.view.height - self.tabBar.height, 1, self.tabBar.height)];
        [dividerImageView setImage:imgDivider];
        [self.view addSubview:dividerImageView];
    }
    
    [self showSplashView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)buttonDidClicked:(UIButton *)button
{
    for (UIButton *button in tabBarArray) {
        [button setSelected:NO];
    }
    
    [button setSelected:YES];
    [self setSelectedIndex:button.tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSplashView
{
    NSString* currentReviewVersion = [MobClick getConfigParams:@"currentReviewVersion"];
    NSString *str = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    DLog(@"--->%@",str);
    
    if (currentReviewVersion == nil || [currentReviewVersion isEqualToString:str]) {
        // 审核中
    } else {
        // 已通过审核
        NSString *show = [MobClick getConfigParams:@"showsplash"];
        
        if (show != nil && show.integerValue == 1) {
            [[NineTonSplashManager sharedInstance] prepareWithViewController:self];
            [[NineTonSplashManager sharedInstance] reloadNineTonSplashDataOnInternet];
        }
    }
}

@end
