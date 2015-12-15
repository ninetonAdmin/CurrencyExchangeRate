//
//  SplashGdtAdView.h
//  GLCalendarHL
//
//  Created by gaolong on 15/9/11.
//  Copyright (c) 2015年 Nineton Tech Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{

    Skin_Type_lovely,
    Skin_Type_game,
    Skin_Type_Default
    
}Skin_Type;

@interface SplashGdtAdView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *titleBgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *zhishuImageView;
@property (strong, nonatomic) IBOutlet UIImageView *xiangkuangImageView;
@property (strong, nonatomic) IBOutlet UIImageView *downloadImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *xiangkuangAlignYCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewTraingCons;
-(void)resizeView:(Skin_Type)type;

@end
