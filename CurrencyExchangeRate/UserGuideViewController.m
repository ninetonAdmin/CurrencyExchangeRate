//
//  UserGuideViewController.m
//  CurrencyExchangeRate
//
//  Created by YouLoft520 on 15/6/11.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import "UserGuideViewController.h"

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedEnterButton:(id)sender {
    // 不是第一次使用这个版本
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [[UIApplication sharedApplication] delegate].window.rootViewController = storyboard.instantiateInitialViewController;;
}


@end
