//
//  DMAsyncImageView.m
//  DomobAdWallCoreSDK
//
//  Created by wangxijin on 13-11-22.
//  Copyright (c) 2013年 domob. All rights reserved.
//

#import "DMAsyncImageView.h"

@interface DMAsyncImageView ()

@property (nonatomic, strong) NSURLConnection			*connection;
@property (nonatomic, strong) NSMutableData				*data;
@property (nonatomic, strong) UIActivityIndicatorView	*spinner;
@property (nonatomic, strong) NSString					*filePath;
@property (nonatomic, strong) NSString					*imageType;

@property (nonatomic, assign) BOOL	isInResuableCell;

@end

@implementation DMAsyncImageView

@synthesize imageId, imageUrl, imageIdKey, imageSize;
@synthesize connection, data, spinner, filePath, imageType, isInResuableCell;


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
	return self;
}

- (void)setup {
    
	self.imageType = @"";
	self.imageSize = DMAsyncImageSizeThumbnail;
	
	self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.frame = self.frame;
	spinner.center = self.center;
	spinner.hidesWhenStopped = TRUE;
}

- (void)setImageSize:(int)aSize {
	self.filePath = nil;
	imageSize = aSize;
}

- (void)setImageId:(NSString *)anId {
	
    [imageId release];
	imageId = [anId copy];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:[self filePath]]) {
		// if we know the image extention, and we're not resuing the imageview in a cell, take advantage of iOS image caching
		if ([imageType length] && !isInResuableCell) {
			self.image = [[UIImage alloc] initWithContentsOfFile:[self filePath]];
		} else {
			self.image = [UIImage imageWithContentsOfFile:[self filePath]];
		}
        
		[self setNeedsDisplay];
	} else {
		[self downloadImage];
	}
}

- (void)setImageUrl:(NSString *)url {
    
    [connection cancel];
	if (!url) {
		self.isInResuableCell = TRUE;
		imageId = nil;
		imageUrl = nil;
		self.filePath = nil;
		return;
	}
    
	imageUrl = url;
	
	NSArray *urlParts = [url componentsSeparatedByString:@"?"];
	
	if ([urlParts count] < 2) {
		[self processFullPathURL];
	} else {
		[self processQueryURL:[urlParts objectAtIndex:1]];
	}
}

- (void)processFullPathURL {
	NSArray *pathParts = [imageUrl componentsSeparatedByString:@"/"];
	NSString *filePart = [pathParts lastObject];
	NSArray *fileParts = [filePart componentsSeparatedByString:@"."];
	
	if ([fileParts count] == 2) {
		self.imageType = [fileParts objectAtIndex:1];
	}
    
	self.imageId = [fileParts objectAtIndex:0];
}

- (void)processQueryURL:(NSString*)query {
    
	// if the imageIdKey was not supplied, we can try a generic "imageId" key
	if (!imageIdKey || [imageIdKey length] == 0) {
		self.imageIdKey = defaultDMImageIdKey;
	}
	
	NSArray *queryParts = [query componentsSeparatedByString:@"&"];
	for (NSString *param in queryParts) {
		if ([param hasPrefix:[NSString stringWithFormat:@"%@=", imageIdKey]]) {
			NSArray *paramParts = [param componentsSeparatedByString:@"="];
			if ([paramParts count] == 2) {
				self.imageId = [paramParts objectAtIndex:1];
			}
		}
	}
    
	// couldn't generate an imageId, so can't cache, so download every time
	if (!imageId) {
		[self downloadImage];
	}
}

- (void)downloadImage {
	[self.superview addSubview:spinner];
	[spinner startAnimating];
    
	self.data = [NSMutableData data];
	NSURL *url = [NSURL URLWithString:imageUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (!data) self.data = [NSMutableData data];
    [data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	NSString *url = theConnection.currentRequest.URL.absoluteString;
	NSString *msg = [NSString stringWithFormat:@"Domob Error:\n%@\n\nWith this url:\n%@", [error description], url];
    NSLog(@"%@", msg);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	[spinner stopAnimating];
	self.connection = nil;
	
	if ([theConnection.currentRequest.URL.absoluteString isEqualToString:imageUrl]) {
		self.image = [UIImage imageWithData:data];;
		[self setNeedsLayout];
		
		if ([imageId length] > 0) [data writeToFile:[self filePath] atomically:TRUE];
	}
    
	self.data = nil;
}

- (NSString*)fileName {
    
	if (!imageId) return @"";
	
	if (imageSize == DMAsyncImageSizeThumbnail) return [NSString stringWithFormat:@"thumb_%@%@%@", imageId, ([imageType length])? @"." : @"", imageType];
	if (imageSize == DMAsyncImageSizeRegular)	return [NSString stringWithFormat:@"small_%@%@%@", imageId, ([imageType length])? @"." : @"", imageType];
	if (imageSize == DMAsyncImageSizeLarge)		return [NSString stringWithFormat:@"large_%@%@%@", imageId, ([imageType length])? @"." : @"", imageType];
    
	return @"";
}

- (NSString*)filePath {
    
	if (!filePath) {
		NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		self.filePath = [imageCachePath stringByAppendingPathComponent:[self fileName]];
	}
	return filePath;
}

- (void)dealloc {
    
    [connection cancel];
    [super dealloc];
}

@end
