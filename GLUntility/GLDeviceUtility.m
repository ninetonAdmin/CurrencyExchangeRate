//
//  GLDeviceUtility.m
//  LingShiKong
//
//  Created by dimmy on 13-4-25.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import "GLDeviceUtility.h"
#import "GLNetworkUtility.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation GLDeviceUtility

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isCurrentDeviceIphone{
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        return YES;
    }
    return NO;
}

+(BOOL)isCurrentDeviceIphone5{
    
    BOOL result = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
    return result;
}

+(BOOL)isCurrentRetina{
    
    if ([GLDeviceUtility isCurrentDeviceIphone5]) {
        return YES;
    }
    BOOL result = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
    return result;
}

+(NSString*) deviceModel {
	
    /*
	 iPhone = iPhone1,1
	 iPhone 3G = iPhone1,2
	 iPhone 3GS = iPhone2,1
	 iPhone 4 = iPhone3,1
	 CDMA iPhone = iPhone3,2
	 iPad Wifi = iPad1,1
	 iPad 3G = iPad1,2 (not sure about this one)
	 iPod Touch 1G = iPod1,1
	 iPod Touch 2G = iPod2,1
	 iPod Touch 3G = iPod3,1
	 iPod Touch 4G = iPod4,1
	 */
    
	struct utsname u;
	uname(&u);
	NSString *nameString = [NSString stringWithFormat:@"%s", u.machine];
	return nameString;
}

+(float) osVersion {
	
    NSString *Version= [[UIDevice currentDevice] systemVersion] ;
	return [Version floatValue];
}

+(NSString*)getCacheRootPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(void)addDotOnView:(UIView *)view withX:(float)x withY:(float)y{
    
    [GLDeviceUtility removeDotFromView:view];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
    iv.tag = 12345678;
    iv.image = [UIImage imageNamed:@"um_badge_bg"];
    if ([view viewWithTag:12345678]==nil) {
        [view addSubview:iv];
    }
}

+(void)removeDotFromView:(UIView *)view{
    
    UIView* v = [view viewWithTag:12345678];
    [v removeFromSuperview];
}

//+(NSString*)uuid{
//    return [[NSDate date] stringWithFormat:@"yyyyMMddHHmmss"];
//}


+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString
                               stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

+ (BOOL)isCurrentDeviceLowThan5
{
    return [[UIScreen mainScreen] bounds].size.height == 480;
}



@end