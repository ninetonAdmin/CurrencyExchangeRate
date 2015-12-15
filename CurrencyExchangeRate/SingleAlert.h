//
//  SingleAlert.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-21.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleAlert : NSObject <UIAlertViewDelegate>
{
    BOOL _isShowing;
}

+ (SingleAlert *)sharedAlert;

- (void)showMessage:(NSString *)message withTitle:(NSString *)title;

@end
