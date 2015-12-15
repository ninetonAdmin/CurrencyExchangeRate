//
//  RingBoxViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-20.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "RingBoxViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "NoticeCell.h"
#import "MyUtilities.h"
#import "ASIFormDataRequest.h"
#import "RMStore.h"
#import "MainChineseExchangeRateAppDelegate.h"

NSInteger firstLevelNoticeCount = 3;
NSInteger secondLevelNoticeCount = 10;
NSInteger thirdLevelNoticeCount = 20;


static NSInteger rechargeVIPTag = 888;
static NSInteger rechargeSVIPTag = 999;

@interface RingBoxViewController () <UIGestureRecognizerDelegate, ASIHTTPRequestDelegate>
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) ASIHTTPRequest *getListRequest;
@property (nonatomic, strong) ASIFormDataRequest *addNoticeRequest;
@end

@implementation RingBoxViewController
{
    BOOL isDataLoaded;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.getListRequest clearDelegatesAndCancel];
    [self.addNoticeRequest clearDelegatesAndCancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.clipView.clipsToBounds = YES;
//    self.clipView.layer.masksToBounds = YES;
//    self.clipView.layer.cornerRadius = 10;
//    
//    self.noticeView.layer.cornerRadius = 10;
//    self.scrollView.contentSize = CGSizeMake(480.f, 0.f);
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.layer.cornerRadius = 10.f;
    
    UIImage *bgImage = [UIImage imageNamed:@"v2-exchange-box-background.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
    self.bgImageView.image = bgImage;
    self.bgImageView1.image = bgImage;
    
    UIImage *backIconNormal = [UIImage imageNamed:@"back-button-icon-normal.png"];
    UIImage *backIconHighlighted = [UIImage imageNamed:@"back-button-icon-active.png"];
    
    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton setImage:backIconNormal forState:UIControlStateNormal];
    [self.backButton setImage:backIconHighlighted forState:UIControlStateHighlighted];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    [self.cancelButton setImage:backIconNormal forState:UIControlStateNormal];
    [self.cancelButton setImage:backIconHighlighted forState:UIControlStateHighlighted];
    
    
    self.flagImgView.layer.masksToBounds = YES;
    self.flagImgView.layer.cornerRadius = 10;
    self.otherFlagImgView.layer.masksToBounds = YES;
    self.otherFlagImgView.layer.cornerRadius = 10;
    NSString *flageImgPath = [[NSString alloc] initWithFormat:@"s%@.png", self.countryCode];
    self.flagImgView.image = [UIImage imageNamed:flageImgPath];
    self.otherFlagImgView.image = [UIImage imageNamed:flageImgPath];
    
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"button-background-style04-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"add-remind-icon-normal.png"] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"button-background-style04-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"add-remind-icon-active.png"] forState:UIControlStateHighlighted];
    
    [self.countryCodeLable setText:self.countryCode];
    [self.otherCountryCodeLable setText:self.countryCode];
    NSString *name = [[GlobleObject getInstance].countrysName objectForKey:self.countryCode];
    [self.countryChineseNameLable setText:name];
    [self.otherCountryChineseNameLabel setText:name];
    
    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style04-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style04-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];

    self.fieldView.layer.cornerRadius = 4;
    self.fieldView.layer.borderColor = [UIColor blackColor].CGColor;
    self.fieldView.layer.borderWidth = 1.f;
    
    self.deleteButton.layer.cornerRadius = 4;
    self.deleteButton.layer.borderWidth = 1.f;
    self.deleteButton.layer.borderColor = [UIColor colorWithRed:.99f green:.59f blue:.5f alpha:1.f].CGColor;
//    [self.deleteButton.layer setBorderColor:[UIColor colorWithRed:1.0 green:169.0/255.0 blue:146.0/255.0 alpha:1.0].CGColor];
//    self.deleteButton.layer.borderWidth = 2.0;
//    self.deleteButton.layer.masksToBounds = YES;
//    self.deleteButton.layer.cornerRadius = 5;
//    
//    [self.priceTextField.layer setBorderColor:[UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0].CGColor];
//    self.priceTextField.layer.borderWidth = 2;
//    self.priceTextField.layer.masksToBounds = YES;
//    self.priceTextField.layer.cornerRadius = 5;

    if (DEVICE_HEIGHT == 480.f) {
        self.deleteButton.frame = CGRectMake(14.f, 298.f, 210.f, 40.f);
    }
    
    //相应汇率提醒中添加或者编辑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoticeListFromWeb) name:@"NoticeUpdateNotification" object:nil];
    //定义一个通知，当键盘隐藏时self收到UIKeyboardWillHideNotificaton，调用keboardWillHide:方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //获得设备ios版本
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.0) {//如果时ios5以上
        /*定义一个通知，当键盘高度变化时self收到UIKeyboardWillChangeFrameNotification,调用keyboardWillShow:方法*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    } else {
        /*定义一个通知，当键盘显示的时候self收到UIKeyboardWillShowNotification,调用keyboardWillShow:方法*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    [self initData];
    
    
}

#pragma mark -

#pragma mark Responding to keyboard events
//键盘显示或高度变化时调用
- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.tap)
    {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
        self.tap.delegate = self;
    }
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:self.tap];
    //获取键盘信息
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘的frame信息
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    
    // 获取动画的持续时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 重新定位seachBar,并实现动画效果
    CGFloat coverHeight = 58.f + self.fieldView.frame.size.height + self.fieldView.frame.origin.y + keyboardRect.size.height - screenHeight;
    if (DeviceSystemMajorVersion() < 7)
    {
        coverHeight -= 20.f;
    }
    
    if (coverHeight > -10)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:animationDuration];
        CGRect frame = self.noticeView.frame;
        frame.origin.y -= coverHeight + 10.f;
        self.noticeView.frame = frame;
        [UIView commitAnimations];
        
    }
}

- (void)closeKeyboard
{
    [self.priceField resignFirstResponder];
    if (self.tap)
        [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.tap];
}


//键盘关闭时调用
- (void)keyboardWillHide:(NSNotification *)notification {


    NSDictionary* userInfo = [notification userInfo];
    
    //获取关闭键盘动画持续时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //重新定位seachBar,并实现动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:animationDuration];
    CGRect frame = self.noticeView.frame;
    frame.origin.y = 0.f;
    self.noticeView.frame = frame;
    [UIView commitAnimations];
    
}

- (void)initData
{
//    NSMutableDictionary *dic = [GlobleObject getInstance].noticeRates;
//    _datas = [dic objectForKey:self.countryCode];
//    if (!_datas)
//    {
//        _datas = [[NSMutableArray alloc] init];
//        [dic setObject:_datas forKey:self.countryCode];
//    }
    if (!_datas)
        _datas = [[NSMutableArray alloc] init];
    [self.loadingIndicator startAnimating];
    [self getNoticeList];
}

- (void)getNoticeList
{
    GlobleObject *globleObject = [GlobleObject getInstance];
    if (globleObject.notices)
    {
        [self.datas removeAllObjects];
        for (NSDictionary *data in globleObject.notices)
            if ([data[@"countrycode"] isEqualToString:self.countryCode])//国家相同，加入到数组里
            {
                Notice *notice = [[Notice alloc] initWithCheckItem:data[@"checkitem"] compareType:data[@"comparetype"] countryCode:data[@"countrycode"] ringrate:data[@"ringrate"]];
                notice.noticeId = data[@"id"];
                [self.datas addObject:notice];
            }
        isDataLoaded = YES;
        [self.loadingIndicator stopAnimating];

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
    NSString *path = [NSString stringWithFormat:@"%@%@", NOTICE_URL, deviceToken];
    NSURL *url = [NSURL URLWithString:path];
    self.getListRequest = [ASIHTTPRequest requestWithURL:url];
    
    self.getListRequest.delegate = self;
    [self.getListRequest startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCellIdentifier"];

    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remind-list-background.png"]];
    
//    NSDictionary *rowData = [self.datas objectAtIndex:indexPath.row];
//    Notice *notice = [[Notice alloc] initWithCheckItem:rowData[@"checkitem"] compareType:rowData[@"comparetype"] countryCode:rowData[@"countrycode"] ringrate:rowData[@"ringrate"]];
    cell.notice = [self.datas objectAtIndex:indexPath.row];
    
    
    return cell;
}

#pragma mark UITableView Delegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    //点添加按钮时，发送通知，主界面接收通知，跳转到相应页面
    Notice *notice = [self.datas objectAtIndex:indexPath.row];
    
    self.selectedIndexPath = indexPath;
    self.tempNotice = [notice copy];
    [self resetNoticeView];
    [self.scrollView setContentOffset:CGPointMake(240.f, 0.f) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBgImageView:nil];
    [self setBackButton:nil];
    [self setFlagImgView:nil];
    [self setAddButton:nil];
    [self setClipView:nil];
    [self setCountryChineseNameLable:nil];
    [self setCountryCodeLable:nil];
    [self setDeleteButton:nil];
    self.datas = nil;
    [super viewDidUnload];
}

- (IBAction)backButtonDown {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RingBoxBackButtonClick" object:self];
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
    
    [self turnToAddPage];
}

- (void)turnToAddPage
{
    self.tempNotice = [[Notice alloc] init];
    [self resetNoticeView];
    [self.scrollView setContentOffset:CGPointMake(240.f, 0.f) animated:YES];
}

- (void)resetNoticeView
{
    self.typeSegment.selectedSegmentIndex = self.tempNotice.noticeType;
    self.compareSegment.selectedSegmentIndex = self.tempNotice.compareType;
    if (!self.selectedIndexPath)
        self.deleteButton.hidden = YES;
    else
        self.deleteButton.hidden = NO;
    if (self.tempNotice.price)
    {
        NSString *string = self.tempNotice.price;
        NSRange range = [string rangeOfString:@"."];
        if (range.location != NSNotFound)
            if (string.length > 6)
                string = [string substringToIndex:6];
        self.priceField.text = string;
    }
    else
        self.priceField.text = @"";
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.countryCode];
    NSString *currenyPrice = [contentDic objectForKey:@"xhmr"];
    self.currentLabel.text = currenyPrice;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self closeKeyboard];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    self.selectedIndexPath = nil;
    self.tempNotice = nil;
}

- (IBAction)selectNoticeType:(id)sender
{
//    _haveEdit = YES;
    [self closeKeyboard];
    UISegmentedControl *segment = sender;
    self.tempNotice.noticeType = (int)segment.selectedSegmentIndex;
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.countryCode];
    if (self.tempNotice.noticeType == NoticeTypeSpotExchangeBuy)
    {
        NSString *currenyPrice = [contentDic objectForKey:@"xhmr"];
        self.currentLabel.text = currenyPrice;
    }
    else
    {
        
        NSString *bankofferPrice = [contentDic objectForKey:@"xhmc"];
        self.currentLabel.text = bankofferPrice;
    }
}

- (IBAction)selectCompareType:(id)sender
{
//    _haveEdit = YES;
    [self closeKeyboard];
    UISegmentedControl *segment = sender;
    self.tempNotice.compareType = (int)segment.selectedSegmentIndex;
}

- (IBAction)priceChange:(id)sender
{
//    _haveEdit = YES;
}

- (BOOL)haveEdit
{
    if (!self.selectedIndexPath)
        return YES;
    Notice *notice = [self.datas objectAtIndex:self.selectedIndexPath.row];
    if ([notice isequalToNotice:self.tempNotice])
        return NO;
    return YES;
}

- (IBAction)doneButtonPressed:(id)sender
{
    if (![self checkInput])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入价格！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 666;
        [alert show];
        return;
    }
    [self closeKeyboard];
    self.tempNotice.price = self.priceField.text;
    if (![self haveEdit])
    {
        [self cancelButtonPressed:nil];
        return;
    }
    
//    if (!self.selectedIndexPath)//如果是添加
//    {
//        [self.datas addObject:self.tempNotice];
//    }
//    else
//    {
//        [self.datas replaceObjectAtIndex:self.selectedIndexPath.row withObject:self.tempNotice];
//    }
    
    //去掉无效的提醒，返回YES表示当前编辑的提醒有效
    if ([self validNotice])
    {
        self.doneButton.enabled = NO;
        //请求服务器提醒
        if (!self.selectedIndexPath)
            [self noticeOperate:0];
        else
            [self noticeOperate:1];
    }

    
//    [_table reloadData];
//    [self cancelButtonPressed:nil];
}

//对提醒操作
//参数:新增 0    修改 1    删除 2
- (void)noticeOperate:(NSInteger)operate
{
    NSURL *url = [NSURL URLWithString:@"http://currency.51wnl.com/APIS/PostPushMessage"];
    self.addNoticeRequest = [ASIFormDataRequest requestWithURL:url];
    NSString *deviceToken = [MyUtilities deviceToken];
    [self.addNoticeRequest setPostValue:deviceToken forKey:@"devicetoken"];
    NSString *checkitem = nil;
    if (self.tempNotice.noticeType == NoticeTypeSpotExchangeBuy)
        checkitem = @"xhmr";
    else if (self.tempNotice.noticeType == NoticeTypeSpotExchangeSale)
        checkitem = @"xhmc";
    [self.addNoticeRequest setPostValue:checkitem forKey:@"checkitem"];
    [self.addNoticeRequest setPostValue:self.tempNotice.price forKey:@"ringrate"];
    DLog(@"%d", self.tempNotice.compareType);
    [self.addNoticeRequest setPostValue:[NSNumber numberWithInt:self.tempNotice.compareType] forKey:@"type"];
    [self.addNoticeRequest setPostValue:self.countryCode forKey:@"countryCode"];
    [self.addNoticeRequest setPostValue:[NSNumber numberWithInteger:operate] forKey:@"operationType"];
    
    NSNumber *noticeId;
    if (operate == 0)//add
        noticeId = @0;
    else
        noticeId = self.tempNotice.noticeId;
    [self.addNoticeRequest setPostValue:noticeId forKey:@"id"];
    
    self.addNoticeRequest.tag = operate;
    self.addNoticeRequest.delegate = self;
    [self.addNoticeRequest startAsynchronous];
}

//返回值表示当前编辑的是否有效
- (BOOL)validNotice
{
    BOOL result = NO;
    
    for (Notice *notice in self.datas)
        if (notice.noticeType == self.tempNotice.noticeType && notice.compareType == self.tempNotice.compareType && notice.price == self.tempNotice.price)
        {
            [MyUtilities showMessage:@"你已经添加过此提醒！" withTitle:@"提示"];
            return result;
        }
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.countryCode];
    if (self.tempNotice.noticeType == NoticeTypeSpotExchangeBuy)//现汇买入
    {
        NSString *currenyPrice = [contentDic objectForKey:@"xhmr"];
        float currenyPricef = currenyPrice.floatValue;//现汇买入
        
        if (self.tempNotice.compareType == CompareTypeHigher)
        {
            if (self.tempNotice.price.floatValue >= currenyPricef)
                result = YES;
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经大于您所设定的值" withTitle:@"提示"];
            }
        }
        else if (self.tempNotice.compareType == CompareTypeLower)
        {
            if (self.tempNotice.price.floatValue <= currenyPricef)
                result = YES;
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经小于您所设定的值" withTitle:@"提示"];
            }
        }
    }
    else if (self.tempNotice.noticeType == NoticeTypeSpotExchangeSale)
    {
        //DLog(@"2222222222-----%f", cashPricef);
        NSString *bankofferPrice = [contentDic objectForKey:@"xhmc"];
        float bankofferPricef = bankofferPrice.floatValue;
        if (self.tempNotice.compareType == CompareTypeHigher)
        {
            if (self.tempNotice.price.floatValue >= bankofferPricef)
                result = YES;
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经大于您所设定的值" withTitle:@"提示"];
            }
        }
        else if (self.tempNotice.compareType == CompareTypeLower)
        {
            if (self.tempNotice.price.floatValue <= bankofferPricef)
                result = YES;
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经小于您所设定的值" withTitle:@"提示"];
            }
        }
    }
    
    
    
    return result;
}

//- (BOOL)removeInvalidNotice
//{
//    Notice *noticeToRemove = nil;
//    for (Notice *notice in self.datas)
//    {
//        if (notice != self.tempNotice)
//        {
//            DLog(@"%@", notice);
//            //如果类型和大小关系相同
//            if (notice.noticeType == self.tempNotice.noticeType && notice.compareType == self.tempNotice.compareType)
//            {
//                if (notice.compareType == CompareTypeHigher)//如果时大于
//                {
//                    if (self.tempNotice.price >= notice.price)//当前编辑的是有效的，移除之前的
//                    {
//                        noticeToRemove = notice;
//                        break;
//                    }
//                    else//当前编辑的是无效的，移除当前编辑的
//                    {
//                        noticeToRemove = self.tempNotice;
//                        break;
//                    }
//                }
//                else//如果是小于
//                {
//                    if (self.tempNotice.price <= notice.price)//当前编辑的是有效的，移除之前的
//                    {
//                        noticeToRemove = notice;
//                        break;
//                    }
//                    else//当前编辑的是无效的，移除当前编辑的
//                    {
//                        noticeToRemove = self.tempNotice;
//                        break;
//                    }
//                }
//            }
//        }
//    }
//    BOOL result = YES;
//    if (noticeToRemove == self.tempNotice)
//        result = NO;
//    if (noticeToRemove)
//        [self.datas removeObject:noticeToRemove];
//    
//    return result;
//}

- (void)noticeUpdate
{
    [_table reloadData];
}

- (BOOL)checkInput
{
    if (self.priceField.text.length && self.priceField.text.doubleValue)
        return YES;
    return NO;
}

- (IBAction)deleteButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除此条提醒？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 666)//提示输入价格
        {
            [self.priceField becomeFirstResponder];
        }
        else if (alertView.tag == rechargeVIPTag)
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
        else//删除此条提醒
        {
            [self noticeOperate:2];
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
        [self turnToAddPage];
        [MyUtilities showMessage:@"购买成功" withTitle:@"提示"];
        
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

#pragma mark UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.doneButton)
        return NO;
    if (![touch.view isDescendantOfView:self.priceField])
        [self closeKeyboard];
    return YES;
}

#pragma mark ASIHttpRequest Delegate Methods
- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.doneButton.enabled = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSString *responseString = request.responseString;

    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NULL error:&error];
    if (request == self.addNoticeRequest)
    {
        self.doneButton.enabled = YES;
        if (![result[@"isok"] boolValue])
        {
            [self getNoticeListFromWeb];
            [self cancelButtonPressed:nil];
        }
        else
        {
            switch (request.tag) {
                case 0:
                    [MyUtilities showMessage:@"添加提醒失败！" withTitle:@"提示"];
                    break;
                case 1:
                    [MyUtilities showMessage:@"修改提醒失败！" withTitle:@"提示"];
                    break;
                case 2:
                    [MyUtilities showMessage:@"删除提醒失败！" withTitle:@"提示"];
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    else if (request == self.getListRequest)
    {
        if (![result[@"isok"] boolValue])//获取数据成功
        {
            isDataLoaded = YES;
            [self.loadingIndicator stopAnimating];

            [self.datas removeAllObjects];
            NSArray *datas = result[@"msg"];
            GlobleObject *globle = [GlobleObject getInstance];
            globle.totalNoticeCount = datas.count;
            globle.notices = datas;
            
            for (NSDictionary *data in datas)
                if ([data[@"countrycode"] isEqualToString:self.countryCode])//国家相同，加入到数组里
                {
                    Notice *notice = [[Notice alloc] initWithCheckItem:data[@"checkitem"] compareType:data[@"comparetype"] countryCode:data[@"countrycode"] ringrate:data[@"ringrate"]];
                    notice.noticeId = data[@"id"];
                    [self.datas addObject:notice];
                }
            [self.table reloadData];
        }
    }

}
@end
