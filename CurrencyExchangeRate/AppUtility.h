//
//  AppUtility.h
//  iCareer
//
//  Created by YANGRui on 14-3-6.
//  Copyright (c) 2014年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtility : NSObject

/*计算但当前时间加上多少天后的时间*/
+ (NSDate *)dateAfterDay:(int)day;

/*计算当前时间*/
+ (NSString *)curentDate;

/*从UserDefault获取数据*/
+ (id)getObjectForKey:(NSString *)key;

/*向UserDefault写入数据*/
+ (void)storeObject:(id)obj forKey:(NSString *)key;

/*从UserDefault删除数据*/
+ (void)removeObjectForkey:(NSString *)key;

/*计算给定字符串的高度*/
+ (CGSize)getLabelSizeWithText:(NSString *)text font:(int)fontSize width:(float)width;

/*获取字符串的MD5值*/
+ (NSString *)md5String:(NSString *)str;

/*获取系统版本*/
+ (NSString *)systemVersion;

/*获取设备型号*/
+ (NSString *)deviceModel;

/*对数组中的字典进行排序*/

+ (NSArray *)sortArray:(NSArray *)array byKey:(NSString *)key;

/*弹出提示信息*/
+ (void)showMBLodingWithMessage:(NSString *)msg; //inWindow

+ (void)showMBLodingWithMessage:(NSString *)msg andInView:(UIView *)view;

+ (UIView *)findCalcCell:(UIView *)view; //找到MyCalcTableViewCell

+ (NSString *)getOnlineParameter:(NSString *) param;

+ (UIViewController *)getFrontViewController;//找到window的当前显示的VC；

@end
