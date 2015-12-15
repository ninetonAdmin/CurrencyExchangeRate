//
//  SplashGdtAdView.m
//  GLCalendarHL
//
//  Created by gaolong on 15/9/11.
//  Copyright (c) 2015年 Nineton Tech Co., Ltd. All rights reserved.
//

#import "SplashGdtAdView.h"
#import "GLDeviceUtility.h"

@implementation SplashGdtAdView

-(void)resizeView:(Skin_Type)type{

    if ([GLDeviceUtility isCurrentDeviceLowThan5]) {
        self.titleImageView.hidden = YES;
    }else{
        self.titleImageView.hidden = NO;
    }
    
    [self changeSkin:type];
}

-(void)changeSkin:(Skin_Type)type{
    
    switch (type) {
        
        case Skin_Type_lovely:
            
            self.titleImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
            self.imgView.transform = CGAffineTransformMakeScale(0.96, 0.98);
            self.xiangkuangImageView.transform = CGAffineTransformMakeScale(1.25, 1.1);
            self.xiangkuangAlignYCons.constant = 2;
            self.imageViewLeadingCons.constant = 20;
            [self setNeedsLayout];
            [self layoutIfNeeded];
            self.bgImageView.image = [UIImage imageNamed:@"lovely_bg.jpg"];
            self.titleImageView.image = [UIImage imageNamed:@"lovely_menu.png"];
            self.titleBgImageView.image = [UIImage imageNamed:@"lovely_titlebg.png"];
            self.xiangkuangImageView.image = [UIImage imageNamed:@"lovely_xiangkuang.png"];
            self.zhishuImageView.image = [UIImage imageNamed:@"lovely_zhishu.png"];
            self.downloadImageView.image = [UIImage imageNamed:@"lovely_download.png"];
            break;
            
            case Skin_Type_Default:
            self.titleImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.xiangkuangImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.xiangkuangAlignYCons.constant = -10;
            self.imgView.transform = CGAffineTransformMakeScale(1, 1);
            [self setNeedsLayout];
            [self layoutIfNeeded];
            self.bgImageView.image = [UIImage imageNamed:@"default_bg.jpg"];
            self.titleImageView.image = [UIImage imageNamed:@"default_menu.png"];
            self.titleBgImageView.image = [UIImage imageNamed:@"default_titlebg.png"];
            self.xiangkuangImageView.image = [UIImage imageNamed:@"default_xiangkuang.png"];
            self.zhishuImageView.image = [UIImage imageNamed:@"default_zhishu.png"];
            self.downloadImageView.image = [UIImage imageNamed:@"default_download.png"];
            break;
            
            case Skin_Type_game:
            self.bgImageView.image = [UIImage imageNamed:@"game_bg.png"];
            self.titleImageView.image = [UIImage imageNamed:@"game_menu.png"];
            self.titleBgImageView.image = [UIImage imageNamed:@"game_titlebg.png"];
            self.xiangkuangImageView.image = [UIImage imageNamed:@"game_xiangkuang.png"];
            self.zhishuImageView.image = [UIImage imageNamed:@"game_zhishu.png"];
            self.downloadImageView.image = [UIImage imageNamed:@"game_download.png"];
            break;
            
        default:
            break;
    }
}

@end
