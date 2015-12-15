//
//  TrendView.m
//  曲线图
//
//  Created by 严明俊 on 13-9-25.
//  Copyright (c) 2013年 严明俊. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView

const CGFloat distanceToLeft = 0.f;

//static float points[4][2] = {{2, 71}, {26, 44}, {202, 70}, {274, 108}};

static const float minDistance = 130.f;
static const float maxDistance = 40.f;

static float aliginDistance;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        aliginDistance = DEVICE_WIDTH / 30;
        _chartType = @"xhmr";
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //设置参数
    [self drawChatWithContext:context];
    [self drawDataWithContext:context];
    
    CGContextRestoreGState(context);
}

- (void)drawChatWithContext:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.59f green:.59f blue:.59f alpha:1.f].CGColor);
    CGContextSetLineWidth(context, 2.f);

    CGContextMoveToPoint(context, 0.f, 0.f);
    CGContextAddLineToPoint(context, 0.f, 158.f);
    CGContextAddLineToPoint(context, DEVICE_WIDTH, 158.f);
    
    CGContextSetLineWidth(context, 0.4f);
//    //绘制标尺
//    for (int i = 1; i != 7; ++i)
//    {
//        CGFloat originX = i * 44.f;
//        CGContextMoveToPoint(context, originX, 156.f);
//        CGContextAddLineToPoint(context, originX, 158.f);
//    }
    
    //绘制标线
    for (int i = 1; i <= 31; i++)
    {
        CGFloat originX = i * aliginDistance;
        CGContextMoveToPoint(context, originX, 0.f);
        CGContextAddLineToPoint(context, originX, 158.f);
    }
    
    CGContextStrokePath(context);


//    UIFont *mainFont = [UIFont systemFontOfSize:9.f];
//    NSDictionary *mainTextAttributes = @{ NSFontAttributeName : mainFont};
//    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:@"632.12" attributes:mainTextAttributes];
//    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:@"612.12" attributes:mainTextAttributes];
//    
//    CGPoint point1 = CGPointMake(6.f, 38.f);
//    CGPoint point2 = CGPointMake(6.f, 65.f);
//    [string1 drawAtPoint:point1];
//    [string2 drawAtPoint:point2];
}

- (void)setChartType:(NSString *)chartType
{
    _chartType = chartType;
    [self setNeedsDisplay];
}

- (void)drawDataWithContext:(CGContextRef)context
{
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:.23f green:.6f blue:.72f alpha:.9f].CGColor);
    
    NSInteger count = _values.count;
    for (int i = 0; i != count; ++i)
    {
        CGFloat value = [_values[i][self.chartType] floatValue];
        CGFloat yPosition = [self valueToY:value];
        CGFloat xPosition = aliginDistance * i;
        
        if (i == 0) {
            CGContextMoveToPoint(context, xPosition, yPosition);
        } else {
            CGContextAddLineToPoint(context, xPosition, yPosition);
        }
    }
    
//    CGContextStrokePath(context);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    for (int i = 0; i != count; ++i)
//    {
//        CGFloat value = [_values[i][@"xhmc"] floatValue];
//        CGFloat yPosition = [self valueToY:value];
//        CGFloat xPosition = 2 + 8.8 * i;
//        
//        if (i == 0)
//            CGContextMoveToPoint(context, xPosition, yPosition);
//        else
//            CGContextAddLineToPoint(context, xPosition, yPosition);
//    }

    
    CGContextAddLineToPoint(context, (count - 1) * aliginDistance, 158.f);
    CGContextAddLineToPoint(context, 0.f, 158.f);
    
    CGFloat firstValue = [_values[0][self.chartType] floatValue];
    CGContextAddLineToPoint(context, 0.f, [self valueToY:firstValue]);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFill);
}

- (void)setValues:(NSArray *)values
{
    _values = values;
    [self setNeedsDisplay];
}

- (CGFloat)valueToY:(CGFloat)value
{
    CGFloat differFrom = value - self.minValue;
    CGFloat y = (1 - differFrom / (self.maxValue - self.minValue)) * (minDistance - maxDistance) + maxDistance;
    return y;
}

@end
