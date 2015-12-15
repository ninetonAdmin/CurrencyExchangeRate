//
//  NineTonPlugAdView.m
//  AdAnimationDemo
//
//  Created by admin on 14/12/29.
//  Copyright (c) 2014年 youloft. All rights reserved.
//

#import "NineTonPlugAdView.h"
#import "UIImageView+WebCache.h"

@interface NineTonPlugAdView ()<UIWebViewDelegate, UIScrollViewDelegate>
{
    CGRect originPlugAdFrame;
    CGRect originScrollFrame;
    CGRect originCancelFrame;
    CGRect originLookFrame;
    CGRect originPageControlFrame;
    CGRect originToolBarFrame;
    NSInteger currentIndex;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSArray *adDataSourse;
//@property (nonatomic, strong) NSString *setupUrl;
//@property (nonatomic, assign) BOOL setupFlag;

@end

@implementation NineTonPlugAdView

#pragma mark - Init
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    if (self = [super init]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"NineTonPlugAdView_iPad" owner:self options:nil] objectAtIndex:0];
        }else{
            self = [[[NSBundle mainBundle] loadNibNamed:@"NineTonPlugAdView" owner:self options:nil] objectAtIndex:0];
        }
        for (UIView *view in self.subviews) {
            [view setFrame:CGRectMake(0, 0, 1, 1)];
        }
        [self setAdUserInteraction:NO];
        currentIndex = 0;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [_webView setDelegate:self];
        [self setHidden:YES];
        
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"NineTonPlugAdView_iPad" owner:self options:nil] objectAtIndex:0];
        }else{
            self = [[[NSBundle mainBundle] loadNibNamed:@"NineTonPlugAdView" owner:self options:nil] objectAtIndex:0];
        }
        [self setFrame:frame];
        for (UIView *view in self.subviews) {
            [view setFrame:CGRectMake(0, 0, 1, 1)];
        }
        [self setAdUserInteraction:NO];
        currentIndex = 0;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [_webView setDelegate:self];
        [self setHidden:YES];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib
{
    [super awakeFromNib];
    originPlugAdFrame = self.frame;
    originScrollFrame = _adScrollView.frame;
    originCancelFrame = _cancelButton.frame;
    originLookFrame = _lookButton.frame;
    originPageControlFrame = _pageControl.frame;
    originToolBarFrame = _toolBar.frame;
    [self.layer setCornerRadius:10.0f];
    [self.layer setMasksToBounds:YES];
}

- (void)prepareLoadAdDataSourse:(NSArray *)array
{
    self.adDataSourse = [NSArray arrayWithArray:array];
    [_pageControl setNumberOfPages:_adDataSourse.count];
    [_pageControl setCurrentPage:0];
    __block NineTonPlugAdView *safeSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = _adDataSourse[idx];
        [safeSelf setupAdImageViewWithTag:idx andImageUrl:[safeSelf handleUrl:[dic objectForKey:@"appimg"]]];
    }];
}

- (void)setupAdImageViewWithTag:(NSInteger)index andImageUrl:(NSURL *)url
{
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(index * _adScrollView.frame.size.width, 0, _adScrollView.frame.size.width, _adScrollView.frame.size.height)];
    [imageview setTag:index];
    [imageview setUserInteractionEnabled:YES];
    if (index != 0) {
        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:nil]];
    }else{
        //__block NineTonPlugAdView *safeSelf = self;
        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:nil] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //[safeSelf adWillAppear];
        }];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdImageRecognzier:)];
    [imageview addGestureRecognizer:tap];
    [_adScrollView addSubview:imageview];
    [_adScrollView setContentSize:CGSizeMake(originScrollFrame.size.width * (index + 1), 0)];
}


- (NSURL *)handleUrl:(id)url
{
    NSURL *requestUrl;
    if ([url isKindOfClass:[NSString class]]) {
        requestUrl = [NSURL URLWithString:url];
    }else if([url isKindOfClass:[NSURL class]]){
        requestUrl = url;
    }else{
        return nil;
    }
    return requestUrl;
}

- (void)tapAdImageRecognzier:(id)sender
{
    [self submitButtonDidClicked:nil];
}

- (IBAction)submitButtonDidClicked:(id)sender
{
    NSDictionary *dic = [_adDataSourse objectAtIndex:currentIndex];
    NSString *url = [dic objectForKey:@"appurl"];
    if (url == nil || [url isEqualToString:@""] || [url isKindOfClass:[NSNull class]]) {
    }else{
        [self loadRequestWithLink:url];
    }
    [self adWillDisAppear];
}

- (void)loadRequestWithLink:(NSString *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL URLWithString:url]]];
}

- (IBAction)nexttimeButtonDidClicked:(id)sender
{
    [self adWillDisAppear];
}

- (void)adWillAppear
{
    [self setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [self showAdWithFlag:YES];
    } completion:^(BOOL finished) {
        [self setAdUserInteraction:YES];
    }];
}

- (void)adWillDisAppear
{
    [UIView animateWithDuration:0.5f animations:^{
        [self showAdWithFlag:NO];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self setAdUserInteraction:NO];
        self.didDismissEvent();
    }];
}

- (void)execAdDisAppear
{
    [UIView animateWithDuration:0.5f animations:^{
        [self showAdWithFlag:NO];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self setAdUserInteraction:NO];
    }];
}

- (void)showAdWithFlag:(BOOL)flag
{
    UIView *superView = self.superview;
    if (flag == YES) {
        [self setFrame:CGRectMake(superView.center.x - originPlugAdFrame.size.width/2, superView.center.y - originPlugAdFrame.size.height/2, originPlugAdFrame.size.width, originPlugAdFrame.size.height)];
        [_adScrollView setFrame:originScrollFrame];
        [_toolBar setFrame:originToolBarFrame];
        [_pageControl setFrame:originPageControlFrame];
        [_cancelButton setFrame:originCancelFrame];
        [_lookButton setFrame:originLookFrame];
        for (UIView *view in _adScrollView.subviews) {
            [view setFrame:CGRectMake(view.tag * _adScrollView.frame.size.width, 0, _adScrollView.frame.size.width, _adScrollView.frame.size.height)];
        }
        self.willShowAnimationBlock();
    }else{
        [self setFrame:CGRectMake(superView.center.x, superView.center.y, 1, 1)];
        [_adScrollView setFrame:CGRectMake(0, 0, 1, 1)];
        [_toolBar setFrame:CGRectMake(0, 0, 1, 1)];
        [_pageControl setFrame:CGRectMake(0, 0, 1, 1)];
        [_cancelButton setFrame:CGRectMake(0, 0, 1, 1)];
        [_lookButton setFrame:CGRectMake(0, 0, 1, 1)];
        for (UIView *view in _adScrollView.subviews) {
            [view setFrame:CGRectMake(view.tag * _adScrollView.frame.size.width, 0, _adScrollView.frame.size.width, _adScrollView.frame.size.height)];
        }
        self.willDismissAnimationBlock();
    }
}


- (void)setShowAnimationBlock:(void(^)(void))animationBlock
{
    _willShowAnimationBlock = [animationBlock copy];
}


- (void)setDismissAnimationBlock:(void(^)(void))animationBlock
{
    _willDismissAnimationBlock = [animationBlock copy];
}

- (void)setDidDismissEventBlock:(void (^)(void))dismissEvent
{
    _didDismissEvent = [dismissEvent copy];
}


- (void)setAdUserInteraction:(BOOL)flag
{
    [_adScrollView setUserInteractionEnabled:flag];
    [_cancelButton setUserInteractionEnabled:flag];
    [_lookButton setUserInteractionEnabled:flag];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor(offset.x/pageWidth);
    currentIndex = page;
    [_pageControl setCurrentPage:page];
}


#pragma mark - UIWebViewDelegate

-(BOOL)isStoreUrl:(NSString*)url {
    return ([url hasPrefix:@"https://itunes.apple.com"] || [url hasPrefix:@"http://itunes.apple.com"]);
}

-(NSString*) iTunesIdViaUrlStr:(NSString*)urlStr {
    NSAssert(([urlStr hasPrefix:@"https://itunes.apple"] || [urlStr hasPrefix:@"http://itunes.apple"]), @"Parameter should be a valid store link");
    NSString *result = nil;
    @try {
        NSRange begin = [urlStr rangeOfString:@"/id"];
        NSRange end = [urlStr rangeOfString:@"?" options:NSBackwardsSearch];
        if (0 == end.length || end.location < begin.location) {
            end.location = [urlStr length];
        }
        NSInteger index = begin.location+begin.length;
        NSInteger len = end.location-(begin.location+begin.length);
        result = [urlStr substringWithRange:NSMakeRange(index,len)];
        
    }
    @catch (NSException *exception) {
        result = nil;
    }
    return result;
}

- (BOOL)isSetupPackageUrl:(NSString *)url
{
    if ([url hasPrefix:@"itms-services://"] || [url hasPrefix:@"itms-service://"]) {
        return YES;
    }
    return NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url1=[[request URL] absoluteString];
    if([self isStoreUrl:url1]){
        NSString *itunesId=[self iTunesIdViaUrlStr:url1];
        if (itunesId) {
            self.appId = itunesId;
            if ([self.delegate respondsToSelector:@selector(getiTunesAppId:)]) {
                [self.delegate getiTunesAppId:self.appId];
            }
            return NO;
        }
    }
    if ([self isSetupPackageUrl:url1]) {
        return YES;
//        self.setupUrl = url1;
//        if (self.setupFlag == YES) {
//            return YES;
//        }else{
//            return NO;
//        }
    }
    return YES;
}


@end
