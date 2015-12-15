//
//  SingleAlert.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-21.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "SingleAlert.h"

@implementation SingleAlert

+ (SingleAlert *)sharedAlert
{
    static SingleAlert *_sharedAlert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAlert = [[self alloc] init];
    });
    return _sharedAlert;
}

- (void)showMessage:(NSString *)message withTitle:(NSString *)title
{
    if (_isShowing)
        return;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    _isShowing = YES;
}

#pragma mark -
#pragma mark UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _isShowing = NO;
}

@end
