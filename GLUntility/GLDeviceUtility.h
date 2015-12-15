//
//  GLDeviceUtility.h
//  LingShiKong
//
//  Created by dimmy on 13-4-25.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLDeviceUtility : NSObject

+ (BOOL)validateEmail:(NSString *)email;
+(BOOL)isCurrentDeviceIphone;//当前设备是否式iphone
+(BOOL)isCurrentDeviceIphone5;//当前设备是否是iphone5
+(BOOL)isCurrentRetina;//当前是否是retina屏幕
+(float) osVersion;
+(NSString*)getCacheRootPath;
+(NSString*) deviceModel;
+(void)addDotOnView:(UIView*)view withX:(float)x withY:(float)y;
+(void)removeDotFromView:(UIView*)view;
//+(NSString*)uuid;

+(NSString *)md5:(NSString *)str;

+ (BOOL)isCurrentDeviceLowThan5;

@end
