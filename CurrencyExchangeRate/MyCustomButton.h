//
//  MyCustomButton.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-29.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomButton : UIButton

- (void) setBackgroundImage:(UIImage *) bkImage resizableBackgroundImageWithCapInsets:(UIEdgeInsets)capInsets
    setImage:(UIImage *)image
    forState:(UIControlState)state;

@end
