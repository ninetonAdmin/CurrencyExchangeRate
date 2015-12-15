//
//  MyUtilities.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-24.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtilities : NSObject

+ (void)showMessage:(NSString *)messageContent withTitle:(NSString *)title;

+ (BOOL)isIphone5;

+ (NSString *)noticepath;

NSUInteger DeviceSystemMajorVersion();

+ (NSString *)deviceToken;

@end
