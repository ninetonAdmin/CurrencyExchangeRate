//
//  AppUtility.m
//  iCareer
//
//  Created by YANGRui on 14-3-6.
//  Copyright (c) 2014年 andy. All rights reserved.
//

#import "AppUtility.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#import <sys/utsname.h>
#import "MBProgressHUD.h"
#import "MyCalcTableViewCell.h"
#import "MobClick.h"

@implementation AppUtility 

#pragma mark -计算时间

+ (NSDate *)dateAfterDay:(int)day
{
    NSDate * sendDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:sendDate options:0];
    return dateAfterDay;
}

+ (NSString *)curentDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate = [df stringFromDate:[NSDate date]];
    return currentDate;
}


#pragma mark - 存储少量数据
+ (id)getObjectForKey:(NSString *)key
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (obj == nil)
    {
        obj = @"";
    }
    return obj;
}

+ (void)storeObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjectForkey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 计算文字的高度
+ (CGSize)getLabelSizeWithText:(NSString *)text font:(int)fontSize width:(float)width
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *attr = @{NSFontAttributeName: font};
    return  [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}

#pragma mark - 判断输入的字符是不是纯数字
+ (BOOL)isDightWithText:(NSString *)text
{
    for (NSInteger i = 0;i < text.length;i ++)
    {
        char c = [text characterAtIndex:i];
        if (!(c<='9'&&c>='0'))
        {
            return NO;
        }
    }
    return YES;
}


#pragma mark - MD5加密

+ (NSString *)md5String:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

/*获取系统版本*/
+(NSString *)systemVersion
{
   return  [[UIDevice currentDevice] systemVersion];
}

/*获取设备型号*/
+(NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSArray *modelArray = @[
                            @"i386",@"x86_64",@"iPhone1,1",@"iPhone1,2",@"iPhone2,1",
                            @"iPhone3,1",@"iPhone3,2",@"iPhone3,3",@"iPhone4,1",@"iPhone5,1",
                            @"iPhone5,2",@"iPhone5,3",@"iPhone5,4",@"iPhone6,1",@"iPhone6,2",
                            @"iPod1,1",@"iPod2,1",@"iPod3,1",@"iPod4,1",@"iPod5,1",
                            @"iPad1,1",@"iPad2,1",@"iPad2,2",@"iPad2,3",@"iPad2,4",
                            @"iPad3,1",@"iPad3,2",@"iPad3,3",@"iPad3,4",@"iPad3,5",
                            @"iPad3,6",@"iPad2,5",@"iPad2,6",@"iPad2,7",@"iPad4,1",
                            @"iPad4,2",@"iPad4,4",@"iPad4,5"
                            ];
    NSArray *modelNameArray = @[
                                @"Simulator", @"Simulator",@"iPhone 2G",@"iPhone 3G",@"iPhone 3GS",
                                @"iPhone 4(GSM)",@"iPhone 4(GSM Rev A)",@"iPhone 4(CDMA)",@"iPhone 4s",
                                @"iPhone 5(GSM)",@"iPhone 5(GSM+CDMA)",@"iPhone 5c(GSM)",@"iPhone 5c(Global)",
                                @"iPhone 5s(GSM)",@"iPhone 5s(Global)",@"iPod Touch 1G",@"iPod Touch 2G",
                                @"iPod Touch 3G",@"iPod Touch 4G",@"iPod Touch 5G",@"iPad",
                                @"iPad 2(WiFi)",@"iPad 2(GSM)",@"iPad 2(CDMA)",@"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",@"iPad 3(GSM+CDMA)",@"iPad 3(GSM)",@"iPad 4(WiFi)",
                                @"iPad 4(GSM)",@"iPad 4(GSM+CDMA)",@"iPad mini (WiFi)",@"iPad mini (GSM)",
                                @"iPad mini (GSM+CDMA)",@"iPad Air (A1474)",@"iPad Air (A1475)",@"iPad mini 2(A1489)",
                                @"iPad mini 2(1452)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = @"New Device";
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count])
    {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    return modelNameString;
}

+ (NSString *)yearsFromDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *current = [formatter stringFromDate:[NSDate date]];
    DLog(@"current = %@",current);
    int interval = current.intValue - date.intValue;
    return [NSString stringWithFormat:@"%d",interval];
    
}

+ (NSArray *)sortArray:(NSArray *)array byKey:(NSString *)key
{
    return  [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dict1 = (NSDictionary *)obj1;
        NSDictionary *dict2 = (NSDictionary *)obj2;
        NSNumber *num1 = [dict1 objectForKey:key];
        NSNumber *num2 = [dict2 objectForKey:key];
        if ([num1 isEqual:[NSNull null]])
        {
            num1 = @1;
        }
        if ([num2 isEqual:[NSNull null]])
        {
            num2 = @1;
        }
        return [num1 compare:num2];
    }];
}

+ (void)showMBLodingWithMessage:(NSString *)msg
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
    hud.animationType = MBProgressHUDAnimationZoom;

    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [window addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0f];
}

+ (void)showMBLodingWithMessage:(NSString *)msg andInView:(UIView *)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.animationType = MBProgressHUDAnimationZoom;
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0f];
}

+ (UIView *)findCalcCell:(UIView *)view
{
    if ([view.superview isKindOfClass:[MyCalcTableViewCell class]]) {
        return view.superview;
    }
    
    if ([view.superview isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    
    return [self findCalcCell:view.superview];
}

+ (NSString *)getOnlineParameter:(NSString *) param
{
    NSString *result = [MobClick getConfigParams:param];
    return result;
}

+ (UIViewController *)getFrontViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] windows][0];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

@end
