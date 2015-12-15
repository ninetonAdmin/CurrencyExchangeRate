//
//  TrendView.h
//  曲线图
//
//  Created by 严明俊 on 13-9-25.
//  Copyright (c) 2013年 严明俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

@property (nonatomic) CGFloat minValue;
@property (nonatomic) CGFloat maxValue;

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSString *chartType;

@end
