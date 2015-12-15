//
//  MyTableViewCell.h
//  iMagReader
//
//  Created by apple apple on 11年3月24日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCell (UITableViewCellExt)

- (void)setBackgroundImage:(UIImage*)image;

- (void)setBackgroundImageByName:(NSString*)imageName;

@end

