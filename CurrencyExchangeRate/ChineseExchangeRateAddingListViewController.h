//
//  ChineseExchangeRateAddingListViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-7.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface ChineseExchangeRateAddingListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *currencyAddingTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (weak, nonatomic) IBOutlet MyCustomButton *doneButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *cancelButton;

@property (strong, nonatomic) NSMutableDictionary *countryNeedToAddDic;
@property (strong, nonatomic) NSArray *countryNeedToAddArray;

- (IBAction)addingDone:(id)sender;
- (IBAction)cancleAction:(id)sender;
@end
