//
//  CalcRateAddingListViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-13.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface CalcRateAddingListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *currentAddingTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;

@property (weak, nonatomic) IBOutlet MyCustomButton *doneButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *cancleButton;

@property (strong, nonatomic) NSMutableDictionary *countryNeedToAddDic;
@property (strong, nonatomic) NSMutableArray *countryNeedToAddArray;

- (IBAction)addingDone;
- (IBAction)cancleDown:(id)sender;


@end
