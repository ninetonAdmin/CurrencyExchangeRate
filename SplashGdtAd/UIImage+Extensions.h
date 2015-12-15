//
//  UIImage+Extensions.h
//  MaHuaDouDou
//
//  Created by dimmy on 13-7-31.
//  Copyright (c) 2013年 nineton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions2)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
-(BOOL)sameWithAnotherImage:(UIImage*)img;
+ (UIImage *)imageNamed:(NSString *)name bundle:(NSBundle *)bundle;
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

@end
