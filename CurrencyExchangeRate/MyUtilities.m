//
//  MyUtilities.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-24.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "MyUtilities.h"
#import "MainChineseExchangeRateAppDelegate.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MyUtilities

+ (NSString *)deviceToken
{
    MainChineseExchangeRateAppDelegate *delegaete = [UIApplication sharedApplication].delegate;
    return delegaete.deviceToken;
}

+(void)showMessage:(NSString *)messageContent withTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageContent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+(BOOL)isIphone5
{
    if (IS_IPHONE_5) {
        DLog(@"is IS_IPHONE_5");
        return YES;
    }else
    {
        return NO;
    }
}

+ (NSString *)noticepath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/notice.plist"];
}


NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
    });
    return _deviceSystemMajorVersion;
}
@end
