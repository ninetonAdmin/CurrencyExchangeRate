//
//  NineTonConfigManager.h
//  AdAnimationDemo
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 youloft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

//#define baseUrl @"http://tj.nineton.cn/"
#define baseUrl @"http://local.nineton.cn/tianqi/"
#define projectAppId   @"6"//6

@interface NineTonConfigManager : NSObject

+ (NineTonConfigManager *)sharedInstance;
- (void)getConfigWithCid:(NSString *)cid andCompletionBlock:(void(^)(NSInteger statusCode, id response))callbackBlock andFailBlock:(void(^)(NSError *error))failBlock;
- (void)getCutAdInfomationCompletionBlock:(void(^)(NSInteger statusCode, id response))completionBlock andFailBlock:(void(^)(NSError *error))failBlock;
- (void)getCRToastAdInfomationCompletionBlock:(void(^)(NSInteger statusCode, id response))completionBlock andFailBlock:(void(^)(NSError *error))failBlock;
- (void)getAdArrayInfomationCompleteBlock:(void(^)(NSMutableArray *adArray))completionBlock andFailBlock:(void(^)(NSError *error))failBlock;
- (void)getCRToastArrayAndPlugArrayCompletionBlock:(void(^)(NSArray *toastArray, NSArray *plugArray))completionBlock andFailBlock:(void(^)(NSError *error))failBlock;


//splash
- (void)getSplashDataSourseCompletionBlock:(void(^)(NSInteger statusCode, id response))callbackBlock andFailBlock:(void(^)(NSError *error))failBlock;
//- (void)onClickSplashID:(NSString *)aId;


@end
