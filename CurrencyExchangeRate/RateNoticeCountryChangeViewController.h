//
//  RateNoticeCountryChangeViewController.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-15.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
#import "NoticeDetailController.h"

@interface RateNoticeCountryChangeViewController : UIViewController


@property (weak, nonatomic) IBOutlet MyCustomButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (nonatomic, strong) NSString *countryCode;
@property (strong, nonatomic) NSArray *listRateCountrys;
@property (nonatomic, strong) NoticeDetailController *parentController;


- (IBAction)cancelDown;

@end
