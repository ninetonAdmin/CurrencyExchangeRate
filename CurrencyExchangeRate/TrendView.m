//
//  TrendView.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-26.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "TrendView.h"
#import "GlobleObject.h"
#import "ASIHTTPRequest.h"
#import "MyUtilities.h"
#import "SingleAlert.h"

@interface TrendView () <ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, strong) NSArray *datas;

@end

NSString *changeFormate(NSString *time)
{
    NSArray *times = [time componentsSeparatedByString:@"/"];
    NSString *result = [NSString stringWithFormat:@"%ld月%ld日", (long)[times[1] integerValue], (long)[times[2] integerValue]];
    return result;
}

void findMinAndMaxValue(NSArray *array, NSString **minValue, NSString **maxValue, NSString **min10Value, NSString **max10Value, NSString *type)
{
    NSLog(@"%@", array);
    CGFloat min = 0, max = 0, min10 = 0, max10 = 0;
    
    if (array.count > 0)
    {
        min = max = [array[0][type] floatValue];
        for (NSDictionary *dic in array)
        {
            CGFloat value = [dic[type] floatValue];
            if (value > max) {
                max = value;
            } else if (value < min) {
                min = value;
            }
        }
        
        min10 = max10 = [array[array.count - 1][type] floatValue];
        for (int i = 10; i>0; i--)
        {
            if (array.count - i > 0)
            {
                NSDictionary *dic = array[array.count - i];
                CGFloat value = [dic[type] floatValue];
                if (value > max10) {
                    max10 = value;
                } else if (value < min10) {
                    min10 = value;
                }
            }
        }
    }
    
    *minValue = [NSString stringWithFormat:@"%f", min];
    *maxValue = [NSString stringWithFormat:@"%f", max];
    *min10Value = [NSString stringWithFormat:@"%f", min10];
    *max10Value = [NSString stringWithFormat:@"%f", max10];
}


@implementation TrendView

- (IBAction)typeChanged:(id)sender
{
    UISegmentedControl *segmentedControl = sender;
    
    NSString *minValue = nil;       // 近一月最小值
    NSString *maxValue = nil;       // 近一月最小值
    NSString *min10Value = nil;     // 10天最小值
    NSString *max10Value = nil;     // 10天最大值
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.chartView.chartType = @"xhmr";
        findMinAndMaxValue(self.datas, &minValue, &maxValue, &min10Value, &max10Value, @"xhmr");
    } else {
        self.chartView.chartType = @"xhmc";
        findMinAndMaxValue(self.datas, &minValue, &maxValue, &min10Value, &max10Value, @"xhmc");
    }
    
    if (minValue.floatValue && maxValue.floatValue) {
        self.chartView.minValue = minValue.floatValue;
        self.chartView.maxValue = maxValue.floatValue;
        self.chartView.values = self.datas;
    }
    
    if (minValue.length > 6) {
        self.minValueLabel.text = [minValue substringToIndex:6];
        self.label30Min.text = [minValue substringToIndex:6];
    }
    
    if (maxValue.length > 6) {
        self.maxValueLabel.text = [maxValue substringToIndex:6];
        self.label30Max.text = [maxValue substringToIndex:6];
    }
    
    if (min10Value.length > 6) {
        self.label10Min.text = [min10Value substringToIndex:6];
    }
    
    if (max10Value.length > 6) {
        self.label10Max.text = [max10Value substringToIndex:6];
    }
}

- (void)dealloc
{
    [self.request clearDelegatesAndCancel];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}*/

- (void)loadContent
{
    //加载对哪种币种标签
    NSArray *currentChineseRates = [GlobleObject getInstance].currentChineseRates;
    NSString *countryCode = [currentChineseRates objectAtIndex:self.index];
    NSString *name = [[GlobleObject getInstance].countrysName objectForKey:countryCode];
    self.currencyLabel.text = [NSString stringWithFormat:@"人民币对%@折算价图表", name];
    
    //请求网络获取数据
    [self getDataFromWeb];
}

- (void)getDataFromWeb
{
    [self setupTimeLabelX];
    
    NSArray *currentChineseRates = [GlobleObject getInstance].currentChineseRates;
    NSString *countryCode = [currentChineseRates objectAtIndex:self.index];
    NSString *path = [NSString stringWithFormat:@"%@%@", HISTORY_URL, countryCode];
    NSURL *url = [NSURL URLWithString:path];
    self.request = [ASIHTTPRequest requestWithURL:url];
    _request.delegate = self;
    [_request startAsynchronous];
}

- (void)setupTimeLabelX
{
    int margin = (((int)DEVICE_WIDTH - 30) % 6) / 2;
    int space = (int)(DEVICE_WIDTH - 30) / 6;
    
    self.timeLabel1.x = margin == 0 ? 2 : margin;
    self.timeLabel2.x = CGRectGetMinX(self.timeLabel1.frame) + space;
    self.timeLabel3.x = CGRectGetMinX(self.timeLabel2.frame) + space;
    self.timeLabel4.x = CGRectGetMinX(self.timeLabel3.frame) + space;
    self.timeLabel5.x = CGRectGetMinX(self.timeLabel4.frame) + space;
    self.timeLabel6.x = CGRectGetMinX(self.timeLabel5.frame) + space;
    self.timeLabel7.x = DEVICE_WIDTH -30 - margin;
    
}

#pragma mark -
#pragma ASIHttpRequest Delegate Methods
- (void)requestFailed:(ASIHTTPRequest *)request
{
//    [MyUtilities showMessage:@"请求数据失败" withTitle:@"提示"];
    SingleAlert *sharedAlert = [SingleAlert sharedAlert];
    [sharedAlert showMessage:@"请求数据失败" withTitle:@"提示"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NULL error:&error];
    if ([result isKindOfClass:[NSDictionary class]] && [result[@"isok"] isEqualToString:@"0"])//如果返回数据正常
    {
        NSArray *values = result[@"msg"];
        self.datas = values;
        NSString *minValue = nil;       // 近一月最小值
        NSString *maxValue = nil;       // 近一月最小值
        NSString *min10Value = nil;     // 10天最小值
        NSString *max10Value = nil;     // 10天最大值
        
        findMinAndMaxValue(values, &minValue, &maxValue, &min10Value, &max10Value, @"xhmr");
        
        if (minValue.length > 6) {
            self.minValueLabel.text = [minValue substringToIndex:6];
            self.label30Min.text = [minValue substringToIndex:6];
        }
        
        if (maxValue.length > 6) {
            self.maxValueLabel.text = [maxValue substringToIndex:6];
            self.label30Max.text = [maxValue substringToIndex:6];
        }
        
        if (min10Value.length > 6) {
            self.label10Min.text = [min10Value substringToIndex:6];
        }
        
        if (max10Value.length > 6) {
            self.label10Max.text = [max10Value substringToIndex:6];
        }

        [self displayTimeWithArray:values];
        
        if (minValue.floatValue && maxValue.floatValue)
        {
            self.chartView.minValue = minValue.floatValue;
            self.chartView.maxValue = maxValue.floatValue;
            self.chartView.values = values;
        }
    }
    else
    {
        [MyUtilities showMessage:@"返回数据错误" withTitle:@"提示"];
    }
}


- (void)displayTimeWithArray:(NSArray *)values
{
    for (int i = 0; i < values.count; i += 5)
    {
        NSString *date = values[i][@"date"];
        NSArray *times = [date componentsSeparatedByString:@"/"];
        if (times.count == 3)
        {
            NSString *time = [NSString stringWithFormat:@"%ld/%02ld", (long)[times[1] integerValue], (long)[times[2] integerValue]];
            int n = i / 5 + 1;
            NSString *name = [NSString stringWithFormat:@"timeLabel%d", n];
            UILabel *label = [self valueForKey:name];
            label.text = time;
        }
    }
    
    NSString *fromDate = values[0][@"date"];
    NSString *toDate = values[values.count - 1][@"date"];
    NSString *timeInfo = [NSString stringWithFormat:@"%@ 到 %@", changeFormate(fromDate), changeFormate(toDate)];
    self.timeLabel.text = timeInfo;
}

@end



