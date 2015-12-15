//
//  YLDomobWallViewController.m
//  CalendarOS7
//
//  Created by jason luo on 1/4/14.
//  Copyright (c) 2014 YouLoft. All rights reserved.
//

#import "YLDomobWallViewController.h"
#import "DMAdViewCell.h"
#import "MyUtilities.h"
#import "AppUtility.h"
@interface YLDomobWallViewController ()

@end

@implementation YLDomobWallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    _manager.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _manager = [[DMAdWallDataManager alloc] initWithPublisherId:PUBLISHER_ID placementId:PLACEMENT_ID rootViewController:self.navigationController];
    _manager.delegate = self;

    
    [self initUI];
    
    // 发送显示广告界面
    [_manager sendActivityReport:kActivityEnterReport];
    BOOL shouldReload = NO;
    // 超时后重新请求广告
    double timeOutInterval = [_controlInfo.timeOutInterval longLongValue];
    if (_lastRequestTime>0&&timeOutInterval>0) {
        if (([[NSDate date] timeIntervalSince1970]-_lastRequestTime)*1000>timeOutInterval) {
            shouldReload = YES;
        }
    }
    // 广告列表无数据时也重新请求广告
    if (_adArray.count==0) {
        shouldReload = YES;
    }
    if (shouldReload) {
        _lastRequestTime = [[NSDate date] timeIntervalSince1970];
        [_manager requsetAdData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self updateTableViewLayout];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)showMoreAd {
    //    NSInteger pageSize = [_controlInfo.adListNumber integerValue];
    //    _adCount = (_adCount+pageSize)<_adArray.count?(_adCount+pageSize):_adArray.count;
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initUI {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = nil;
        //        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
        _moreLabel.text = @"更多";
        _moreLabel.textColor = [UIColor blackColor];
        _moreLabel.textAlignment = NSTextAlignmentCenter;
        _moreLabel.font = [UIFont systemFontOfSize:14];
    }
    
    _mLoadingWaitView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mLoadingWaitView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    _mLoadingWaitView.autoresizesSubviews = YES;
    _mLoadingWaitView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _mLoadingStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-300)/2, 210, 300, 21)];
    _mLoadingStatusLabel.backgroundColor = [UIColor clearColor];
    _mLoadingStatusLabel.textColor = [UIColor colorWithRed:0.162959 green:0.159827 blue:0.159899 alpha:1];
    _mLoadingStatusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    _mLoadingStatusLabel.text = @"加载数据中...";
    _mLoadingStatusLabel.textAlignment = NSTextAlignmentCenter;
    _mLoadingStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_mLoadingWaitView addSubview:_mLoadingStatusLabel];
    
    _mLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _mLoadingActivityIndicator.backgroundColor = [UIColor clearColor];
    if ([_mLoadingActivityIndicator respondsToSelector:@selector(color)]) {
        _mLoadingActivityIndicator.color=[UIColor darkGrayColor];
    }
    _mLoadingActivityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mLoadingActivityIndicator.frame = CGRectMake((self.view.bounds.size.width-30)/2, 170, 30, 30);
    [_mLoadingWaitView addSubview:_mLoadingActivityIndicator];
    
    [_mLoadingActivityIndicator startAnimating];
    
    [self.view insertSubview:_mLoadingWaitView aboveSubview:_tableView];
    
    //load the menu button
    CGFloat systemMajorVersion = DeviceSystemMajorVersion();
    CGRect frame;
    if (systemMajorVersion >= 7.0)
        frame = CGRectMake(6.f, 26.f, 35.f, 30.f);
    else
        frame = CGRectMake(6.f, 6.f, 35.f, 30.f);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) initData {
    _adArray = [[NSMutableArray alloc] init];
    _controlInfo = [[DMAWConrtolInfo alloc] init];
    _reportedAdIdDic = [[NSMutableDictionary alloc] init];
}

- (id)initWithPublisherId:(NSString *)publisherId placementId:(NSString *)placementId parentViewController:(UIViewController*)pvc {
    self = [super init];
    if (self) {
//        _manager = [[DMAdWallDataManager alloc] initWithPublisherId:publisherId placementId:placementId rootViewController:pvc];
//        _manager.delegate = self;
        
        [self initData];
    }
    return self;
}

- (void) sendCloseReport {
    [_manager sendActivityReport:kActivityExitReport];
}

-(void) updateTableViewLayout {
    _tableView.frame = self.view.bounds;
}

#pragma mark - DMAdWallDataManagerDelegate
/**
 *  推广墙请求广告信息成功后，回调该方法
 *
 *  @param manager     DMAdWallDataManager
 *  @param adList      NSArray
 *  @param controlInfo DMAWConrtolInfo
 *  @param bannerList  NSArray
 *  @param extendList  NSArray
 */

- (void)removeLoadingMaskView {
    
    if ([_mLoadingWaitView superview])
    {
        [_mLoadingWaitView removeFromSuperview];
    }
}

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
           didReceiveAdList:(NSArray *)adList
                controlInfo:(DMAWConrtolInfo *)controlInfo
                 bannerList:(NSArray *)bannerList
                 extendList:(NSArray *)extendList {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //    _mLoadingActivityIndicator.hidden = YES;
    [self removeLoadingMaskView];
    
    if (!_mNoNetworkImageView)
    {
        UIImage *image = [UIImage imageFromMainBundleFile:@"um_no_network.png"];
        CGSize imageSize = image.size;
        _mNoNetworkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_mLoadingWaitView.bounds.size.width - imageSize.width) / 2, 80, imageSize.width, imageSize.height)];
        _mNoNetworkImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _mNoNetworkImageView.image = image;
    }
    
    if (![_mNoNetworkImageView superview])
    {
        [_mLoadingWaitView addSubview:_mNoNetworkImageView];
    }
    
    _mLoadingStatusLabel.text = @"抱歉，网络连接不畅，请稍后再试！";
    
    _adArray = [NSMutableArray array];
    _controlInfo = controlInfo;
    //请求成功后重新发送广告的展现报告
    [_reportedAdIdDic removeAllObjects];
    
    for (int i = 0; i<adList.count; i++) {
        DMAWAdInfo *adInfo = [adList objectAtIndex:i];
        if (self.wallCategory == DMWallCategoryAll) {
            [_adArray addObject:adInfo];
        }
        else if ([adInfo.type integerValue]== self.wallCategory) {
            [_adArray addObject:adInfo];
        }
    }
    //    NSInteger pageSize = [_controlInfo.adListNumber integerValue];
    //    _adCount = _adArray.count>pageSize?pageSize:_adArray.count;
    
    [_tableView reloadData];
}

/**
 *  推广墙请求广告信息失败后，回调该方法
 *
 *  @param manager DMAdWallDataManager
 *  @param error   NSError
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
        requestAdDataFailed:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
//    [_adArray removeAllObjects];
    //    _adCount = 0;
    
//    [_tableView reloadData];
}

/**
 *  推广墙搜索广告成功后，回调该方法;当没有搜索到广告时，返回recommandList
 *
 *  @param manager DMAdWallDataManager
 *  @param adList  NSArray
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
   didReceiveSearchedAdList:(NSArray *)adList
              recommandList:(NSArray *)recommandList {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}
/**
 *  推广墙搜索广告失败后，回调该方法
 *
 *  @param manager DMAdWallDataManager
 *  @param error   NSError
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
         searchAdListFailed:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

/**
 *  推广墙请求搜索热词成功后，回调该方法
 *
 *  @param manager DMAdWallDataManager
 *  @param hotWord DMAWHotWord
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
     didReceiveHotWordArray:(NSArray *)hotWordArray {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
/**
 *  推广墙请求搜索热词失败后，回调该方法
 *
 *  @param manager DMAdWallDataManager
 *  @param error   NSError
 */
- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager
       requestHotWordFailed:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark -


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return (_adCount<_adArray.count?(_adCount+1):_adArray.count);
    return _adArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return (_adCount==indexPath.row)?44:70;
    return 70;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *adCellIndetifier = @"adCellIdentifier";
    static NSString *adCellFootButtonIndetifier = @"adCellFootButtonIdentifier";
    BOOL isFootCell = NO;
    DMAWAdInfo *adInfo = nil;
    //    if (NO) {
    //        isFootCell = YES;
    //    }
    //    else {
    adInfo = [_adArray objectAtIndex:indexPath.row];
    //    }
    if (isFootCell) {
        UITableViewCell *footCell = [tableView dequeueReusableCellWithIdentifier:adCellFootButtonIndetifier];
        if (!footCell)
        {
            footCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:adCellFootButtonIndetifier];
        }
        for (UIView *aView in footCell.subviews) {
            if ([aView isEqual:_moreLabel]) {
                [aView removeFromSuperview];
            }
        }
        [footCell addSubview:_moreLabel];
        [self showMoreAd];
        return footCell;
    }
    //发送展现报告
    if (adInfo.adId) {
        if (![_reportedAdIdDic objectForKey:adInfo.adId]) {
            adInfo.position = [NSNumber numberWithInteger:indexPath.row+1];
            [_manager sendImpressionReportWithAdList:[NSArray arrayWithObject:adInfo]];
            [_reportedAdIdDic setObject:adInfo.adId forKey:adInfo.adId];
        }
    }
    DMAdViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adCellIndetifier];
    if (!cell) {
        cell = [[DMAdViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:adCellIndetifier];
    }
    DMAsyncImageView *iconImageView = [[DMAsyncImageView alloc] initWithFrame:cell.iconImageView.frame];
    iconImageView.image = nil;//[UIImage imageNamed:@"defaultIcon.png"];
    cell.iconImageView = iconImageView;
    
    cell.iconImageView.layer.cornerRadius = 10;
    cell.iconImageView.clipsToBounds = YES;
    cell.iconImageView.imageUrl = adInfo.logoUrl;
    cell.titleLabel.text = adInfo.title;
    //    NSNumber *appKb = adInfo.size;
    //    if (appKb&&[appKb longLongValue]>0) {
    //        cell.sizeLabel.text = [NSString stringWithFormat:@"%.2fM",[appKb longLongValue]/(1024.f*1024)];
    //    }
    cell.detailLabel.text = adInfo.text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isFootCell = NO;
    DMAWAdInfo *adInfo = nil;
    //    if (_adCount==indexPath.row) {
    //        isFootCell = YES;
    //    }
    //    else {
    adInfo = [_adArray objectAtIndex:indexPath.row];
    //    }
    if (isFootCell) {
        [self showMoreAd];
    }
    else {
//        NSMutableDictionary *promData = [NSMutableDictionary dictionary];
//        if (adInfo.itunesId) {
//            [promData setObject:adInfo.itunesId forKey:@"app_store_id"];
//        }
//        if (adInfo.title) {
//            [promData setObject:adInfo.title forKey:@"title"];
//        }
//        if (adInfo.provider) {
//            [promData setObject:[NSString stringWithFormat:@"DM_%@",adInfo.provider] forKey:@"provider"];
//        }
//        else {
//            [promData setObject:@"DM_" forKey:@"provider"];
//        }
//        if (adInfo.identifier) {
//            [promData setObject:adInfo.identifier forKey:@"bundle_identifier"];
//        }
//        if (adInfo.actionUrl) {
//            [promData setObject:adInfo.actionUrl forKey:@"url"];
//        }
        //        [StatisticHelper postClickInfoByPromoterData:promData];
        [_manager onClickAdItemWithInfo:adInfo type:kDMAWClickTypeListItem position:indexPath.row];
    }
}

#pragma mark -


@end
