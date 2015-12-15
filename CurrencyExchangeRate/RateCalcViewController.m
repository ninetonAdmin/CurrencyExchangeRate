//
//  RateCalcViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-8.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "RateCalcViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyImageView.h"
#import "GlobleObject.h"
#import "DMAdView.h"

@interface RateCalcViewController () <DMAdViewDelegate>
{
    BOOL isInTheAddingMode;//标准是否是快速添加
}

@property (nonatomic, strong) NSMutableArray *resultArr;

@end

@implementation RateCalcViewController
{
    NSString *currentValue;
    BOOL shouldChangeToOrigin;
}

@synthesize myCRPVViewController = _myCRPVViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.resultArr = [[NSMutableArray alloc] init];
    }
    return self;
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

-(void)viewWillAppear:(BOOL)animated
{
    //DLog(@"viewWillAppear--------------------");
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"viewWillAppear--------------------");
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"viewWillDisAppear--------------------");
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationBarImageView setImage:[UIImage imageNamed:@"v2-navigationbar-bg.png"]];
    [self.infoCenterButton setImage:[UIImage imageNamed:@"v2-altert-normal.png"] forState:UIControlStateNormal];
    [self.infoCenterButton setImage:[UIImage imageNamed:@"v2-altert-active.png"] forState:UIControlStateHighlighted];
    
    UIImageView *dotImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v2-dot.png"]];
    dotImgView.tag = 101;
    [dotImgView setFrame: CGRectMake(16, 8, 8, 8)];
    [self.infoCenterButton addSubview:dotImgView];
    
    //接受消息，当计算器里面的国家添加或者顺序改变时~
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentCalcRatesChangedHandler) name:@"TheCurrenyCalcRateIsChange" object:nil];
    
    //接受消息，当快速添加填出的pickerview的cancel被点击时~
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerViewCancelHandler) name:@"DisMissThePickerView" object:nil];
    
    //接受消息，当快速添加填出的pickerview选择了一个选项时~
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerViweDidSelectRowHandler:) name:@"ThePickerViewDidSelectRow" object:nil];
    
    //接受消息，当用户确认添加一个选项时~
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickerViweIsAddingHandler) name:@"ThePickerViewIsAdding" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [self.navigationBarImageView setImage: [[UIImage imageNamed:@"v2-navigationbar-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(63, 5, 63, 5)]];
    
//    [self.editButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.editButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
    self.view.clipsToBounds = YES;
    
    self.myEndEditButton.hidden = YES;
    self.myEndEditButton.backgroundColor = [UIColor clearColor];
    
    self.currentCalcCountryCode = [[GlobleObject getInstance].currenteCalcRates objectAtIndex:0];//默认为当前显示国家的第一个国家
    self.currentCalcCountryValue = 100.0;//数值为100
    
//    NSString *adBanner = [AppUtility getOnlineParameter:@"adBanner"];
//    if (adBanner == nil) {
//        adBanner = @"";
//    }
//    
//    if (![adBanner isEqualToString:@"0"]) {
//        
//        
//        //DMAdView *lDMAdv=[[DMAdView alloc]initWithPublisherId:@"56OJybiouMwpd35COu" placementId:@"16TLwS7vAcSE4Y6N0xBtucsi" size:CGSizeMake(0, 50) autorefresh:YES];
//        DMAdView *lDMAdv = [[DMAdView alloc] initWithPublisherId:@"56OJybiouMwpd35COu" placementId:@"16TLwS7vAcSE4Y6N0xBtucsi" autorefresh:YES];
//        [lDMAdv setFrame:CGRectMake(0, 0, 0, 50)];
//        lDMAdv.x = 0;
//        lDMAdv.y = DEVICE_HEIGHT - 59 - 50;
//        
//        if (CURRENT_DEVICE < 7.0f)
//        {
//            lDMAdv.y -= 20;
//        }
//
//        lDMAdv.rootViewController = [AppUtility getFrontViewController];
//        lDMAdv.delegate = self;
//        [lDMAdv loadAd];
//        lDMAdv.autoresizingMask= UIViewAutoresizingFlexibleTopMargin;
//        [self.view addSubview:lDMAdv];
//        self.myCalcTableView.contentInset=UIEdgeInsetsMake(0, 0, 50, 0);
//        self.myPickerView.y -= 50;
//    }
    
    
}




//-(void)viewDidAppear:(BOOL)animated
//{
//    DLog(@"viewDidAppear--------------------");
//    DLog(@"%@",NSStringFromCGSize(self.myCalcTableView.contentSize));
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    DLog(@"viewDidDisappear--------------------");
//}


- (IBAction)editButtonDidClicked:(id)sender
{
    if (self.myEndEditButton.hidden != NO) {
        [self performSegueWithIdentifier:@"ShowCalcRate" sender:self];
    }
}

-(void) pickerViweIsAddingHandler
{
    [self.myCalcTableView reloadData];
//    CGRect frame = self.myCalcTableView.frame;
//    if (frame.origin.y < 44) {
//        frame.origin.y += beforeDexOriginY;
//        [self.myCalcTableView setFrame:frame];
//    }else{
//        
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TheCurrenyCalcRateIsChange" object:nil];
    
    //通知主界面不再禁用上面的一排按钮
//    NSNotification *notify1 = [NSNotification notificationWithName:@"InteractionTitleButtons" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notify1];
}


-(void) pickerViweDidSelectRowHandler:(NSNotification *)notification
{
    NSString *countryCode = [notification object];
    
    self.theLastCell.myCountryCode = countryCode;
    self.theLastCell.codeLable.text = countryCode;

    NSString *flgeName = [[NSString alloc] initWithFormat:@"s%@.png", countryCode];
    self.theLastCell.flagView.image = [UIImage imageNamed:flgeName];
    
    NSString *currencyName = [[GlobleObject getInstance].countrysName objectForKey:countryCode];
    self.theLastCell.nameLable.text = currencyName;
}

-(void)currentCalcRatesChangedHandler
{
    [self.myCalcTableView reloadData];
    //保存当前用户定义要展示的国家
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    if (!documentsDirectoryPath) {
        DLog(@"documentsDirectoryPath is not found!!!!!!!!");
    }else
    {
        NSString *chinesesRatesFile = [documentsDirectoryPath stringByAppendingPathComponent:@"CalcRatesCountry.plist"];
        if ([[GlobleObject getInstance].currenteCalcRates writeToFile:chinesesRatesFile atomically:NO]) {
            DLog(@"CalcRatesCountry.plist is save!!!!!!!!");
        }
    }
}

-(void) pickerViewCancelHandler
{
    [UIView beginAnimations:@"DismissPickerView" context:nil];
    [UIView setAnimationDuration:0.3f];
    float width1 = self.myCalcTableView.frame.size.width;
    float height1 = self.myCalcTableView.frame.size.height;
    
    float diffY = 0;
    if (CURRENT_DEVICE <7) {
        diffY = -20;
    }
    
    CGRect rect1 = CGRectMake(10.0f, 64.0f + diffY,width1,height1);
    self.myCalcTableView.frame = rect1;
    
    float width = self.myPickerView.frame.size.width;
    float height = self.myPickerView.frame.size.height;
    float y = self.myPickerView.frame.origin.y;
    CGRect rect = CGRectMake(0.0f, y + height + 38,width,height);
    self.myPickerView.frame = rect;
    [UIView commitAnimations];
    
//    UIImage *bgImg = [UIImage imageNamed:@"quick-add-new-normal-background.png"];
//    bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 29, 0, 29)];
//    self.theLastCell.myBgView.image = bgImg;
    self.theLastCell.flagView.hidden = YES;
    self.theLastCell.nameLable.hidden = YES;
    self.theLastCell.codeLable.hidden = YES;
    self.theLastCell.highLightView.hidden = YES;
    
    self.theLastCell.addNewCurrencyLable.hidden = NO;
    self.theLastCell.myAddIconView.hidden = NO;
    
    self.myEndEditButton.hidden = YES;
    isInTheAddingMode = NO;
    
    //通知主界面不再禁用上面的一排按钮
    NSNotification *notify1 = [NSNotification notificationWithName:@"InteractionTitleButtons" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notify1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([GlobleObject getInstance].currenteCalcRates.count == 52) {
        return 52;////52表示当前计算器已经显示了全部国家
    }
    return [GlobleObject getInstance].currenteCalcRates.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"cellForRowAtIndexPath.....................");
    //最后一项，快速添加项
    if ([GlobleObject getInstance].currenteCalcRates.count != 52) {
        //52表示当前计算器已经显示了全部国家
        if (indexPath.row == [GlobleObject getInstance].currenteCalcRates.count) {
            
            MyCalcTableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:@"MyCalcTableViewCell-Last"];
            if(!lastCell)
            {
                //DLog(@"Create Last Cell");
                lastCell = [[MyCalcTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCalcTableViewCell-Last"];
                lastCell.backgroundColor = [UIColor clearColor];
                lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
                /*
                UIImage *bgImg = [UIImage imageNamed:@"quick-add-new-normal-background.png"];
                bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 29, 0, 29)];
                lastCell.myBgView.image = bgImg;
                */
                lastCell.flagView.hidden = YES;
                lastCell.nameLable.hidden = YES;
                lastCell.codeLable.hidden = YES;
                lastCell.numberTextField.hidden = YES;
                lastCell.highLightView.hidden = YES;
            }
            return lastCell;
        }
    }
        
    MyCalcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCalcTableViewCell"];
    if(!cell)
    {
        //DLog(@"Create Cell");

        cell = [[MyCalcTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCalcTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UIImage *bgImg = [UIImage imageNamed:@"calculator-box-background.png"];
//        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 29, 0, 29)];
//        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:bgImg];
//        cell.myBgView.image = bgImg;
        
//        cell.myHighLightView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"calculator-box-active-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 34, 0, 34)]];
//        cell.myHighLightView.hidden = YES;
        cell.myAddIconView.hidden = YES;
        cell.addNewCurrencyLable.hidden = YES;
    }
    
    NSString *flgeName = [[NSString alloc] initWithFormat:@"s%@.png", [[GlobleObject getInstance].currenteCalcRates objectAtIndex:indexPath.row]];
    
    cell.myCountryCode = [[GlobleObject getInstance].currenteCalcRates objectAtIndex:indexPath.row];
    
    cell.flagView.image = [UIImage imageNamed:flgeName];
//    UIRectCorner corners = !UIRectCornerAllCorners;
//    corners = UIRectCornerTopLeft;
//    corners |= UIRectCornerBottomLeft;
//    [cell.flagView  maskRoundCorners:corners radius:25];
    
    NSString *title = [[GlobleObject getInstance].currenteCalcRates objectAtIndex:indexPath.row];
    
    [cell.codeLable setText:title];
    
    title = [[GlobleObject getInstance].countrysName objectForKey:title];
    cell.nameLable.text = title;
    
    cell.numberTextField.delegate = self;
    
    //根据当前货币与主货币之间的汇率比较来获得当前textfield里面所需要填的货币数
//    DLog(@"self.currentCalcCountryCode = %@ = %f", self.currentCalcCountryCode, self.currentCalcCountryValue);
    NSNumber *fromRateNum = [[GlobleObject getInstance].theRates objectForKey:self.currentCalcCountryCode];
    NSNumber *toRateNum = [[GlobleObject getInstance].theRates objectForKey:cell.myCountryCode];
//    DLog(@"self.currentCalcCountryCode = %@ = %@", fromRateNum, toRateNum);
    
    double toValue = self.currentCalcCountryValue/fromRateNum.floatValue*toRateNum.floatValue;
    toValue = round(toValue*100)/100.0;
//    NSNumber *toNum = [[NSNumber alloc] initWithDouble:toValue];
    NSString *toStr = [NSString stringWithFormat:@"%.2f", toValue];
    cell.numberTextFieldShadow.text = toStr;
    cell.numberTextField.text = toStr;
    cell.numberTextField.tag = 100;
    cell.numberTextFieldShadow.tag = 101;
    
//    cell.layer.cornerRadius = 46;
//    cell.clipsToBounds = YES;
    
    //罗氏给的MAGIC CODE
//    if ([cell.layer respondsToSelector:@selector(setShouldRasterize:)]) {
//        [cell.layer setShouldRasterize:YES];
//    }
    if ([cell.layer respondsToSelector:@selector(setShouldRasterize:)]) {
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [cell.layer setShouldRasterize:YES];
    }

//    cell.highLightView.hidden = YES;
    
    return cell;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{    
//    MyCalcTableViewCell *cell = (MyCalcTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    cell.myHighLightView.hidden = NO;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    MyCalcTableViewCell *cell = (MyCalcTableViewCell *)[AppUtility findCalcCell:textField];
    
    UILabel *txfShadow = (UILabel*)[cell viewWithTag:101];
    
//    cell.myHighLightView.hidden = NO;

    [cell.myBgView.layer setShadowColor:[[UIColor colorWithRed:1 green:0.66 blue:0 alpha:1] CGColor]];
    
    self.myEndEditButton.hidden = NO;
    self.myEndEditButton.alpha = 0.011;
    
    self.currentField = textField;
    self.currentFieldShadow = txfShadow;
    
    self.currentCalcCountryCode = cell.myCountryCode;//设置为当前主货币
    self.currentCalcCountryValue = [cell.numberTextField.text floatValue];
    
    //清除之前数据
    currentValue = textField.text;
    shouldChangeToOrigin = YES;
    textField.text = @"";
    txfShadow.text = @"";
    
    //当键盘弹出时，为避免输入的cell被遮挡了，所以要移动tableview以保证不被遮挡住
//    DLog(@"jjjjj*******************%f", cell.frame.origin.y);
//    DLog(@"kkkkk*******************%f", self.myCalcTableView.contentOffset.y);
    //dexOriginY是当前cell相对于屏幕的y轴位置，若大于120时，需要使tableview向上移动，超过120多少数值就移动多少数值
//    float dexOriginY = cell.frame.origin.y - self.myCalcTableView.contentOffset.y;
//
//    float screenHeight = [UIScreen mainScreen].bounds.size.height;//screen height
//    //if the iOS system is upper than 7.0, contain the status bar's height
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
//        screenHeight += 20.f;
//    
//    // distance to Bottom of the screen
//    float distanceToBottom = screenHeight - dexOriginY - 140.f;
//    
//    // if the distance is longer than the length of the keyboard, do not need to move the table, else move the table
//    if (distanceToBottom >= 216.f)
//        dexOriginY = 0;
//    else
//        dexOriginY = 216.f - distanceToBottom;
//    
////    if (dexOriginY > 120) {
////        dexOriginY = dexOriginY - 120;
////    }else{
////        dexOriginY = 0;//不需要移动
////    }
//    
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:0.25f];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////    float width = self.myCalcTableView.frame.size.width;
////    float height = self.myCalcTableView.frame.size.height;
////    CGRect rect = CGRectMake(10.0f, -dexOriginY,width,height);
////    self.myCalcTableView.frame = rect;
//    CGRect frame = self.myCalcTableView.frame;
//    frame.origin.y -= dexOriginY;
//    self.myCalcTableView.frame = frame;
//    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    MyCalcTableViewCell *cell = (MyCalcTableViewCell *)[AppUtility findCalcCell:textField];

    [cell.myBgView.layer setShadowColor:[[UIColor clearColor]CGColor]];
    self.currentField = nil;
    
//    cell.myHighLightView.hidden = YES;
    float num = textField.text.floatValue;
    if (num == 0) {
        //self.currentFieldShadow.text = @"0.00";
        if (currentValue && shouldChangeToOrigin) {
            textField.text = currentValue;
            self.currentFieldShadow.text = currentValue;
        } else {
            textField.text = @"0.00";
            self.currentFieldShadow.text = textField.text;
        }
    }
    else
    {
        NSString *newString = [[NSString alloc] initWithFormat:@"%.2f", textField.text.doubleValue];
        textField.text = newString;
    }
    
    //若字符串以“.”结尾，把“.”去掉
    if ([textField.text hasSuffix:@"."])
    {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
        self.currentFieldShadow.text = textField.text;
    }
    
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:0.3f];
//    float width = self.myCalcTableView.frame.size.width;
//    float height = self.myCalcTableView.frame.size.height;
//    CGRect rect = CGRectMake(10.0f, 0.0f,width,height);
//    self.myCalcTableView.frame = rect;
//    [UIView commitAnimations];
    [UIView animateWithDuration:0.2 animations:^{
        if (CURRENT_DEVICE >= 7.0f) {
            self.myCalcTableView.height = DEVICE_HEIGHT- 64 - 49 + 3;
        } else {
            self.myCalcTableView.height = DEVICE_HEIGHT- 44 - 49 + 3 - 20;
        }
    }];
    
    self.currentFieldShadow = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldReturnTheChar = YES;//标志是否返回输入的数字
    
    //如果用户输入一个数字
    shouldChangeToOrigin = NO;
    
    if ([textField.text isEqualToString:@"0"]) {
        if ([string isEqualToString:@"0"])
        {
            return NO;
        }else if(![string isEqualToString:@""])
        {
            self.currentFieldShadow.text = @"";
            textField.text = @"";
        }
    }
    
    if ([string isEqualToString:@"."]) {
        NSRange textRange;
        textRange = [textField.text rangeOfString:@"."];
        if (textRange.location != NSNotFound) {
            return NO;
        }
        
        if ([textField.text isEqualToString:@""]) {
            self.currentFieldShadow.text = @"0.";
            textField.text = @"0.";
            return NO;
        }
    }
    
    //    DLog(@"1111111111111--str = %@", str);
    
    
    NSString *str = [textField.text stringByAppendingString:string];
    //DLog(@"ffff%@", str);
    //DLog(@"%@", string);
    if ([string isEqualToString:@""]) {
        str = [str substringToIndex:[str length] -1];
        //DLog(@"aaaa%@", str);
    }
        
    self.currentCalcCountryValue = str.floatValue;//设置当前主货币的数值
    
    MyCalcTableViewCell *fromCell = (MyCalcTableViewCell *)[AppUtility findCalcCell:textField];
    
    if (fromCell == nil) {
        return NO;
    }
    
    for (MyCalcTableViewCell *cell in [self.myCalcTableView visibleCells]) {
        if ([cell.reuseIdentifier isEqualToString:@"MyCalcTableViewCell-Last"]) {
            continue;
        }
        UITextField *txf = (UITextField*)[cell viewWithTag:100];
        
        UILabel *txfShadow = (UILabel*)[cell viewWithTag:101];
        if (txf == textField) {
            //DLog(@"we are equal!");
        }else{

            
            NSNumber *fromRateNum = [[GlobleObject getInstance].theRates objectForKey:fromCell.myCountryCode];
            NSNumber *toRateNum = [[GlobleObject getInstance].theRates objectForKey:cell.myCountryCode];
            float fromValue = str.floatValue;
            double toValue = fromValue/fromRateNum.floatValue*toRateNum.floatValue;
            //int toValueInt = toValue*100;
            //toValue = toValueInt/100.0;
            //toValue = round(toValue*100)/100.0;
            NSNumber *toNum = [[NSNumber alloc] initWithDouble:toValue];
            NSString *toStr = [NSString stringWithFormat:@"%.2f", toNum.doubleValue];
            txf.text = toStr;
            txfShadow.text = toStr;
            
        }
    }
    
    
    if (shouldReturnTheChar) {
        if ([string isEqualToString:@""]) {
            self.currentFieldShadow.text = [self.currentFieldShadow.text substringToIndex:[self.currentFieldShadow.text length] -1];
            //DLog(@"aaaa%@", str);
        }else
        {
            self.currentFieldShadow.text = [[NSString alloc] initWithFormat:@"%@%@", textField.text, string];
        }
    }
    
    return shouldReturnTheChar;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%@",NSStringFromCGRect(self.view.frame));
    //响应快速添加
    if (indexPath.row == [GlobleObject getInstance].currenteCalcRates.count) {
        
        if (self.myPickerView.subviews.count != 0) {
            UIView *view = [self.myPickerView.subviews objectAtIndex:0];
            [view removeFromSuperview];
            DLog(@"remove ing");
        }
        
        UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CalcRatePickerViewViewController *crpv = [sd instantiateViewControllerWithIdentifier:@"CalcPicker"];
        self.myCRPVViewController = crpv;
        CGRect frame = self.myCRPVViewController.view.frame;
        
        if (CURRENT_DEVICE < 7.0f) {
            frame.origin.y -= 20;
        }
        
        self.myCRPVViewController.view.frame = frame;
        [self.myPickerView addSubview:self.myCRPVViewController.view];
        
        //dexOriginY是当前cell相对于屏幕的y轴位置，若大于120时，需要使tableview向上移动，超过120多少数值就移动多少数值
        float dexOriginY = indexPath.row * 60 - self.myCalcTableView.contentOffset.y;
        if (dexOriginY > 60) {
            dexOriginY = dexOriginY - 60;
        } else {
            dexOriginY = 0;//不需要移动
        }
        
        float diffY = 0;
        if (CURRENT_DEVICE < 7.0) {
            diffY = -20 - 20;
        }
        
        [UIView beginAnimations:@"ShowPickerView" context:nil];
        [UIView setAnimationDuration:0.3f];
        
        float width1 = self.myCalcTableView.frame.size.width;
        float height1 = self.myCalcTableView.frame.size.height;
        CGRect rect1 = CGRectMake(10.0f,-dexOriginY + 64 + diffY,width1,height1);
        self.myCalcTableView.frame = rect1;
        
        float width = self.myPickerView.frame.size.width;
        float height = self.myPickerView.frame.size.height;
        float y = self.myPickerView.frame.origin.y;
        CGRect rect = CGRectMake(0.0f, y - height - 38,width,height);
        self.myPickerView.frame = rect;
        [self.myPickerView sendSubviewToBack:self.view];
        [UIView commitAnimations];
        
        //改变最后一项Cell由快速添加模式变为添加时的模式
        self.theLastCell = ( MyCalcTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        //弹出后，默认选择的第一项
        NSNotification *notify = [NSNotification notificationWithName:@"ThePickerViewDidSelectRow" object:[crpv.countryNeedToAddArray objectAtIndex:0]];
        [[NSNotificationCenter defaultCenter] postNotification:notify];
        
        //通知主界面禁用上面的一排按钮
        NSNotification *notify1 = [NSNotification notificationWithName:@"DeInteractionTitleButtons" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notify1];
        
        self.theLastCell.addNewCurrencyLable.hidden = YES;
        self.theLastCell.myAddIconView.hidden = YES;
        self.theLastCell.flagView.hidden = NO;
        self.theLastCell.nameLable.hidden = NO;
        self.theLastCell.highLightView.hidden = NO;
        self.theLastCell.codeLable.hidden = NO;
//        UIImage *bgImg = [UIImage imageNamed:@"calculator-box-background.png"];
//        bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 29, 0, 29)];
//        self.theLastCell.myBgView.image = bgImg;
        self.myEndEditButton.hidden = NO;
        self.myEndEditButton.alpha = 0.011;
        isInTheAddingMode = YES;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
//{
//    return [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"calculator-box-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 34, 0, 34)]];
//}
//

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 60;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (void)viewDidUnload {
    [self setMyCalcTableView:nil];
    [self setMyEndEditButton:nil];
    [self setMyPickerView:nil];
    [super viewDidUnload];
}

- (IBAction)endEdit {
    if (!isInTheAddingMode) {
        [self.currentField resignFirstResponder];
        self.myEndEditButton.hidden = YES;
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger movementDistance = (NSInteger)keyboardBounds.size.height;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        if (CURRENT_DEVICE >= 7.0f) {
            self.myCalcTableView.height = DEVICE_HEIGHT - movementDistance - 64;
        } else {
            self.myCalcTableView.height = DEVICE_HEIGHT - movementDistance - 44;
        }
    }];
}

#pragma mark  -------- DMAdViewDelegate --------
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView{
    DLog(@"Ad Success");
}

- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error{
    DLog(@"Ad Failed");
}

- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    DLog(@"Ad DidDismiss");
}

- (void)dmAdViewDidClicked:(DMAdView *)adView{
    DLog(@"Ad Click");
}

- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView{
    DLog(@"Present Ad");
}

@end
