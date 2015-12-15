//
//  HistoryTrendViewController.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-22.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "HistoryTrendViewController.h"
#import "GlobleObject.h"
#import "TrendView.h"

@interface HistoryTrendViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *loadState;

@end

@implementation HistoryTrendViewController

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self.navigationBarImageView setImage:[[UIImage imageNamed:@"v2-navigationbar-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(63, 5, 63, 5)]];
    
    
	// Do any additional setup after loading the view.
    self.updateTimeLabel.text = [GlobleObject getInstance].updateTimeForChineseRate;
    self.flagImgView.layer.masksToBounds = YES;
    self.flagImgView.layer.cornerRadius = 4;
    NSArray *currentChineseRates = [GlobleObject getInstance].currentChineseRates;
    NSInteger totalPage = currentChineseRates.count;
    
    CGSize size = self.scrollView.bounds.size;
    self.scrollView.contentSize = CGSizeMake(size.width * totalPage, size.height);
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = self.currentPageIndex;
    self.scrollView.contentOffset = CGPointMake(self.currentPageIndex * size.width, 0.f);
    self.scrollView.delegate = self;
    
    self.loadState = [[NSMutableArray alloc] initWithCapacity:totalPage];
    for (int i = 0; i != totalPage; ++i)
        [self.loadState addObject:[NSNumber numberWithBool:NO]];
    if (self.currentPageIndex > 0)
        [self loadPageWithIndex:self.currentPageIndex - 1];
    
    if (self.currentPageIndex < totalPage - 1)
        [self loadPageWithIndex:self.currentPageIndex + 1];
    
    [self loadPageWithIndex:self.currentPageIndex];
}

- (void)loadPageWithIndex:(NSInteger)pageIndex
{
    NSArray *currentChineseRates = [GlobleObject getInstance].currentChineseRates;
    
    
    if (pageIndex >= 0 && pageIndex < currentChineseRates.count)
    {
        //改变标题
        NSString *countryCode = [currentChineseRates objectAtIndex:pageIndex];
        NSString *flageImgPath = [[NSString alloc] initWithFormat:@"s%@.png", countryCode];
        self.flagImgView.image = [UIImage imageNamed:flageImgPath];
        
        NSString *name = [[GlobleObject getInstance].countrysName objectForKey:countryCode];
        NSString *nameString = [NSString stringWithFormat:@"  %@ %@", name, countryCode];
        self.countryNameLabel.text = nameString;
        
        UIImage *img = [UIImage imageNamed:flageImgPath];
        UIImage *countFlag = [img scaleToSize:CGSizeMake(24, 24)];
        [self.titleButton setImage:countFlag forState:UIControlStateNormal];
        [self.titleButton setTitle:nameString forState:UIControlStateNormal];
        [self.titleButton setImage:countFlag forState:UIControlStateHighlighted];
        [self.titleButton setTitle:nameString forState:UIControlStateHighlighted];
        [self.titleButton.imageView.layer setCornerRadius:5.0];
        [self.titleButton.imageView.layer setMasksToBounds:YES];
        
        //如果已经加载过图表
        if ([self.loadState[pageIndex] boolValue]) {
            return;
        }
        
        //加载图表，并标记成已加载
        TrendView *trendView = [[NSBundle mainBundle] loadNibNamed:@"TrendView" owner:self options:nil][0];
        trendView.index = pageIndex;
        trendView.frame = CGRectMake(self.scrollView.frame.size.width * pageIndex, 0.f, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:trendView];
        [trendView loadContent];
        
        self.loadState[pageIndex] = [NSNumber numberWithBool:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePage:(id)sender
{
    UIPageControl *pageControl = sender;
    [self.scrollView setContentOffset:CGPointMake(pageControl.currentPage * self.scrollView.frame.size.width, 0.f) animated:YES];
}

#pragma mark -
#pragma mark UIScrollView Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / DEVICE_WIDTH;
    self.pageControl.currentPage = pageIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page;
    if (scrollView.contentOffset.x <= 160) {
        page = 0;
    }else{
        page = floor((scrollView.contentOffset.x - 160) / pageWidth) + 1;
    }
    
    [self loadPageWithIndex:page - 1];
    [self loadPageWithIndex:page + 1];
    [self loadPageWithIndex:page];
    
    CGFloat offsetx = scrollView.contentOffset.x;
    if (offsetx < scrollView.contentSize.width - DEVICE_WIDTH)
    {
        int x = (int)scrollView.contentOffset.x % ((int)DEVICE_WIDTH);
        int distanceToCenter = fabs(x - 160.f);
        self.flagImgView.alpha = self.countryNameLabel.alpha = distanceToCenter / 160.f;
    }
}
@end
