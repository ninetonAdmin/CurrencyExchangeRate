//
//  MyCalcTableViewCell.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-9.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"

@interface MyCalcTableViewCell : UITableViewCell



@property(nonatomic, strong) UIImageView *myBgView;
@property(nonatomic, strong) UIImageView *myHighLightView;
@property(nonatomic, strong) MyImageView *flagView;
@property(nonatomic, strong) MyImageView *highLightView;

@property(nonatomic, strong) UITextField *numberTextField;
// 币种英文缩写
@property(nonatomic, strong) UILabel *codeLable;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) UILabel *numberTextFieldShadow;
@property(nonatomic, strong) NSString *myCountryCode;

@property(nonatomic, strong) UIImageView *myAddIconView;//只是用在最后一项（添加新币种）
@property(nonatomic, strong) UILabel *addNewCurrencyLable;//只是用在最后一项
@end
