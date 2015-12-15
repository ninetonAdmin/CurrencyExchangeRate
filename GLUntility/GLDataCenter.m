//
//  GLDataCenter.m
//  NewDianDianProj
//
//  Created by dimmy on 14-6-28.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import "GLDataCenter.h"
#import "GLUtilityCustom.h"


static GLDataCenter* center = nil;

@implementation GLDataCenter

+(GLDataCenter*)sharedInstance{

    if (center==nil) {
        center = [[GLDataCenter alloc] init];
        center.allGdtNativeAdDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return center;
}

-(void)initData{

    //创建目录
    NSString* cachedPath1 = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:@"indexDataDir"];//存放心情数据
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachedPath1 isDirectory:&isDir]) {
     [[NSFileManager defaultManager] createDirectoryAtPath:cachedPath1 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* cachedPath2 = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:@"signDataDir"];//存放签名文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachedPath2 isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachedPath2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* cachedPath3 = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:@"othersDataDir"];//存放其他缓存数据
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachedPath3 isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachedPath3 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"showDotFlag"]==nil) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"showDotFlag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.showDot = YES;
        
    }else{
        self.showDot = NO;
    }
    
    NSLog(@"%@:finished!",NSStringFromSelector(_cmd));
}

//- (NSArray *)getArticlesFromServerOf:(NSDate *)date andPageNum:(NSInteger)aPage
//{
//    NSDate* today = [NSDate date];
//    if (date.day==[today day]&&date.month==[today month]&&date.year==[today year]) {
//        date = [today addDays:-1];//前一天
//    }
//    NSString* dateStr = [date stringWithFormat:@"yyyy-MM-dd"];
//    
//    NSString* s = [NSString stringWithFormat:@"%@sign/api/v1/sentence/daylist/%@/%d/10",BASE_URL_ARTICLE,dateStr,aPage];
//    
//    NSString* response = [GLNetworkUtility getToSyn:s];
//    NSMutableArray* result = nil;
//    
//    //每日美文一句
//    NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
//    if (data==nil) {
//        return nil;
//    }
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    if (dic==nil) {
//        return nil;
//    }
//    
//    self.totalPages = [[dic objectForKey:@"totalPages"] integerValue];
//    
//    NSArray* arr = [dic objectForKey:@"content"];
//    if (arr.count==0) {
//        return nil;
//    }
//    
//    result = [NSMutableArray array];
//    for (NSDictionary* post in arr) {
//        
//        GLArticle* article = [[GLArticle alloc] init];
//        [result addObject:article];
//        
//        article.articleID = [[post objectForKey:@"id"] description];
//        article.content = [[post objectForKey:@"title"] description];
//        article.picUrl = [[post objectForKey:@"pic"] description];
//        article.picWidth = [[post objectForKey:@"picWidth"] floatValue];
//        article.picHeight = [[post objectForKey:@"picHeight"] floatValue];
//        article.dateStr = [[post objectForKey:@"ctime"] description];
//        article.hotRate = arc4random()%2999+205;
//        article.isLovedByUser = NO;
//    }
//    
//    return result;
//}
//
//-(NSArray*)getArticlesFromServerOf:(NSDate *)date{
//
//    NSDate* today = [NSDate date];
//    if (date.day==[today day]&&date.month==[today month]&&date.year==[today year]) {
//        date = [today addDays:-1];//前一天
//    }
//    NSString* dateStr = [date stringWithFormat:@"yyyy-MM-dd"];
//    
//    NSString* s = [NSString stringWithFormat:@"%@/sign/api/v1/sentence/ten/%@",BASE_URL_ARTICLE,dateStr];
//    NSLog(@"--->%@",s);
//    
//    NSString* response = [GLNetworkUtility getToSyn:s];
//    NSMutableArray* result = nil;
//    
//    //每日美文一句
//    NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
//    if (data==nil) {
//        return nil;
//    }
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    if (dic==nil) {
//        return nil;
//    }
//    
//    self.totalPages = [[dic objectForKey:@"totalPages"] integerValue];
//    
//    NSArray* arr = [dic objectForKey:@"content"];
//    if (arr.count==0) {
//        return nil;
//    }
//    result = [NSMutableArray array];
//    for (NSDictionary* post in arr) {
//        
//        GLArticle* article = [[GLArticle alloc] init];
//        [result addObject:article];
//        
//        article.articleID = [[post objectForKey:@"id"] description];
//        article.content = [[post objectForKey:@"title"] description];
//        article.picUrl = [[post objectForKey:@"pic"] description];
//        article.picWidth = [[post objectForKey:@"picWidth"] floatValue];
//        article.picHeight = [[post objectForKey:@"picHeight"] floatValue];
//        article.dateStr = [[post objectForKey:@"ctime"] description];
//        article.hotRate = arc4random()%2999+205;
//        article.isLovedByUser = NO;
//    }
//    
//    return result;
//}
//
//-(NSDictionary*)getArticlesFromLocal{
//
//    NSString* path = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:@"indexDataDir"];
//    NSString* filePath = [path stringByAppendingPathComponent:@"ArticleDic"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    }else{
//        return nil;
//    }
//}
//
//-(void)saveArticles:(NSDictionary*)dic{
//    
//    if (nil==dic) {
//        return;
//    }
//    NSString* path = [[GLDeviceUtility getCacheRootPath] stringByAppendingPathComponent:@"indexDataDir"];
//    NSString* filePath = [path stringByAppendingPathComponent:@"ArticleDic"];
//    [NSKeyedArchiver archiveRootObject:dic toFile:filePath];
//}
//
//-(NSDate*)getRandomDateInLegalRange:(int)year month:(int)month day:(int)day{
//    
//    const int headYear = year;
//    const int headMonth = month;
//    const int headDay = day;
//    
//    //当前日期
//    NSDate* now = [NSDate date];
//    NSDateComponents* nowComps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
//    
//    //约定的最早可穿越日期
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:headYear];
//    [comps setMonth:headMonth];
//    [comps setDay:headDay];
//    NSDate* headDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
//    
//    NSTimeInterval nowInterval = [[[NSCalendar currentCalendar] dateFromComponents:nowComps] timeIntervalSince1970]-86400;//当前时间戳
//    NSTimeInterval headInterval = [headDate timeIntervalSince1970];//最早可穿越日期的时间戳
//    
//    int currentYear = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:now].year;//当前年，比如2013
//    
//    NSDate* result = nil;
//    
//    BOOL legal = NO;
//    while (!legal) {
//        
//        int randomYear = arc4random()%(currentYear-headYear+1)+headYear;//开始年和结束年之间的随机数
//        int randomMonth = arc4random()%12+1;//1到12之间的随机数
//        int randomDay = arc4random()%31+1;//1到28之间的随机数
//        
//        NSDateComponents *c = [[NSDateComponents alloc] init];
//        [c setYear:randomYear];
//        [c setMonth:randomMonth];
//        [c setDay:randomDay];
//        NSTimeInterval interval = [[[NSCalendar currentCalendar] dateFromComponents:c] timeIntervalSince1970];
//        if (interval>=headInterval&&interval<=nowInterval) {
//            //表示当前随机的这个年份在有效范围内
//            NSDateFormatter* fm = [[NSDateFormatter alloc] init];
//            fm.dateFormat = @"yyyy-MM-dd";
//            result = [[NSCalendar currentCalendar] dateFromComponents:c];
//            legal = YES;
//        }
//    }
//    return result;
//}

@end
