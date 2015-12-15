//
//  Notice.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-23.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NoticeTypeSpotExchangeBuy,
    NoticeTypeSpotExchangeSale,
    NoticeTypeBand
}NoticeType;

typedef enum
{
    CompareTypeHigher = 0,
    CompareTypeLower
}CompareType;

@interface Notice : NSObject <NSCopying>
{
    
}
@property (nonatomic) NoticeType noticeType;
@property (nonatomic) CompareType compareType;
@property (nonatomic) NSString *price;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSNumber *noticeId;

- (id)initWithCheckItem:(NSString *)checkItem compareType:(NSNumber *)compareType countryCode:(NSString *)countryCode ringrate:(NSString *)ringrate;

- (BOOL)isequalToNotice:(Notice *)notice;

@end
