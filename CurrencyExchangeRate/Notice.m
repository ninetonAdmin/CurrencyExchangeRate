//
//  Notice.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-23.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "Notice.h"

@implementation Notice

- (id)init
{
    self = [super init];
    if (self)
    {
        _countryCode = @"USD";
        _noticeType = NoticeTypeSpotExchangeBuy;
        _compareType = CompareTypeHigher;
    }
    return self;
}

- (id)initWithCheckItem:(NSString *)checkItem compareType:(NSNumber *)compareType countryCode:(NSString *)countryCode ringrate:(NSString *)ringrate
{
    self = [super init];
    if (self)
    {
        if ([checkItem isEqualToString:@"xhmr"]) {
            _noticeType = NoticeTypeSpotExchangeBuy;
        } else if ([checkItem isEqualToString:@"xhmc"]) {
            _noticeType = NoticeTypeSpotExchangeSale;
        }
        
        _compareType = compareType.intValue;
        _countryCode = countryCode;
        _price = ringrate;
    }
    return self;
}

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeInt:_noticeType forKey:@"NoticeType"];
//    [aCoder encodeInt:_compareType forKey:@"CompareType"];
//    [aCoder encodeFloat:_price forKey:@"NoticePrice"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    _noticeType = [aDecoder decodeIntegerForKey:@"NoticeType"];
//    _compareType = [aDecoder decodeIntegerForKey:@"CompareType"];
//    _price = [aDecoder decodeFloatForKey:@"NoticePrice"];
//    return self;
//}

- (id)copyWithZone:(NSZone *)zone
{
    Notice *noticeCopy = [[[self class] allocWithZone:zone] init];
    noticeCopy.noticeType = _noticeType;
    noticeCopy.compareType = _compareType;
    noticeCopy.price = _price;
    noticeCopy.countryCode = _countryCode;
    noticeCopy.noticeId = _noticeId;
    return noticeCopy;
}

- (BOOL)isequalToNotice:(Notice *)notice
{
    if (self.noticeType == notice.noticeType && [self.noticeId isEqualToNumber:notice.noticeId] && self.compareType == notice.compareType && [self.price isEqualToString:notice.price] && [self.countryCode isEqualToString:notice.countryCode])
        return YES;
    return NO;
}

@end
