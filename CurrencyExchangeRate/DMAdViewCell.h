//
//  DMAdViewCell.h
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-11-22.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAsyncImageView.h"

@interface DMAdViewCell : UITableViewCell

@property(nonatomic,retain)DMAsyncImageView *iconImageView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *detailLabel;
@property(nonatomic,retain)UILabel *sizeLabel;
@property(nonatomic,retain)UIImageView *downloadImageView;

@end
