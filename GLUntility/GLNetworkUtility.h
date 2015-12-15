//
//  GLNetworkUtility.h
//  LingShiKong
//
//  Created by dimmy on 13-4-25.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLNetworkUtility : NSObject

+(BOOL)isCurrentWifi;//当前网络环境是否是wifi
+(BOOL)isNetAvaliable;//当前是否有网络

+(NSString*)postToSyn:(NSString*)urlstr with:(NSDictionary*)params;//同步post请求
+(NSString*)getToSyn:(NSString*)urlstr;

@end
