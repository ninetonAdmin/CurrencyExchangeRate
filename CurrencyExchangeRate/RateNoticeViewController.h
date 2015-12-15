//
//  RateNoticeViewController.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-23.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
#import "Notice.h"

@interface RateNoticeViewController : UIViewController

@property (weak, nonatomic) IBOutlet MyCustomButton *showMenuButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *addButton;

@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *datas;

- (IBAction)showMenu;

- (void)getNoticeList;

- (IBAction)addButtonPressed:(id)sender;

- (void)getNoticeListFromWeb;
@end
