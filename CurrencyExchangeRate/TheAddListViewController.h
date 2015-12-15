//
//  TheAddListViewController.h
//  CurrencyExchangeRate
//
//  Created by YouLoft520 on 15/6/23.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheAddListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, retain) UIImageView *bgImageview;
//@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIButton *closeBtn;
@property (nonatomic, retain) UILabel *titleLable;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UISearchBar *searchBar;

- (instancetype)initWithBg:(UIImage *)img;

@end
