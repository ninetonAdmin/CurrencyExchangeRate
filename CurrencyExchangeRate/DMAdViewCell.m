//
//  DMAdViewCell.m
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-11-22.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import "DMAdViewCell.h"

@implementation DMAdViewCell

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    _downloadImageView.frame=CGRectMake(self.frame.size.width-50, 20, 40, 25);
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImageView = [[DMAsyncImageView alloc] initWithFrame:CGRectMake(13, 10, 50, 50)];
        [self addSubview:_iconImageView];
        
        float orgin_x = 70;
        float width = 180;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(orgin_x, 12, width, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_titleLabel];
        
//        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(orgin_x, 36, width, 12)];
//        _sizeLabel.textColor = [UIColor grayColor];
//        _sizeLabel.font = [UIFont systemFontOfSize:12];
//        [self addSubview:_sizeLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(orgin_x, 42, width+20, 12)];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_detailLabel];
        
        _downloadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 20, 40, 25)];
        _downloadImageView.image = [UIImage imageFromMainBundleFile:@"app-wall-free-button.png"];
        [self addSubview:_downloadImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    self.iconImageView = nil;
    self.titleLabel = nil;
    self.sizeLabel = nil;
    self.detailLabel = nil;
    
    [super dealloc];
}

#pragma mark - setter 

- (void)setIconImageView:(DMAsyncImageView *)iconImageView {
    
    [_iconImageView removeFromSuperview];
    [_iconImageView release];
    _iconImageView = [iconImageView retain];
    _iconImageView.frame = CGRectMake(13, 10, 50, 50);
    [self addSubview:_iconImageView];
}
@end
