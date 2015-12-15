//
//  Global.h
//  iCareer
//
//  Created by YANGRui on 14-2-27.
//  Copyright (c) 2014年 LJLD. All rights reserved.
//

#ifndef iCareer_Global_h
#define iCareer_Global_h

#pragma mark --导入头文件

#import "AppUtility.h"
#import "NSDictionary+JSON.h"
#import "UIColor+HexString.h"
#import "UIImage+Loader.h"
#import "UIView+ModifyFrame.h"
#import "JSONKit.h"
#import "NSNull+NullHandle.h"

#pragma mark --定义常用宏

//即时汇率AppId
#define MY_APP_ID    @"570604441"

//友盟AppKey
#define UMAppKey       @"50ad9a9e52701542b900007d"

//微信ID
#define WECHAT_ID     @"wx86ab233d3a2709ae"
#define WECHAT_SECRET    @"082837890ca7768bfeb65dcd74de92d6"

//QQ ID
#define QQ_ID      @"100541896"

//新浪微博
#define WEIBO_ID     @"2580132515" 
#define WEIBO_SECRET    @"058588c9fd3a73e71429c6d5275acd77"
#define WEIBO_REDIRECT_URL    @"https://api.weibo.com/oauth2/default.html"

//apple store链接
#define APPSTORE_URL     @"https://itunes.apple.com/cn/app/ji-shi-hui-lu/id570604441?mt=8"

//多盟Publisher
#define PUBLISHER_ID    @"56OJybiouMwpd35COu"
//#define PUBLISHER_ID    @"56OJybiouNDb51kwwY"     // （测试）

//广告位ID
#define PLACEMENT_ID   @"16TLwS7vAcSE4NUfuZ95oJjs"
//#define PLACEMENT_ID   @"16TLwS7vApU8zNU0wM2bW25z"     //（测试）

#define HISTORY_URL         @"http://currency.51wnl.com/APIS/GetRecords?countrycode="
#define NOTICE_URL          @"http://currency.51wnl.com/APIS/GetPushListByToken?devicetoken="

#define VIP_PURCHASE        @"com.ireadercity.imoney.vip1"
#define UPDATE_PURCHASE     @"com.ireadercity.imoney.updatevip1"
#define SUPERVIP_PURCHASE   @"com.ireadercity.imoney.supervip2"

#define autorefreshTimeInterval 60 * 5

#define kLoadGDTNotification @"kLoadGDTNotification"

/*********************
 几何尺寸
 *********************/
#define ISIP5 ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define IP5ORIP4FRAME [UIScreen mainScreen].bounds.size.height == 568 ? CGRectMake(0.0, 0.0, 320.0, 568.0) : CGRectMake(0.0, 0.0, 320.0, 480.0)
#define RECT(x,y,w,h) CGRectMake(x,y,w,h)
#define POINT(x,y) CGPointMake(x,y)
#define NBValue(x,y) [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define SIZE(x,y)   CGSizeMake(x,y)

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

#define CURRENT_DEVICE [UIDevice currentDevice].systemVersion.floatValue

#define NAV_HEIGHT 64

#define TABBAR_HEIGHT 49

#define ANIMATION_DURATION 0.2  //动画时长

/*********************
 常用颜色
 *********************/
#define WHITE_COLOR      [UIColor whiteColor]                    //白色
#define BLACK_COLOR      [UIColor blackColor]                    //黑色
#define CLEAR_COLOR      [UIColor clearColor]                    //透明色
#define LIGHT_GRAY       [UIColor colorWithHexString:@"#BFC7DA"] //浅灰色
#define THIN_GRAY        [UIColor colorWithHexString:@"#e4e4e4"] //淡灰色
#define DEEP_GREEN       [UIColor colorWithHexString:@"#0CCABE"] //深绿色
#define LIGHT_GREEN      [UIColor colorWithHexString:@"#20E6D9"] //浅绿色
#define THIN_GREEN       [UIColor colorWithHexString:@"#ebfffe"] //淡绿色
#define ORANGE_COLOR     [UIColor colorWithHexString:@"#f4794f"] //橘黄色
#define LIGHT_ORANGE     [UIColor colorWithHexString:@"#F8A88C"] //浅橘黄色
#define DEEP_BLACK       [UIColor colorWithHexString:@"#354656"] //标题颜色
#define LIGHT_BLACK      [UIColor colorWithHexString:@"#5C6976"] //正文颜色
#define RED_COLOR        [UIColor colorWithHexString:@"#fe6560"] //粉红色

#define TITLE_COLOR      [UIColor colorWithHexString:@"#2a2a2a"]
#define PLACE_HOLDER_COLOR  [UIColor colorWithHexString:@"#dadada"]
#define SUB_TITLE_COLOR     [UIColor colorWithHexString:@"#a1abac"]
#define TEXT_COLOR       [UIColor colorWithHexString:@"#545454"]
#define PROMPT_COLOR     [UIColor colorWithHexString:@"#9aa7a8"]
#define BLUE_COLOR       [UIColor colorWithHexString:@"#2c4484"]


#pragma mark - 数据类型转换

#define IntToString(num)   [NSString stringWithFormat:@"%d",num]
#define FloatToString(num) [NSString stringWithFormat:@"%f",num]

#pragma mark -- 定义APP沙盒路径
/******************************
 定义APP沙盒路径
 ******************************/
#define DOCUMENTPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define TMPPATH NSTemporaryDirectory()
#define CACHPATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CACH_DOCUMENTS_PATH(fileName) [CACHPATH stringByAppendingPathComponent:fileName]//缓存文件路径
#define DOCUMENTS_PATH(fileName) [DOCUMENTPATH stringByAppendingPathComponent:fileName]//Documents文件夹路径

#pragma mark -- 定义颜色
/******************************
 定义RGB颜色
 ******************************/
#define RGBColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a*1.0]
/******************************
 RGB颜色转换（16进制->10进制）
 ******************************/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark -- 定义日志输出
/******************************
 定义日志输出模式
 DLog is almost a drop-in replacement for DLog
 DLog();
 DLog(@"here");
 DLog(@"value: %d", x);
 Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
 ******************************/
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define ELog(err) {if(err) DLog(@"%@", err)}
#else
#define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#endif
