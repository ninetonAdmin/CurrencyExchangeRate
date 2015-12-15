//
//  DetailChineseExchangeRateViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-30.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingBoxViewController.h"

@interface DetailChineseExchangeRateViewController : UIViewController

- (void)reloadTheViews;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImg;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLable;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLable;
@property (weak, nonatomic) IBOutlet UILabel *currencyPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *cashPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *bankOfferPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *bankBenchmarkPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *bankDiscountedPriceLable;
@property (weak, nonatomic) IBOutlet UIView *ringBoxView;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImg;
@property (strong, nonatomic) RingBoxViewController *ringBoxViewController;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *ringButton;
@property (weak, nonatomic) IBOutlet UIButton *trendButton;

//@property (strong, nonatomic) NSDictionary *contentDic;
@property (strong, nonatomic) NSString *countryCodeIdentifier;

- (IBAction)clikRingButton;

- (IBAction)trendButtonPressed:(id)sender;

- (IBAction)commendButtonPressed:(id)sender;

@end
