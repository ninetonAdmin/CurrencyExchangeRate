//
//  AboutUsViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-22.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "AboutUsViewController.h"
#include <sys/utsname.h>
#import "MyUtilities.h"
#import "MobClick.h"


@interface AboutUsViewController ()

-(void) loadWebPageWithString:(NSString *) urlString;

@end

@implementation AboutUsViewController

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
//    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.showMenuButton setImage:[UIImage imageNamed:@"v2-return-normal.png"] forState:UIControlStateNormal];
    [self.showMenuButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 0)];
    [self.showMenuButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"v2-return-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    [self.activityIndicatorView setCenter:self.view.center];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicatorView];

    [self loadDate];
    DLog(@"TEST SVN");
}

-(void)loadDate
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.youloft.com/about/normal/ipindex-b.html?date=%@", [self getOnlyDateStringFromDate]];
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
    // Dispose of any resources that can be recreated
}

- (void)viewDidUnload {
    [self setShowMenuButton:nil];
    [self setMyWebView:nil];
    [self setMyBgImg:nil];
    [super viewDidUnload];
}
- (IBAction)showMenu {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"webViewDidStartLoad");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"webViewDidFinishLoad");
    [self.activityIndicatorView stopAnimating];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code != 102) {
//        [MyUtilities showMessage:@"抱歉，网络连接不畅，请稍后再试" withTitle:@"提示"];
        [AppUtility showMBLodingWithMessage:@"抱歉，网络连接不畅，请稍后再试"];
    }
    [self.activityIndicatorView stopAnimating];

}


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    DLog(@"URL == %@", request.URL.absoluteString);
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<6.0f) {
        if ([request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"] || [request.URL.absoluteString hasPrefix:@"http://itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        }
    }
    
    //邮件反馈
    if ([request.URL.absoluteString hasSuffix:@"mailtosupport"]) {
        DLog(@"mailtosupport!");
        [self mailtoMe];
        return NO;
    }else if([request.URL.absoluteString hasSuffix:@"xlwb"])
    {
        NSURL *url = [NSURL URLWithString:@"http:weibo.com/youloft"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }else if([request.URL.absoluteString hasSuffix:@"wypwx"])
    {
        [self talkaboutMe];
        return NO;
    }else if([request.URL.absoluteString hasSuffix:@"mailtofriends"])
    {
        [self smsToFriend];
        return NO;
    }
    
    return YES;
}

-(void)smsToFriend{
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	[self showSMSPicker :[NSString stringWithFormat:@"即时的汇率信息，给你推荐个很不错的软件：%@：\n在这里可以下载：http://ireadercity.com",  appName]];
}

-(void)showSMSPicker:(NSString*)str {
	//  The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
	//  So, we must verify the existence of the above class and log an error message for devices
	//      running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
	//      MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
			picker.messageComposeDelegate = self;
			
			picker.body=str;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
			[self presentViewController:picker animated:YES completion:^{
                
            }];
		} else {
			[MyUtilities showMessage:@"设备没有短信功能" withTitle:@"提示"];
		}
	} else {
		[MyUtilities showMessage:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" withTitle:@"提示"];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
				 didFinishWithResult:(MessageComposeResult)result {
	
	switch (result)
	{
		case MessageComposeResultCancelled:
			DLog(@"Result: SMS sending canceled");
			break;
		case MessageComposeResultSent:
			DLog(@"Result: SMS sent");
            [MyUtilities showMessage:@"短信发送成功！" withTitle:@"提示"];
			break;
		case MessageComposeResultFailed:
			[MyUtilities showMessage:@"短信发送失败" withTitle:@"提示"];
			break;
		default:
			DLog(@"Result: SMS not sent");
            break;
	}
	[controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)talkaboutMe{
    //用户评论
    
    NSString *url = @"";
    
    if ([[AppUtility systemVersion] floatValue] >= 7.0)
    {
        url = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/app/id%@", MY_APP_ID];
    }
    else
    {
        url = [NSString stringWithFormat:
                       @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", MY_APP_ID];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


-(void)mailtoMe{
	struct utsname u;
	uname(&u);
	NSString *nameString = [NSString stringWithFormat:@"%s", u.machine];
	NSString *tmp= [NSString stringWithFormat:@"设备型号：%@", nameString];
	NSString *osVersion = [NSString stringWithFormat:@"iOS版本：%@", [[UIDevice currentDevice] systemVersion]];
	NSString *appName = [NSString stringWithFormat:@"程序名称：%@ Ver%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
						 , [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];//CFBundleDisplayName//CFBundleVersion];
	[self sendEmail:@"support@ireadercity.com" :@"iOS问题反馈" :[NSString stringWithFormat:@"问题及建议：\n\n\nps:\n%@\n%@\n%@", tmp,osVersion,appName]];
}

-(void)sendEmail :(NSString*)mailAdress :(NSString*)subject :(NSString*)content{
	
	
	
	if ([MFMailComposeViewController canSendMail])
    {
        DLog(@"发送邮件。");
        
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        
		//Setting up the Subject, recipients, and message body.
		[mailComposer setToRecipients:[NSArray arrayWithObjects:mailAdress,nil]];
		[mailComposer setSubject:subject];
		[mailComposer setMessageBody:content isHTML:NO];
		//Present the mail view controller
        //		if ([Utilities isiPad]) {
        //			mailComposer.modalPresentationStyle=UIModalPresentationFormSheet;
        //		}
		[self presentViewController:mailComposer animated:YES completion:^{
            
        }];
	}else {
		//[Utilities showMessage:@"未设置邮箱信息，无法发送邮件。"];
        //DLog(@"未设置邮箱信息，无法发送邮件。");
        [MyUtilities showMessage:@"未设置邮箱信息，无法发送邮件。" withTitle:@"提示"];
	}
    
	//release the mailComposer as it is the UIViewControllers modalViewController now.
	//[mailComposer release];
}

//This is one of the delegate methods that handles success or failure

//and dismisses the mailComposer

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
	
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败!" message:@"Your email has failed to send" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
	}
}

@end
