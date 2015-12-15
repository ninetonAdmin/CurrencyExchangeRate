//
//  MyCalcTableViewCell.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-9.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "MyCalcTableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation MyCalcTableViewCell

@synthesize myBgView = _myBgView;
@synthesize myHighLightView = _myHighLightView;
@synthesize flagView = _flagView;
@synthesize highLightView = _highLightView;
@synthesize nameLable = _nameLable;
@synthesize numberTextField = _numberTextField;
@synthesize myCountryCode = _myCountryCode;
@synthesize codeLable = _codeLable;

//-(void)setMyBgView:(UIImageView *)myBgView
//{
//    _myBgView = myBgView;
////    [_myBgView.layer setShadowColor:[[UIColor clearColor]CGColor]];
////    [_myBgView.layer setShadowOffset:CGSizeMake(0, 0)];
////    [_myBgView.layer setShadowOpacity:1.0];
////    //[_myBgView.layer setShadowRadius:3];
////    [self addSubview:_myBgView];
//}

//-(UIImageView *)myBgView
//{
//    if (!_myBgView) {
//        _myBgView = [[UIImageView alloc] init];
//        [_myBgView.layer setShadowColor:[[UIColor clearColor]CGColor]];
//        [_myBgView.layer setShadowOffset:CGSizeMake(0, 0)];
//        [_myBgView.layer setShadowOpacity:1.0];
//        //[_myBgView.layer setShadowRadius:3];
//        [self addSubview:_myBgView];
//    }
//    return _myBgView;
//}

//-(void)setMyHighLightView:(UIView *)myHighLightView
//{
//    _myHighLightView = myHighLightView;
//    [self addSubview:_myHighLightView];
//}
//
//-(UIImageView *)myHighLightView
//{
//    
//}

//-(void)setFlagView:(MyImageView *)flagView
//{
//    _flagView = flagView;
//}
//
//-(MyImageView *)flagView
//{
//    if (!_flagView) {
//        _flagView = [[MyImageView alloc] init];
//        [self addSubview:_flagView];
//    }
//    return _flagView;
//}

//-(void)setNameLable:(UILabel *)nameLable
//{
//    _nameLable = nameLable;
//    _nameLable.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
//    _nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
//    _nameLable.shadowColor = [UIColor whiteColor];
//    _nameLable.shadowOffset = CGSizeMake(0, 1.0);
//    
//    [self addSubview:_nameLable];
//}

//-(void)setNumberTextField:(UITextField *)numberTextField
//{
//    _numberTextField = numberTextField;
//    _numberTextField.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
//    _numberTextField.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
//    _numberTextField.layer.shadowColor = [UIColor whiteColor].CGColor;
//    _numberTextField.layer.shadowOffset = CGSizeMake(0, 1.0);
//    _numberTextField.layer.shadowOpacity = 1;
//    
//    [self addSubview:_numberTextField];
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //DLog(@"self = %@  reuseIdentifier = %@", self, reuseIdentifier);
    
    if (self) {
        // Initialization code
        //DLog(@"initWithStyle in self");
        self.myBgView = [[UIImageView alloc] init];
//        [self.myBgView.layer setShadowColor:[[UIColor clearColor]CGColor]];
        [self.myBgView setBackgroundColor:[UIColor colorWithRed:243.0/255 green:243.0/255 blue:243.0/255 alpha:1]];
        [self.myBgView.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.myBgView.layer setShadowOpacity:1.0];
        [self.myBgView.layer setShadowRadius:6];
        [self addSubview:self.myBgView];
        
        MyImageView *flagView = [[MyImageView alloc] init];
        self.flagView = flagView;
        [self addSubview:self.flagView];
        
//        MyImageView *highLightView = [[MyImageView alloc] init];
//        self.highLightView = highLightView;
//        self.highLightView.image = [UIImage imageNamed:@"calculator-box-high-light.png"];
//        [self addSubview:self.highLightView];
        
//        UILabel *textShadow = [[UILabel alloc] init];
//        self.numberTextFieldShadow = textShadow;
//        self.numberTextFieldShadow.backgroundColor = [UIColor clearColor];
//        self.numberTextFieldShadow .textColor = [UIColor whiteColor];
//        self.numberTextFieldShadow .font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        
        [self addSubview:self.numberTextFieldShadow];
        
        UITextField *textField = [[UITextField alloc] init];
        self.numberTextField = textField;
        self.numberTextField.textColor = [UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1];
        self.numberTextField.font = [UIFont fontWithName:@"Helvetica" size:20];
//        self.numberTextField.layer.shadowColor = [UIColor redColor].CGColor;
//        self.numberTextField.layer.shadowOffset = CGSizeMake(0, 1.0);
//        self.numberTextField.layer.shadowOpacity = 1;
        self.numberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.numberTextField setTextAlignment:NSTextAlignmentRight];
        [self.numberTextField setTextColor:[UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1]];
        [self addSubview:self.numberTextField];
        
        UILabel *nameLable = [[UILabel alloc] init];
        self.nameLable = nameLable;
        self.nameLable.backgroundColor = [UIColor clearColor];
        self.nameLable.textColor = [UIColor colorWithRed:197.0/255 green:197.0/255 blue:197.0/255 alpha:1];
        self.nameLable.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.nameLable.shadowColor = [UIColor whiteColor];
        self.nameLable.shadowOffset = CGSizeMake(0, 1.0);
        [self.nameLable setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.nameLable ];
        
        // 币种英文缩写
        self.codeLable = [[UILabel alloc] init];
        [self.codeLable setTextColor:[UIColor blackColor]];
        [self.codeLable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [self addSubview:self.codeLable];
        
        // 最后一项快速添加的模式
        self.myAddIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v2-quick-add-icon-active.png"]];
        [self addSubview:self.myAddIconView];
        self.addNewCurrencyLable = [[UILabel alloc] init];
        self.addNewCurrencyLable.text = @" 添加新币种";
        [self.addNewCurrencyLable setTextColor:[UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1.0]];
//        self.addNewCurrencyLable.backgroundColor = [UIColor clearColor];
//        [self.addNewCurrencyLable setShadowColor:[UIColor blackColor]];
//        [self.addNewCurrencyLable setShadowOffset:CGSizeMake(0, -1.0)];
        [self addSubview:self.addNewCurrencyLable];
         
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = self.frame.size;
    
    //DLog(@"layoutSubviews");
    
    self.myBgView.frame = CGRectMake(4, 5, sz.width - 8, sz.height - 10);
    [self.myBgView.layer setCornerRadius:4];
    [self.myBgView.layer setMasksToBounds:YES];
    
    self.myHighLightView.frame = CGRectMake(0, 0, sz.width, sz.height);
    
    self.flagView.frame = CGRectMake(3, 5, 54, 54);
    UIRectCorner corners;
    corners = UIRectCornerTopLeft;
    corners |= UIRectCornerBottomLeft;
    [self.flagView  maskRoundCorners:corners radius:4];
    self.flagView.layer.masksToBounds = YES;
    
//    self.highLightView.frame = CGRectMake(3, 5, sz.width - 7, 33);
//    UIRectCorner corners1 = UIRectCornerAllCorners;
//    corners1 = UIRectCornerBottomRight;
//    corners1 |= UIRectCornerTopRight;
//    [self.highLightView  maskRoundCorners:corners1 radius:4];
    
    [self.codeLable setFrame:CGRectMake(64, 20, 80, 20)];
    self.nameLable.frame = CGRectMake(65, 38, DEVICE_WIDTH - 100, 20);
    self.numberTextFieldShadow.frame = CGRectMake(60, 17, DEVICE_WIDTH - 90, 40);
    self.numberTextField.frame = CGRectMake(95, 18, DEVICE_WIDTH - 130, 40);
    self.myAddIconView.frame = CGRectMake((DEVICE_WIDTH - 150) / 2 + 10, 21, 18, 18);
    self.addNewCurrencyLable.frame = CGRectMake((DEVICE_WIDTH - 150) / 2 + 35, 15, 150, 30);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //若是最后的快速添加，这变化背景图
    if (self.myAddIconView.hidden == NO) {
        
//        UIImage *bgImg = [UIImage imageNamed:@"quick-add-new-active-background.png"];
//        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 29, 0, 29)];
//        self.myBgView.image = bgImg;
//        
//        self.myAddIconView.image = [UIImage imageNamed:@"quick-add-icon-active.png"];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //若是最后的快速添加，这变化背景图
    if (self.myAddIconView.hidden == NO) {
        
//        UIImage *bgImg = [UIImage imageNamed:@"quick-add-new-normal-background.png"];
//        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 29, 0, 29)];
//        self.myBgView.image = bgImg;
//        
//        self.myAddIconView.image = [UIImage imageNamed:@"quick-add-icon-normal.png"];
    }
}

@end
