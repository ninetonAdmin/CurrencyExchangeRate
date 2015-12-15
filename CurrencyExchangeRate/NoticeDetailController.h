//
//  NoticeDetailController.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-14.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
#import "Notice.h"
#import "RateNoticeViewController.h"
#import "YLButton.h"

@interface NoticeDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *compareSegment;

@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet UITextField *priceField;

@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UIView *clipView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;

@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *btnUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDown;

@property (weak, nonatomic) IBOutlet MyCustomButton *cancelButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *doneButton;
@property (weak, nonatomic) IBOutlet YLButton *moreButton;

@property (weak, nonatomic) RateNoticeViewController *parentController;
@property (copy, nonatomic) Notice *notice;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)selectNoticeType:(id)sender;
- (IBAction)selectCompareType:(id)sender;
- (IBAction)priceChange:(id)sender;

- (IBAction)btnUpPressed:(id)sender;
- (IBAction)btnDownPressed:(id)sender;

- (void)changeCountry:(NSString *)countryCode;

@end
