//
//  MenuViewController.h
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-15.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *shadowView;//设置动画时用到
@property (weak, nonatomic) IBOutlet UITableView *menuTableview;
@property (weak, nonatomic) IBOutlet UIImageView *menuBgImg;

-(void) rightMoveShadow;
-(void) leftMoveShadow1;
@end
