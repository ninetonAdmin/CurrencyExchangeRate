//
//  DMAdInfo.h
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-12-14.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAWAdInfo : NSObject

@property(nonatomic, strong) NSString *adId;
@property(nonatomic, strong) NSNumber *type;//1代表游戏，2代表应用
@property(nonatomic, strong) NSNumber *position;
@property(nonatomic, strong) NSString *logoUrl;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *thumbnailUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *provider;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSNumber *versonCode;
@property(nonatomic, strong) NSString *actionUrl;
@property(nonatomic, strong) NSNumber *size;
@property(nonatomic, strong) NSNumber *releaseTime;
@property(nonatomic, strong) NSNumber *actionType;
@property(nonatomic, strong) NSString *tracker;
@property(nonatomic, strong) NSString *trackerUrl;//todo report
@property(nonatomic, strong) NSString *itunesId;
@property(nonatomic, assign) BOOL isNew;

@end
