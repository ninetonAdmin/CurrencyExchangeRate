//
//  ClipView.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-31.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "ClipView.h"

@implementation ClipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *child = nil;
    if ((child = [super hitTest:point withEvent:event]) == self) {
        return self.scrollView;
    }
    return child;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
