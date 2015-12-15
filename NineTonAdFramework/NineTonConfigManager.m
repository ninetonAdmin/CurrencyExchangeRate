//
//  NineTonConfigManager.m
//  AdAnimationDemo
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 youloft. All rights reserved.
//

#import "NineTonConfigManager.h"

//#import "ASIFormDataRequest.h"
//#import "SSKeychain.h"

@implementation NineTonConfigManager

+ (NineTonConfigManager *)sharedInstance
{
    static NineTonConfigManager *_obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_obj) {
            _obj = [[NineTonConfigManager alloc] init];
        }
    });
    return _obj;
}

- (void)getConfigWithCid:(NSString *)cid andCompletionBlock:(void(^)(NSInteger statusCode, id response))callbackBlock andFailBlock:(void(^)(NSError *error))failBlock
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@Api/Config/get?appid=%@&cid=%@",baseUrl,projectAppId,cid];
    ASIHTTPRequest *requset = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
    __block ASIHTTPRequest *blockRequest = requset;
    [blockRequest setTimeOutSeconds:10.0f];
    [blockRequest setCompletionBlock:^{
        [requset responseData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[requset responseData] options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            callbackBlock([requset responseStatusCode], dic);
        });
    }];
    [blockRequest setFailedBlock:^{
        failBlock(requset.error);
    }];
    [requset startAsynchronous];
}

- (void)getCutAdInfomationCompletionBlock:(void(^)(NSInteger statusCode, id response))completionBlock andFailBlock:(void(^)(NSError *error))failBlock
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/Api/Advis/all?appid=%@",baseUrl,projectAppId];
    ASIHTTPRequest *requset = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
    __block ASIHTTPRequest *blockRequest = requset;
    [requset setTimeOutSeconds:10.0f];
    [requset setCompletionBlock:^{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[blockRequest responseData] options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(blockRequest.responseStatusCode, dic);
        });
    }];
    [requset setFailedBlock:^{
        failBlock(blockRequest.error);
    }];
    [requset startAsynchronous];
    
}

- (void)getCRToastAdInfomationCompletionBlock:(void(^)(NSInteger statusCode, id response))completionBlock andFailBlock:(void(^)(NSError *error))failBlock
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@/Api/Toast/all?appid=%@",baseUrl,projectAppId];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
    __block ASIHTTPRequest *blockRequest = request;
    [request setTimeOutSeconds:10.0f];
    [request setCompletionBlock:^{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[blockRequest responseData] options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(blockRequest.responseStatusCode, dic);
        });
    }];
    [request setFailedBlock:^{
        failBlock(blockRequest.error);
    }];
    [request startAsynchronous];
}


- (void)getAdArrayInfomationCompleteBlock:(void(^)(NSMutableArray *adArray))completionBlock andFailBlock:(void(^)(NSError *error))failBlock
{
    __block NSMutableArray *sumArray = [[NSMutableArray alloc] initWithCapacity:0];
    __block NineTonConfigManager *safeSelf = self;
    [self getCutAdInfomationCompletionBlock:^(NSInteger statusCode, id response) {
        if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *array = [response objectForKey:@"data"];
            if (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0) {
            }else{
                [sumArray addObjectsFromArray:[safeSelf insertAdTypeWithInt:0 andArray:array]];
            }
        }
       [self getCRToastAdInfomationCompletionBlock:^(NSInteger statusCode, id response) {
           if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
               NSArray *array = [response objectForKey:@"data"];
               if (array == nil  || [array isKindOfClass:[NSNull class]] || array.count == 0) {
                   
               }else{
                   [sumArray addObjectsFromArray:[safeSelf insertAdTypeWithInt:1 andArray:array]];
               }
               
           }
           completionBlock(sumArray);
       } andFailBlock:^(NSError *error) {
           failBlock(error);
       }];
    } andFailBlock:^(NSError *error) {
        [self getCRToastAdInfomationCompletionBlock:^(NSInteger statusCode, id response) {
            if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
                NSArray *array = [response objectForKey:@"data"];
                [sumArray addObjectsFromArray:[safeSelf insertAdTypeWithInt:1 andArray:array]];
            }
            completionBlock(sumArray);
        } andFailBlock:^(NSError *error) {
            failBlock(error);
        }];
    }];
}

- (void)getCRToastArrayAndPlugArrayCompletionBlock:(void(^)(NSArray *toastArray, NSArray *plugArray))completionBlock andFailBlock:(void(^)(NSError *error))failBlock
{
    __block NSMutableArray *safeToastArray = [[NSMutableArray alloc] initWithCapacity:0];
    __block NSMutableArray *safePlugArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self getCutAdInfomationCompletionBlock:^(NSInteger statusCode, id response) {
        if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
            NSArray *tempArray = [response objectForKey:@"data"];
            if (tempArray == nil  || [tempArray isKindOfClass:[NSNull class]] || tempArray.count == 0) {
            }else{
                [safePlugArray addObjectsFromArray:tempArray];
            }
        }
        [self getCRToastAdInfomationCompletionBlock:^(NSInteger statusCode, id response) {
            if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
                NSArray *tempArray = [response objectForKey:@"data"];
                if (tempArray == nil  || [tempArray isKindOfClass:[NSNull class]] || tempArray.count == 0) {
                }else{
                    [safeToastArray addObjectsFromArray:tempArray];
                }
            }
            completionBlock(safeToastArray, safePlugArray);
        } andFailBlock:^(NSError *error) {
            failBlock(error);
        }];
    } andFailBlock:^(NSError *error) {
        [self getCRToastAdInfomationCompletionBlock:^(NSInteger statusCode, id response) {
            if (statusCode == 200 && [[response objectForKey:@"status"] isEqualToString:@"success"]) {
                NSArray *tempArray = [response objectForKey:@"data"];
                if (tempArray == nil  || [tempArray isKindOfClass:[NSNull class]] || tempArray.count == 0) {
                }else{
                    [safeToastArray addObjectsFromArray:tempArray];
                }
            }
            completionBlock(safeToastArray, safePlugArray);
        } andFailBlock:^(NSError *error) {
            failBlock(error);
        }];
    }];
}

- (NSArray *)insertAdTypeWithInt:(NSInteger)aType andArray:(NSArray *)array
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in array) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mutDic setObject:[NSNumber numberWithInteger:aType] forKey:@"adType"];
        [result addObject:mutDic];
    }
    return result;
}



#pragma mark - Splash

- (void)getSplashDataSourseCompletionBlock:(void(^)(NSInteger statusCode, id response))callbackBlock andFailBlock:(void(^)(NSError *error))failBlock
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *stringUrl = [NSString stringWithFormat:@"%@Api/Commonsplash/g?appid=%@",baseUrl,projectAppId];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:stringUrl]];
        [request setTimeOutSeconds:3.0f];
        [request startSynchronous];
        if (request.error == nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:nil];
                callbackBlock([request responseStatusCode],dic);
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                failBlock(request.error);
            });
        }
    });
}

//- (void)onClickSplashID:(NSString *)aId
//{
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        NSString *uniqueUuid = [SSKeychain passwordForService:@"com.ireadercity.weather" account:@"user"];
//        if (uniqueUuid == nil || [uniqueUuid isEqualToString:@""]) {
//            CFUUIDRef  uuid = CFUUIDCreate(NULL);
//            assert(uuid);
//            CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
//            uniqueUuid = [NSString stringWithFormat:@"%@",uuidStr];
//            [SSKeychain setPassword:uniqueUuid forService:@"com.ireadercity.weather" account:@"user"];
//        }
//        
//        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//        NSString *url = [NSString stringWithFormat:@"%@Api/Commonsplash/clicktj",baseUrl];
//        ASIFormDataRequest *post = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
//        [post setPostValue:aId forKey:@"splashid"];
//        [post setPostValue:projectAppId forKey:@"appid"];
//        [post setPostValue:uniqueUuid forKey:@"deviceid"];
//        [post setPostValue:[NSNumber numberWithInt:0] forKey:@"platform"];
//        [post setPostValue:version forKey:@"appver"];
//        [post setPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
//        [post setPostValue:[AppUtility idfaString] forKey:@"idfa"];
//        [post setPostValue:[AppUtility idfvString] forKey:@"idfv"];
//        [post setPostValue:[AppUtility macString] forKey:@"mac"];
//        [post startSynchronous];
//        if (post.error == nil) {
//        }else{
//        }
//    });
//}


@end

















