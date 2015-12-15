//
//  DMExtendAdInfo.h
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-12-16.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAWExtendAdInfo : NSObject

//扩展广告描述
@property(nonatomic,retain)NSString *description;
//扩展广告请求地址
@property(nonatomic,retain)NSString *url;
//是否预加载
@property(nonatomic)BOOL shouldPreload;

@end
