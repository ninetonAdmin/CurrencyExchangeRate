//
//  CalcRatePickerViewViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-14.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
@interface CalcRatePickerViewViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet MyCustomButton *myCancelButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *myAddButton;
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@property (strong, nonatomic) NSString *currentAddingCountryCode;//保存当前添加选择的国家代码

@property (strong, nonatomic) NSMutableArray *countryNeedToAddArray;
- (IBAction)clickCancel;
- (IBAction)clickAdd;

@end
