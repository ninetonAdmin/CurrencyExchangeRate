//
//  NineTonPlugAdView.h
//  AdAnimationDemo
//
//  Created by admin on 14/12/29.
//  Copyright (c) 2014年 youloft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NineTonPlugADViewDelegate <NSObject>

@optional
- (void)getiTunesAppId:(NSString *)itunesId;
@end

@interface NineTonPlugAdView : UIView

@property (nonatomic, copy, readonly) void(^willShowAnimationBlock)(void);
@property (nonatomic, copy, readonly) void(^willDismissAnimationBlock)(void);
@property (nonatomic, copy, readonly) void(^didDismissEvent)(void);
@property (nonatomic, assign) id<NineTonPlugADViewDelegate>delegate;

- (void)setShowAnimationBlock:(void(^)(void))animationBlock;
- (void)setDismissAnimationBlock:(void(^)(void))animationBlock;
- (void)setDidDismissEventBlock:(void(^)(void))dismissEvent;

- (void)prepareLoadAdDataSourse:(NSArray *)array;

- (void)adWillAppear;
- (void)execAdDisAppear;

- (void)loadRequestWithLink:(NSString *)url;

@end
