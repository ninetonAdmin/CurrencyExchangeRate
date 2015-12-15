//
//  GlobleObject.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-31.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobleObject : NSObject

@property (strong, nonatomic) NSMutableDictionary *chineseRates;        //中国人民银行汇率列表（总的列表）
@property (strong, nonatomic) NSMutableDictionary *theRates;            //所有国家的汇率，以国家代码/汇率作为键值对
@property (strong, nonatomic) NSMutableArray *currentChineseRates;      //当前中国人民银行汇率列表，表示当前用户选择来显示的国家列表
@property (strong, nonatomic) NSMutableArray *currenteCalcRates;        //汇率计算器当前所显示的国家
@property (strong, nonatomic) NSDictionary *countrysName;               //所有国家的中文名，以国家代码/中文名作为键值对
@property (strong, nonatomic) NSString *listOfRateBaseCountry;          //汇率列表当前的基准货币


//@property (strong, nonatomic) NSMutableDictionary *noticeRates;//所有需要提醒的汇率,以国家代码/需要提醒的数组作为键值对

//更新时间
@property (strong, nonatomic) NSString *updateTimeForChineseRate;
@property (strong, nonatomic) NSString *updateTimeForCalc;

@property (nonatomic) NSUInteger totalNoticeCount;

@property (nonatomic, strong) NSArray *notices;

+ (GlobleObject *)getInstance;

//- (BOOL)saveNotice;

@end
