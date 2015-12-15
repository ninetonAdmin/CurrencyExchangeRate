//
//  GLImageUtility.m
//  LingShiKong
//
//  Created by dimmy on 13-4-29.
//  Copyright (c) 2013年 dimmy. All rights reserved.
//

#import "GLImageUtility.h"

@implementation GLImageUtility

+(UIImage*)getSubImage:(CGRect)rect img:(UIImage*)img
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (BOOL)isJPEGValid:(NSData*)jpeg
{
    if([jpeg length] < 4)
    {
        return NO;
    }
    const char* bytes = (const char*)[jpeg bytes];
    
    if((Byte)bytes[0] != 0xFF|| (Byte)bytes[1] != 0xD8)
    {
        return NO;
    }
    if((Byte)(bytes[[jpeg length] - 2]) != 0xFF|| (Byte)(bytes[[jpeg length] - 1]) != 0xD9)
    {
        return NO;
    }
    return YES;
}

+(UIImage*)mixImage:(UIImage*)foreImg toImg:(UIImage*)toImg{
    
    UIGraphicsBeginImageContext(CGSizeMake(toImg.size.width*2, toImg.size.height*2));
    [toImg drawInRect:CGRectMake(0, 0, toImg.size.width*2, toImg.size.height*2)];//把背景图绘制进来
    [foreImg drawInRect:CGRectMake(0, 0, toImg.size.width*2, toImg.size.height*2) blendMode:kCGBlendModePlusDarker alpha:1];
    UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

+(UIImage*)stretchImage:(UIImage*)img top:(float)top left:(float)left bottom:(float)bottom right:(float)right{
    
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}

+(UIImage*)generateImageWith:(UIColor*)bgcolor size:(CGSize)size{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgcolor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage*)getImageFromView:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 2);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+(UIImage*)getImageFromView:(UIView*)view WithSize:(CGSize)size  andBackImage:(UIImage *)backImage{
    CGRect yuanshiRect=view.frame;
    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, size.width, size.height+64);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    [backImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.frame=yuanshiRect;
    
    return resultingImage;
}

@end
