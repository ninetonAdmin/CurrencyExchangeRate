//
//  GlobleObject.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-10-31.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "GlobleObject.h"
#import "MyUtilities.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface GlobleObject()

//@property (strong, nonatomic) GlobleObject singleton;

@end


@implementation GlobleObject

@synthesize chineseRates = _chineseRates;
@synthesize currentChineseRates = _currentChineseRates;
@synthesize countrysName = _countrysName;
@synthesize currenteCalcRates = _currenteCalcRates;
@synthesize theRates = _theRates;
@synthesize listOfRateBaseCountry = _listOfRateBaseCountry;
@synthesize updateTimeForChineseRate = _updateTimeForChineseRate;
@synthesize updateTimeForCalc = _updateTimeForCalc;

-(NSDictionary *)chineseRates
{
    if (!_chineseRates) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ChineseRateList" ofType:@"plist"];
        
        _chineseRates = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        //DLog(@"globle object chineserate = %@", _chineseRates);
    }
    return _chineseRates;
}

-(NSMutableDictionary *)theRates
{
    if (!_theRates) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CountrysName" ofType:@"plist"];
        _theRates = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        //DLog(@"globle object theRates = %@", _theRates);
    }
    return _theRates;
}

-(NSMutableArray *)currentChineseRates
{
    if (!_currentChineseRates) {
        _currentChineseRates = [[NSMutableArray alloc] initWithObjects:@"USD", @"EUR", @"GBP", @"HKD", @"AUD", @"JPY", nil];
    }
    
    return _currentChineseRates;
}

-(NSMutableArray *)currenteCalcRates
{
    if (!_currenteCalcRates)
    {
        if (IS_IPHONE_5) {
            _currenteCalcRates = [[NSMutableArray alloc] initWithObjects:@"CNY", @"USD", @"GBP", @"JPY", @"AUD", @"EUR", nil];
        } else {
            _currenteCalcRates = [[NSMutableArray alloc] initWithObjects:@"CNY", @"USD", @"GBP", @"JPY", @"AUD", nil];
        }
    }
    
    return _currenteCalcRates;
}


-(NSDictionary *)countrysName
{
    if (!_countrysName) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CountrysName" ofType:@"plist"];
        _countrysName = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        //DLog(@"globle object countrysName = %@", _countrysName);
    }
    return _countrysName;
}

-(NSString *)listOfRateBaseCountry
{
    if (!_listOfRateBaseCountry) {
        _listOfRateBaseCountry = @"CNY";
    }
    return _listOfRateBaseCountry;
}

//- (NSMutableDictionary *)noticeRates
//{
//    if (!_noticeRates)
//    {
//        NSString *path = [MyUtilities noticepath];
//        _noticeRates = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        if (!_noticeRates)
//            _noticeRates = [[NSMutableDictionary alloc] init];
//    }
//    return _noticeRates;
//}
//
//- (BOOL)saveNotice;
//{
//    NSString *path = [MyUtilities noticepath];
//    BOOL result = [NSKeyedArchiver archiveRootObject:_noticeRates toFile:path];
//    return result;
//}


+ (GlobleObject *)getInstance
{
    static GlobleObject *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^()
                  {
                      singleton = [[GlobleObject alloc] init];
                  });
//    if (!singleton) {
//        singleton = [[GlobleObject alloc] init];
//    }
    return singleton;
}

@end
