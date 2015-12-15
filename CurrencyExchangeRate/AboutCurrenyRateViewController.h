//
//  AboutCurrenyRateViewController.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-21.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface AboutCurrenyRateViewController : UIViewController

@property (weak, nonatomic) IBOutlet MyCustomButton *showMenuButton;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
- (IBAction)showMenu;

- (void)loadDate;

@end
