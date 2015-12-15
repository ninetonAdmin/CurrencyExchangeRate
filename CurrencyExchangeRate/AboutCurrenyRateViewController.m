//
//  AboutCurrenyRateViewController.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-21.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "AboutCurrenyRateViewController.h"
#import "MyUtilities.h"

@interface AboutCurrenyRateViewController ()

@end

@implementation AboutCurrenyRateViewController

-(void)loadWebPageWithString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    DLog(@"loadWebPageWithString : %@", urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //初始化view
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    // 设置“返回”按钮样式
    [self.showMenuButton setImage:[UIImage imageNamed:@"v2-return-normal.png"] forState:UIControlStateNormal];
    [self.showMenuButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 0)];
    [self.showMenuButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    [self.activityIndicatorView setCenter:self.view.center];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicatorView];
    
    [self loadDate];
}

- (IBAction)showMenu
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)loadDate
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.youloft.com/about/jishihuilv/ipindex-b.html?date=%@", [self getOnlyDateStringFromDate]];
    [self loadWebPageWithString:urlString];
    [self.activityIndicatorView startAnimating];
}

-(NSString *) getOnlyDateStringFromDate
{
    NSDateFormatter *frt = [[NSDateFormatter alloc] init];
    [frt setDateStyle:kCFDateFormatterShortStyle];
    [frt setDateFormat:@"yyyy-MM-dd"];
    NSString *tmp = [frt stringFromDate:[NSDate date]];
    return tmp;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"webViewDidFinishLoad");
    [self.activityIndicatorView stopAnimating];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code != 102) {
        [MyUtilities showMessage:@"抱歉，网络连接不畅，请稍后再试" withTitle:@"提示"];
        
    }
    [self.activityIndicatorView stopAnimating];
    
}

@end
