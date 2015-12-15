//
//  CEMenuViewController.h
//  CurrencyExchangeRate
//
//  Created by admin on 14/12/11.
//  Copyright (c) 2014年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;//设置动画时用到
@property (weak, nonatomic) IBOutlet UITableView *menuTableview;

@property (weak, nonatomic) IBOutlet UIImageView *menuBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *navigationBarImageView;

-(void) rightMoveShadow;
-(void) leftMoveShadow1;

@end
