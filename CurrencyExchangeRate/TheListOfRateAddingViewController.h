//
//  TheListOfRateAddingViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-19.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"

@interface TheListOfRateAddingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>



@property (strong, nonatomic) NSMutableArray *listRateCountrys;
@property (nonatomic, strong) NSArray * filterData;

@property (weak, nonatomic) IBOutlet MyCustomButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *listOfRateAddingTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

//@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

- (IBAction)cancelDown;

@end
