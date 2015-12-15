//
//  GLWebViewController.m
//  NewDianDianProj
//
//  Created by LeungJR on 15/11/10.
//  Copyright © 2015年 GL. All rights reserved.
//

#import "GLWebViewController.h"

@interface GLWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *myWebView;

@end

@implementation GLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonDidClicked)] animated:YES];
    
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_myWebView setDelegate:self];
    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestUrl]]];
    [self.view addSubview:_myWebView];
}

- (void)backButtonDidClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"--->%@",error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"--->finish");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"-->start");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
