//
//  YLButton.m
//  CurrencyExchangeRate
//
//  Created by YouLoft520 on 15/6/23.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import "YLButton.h"

@implementation YLButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    self.imageView.frame = CGRectMake(0, 0, 30, 20);
    self.imageView.center = CGPointMake(self.titleLabel.frame.origin.x - 30 / 2 - 5, self.titleLabel.center.y);
    
    if (self.moreIcon != nil) {
        [self.moreIcon removeFromSuperview];
    }
    
    self.moreIcon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2-more.png"]];
    [self.moreIcon sizeToFit];
    self.moreIcon.center = CGPointMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10, self.titleLabel.center.y);
    [self addSubview:self.moreIcon];
}

@end
