//
//  GLImageUtility.h
//  LingShiKong
//
//  Created by dimmy on 13-4-29.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*图像处理工具类*/
@interface GLImageUtility : NSObject

+(UIImage*)mixImage:(UIImage*)foreImg toImg:(UIImage*)toImg;
+(UIImage*)generateImageWith:(UIColor*)bgcolor size:(CGSize)size;
+ (BOOL)isJPEGValid:(NSData*)jpeg;
+(UIImage*)stretchImage:(UIImage*)img top:(float)top left:(float)left bottom:(float)bottom right:(float)right;
+(UIImage*)getImageFromView:(UIView*)view;
+(UIImage*)getImageFromView:(UIView*)view WithSize:(CGSize)size andBackImage:(UIImage *)backImage;
+(UIImage*)getSubImage:(CGRect)rect img:(UIImage*)img;

@end
