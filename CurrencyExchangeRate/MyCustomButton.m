//
//  MyCustomButton.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-29.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "MyCustomButton.h"

@implementation MyCustomButton

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void) setBackgroundImage:(UIImage *) bkImage resizableBackgroundImageWithCapInsets:(UIEdgeInsets)capInsets setImage:(UIImage *)image forState:(UIControlState)state
{
    bkImage = [bkImage resizableImageWithCapInsets:capInsets];
    [self setBackgroundImage:bkImage forState:state];
    
    if (image) {
        [self setImage:image forState:state];
    }

}

@end
