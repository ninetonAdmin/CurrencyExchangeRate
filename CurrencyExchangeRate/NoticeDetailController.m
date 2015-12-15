//
//  NoticeDetailController.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-14.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "NoticeDetailController.h"
#import "MyUtilities.h"
#import "GlobleObject.h"
#import "ASIFormDataRequest.h"
#import "RateNoticeCountryChangeViewController.h"
#import "UIImage+Loader.h"

@interface NoticeDetailController ()<UIGestureRecognizerDelegate, ASIHTTPRequestDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) ASIFormDataRequest *request;
@end

@implementation NoticeDetailController
{
    BOOL _isAdding;
    Notice *originNotice;
    
    UIImage *imgBtnBgNormal;
    UIImage *imgBtnBgHighlighted;
}

#pragma mark 初始化

- (void)dealloc
{
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //init subviews
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    //    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
    //    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    //    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    //    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    
    //    self.clipView.layer.masksToBounds = YES;
    //    self.clipView.layer.cornerRadius = 10.f;
    
    //    self.flagImageView.layer.masksToBounds = YES;
    //    self.flagImageView.layer.cornerRadius = 5;
    
    //    self.fieldView.layer.cornerRadius = 4;
    //    self.fieldView.layer.borderColor = [UIColor blackColor].CGColor;
    //    self.fieldView.layer.borderWidth = 1.f;
    
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.cornerRadius = 3;
    
    
    imgBtnBgNormal= [UIImage imageNamed:@"v2-set-rate-notice-bg-normal.png"];
    imgBtnBgNormal = [imgBtnBgNormal stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    imgBtnBgHighlighted = [UIImage imageNamed:@"v2-set-rate-notice-bg-selected.png"];
    imgBtnBgHighlighted = [imgBtnBgHighlighted stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    [self.btnUp setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
    [self.btnUp setBackgroundImage:imgBtnBgNormal forState:UIControlStateHighlighted];
    [self.btnUp setImage:[UIImage imageNamed:@"v2-up-normal.png"] forState:UIControlStateNormal];
    [self.btnUp setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.btnUp setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    [self.btnDown setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
    [self.btnDown setBackgroundImage:imgBtnBgNormal forState:UIControlStateHighlighted];
    [self.btnDown setImage:[UIImage imageNamed:@"v2-down-normal.png"] forState:UIControlStateNormal];
    [self.btnDown setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [self.btnDown setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"v2-btn-green-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"v2-btn-green-active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    
    //    self.deleteButton.layer.cornerRadius = 4;
    //    self.deleteButton.layer.borderWidth = 1.f;
    self.deleteButton.layer.borderColor = [UIColor colorWithRed:.99f green:.59f blue:.5f alpha:1.f].CGColor;
    
    //    UIImage *image = [UIImage imageNamed:@"button-box-background.png"];
    //    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 6, 6)];
    //    self.backImageView.image = image;
    
    if (!self.notice) {
        self.notice = [[Notice alloc] init];
        _isAdding = YES;
    } else {
        originNotice = [self.notice copy];
    }
    
    [self resetNoticeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //获得设备ios版本
    if (CURRENT_DEVICE >= 5.0) {
        //如果时ios5以上
        /*定义一个通知，当键盘高度变化时self收到UIKeyboardWillChangeFrameNotification,调用keyboardWillShow:方法*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    } else {
        /*定义一个通知，当键盘显示的时候self收到UIKeyboardWillShowNotification,调用keyboardWillShow:方法*/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    //设置各种状态的字体和颜色
//    [self.typeSegment setTitleTextAttributes:dict forState:UIControlStateNormal];
    //设置各种状态的字体和颜色
    [self.typeSegment setTitleTextAttributes:dict forState:UIControlStateSelected];
}

#pragma mark 点击事件
- (IBAction)cancelButtonPressed:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(id)sender
{
    if (![self checkInput])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入价格！"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 666;
        [alert show];
        return;
    }
    
    [self closeKeyboard];
//    CGFloat price = self.priceField.text.floatValue;
    self.notice.price = self.priceField.text;
    
    if (![self haveEdit])
    {
        [self cancelButtonPressed:nil];
        return;
    }
    
    // 去掉无效的提醒，返回YES表示当前编辑的提醒有效
    if ([self validNotice])
    {
        // 请求服务器提醒
        self.doneButton.enabled = NO;
        
        if (_isAdding) {
            [self noticeOperate:0];
        } else {
            [self noticeOperate:1];
        }
    }
}


- (IBAction)deleteButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除此条提醒？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)selectNoticeType:(id)sender
{
    [self closeKeyboard];
    UISegmentedControl *segment = sender;
    self.notice.noticeType = (int)segment.selectedSegmentIndex;
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.notice.countryCode];
    
    if (self.notice.noticeType == NoticeTypeSpotExchangeBuy) {
        NSString *currenyPrice = [contentDic objectForKey:@"xhmr"];
        self.currentLabel.text = currenyPrice;
    } else {
        NSString *bankofferPrice = [contentDic objectForKey:@"xhmc"];
        self.currentLabel.text = bankofferPrice;
    }
    
}

- (IBAction)selectCompareType:(id)sender
{
    [self closeKeyboard];
    UISegmentedControl *segment = sender;
    self.notice.compareType = (int)segment.selectedSegmentIndex;
}

- (IBAction)priceChange:(id)sender
{
    
}

- (IBAction)btnUpPressed:(id)sender {
    self.notice.compareType = CompareTypeHigher;
    
    [self setBtnBg:self.notice.compareType];
    
//    [self.btnUp setBackgroundImage:imgBtnBgHighlighted forState:UIControlStateNormal];
//    [self.btnDown setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
}

- (IBAction)btnDownPressed:(id)sender {
    self.notice.compareType = CompareTypeLower;
    
    [self setBtnBg:self.notice.compareType];
    
//    [self.btnUp setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
//    [self.btnDown setBackgroundImage:imgBtnBgHighlighted forState:UIControlStateNormal];
}


#pragma mark 增删改提醒
- (BOOL)haveEdit
{
    if (_isAdding) {
        return YES;
    }
    
    if ([originNotice isequalToNotice:self.notice]) {
        return NO;
    }
    
    return YES;
}

//对提醒操作
//参数:新增 0    修改 1    删除 2
- (void)noticeOperate:(NSInteger)operate
{
    NSURL *url = [NSURL URLWithString:@"http://currency.51wnl.com/APIS/PostPushMessage"];
    self.request = [[ASIFormDataRequest alloc]  initWithURL:url];
    NSString *deviceToken = [MyUtilities deviceToken];
    [self.request setPostValue:deviceToken forKey:@"devicetoken"];
    NSString *checkitem = nil;
    
    if (self.notice.noticeType == NoticeTypeSpotExchangeBuy) {
        checkitem = @"xhmr";
    } else if (self.notice.noticeType == NoticeTypeSpotExchangeSale) {
        checkitem = @"xhmc";
    }
    
    [self.request setPostValue:checkitem forKey:@"checkitem"];
    [self.request setPostValue:self.notice.price forKey:@"ringrate"];
    [self.request setPostValue:[NSNumber numberWithInt:self.notice.compareType] forKey:@"type"];
    [self.request setPostValue:self.notice.countryCode forKey:@"countryCode"];
    [self.request setPostValue:[NSNumber numberWithInteger:operate] forKey:@"operationType"];
    
    NSNumber *noticeId;
    if (operate == 0) {
        //add
        noticeId = @0;
    } else {
        noticeId = self.notice.noticeId;
    }
    
    [self.request setPostValue:noticeId forKey:@"id"];
    
    self.request.tag = operate;
    self.request.delegate = self;
    [self.request startAsynchronous];
}

//返回值表示当前编辑的是否有效
- (BOOL)validNotice
{
    BOOL result = NO;
    NSArray *datas = [GlobleObject getInstance].notices;
    //检查是否添加过一样的提醒
    for (NSDictionary *rowData in datas)
    {
        NSString *countryCode = rowData[@"countrycode"];
        NoticeType noticeType;
        if ([rowData[@"checkitem"] isEqualToString:@"xhmr"]) {
            noticeType = NoticeTypeSpotExchangeBuy;
        } else {
            /* if ([rowData[@"checkitem"] isEqualToString:@"xhmc"])*/
            noticeType = NoticeTypeSpotExchangeSale;
        }
        
        CompareType compareType = [rowData[@"comparetype"] intValue];
        NSString *price = rowData[@"ringrate"];
        
        if ([self.notice.countryCode isEqualToString:countryCode]
            && self.notice.noticeType == noticeType
            && self.notice.compareType == compareType
            && [self.notice.price isEqualToString:price])
        {
            [MyUtilities showMessage:@"你已经添加过此提醒！" withTitle:@"提示"];
            return result;
        }
    }
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.notice.countryCode];
    
    if (self.notice.noticeType == NoticeTypeSpotExchangeBuy)
    {
        //现汇买入
        NSString *currenyPrice = [contentDic objectForKey:@"xhmr"];
        float currenyPricef = currenyPrice.floatValue;//现汇买入
        
        if (self.notice.compareType == CompareTypeHigher)
        {
            if (self.notice.price.floatValue >= currenyPricef)
            {
                result = YES;
            }
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经大于您所设定的值" withTitle:@"提示"];
            }
        }
        else if (self.notice.compareType == CompareTypeLower)
        {
            if (self.notice.price.floatValue <= currenyPricef)
            {
                result = YES;
            }
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经小于您所设定的值" withTitle:@"提示"];
            }
        }
    }
    else if (self.notice.noticeType == NoticeTypeSpotExchangeSale)
    {
        //DLog(@"2222222222-----%f", cashPricef);
        NSString *bankofferPrice = [contentDic objectForKey:@"xhmc"];
        float bankofferPricef = bankofferPrice.floatValue;
        if (self.notice.compareType == CompareTypeHigher)
        {
            if (self.notice.price.floatValue >= bankofferPricef)
            {
                result = YES;
            }
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经大于您所设定的值" withTitle:@"提示"];
            }
        }
        else if (self.notice.compareType == CompareTypeLower)
        {
            if (self.notice.price.floatValue <= bankofferPricef)
            {
                result = YES;
            }
            else
            {
                result = NO;
                [MyUtilities showMessage:@"现汇买入价已经小于您所设定的值" withTitle:@"提示"];
            }
        }
    }

    return result;
}

// 设置按钮背景
- (void)setBtnBg:(CompareType)val
{
    switch (val) {
        case CompareTypeHigher:
            [self.btnUp setBackgroundImage:imgBtnBgHighlighted forState:UIControlStateNormal];
            [self.btnDown setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
            break;
        default:
            [self.btnUp setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
            [self.btnDown setBackgroundImage:imgBtnBgHighlighted forState:UIControlStateNormal];
            break;
    }
}

- (void)resetNoticeView
{
    NSString *flageImgPath = [[NSString alloc] initWithFormat:@"s%@.png", self.notice.countryCode];
    self.flagImageView.image = [UIImage imageNamed:flageImgPath];
    
    [self.countryImageView setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png", self.notice.countryCode]] blurredImage:0.1]];
    
    NSString *name = [[GlobleObject getInstance].countrysName objectForKey:self.notice.countryCode];
    self.countryNameLabel.text = [NSString stringWithFormat:@"%@ %@", name, self.notice.countryCode];
    
    [self.moreButton setTitle:[NSString stringWithFormat:@"%@ %@", name, self.notice.countryCode] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:flageImgPath] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:flageImgPath] forState:UIControlStateHighlighted];
    self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
//    设置类型
    self.typeSegment.selectedSegmentIndex = self.notice.noticeType;
    self.compareSegment.selectedSegmentIndex = self.notice.compareType;
    
    [self setBtnBg:self.notice.compareType];
//    if(self.notice.compareType == CompareTypeHigher) {
//        [self.btnUp setBackgroundImage:imgBtnBgHighlighted forState:UIControlStateNormal];
//        [self.btnDown setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
//    } else {
//        [self.btnUp setBackgroundImage:imgBtnBgNormal forState:UIControlStateNormal];
//        [self.btnDown setBackgroundImage:imgBtnBgHighlighted forState:UIControlStateNormal];
//    }
    
    if (_isAdding) {
        self.deleteButton.hidden = YES;
    } else {
        self.deleteButton.hidden = NO;
    }
    
    if (self.notice.price) {
        NSString *string = self.notice.price;
        NSRange range = [string rangeOfString:@"."];
        if (range.location != NSNotFound) {
            if (string.length > 6) {
                string = [string substringToIndex:6];
            }
        }
        
        self.priceField.text = string;
    } else {
        self.priceField.text = @"";
    }
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.notice.countryCode];
    DLog(@"%@", contentDic);
    NSString *currenyPrice = (contentDic != nil) ? [contentDic objectForKey:@"xhmr"] : @"";
    self.currentLabel.text = currenyPrice;
}

#pragma mark -
#pragma mark Responding to keyboard events
//键盘显示或高度变化时调用
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.tap) {
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
    CGFloat coverHeight = 54.f + self.fieldView.frame.size.height + self.fieldView.frame.origin.y + keyboardRect.size.height - screenHeight;
    if (DeviceSystemMajorVersion() < 7) {
        coverHeight += 20.f;
    }
    
    if (coverHeight > -10) {
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
    if (self.tap) {
        [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.tap];
    }
}


//键盘关闭时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.tap) {
        [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.tap];
    }
    
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

#pragma mark ASIHttpRequest Delegate Methods
- (void)requestFailed:(ASIHTTPRequest *)request
{
    switch (request.tag)
    {
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
    
    self.doneButton.enabled = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NULL error:&error];
    self.doneButton.enabled = YES;
    
    if (![result[@"isok"] boolValue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeUpdateNotification" object:nil];
        [self.parentController getNoticeListFromWeb];
        [self cancelButtonPressed:nil];
    }
    else
    {
        switch (request.tag)
        {
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

#pragma mark UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 666)//提示输入价格
        {
            [self.priceField becomeFirstResponder];
        }
        else    //删除此条提醒
        {
            [self noticeOperate:2];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkInput
{
    if (self.priceField.text.length && self.priceField.text.doubleValue) {
        return YES;
    }
    
    return NO;
}

- (void)changeCountry:(NSString *)countryCode
{
    self.notice.countryCode = countryCode;
    NSString *flageImgPath = [[NSString alloc] initWithFormat:@"s%@.png", self.notice.countryCode];
    self.flagImageView.image = [UIImage imageNamed:flageImgPath];
    
    [self.countryImageView setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"b%@.png", self.notice.countryCode]] blurredImage:0.1]];
    
    NSString *name = [[GlobleObject getInstance].countrysName objectForKey:self.notice.countryCode];
    self.countryNameLabel.text = [NSString stringWithFormat:@"%@ %@", name, self.notice.countryCode];
    
    [self.moreButton setTitle:[NSString stringWithFormat:@"%@ %@", name, self.notice.countryCode] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:flageImgPath] forState:UIControlStateNormal];
    self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    NSDictionary *contentDic = [[GlobleObject getInstance].chineseRates objectForKey:self.notice.countryCode];
    
    if (self.notice.noticeType == NoticeTypeSpotExchangeBuy) {
        NSString *currenyPrice = [contentDic objectForKey:@"xhmr"];
        self.currentLabel.text = currenyPrice;
    } else {
        NSString *bankofferPrice = [contentDic objectForKey:@"xhmc"];
        self.currentLabel.text = bankofferPrice;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RateNoticeCountryChangeViewController *controller = segue.destinationViewController;
    controller.countryCode = self.notice.countryCode;
    controller.parentController = self;
}

@end
