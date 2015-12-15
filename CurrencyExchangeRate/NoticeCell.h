//
//  NoticeCell.h
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-23.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notice.h"

@interface NoticeCell : UITableViewCell
{
    IBOutlet UIImageView *flagImageView;
}
@property (strong, nonatomic) Notice *notice;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *compareLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
//@property (nonatomic, strong) NSString *countryCode;

@end
