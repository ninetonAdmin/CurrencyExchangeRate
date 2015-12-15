//
//  CalcRateListViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-12.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface CalcRateListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MyCustomButton *addCountryButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *doneButton;
//- (IBAction)editDone:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *currentCalcRateTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;

- (IBAction)editDone;
- (IBAction)addDown;








@end
