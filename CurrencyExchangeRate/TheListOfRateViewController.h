//
//  TheListOfRateViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-16.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface TheListOfRateViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UITableView *listOfRateTableView;
@property (weak, nonatomic) IBOutlet UILabel *updateLable;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *navigationBarImageView;

@property (weak, nonatomic) IBOutlet MyCustomButton *choiceRateButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *showMenuButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *btnChoiceRate;

@property (strong, nonatomic) NSMutableArray *otherCountry;//

- (IBAction)showMenu;

- (IBAction)showAddList:(id)sender;

@end
