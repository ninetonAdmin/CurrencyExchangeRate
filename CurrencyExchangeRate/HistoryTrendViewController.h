//
//  HistoryTrendViewController.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-22.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface HistoryTrendViewController : UIViewController

@property (nonatomic) NSUInteger currentPageIndex;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
//标题栏
@property (weak, nonatomic) IBOutlet UIImageView *navigationBarImageView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)changePage:(id)sender;

@end
