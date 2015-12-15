//
//  RateNoticeViewController.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-9-23.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "RateNoticeViewController.h"
#import "GlobleObject.h"
#import "MyUtilities.h"
#import "ASIHTTPRequest.h"
#import "NoticeCell.h"
#import "NoticeDetailController.h"
#import "RMStore.h"
#import "MainChineseExchangeRateAppDelegate.h"

static NSInteger rechargeVIPTag = 888;
static NSInteger rechargeSVIPTag = 999;
@interface RateNoticeViewController () <UIAlertViewDelegate, ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIHTTPRequest *getListRequest;

@end

@implementation RateNoticeViewController
{
    BOOL isDataLoaded;
}

- (void)dealloc
{
    [self.getListRequest clearDelegatesAndCancel];
    self.getListRequest = nil;
}

- (IBAction)showMenu
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(id)sender
{
    if (!isDataLoaded)
    {
        [self getNoticeList];
        return;
    }
    
    RMStore *defaultStore = [RMStore defaultStore];
    NSInteger totalNoticeCount = [GlobleObject getInstance].totalNoticeCount;
    
    extern NSInteger firstLevelNoticeCount, secondLevelNoticeCount, thirdLevelNoticeCount;
    
//    BOOL isSuperVIP = [defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE] || [defaultStore isPurchasedForIdentifier:SUPERVIP_PURCHASE];
//    BOOL isVIP = [defaultStore isPurchasedForIdentifier:VIP_PURCHASE];
//    
//
    
    if (totalNoticeCount >= thirdLevelNoticeCount)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提醒条数已达到上限，您不能再添加更多提醒了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (totalNoticeCount >= firstLevelNoticeCount)
    {
        BOOL isVIP = [defaultStore isPurchasedForIdentifier:VIP_PURCHASE];
        BOOL updateVIP = [defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE];
        BOOL superVIP = [defaultStore isPurchasedForIdentifier:SUPERVIP_PURCHASE] || [defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE];
        
        BOOL isVIPorSuperVIP = (isVIP && updateVIP) || superVIP;
        
        if (!isVIPorSuperVIP)//如果不是VIP
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"普通用户只能添加3条提醒，想要添加更多提醒，请购买VIP或者超级VIP，VIP可以添加20条提醒，超级VIP没有限制" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"购买VIP", @"购买超级VIP", nil];
            alert.tag = rechargeVIPTag;
            [alert show];
            return;
        }
    }
//    DLog(@"%d", secondLevelNoticeCount);
    if (totalNoticeCount >= secondLevelNoticeCount)
    {
        BOOL isVVVVIP = [defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE] || [defaultStore isPurchasedForIdentifier:SUPERVIP_PURCHASE];
        if (!isVVVVIP)//如果不是超级VIP
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"VIP用户只能添加20条提醒，想要添加更多提醒，请购买超级VIP" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"充值", nil];
            alert.tag = rechargeSVIPTag;
            [alert show];
            return;
        }
    }
    
//    UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    NSLog(@"--->%@",navigationController.viewControllers[0]);
    
    [self performSegueWithIdentifier:@"NoticeRate" sender:nil];
}

#pragma mark UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == rechargeVIPTag)
        {
            if (buttonIndex == 1)
                [self addPayment:VIP_PURCHASE];
            else
                [self addPayment:SUPERVIP_PURCHASE];
        }
        else if (alertView.tag == rechargeSVIPTag)
        {
            [self addPayment:UPDATE_PURCHASE];
        }
    }
}



- (void)addPayment:(NSString *)productIdentifier
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UIWindow *window = [(MainChineseExchangeRateAppDelegate *)[UIApplication sharedApplication].delegate window];
    
    UIView *view = [[UIView alloc] initWithFrame:window.bounds];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = view.center;
    [view addSubview:indicatorView];
    [window addSubview:view];
    [indicatorView startAnimating];
    [[RMStore defaultStore] addPayment:productIdentifier success:^(SKPaymentTransaction *transaction) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [view removeFromSuperview];
        UINavigationController *navigationController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [(navigationController.viewControllers)[0] performSegueWithIdentifier:@"NoticeRate" sender:nil];
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [view removeFromSuperview];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"购买失败", @"")
                                                           message:error.localizedDescription
                                                          delegate:nil
                                                 cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                                 otherButtonTitles:nil];
        [alerView show];
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.table.layer.masksToBounds = YES;
//    self.table.layer.cornerRadius = 10.0f;
    
    //初始化view
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.showMenuButton setImage:[UIImage imageNamed:@"v2-return-normal.png"] forState:UIControlStateNormal];
    [self.showMenuButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, 0)];
    [self.showMenuButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
//    
//    [self.addButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"top-add-icon-normal.png"] forState:UIControlStateNormal];
//    [self.addButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"top-add-icon-active.png"] forState:UIControlStateHighlighted];
    
    _datas = [[NSMutableArray alloc] init];
    
    [self getNoticeList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoticeList) name:@"RateNoticeDidUpdate" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.myBgImg = nil;
    self.showMenuButton = nil;
}

- (void)getNoticeList
{
    GlobleObject *globleObject = [GlobleObject getInstance];
    if (globleObject.notices)
    {
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:globleObject.notices];

        isDataLoaded = YES;
        [self.table reloadData];
    }
    else
    {
        [self getNoticeListFromWeb];
    }
}

- (void)getNoticeListFromWeb
{
    NSString *deviceToken = [MyUtilities deviceToken];
    if (deviceToken) {
        NSString *path = [NSString stringWithFormat:@"%@%@", NOTICE_URL, deviceToken];
        NSURL *url = [NSURL URLWithString:path];
        self.getListRequest = [ASIHTTPRequest requestWithURL:url];
        
        self.getListRequest.delegate = self;
        [self.getListRequest startAsynchronous];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CenterNoticeCellIdentifier"];
    
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remind-list-background.png"]];
    
    //    Notice *notice = [[Notice alloc] initWithCheckItem:rowData[@"checkitem"] compareType:rowData[@"comparetype"] countryCode:rowData[@"countrycode"] ringrate:rowData[@"ringrate"]];
    NSDictionary *rowData = [self.datas objectAtIndex:indexPath.row];

    Notice *notice = [[Notice alloc] initWithCheckItem:rowData[@"checkitem"]
                                           compareType:rowData[@"comparetype"]
                                           countryCode:rowData[@"countrycode"]
                                              ringrate:rowData[@"ringrate"]];
    notice.noticeId = rowData[@"id"];
    cell.notice = notice;
    
    
//    NSString *countryCode = rowData[@"countrycode"];
//    NSString *text = [NSString stringWithFormat:@"%@%@%@%@", countryCode, rowData[@"checkitem"], rowData[@"comparetype"], rowData[@"ringrate"]];
//    cell.textLabel.text = text;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark UITableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoticeCell *cell = (NoticeCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"NoticeRate" sender:cell.notice];
    
    //    //点添加按钮时，发送通知，主界面接收通知，跳转到相应页面
//    NSDictionary *notice = [self.datas objectAtIndex:indexPath.row];
    
    
//    self.selectedIndexPath = indexPath;
//    self.tempNotice = [notice copy];
//    [self resetNoticeView];
//    [self.scrollView setContentOffset:CGPointMake(240.f, 0.f) animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NoticeDetailController *controller = segue.destinationViewController;
    controller.parentController = self;
    controller.notice = sender;
}

#pragma mark ASIHttpRequest Delegate Methods
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [MyUtilities showMessage:@"获取提醒列表失败" withTitle:@"提示"];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSString *responseString = request.responseString;

    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NULL error:&error];
    
    if (![result[@"isok"] boolValue])//获取数据成功
    {
        isDataLoaded = YES;
        [self.datas removeAllObjects];
        NSArray *datas = result[@"msg"];
        GlobleObject *globle = [GlobleObject getInstance];
        globle.totalNoticeCount = datas.count;
        globle.notices = datas;
        
        [self.datas addObjectsFromArray:datas];
        [self.table reloadData];
    }
    else
    {
        [MyUtilities showMessage:@"获取提醒列表失败" withTitle:@"提示"];
    }
}

- (void)writeNoticeWith
{
    
}
@end
