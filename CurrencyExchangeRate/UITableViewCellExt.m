//
//  MyTableViewCell.m
//  iMagReader
//
//  Created by apple apple on 11年3月24日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCellExt.h"


@implementation UITableViewCell (UITableViewCellExt)

- (void)setBackgroundImage:(UIImage*)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundView = imageView;
    [imageView release];
    self.textLabel.backgroundColor=[UIColor clearColor];
	self.detailTextLabel.backgroundColor=[UIColor clearColor];
}

- (void)setBackgroundImageByName:(NSString*)imageName
{
    //[self setBackgroundImage:[UIImage imageNamed:imageName]];
    UIImage *img =[Utilities getImageFromBundleName:imageName];
    [self setBackgroundImage:[img stretchableImageWithLeftCapWidth:0 topCapHeight:1]];
}


@end

