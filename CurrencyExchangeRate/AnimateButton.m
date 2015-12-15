//
//  AnimateButton.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-18.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "AnimateButton.h"

@interface AnimateButton ()

@property (nonatomic, retain) NSTimer *timer;

@end

//static int i = 1;

@implementation AnimateButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)startAnimating
{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(rotation:) userInfo:nil repeats:YES];
    [self .timer fire];

}

- (void)stopAnimating
{
    
    [self.timer invalidate];

    
//    self.transform = CGAffineTransformIdentity;
//    i = 1;
//    int x = 5;
//    x = x;
}

- (void)rotation:(NSTimer *)timer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.7f;
//    animation.repeatCount = CGFLOAT_MAX;
    [self.layer addAnimation:animation forKey:@"transform.rotation"];
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
