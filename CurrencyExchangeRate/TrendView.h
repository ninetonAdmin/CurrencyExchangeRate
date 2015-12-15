//
//  TrendView.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-26.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartView.h"

@interface TrendView : UIView

@property (nonatomic) NSInteger index;

@property (nonatomic, weak) IBOutlet ChartView *chartView;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;

@property (nonatomic, weak) IBOutlet UILabel *minValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxValueLabel;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel1;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel2;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel3;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel4;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel5;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel6;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel7;

@property (weak, nonatomic) IBOutlet UILabel *label10Max;
@property (weak, nonatomic) IBOutlet UILabel *label10Min;
@property (weak, nonatomic) IBOutlet UILabel *label30Max;
@property (weak, nonatomic) IBOutlet UILabel *label30Min;


- (void)loadContent;

- (IBAction)typeChanged:(id)sender;

@end
