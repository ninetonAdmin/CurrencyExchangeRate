//
//  DMAsyncImageView.h
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-11-22.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultDMImageIdKey		@"imageId"

typedef enum {
	DMAsyncImageSizeThumbnail	= 1,
	DMAsyncImageSizeRegular		= 2,
	DMAsyncImageSizeLarge		= 3
} eDMAsyncImageSize;

@interface DMAsyncImageView : UIImageView <NSURLConnectionDelegate> {
    
}

@property (nonatomic, strong) NSString	*imageId;
@property (nonatomic, strong) NSString	*imageUrl;
@property (nonatomic, strong) NSString	*imageIdKey;
@property (nonatomic, assign) int imageSize;

@end
