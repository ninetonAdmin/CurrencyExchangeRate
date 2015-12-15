//
//  RingBoxViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-20.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomButton.h"
#import "Notice.h"

@interface RingBoxViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) Notice *tempNotice;

@property (weak, nonatomic) IBOutlet UIView *clipView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *flagImgView;
@property (weak, nonatomic) IBOutlet MyCustomButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *countryChineseNameLable;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLable;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView1;
@property (strong, nonatomic) NSString *countryCode;
//@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
//@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic, strong) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet MyCustomButton *doneButton;
@property (nonatomic, weak) IBOutlet UILabel *otherCountryChineseNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherCountryCodeLable;
@property (nonatomic, weak) IBOutlet UIImageView *otherFlagImgView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *compareSegment;
@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, weak) IBOutlet UILabel *currentLabel;

- (IBAction)backButtonDown;

- (IBAction)addButtonPressed:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)deleteButtonPressed:(id)sender;

- (IBAction)selectNoticeType:(id)sender;
- (IBAction)selectCompareType:(id)sender;

- (IBAction)priceChange:(id)sender;


@end
