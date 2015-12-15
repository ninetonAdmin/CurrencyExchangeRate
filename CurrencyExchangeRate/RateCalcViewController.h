//
//  RateCalcViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-8.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcRatePickerViewViewController.h"
#import "MyCalcTableViewCell.h"



@interface RateCalcViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *myEndEditButton;
@property (weak, nonatomic) IBOutlet UITableView *myCalcTableView;
@property (weak, nonatomic) UITextField *currentField;
@property (weak, nonatomic) UILabel *currentFieldShadow;
@property (strong, nonatomic) NSString *currentCalcCountryCode;//用来标示当前用户选择的主货币（及用该货币与其他货币直接进行数值的计算）
@property float currentCalcCountryValue;//用来标示当前用户选择的主货币的数值

@property (weak, nonatomic) IBOutlet UIImageView *navigationBarImageView;
@property (weak, nonatomic) IBOutlet MyCustomButton *editButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *infoCenterButton;

@property (weak, nonatomic) IBOutlet UIView *myPickerView;//包含pickview的控件，用于快速添加

@property (strong, nonatomic) CalcRatePickerViewViewController *myCRPVViewController;
@property (strong, nonatomic) MyCalcTableViewCell *theLastCell;//最后一项Cell,快速添加时用于改变外观等

- (IBAction)endEdit;

@end
