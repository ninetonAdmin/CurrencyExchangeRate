//
//  ProgressIndicator.m
//  DownloadHandler
//
//  Created by 阿 朱 on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProgressTableViewCell.h"
#import "GradientView.h"
#import "Utilities.h"

@interface ProgressTableViewCell()
- (void)initProgressView;
- (void)initLabel;
- (void)initTitle;

@end

@implementation ProgressTableViewCell

@synthesize totalSize = _totalSize;
@synthesize retryCount = _retryCount;

-(void)dealloc{
    [_progressView release];
    _progressView  = nil;
    [_label release];
    _label = nil;
    [_lblTitle release];
    _lblTitle = nil;
    [super dealloc];
}


-(void)initProgressView{
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.tag = 12;
    //_progressView.autoresizingMask =     UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin ;
    [self addSubview:_progressView];
}

-(void)initTitle{
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblTitle.textAlignment = UITextAlignmentLeft;
    _lblTitle.textColor = [UIColor darkGrayColor];
    _lblTitle.font = [UIFont systemFontOfSize:15.0];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    _lblTitle.tag = 11;
   // _lblTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth ;
    [self addSubview:_lblTitle];
}

-(void)initLabel{
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textAlignment = UITextAlignmentRight;
    _label.textColor = [UIColor darkGrayColor];
    _label.font = [UIFont systemFontOfSize:12.0];
    _label.backgroundColor = [UIColor clearColor];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.tag = 14;
    //_lblTitle.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth ;
    [self addSubview:_label];
}

- (id)init{
	if (self = [super init]) {
		[self setBackgroundView:[[[GradientView alloc] initWithGradientType:WHITE_GRADIENT] autorelease]];
        [self initProgressView];
        [self initLabel];
        [self initTitle];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGSize sz = self.frame.size;
    _lblTitle.frame = CGRectMake(20/768.0f*sz.width, 8, 580/768.0f*sz.width, 21);
    _label.frame = CGRectMake(581/768.0f*sz.width, 8, 168/768.0f*sz.width, 21);
    _progressView.frame = CGRectMake(20/768.0f*sz.width, 38, 728/768.0f*sz.width, 9);
    
//    [Utilities logRect:self.frame withTitle:@"self.frame = "];
//    [Utilities logRect:_lblTitle.frame withTitle:@"title.frame = "];
//    [Utilities logRect:_label.frame withTitle:@"_label.frame = "];
//    [Utilities logRect:_progressView.frame withTitle:@"_progressView.frame = "];
}

-(void)setProgressInfo:(float)progress{
    if (progress != 1.0) {
        if (_totalSize>0) {
            if (_totalSize>1000/1024.0f) {
                _label.text = [NSString stringWithFormat:@"%.2fM/%.2fM", _totalSize*progress, _totalSize];
            }else {
                _label.text = [NSString stringWithFormat:@"%.0fk/%.0fk", _totalSize*1024*progress, _totalSize*1024];
            }
        }else if (progress>0) {
            _label.text = [NSString stringWithFormat:@"%.1f%%", progress*100];
        }

    } else {
        _label.text = @"Done";
    }
}

-(void)setProgress:(float)progress{
    [_progressView setProgress:progress];
    [self setProgressInfo:progress];
}
-(void)setProgress:(float)progress animated:(BOOL)animated{
    [_progressView setProgress:progress animated:animated];
    [self setProgressInfo:progress];
}


@end
