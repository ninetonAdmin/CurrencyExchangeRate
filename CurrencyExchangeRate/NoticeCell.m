//
//  NoticeCell.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-23.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

//- (void)setCountryCode:(NSString *)countryCode
//{
//    NSString *flageImgPath = [[NSString alloc] initWithFormat:@"s%@.png", countryCode];
//    flagImageView.image = [UIImage imageNamed:flageImgPath];
//}

- (void)awakeFromNib
{
    flagImageView.layer.masksToBounds = YES;
    flagImageView.layer.cornerRadius = 5;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNotice:(Notice *)notice
{
    _notice = notice;
    switch (notice.noticeType) {
        case NoticeTypeSpotExchangeBuy:
            self.typeLabel.text = @"现汇买入";
            break;
        case NoticeTypeSpotExchangeSale:
            self.typeLabel.text = @"现汇卖出";
            break;
        case NoticeTypeBand:
            self.typeLabel.text = @"银行";
            break;
        default:
            break;
    }
    switch (notice.compareType) {
        case CompareTypeHigher:
            self.compareLabel.text = @"大于";
            self.priceLable.textColor = [UIColor colorWithRed:.78f green:.37f blue:.03f alpha:1.f];
            break;
        case CompareTypeLower:
            self.compareLabel.text = @"小于";
            self.priceLable.textColor = [UIColor colorWithRed:.07f green:.46f blue:.04f alpha:1.f];
            break;
        default:
            break;
    }
    NSString *string = notice.price;
    NSRange range = [string rangeOfString:@"."];
    if (range.location != NSNotFound)
        if (string.length > 6)
            string = [string substringToIndex:6];
    
    self.priceLable.text = string;
    NSString *flageImgPath = [[NSString alloc] initWithFormat:@"s%@.png", notice.countryCode];
    flagImageView.image = [UIImage imageNamed:flageImgPath];
}

@end
