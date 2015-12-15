//
//  AboutUsViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-22.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface AboutUsViewController : UIViewController<UIWebViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MyCustomButton *showMenuButton;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

- (IBAction)showMenu;

- (void)loadDate;

@end
