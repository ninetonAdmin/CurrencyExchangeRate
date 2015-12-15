//
//  ChineseExchangeRateListViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-5.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface ChineseExchangeRateListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MyCustomButton *addCountryButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
- (IBAction)editDone:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *currentChineseRateTableView;
- (IBAction)addDown;
@end
