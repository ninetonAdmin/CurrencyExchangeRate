//
//  NineTonSplashView.h
//  CurrencyExchangeRate
//
//  Created by LeungJR on 15/6/10.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kSplashStatusNone = 0,
    kSplashStatusTj = 1,
    kSplashStatusGDT = 2
    //kSplashStatusBaiDu
}kSplashStatus;

#define kSplashGDTSuccessNotification @"kSplashGDTSuccessNotification"
#define kSplashGDTFailNotification    @"kSplashGDTFailNotification"

@protocol NineTonSplashViewDelegate <NSObject>

- (void)tapTJSplashActivityURL:(NSString *)aUrl;
- (void)tapTJSplashAppId:(NSString *)aAppId;

@end

@interface NineTonSplashView : UIView

@property (nonatomic, assign) id<NineTonSplashViewDelegate> nineTonSplashDelegate;
@property (nonatomic, assign) kSplashStatus splashStatus;

- (void)hiddenSplashViewWithAnimation:(BOOL)animation;
- (void)switchGDTViewController;

- (void)loadTJData:(NSDictionary *)aTJData;
- (void)loadFutureTJImageData:(NSDictionary *)data;

- (void)clearSplashViews;

@end
