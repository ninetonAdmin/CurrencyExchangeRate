//
//  MyImageView.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-10.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "MyImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    // To round all corners, we can just set the radius on the layer
    if ( corners == UIRectCornerAllCorners ) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    } else {
        // If we want to choose which corners we want to mask then
        // it is necessary to create a mask layer.
        self.layer.mask = [self maskLayerWithCorners:corners radii:CGSizeMake(radius, radius) frame:self.bounds];
    }
}

- (id)maskLayerWithCorners:(UIRectCorner)corners radii:(CGSize)radii frame:(CGRect)frame {
    
    // Create a CAShapeLayer
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    // Set the frame
    mask.frame = frame;
    
    // Set the CGPath from a UIBezierPath
    mask.path = [UIBezierPath bezierPathWithRoundedRect:mask.bounds byRoundingCorners:corners cornerRadii:radii].CGPath;
    
    // Set the fill color
    mask.fillColor = [UIColor whiteColor].CGColor;
    
    return mask;
}










@end
