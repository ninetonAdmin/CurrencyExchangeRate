//
//  JRTemporaryData.h
//  NewDianDianProj
//
//  Created by LeungJR on 15/11/11.
//  Copyright © 2015年 GL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRTemporaryData : NSObject

+ (JRTemporaryData *)sharedInstance;

- (void)prepare;

@property (nonatomic, assign) BOOL isReview;
@property (nonatomic, assign) BOOL showGLGDTSplash;
@property (nonatomic, assign) BOOL showYD;
@property (nonatomic, assign) BOOL showGDTContent;

@property (nonatomic, strong) NSString *gdtSplashAppkey;
@property (nonatomic, strong) NSString *gdtSplashPlaceId;

@property (nonatomic, strong) NSString *gdtContentAppkey;
@property (nonatomic, strong) NSString *gdtContentPlaceId;

@end
