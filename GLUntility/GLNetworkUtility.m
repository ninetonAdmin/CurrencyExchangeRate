//
//  GLNetworkUtility.m
//  LingShiKong
//
//  Created by dimmy on 13-4-25.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import "GLNetworkUtility.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"

@implementation GLNetworkUtility

+(BOOL)isCurrentWifi{
    
    Reachability* r = [Reachability reachabilityForLocalWiFi];
    NetworkStatus status = [r currentReachabilityStatus];
    if (status==ReachableViaWiFi) {
        return YES;//wifi可达
    }
    return NO;
}

+(BOOL)isNetAvaliable{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=NotReachable;
}

+(NSString*)getToSyn:(NSString*)urlstr{

    NSURL* url = [NSURL URLWithString:urlstr];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.timeOutSeconds = 30;//15秒超时时间
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forKey:@"ContentType"];
    [request setRequestHeaders:dic];
    request.cachePolicy = ASIDontLoadCachePolicy;
    [request startSynchronous];
    NSString* response = request.responseString;
    return response;
}

//同步post请求
+(NSString*)postToSyn:(NSString*)urlstr with:(NSDictionary*)params{
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlstr]];
    request.timeOutSeconds = 30;//60秒超时时间
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forKey:@"ContentType"];
    [request setRequestHeaders:dic];
    request.cachePolicy = ASIDontLoadCachePolicy;
    if (params!=nil) {
        NSArray* keys = params.allKeys;
        for (NSString* key in keys) {
            id value = [params objectForKey:key];
            [request addPostValue:value forKey:key];
        }
    }
    [request startSynchronous];
    NSString* response = request.responseString;
    return response;
}

@end
