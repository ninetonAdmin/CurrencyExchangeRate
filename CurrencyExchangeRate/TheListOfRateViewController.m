//
//  TheListOfRateViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-16.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "TheListOfRateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "MyImageView.h"
#import "TheListOfRateAddingViewController.h"
#import "TheAddListViewController.h"
#import "PDViewController.h"

@interface TheListOfRateViewController ()
{
    int baseCountryIndexInOtherCountry;//基准货币在汇率列表中的位置
}

-(void) setTitleOfChoiseButton;

-(NSMutableArray *) getCountryExpectBaseCountry;

@end

@implementation TheListOfRateViewController

@synthesize otherCountry = _otherCountry;

-(NSMutableArray *)otherCountry
{
    if (!_otherCountry) {
        _otherCountry = [self getCountryExpectBaseCountry];
        //DLog(@"_otherCountry = %@", _otherCountry);
    }
    return _otherCountry;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.updateLable setText:[GlobleObject getInstance].updateTimeForCalc];
}

- (void)viewDidLayoutSubviews
{
    if ([self.listOfRateTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listOfRateTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.listOfRateTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listOfRateTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置分割线
    [self.listOfRateTableView setSeparatorInset:UIEdgeInsetsZero];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBaseCountry:) name:@"SelectANewBaseCountryOfListOfRate" object:nil];
    
    [self.navigationBarImageView setImage: [[UIImage imageNamed:@"v2-navigationbar-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(63, 5, 63, 5)]];
    
    //初始化view
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"main-menu-icon-normal.png"] forState:UIControlStateNormal];
//    [self.showMenuButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"main-menu-icon-active.png"] forState:UIControlStateHighlighted];
//    [self.choiceRateButton setBackgroundImage:[UIImage imageNamed:@"button-background-style06-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.choiceRateButton setBackgroundImage:[UIImage imageNamed:@"button-background-style07-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
//    [self.showMenuButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.showMenuButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    
//    [self.showMenuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.showMenuButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.choiceRateButton setTitleColor:[UIColor colorWithRed:56.0/255 green:224.0/255 blue:126.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.choiceRateButton setTitleColor:[UIColor colorWithRed:56.0/255 green:224.0/255 blue:126.0/255 alpha:1.0] forState:UIControlStateHighlighted];
    
//    self.choiceRateButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [self.btnChoiceRate.layer setMasksToBounds:YES];
    [self.btnChoiceRate setClipsToBounds:YES];
    [self.btnChoiceRate.layer setCornerRadius:4.0]; //设置矩圆角半径
    [self.btnChoiceRate.layer setBorderWidth:1.0];   //边框宽度
    [self.btnChoiceRate.layer setBorderColor:([UIColor whiteColor].CGColor)];//边框颜色
    [self setTitleOfChoiseButton];
    
//    self.maskView.layer.masksToBounds = YES;
//    self.maskView.layer.cornerRadius = 10.0f;
//    self.maskView.clipsToBounds = YES;

    baseCountryIndexInOtherCountry = -1;//-1表示初始化的状态
}

-(void) changeBaseCountry:(NSNotification *)noti
{
    [GlobleObject getInstance].listOfRateBaseCountry = noti.object;
    self.otherCountry = [self getCountryExpectBaseCountry];
    [self.listOfRateTableView reloadData];
    [self setTitleOfChoiseButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShowMenuButton:nil];
    [self setMaskView:nil];
    [self setChoiceRateButton:nil];
    [self setListOfRateTableView:nil];
    [self setUpdateLable:nil];
    [self setMyBgImg:nil];
    [super viewDidUnload];
}

- (IBAction)showMenu {
    NSNotification *notify = [NSNotification notificationWithName:@"OtherMenuButtonDown" object:[NSNumber numberWithInt:1]];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}


- (IBAction)showAddList:(id)sender
{
    // 当前屏幕截图
    UIGraphicsBeginImageContext(CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    // 高斯模糊
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@2.5f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
//    TheListOfRateAddingViewController *lockScreenController = [[TheListOfRateAddingViewController alloc] init];
//    PDViewController *lockScreenController = [[PDViewController alloc] init];
    TheAddListViewController *lockScreenController = [[TheAddListViewController alloc] initWithBg:blurImage];
//    [lockScreenController.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.92f]];
//    [lockScreenController.bgImageview setImage:image];
    
    UIViewController *controller = self.view.window.rootViewController;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    if (CURRENT_DEVICE >=8.0) {
        lockScreenController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [controller presentViewController:lockScreenController animated:YES completion:^{
        // 背景色透明
        lockScreenController.view.superview.backgroundColor = [UIColor clearColor];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.otherCountry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *code= [self.otherCountry objectAtIndex:indexPath.row];
    NSString *baseCountry = [GlobleObject getInstance].listOfRateBaseCountry;
    
    //-1表示初始化状态
//    if (baseCountryIndexInOtherCountry == -1) {
//        code = [self.otherCountry objectAtIndex:indexPath.row];
//        if ([code isEqualToString:[GlobleObject getInstance].listOfRateBaseCountry]) {
//            baseCountryIndexInOtherCountry = indexPath.row;
//            code = [self.otherCountry objectAtIndex:indexPath.row + 1];
//        }
//    }else if(indexPath.row >= baseCountryIndexInOtherCountry)
//    {
//        code = [self.otherCountry objectAtIndex:indexPath.row +1];
//    }else
//    {
//        code = [self.otherCountry objectAtIndex:indexPath.row];
//    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListOfRateTableCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListOfRateTableCell"];
        
        MyImageView *flagImg = [[MyImageView alloc] init];
        flagImg.frame = CGRectMake(15, 10, 30, 25);
        
//        flagImg.layer.shadowColor = [UIColor blackColor].CGColor;
//        flagImg.layer.shadowOpacity = 1.0f;
//        flagImg.layer.shadowOffset = CGSizeMake(0, 0);
        
        flagImg.layer.borderColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1].CGColor;
//        flagImg.layer.borderWidth = 1;
        
        flagImg.layer.masksToBounds = YES;
        flagImg.layer.cornerRadius = 4;
        //[flagImg maskRoundCorners:UIRectCornerAllCorners radius:3];
        
        flagImg.tag = 12;
        [cell addSubview:flagImg];
        
        UILabel *titleLable = [[UILabel alloc] init];
        CGRect frame = CGRectMake(55, 7, 240, 30);
        titleLable.frame = frame;
        titleLable.tag = 11;
        titleLable.textColor = [UIColor colorWithRed:38.0f/255 green:38.0f/255 blue:38.0f/255 alpha:1];
        titleLable.font = [UIFont fontWithName:@"Helvetica" size:16];
        [cell addSubview:titleLable];
        
    }
    
    NSString *flagImgPath = [[NSString alloc] initWithFormat:@"s%@.png", code];
    
    ((UIImageView *)[cell viewWithTag:12]).image = [UIImage imageNamed:flagImgPath];
    
    NSNumber *fromRateNum = [[GlobleObject getInstance].theRates objectForKey:code];
    NSNumber *toRateNum = [[GlobleObject getInstance].theRates objectForKey:baseCountry];
    
    float toValue = 100.0/fromRateNum.floatValue*toRateNum.floatValue;
    toValue = roundf(toValue*10000)/10000.0;
    NSNumber *toNum = [[NSNumber alloc] initWithFloat:toValue];
    
    NSString *str = [[NSString alloc] initWithFormat:@"100 %@ = %.4f %@", code, toNum.floatValue, baseCountry];
   
    
    ((UILabel *)[cell viewWithTag:11]).text = str;
    
//    cell.textLabel.text = str;
//    cell.imageView.image = [UIImage imageNamed:flagImgPath];
//    cell.imageView.layer.cornerRadius = 4;
//    cell.imageView.layer.borderWidth = 1;
//    cell.imageView.layer.masksToBounds = true;
    
    
    
    //罗氏给的MAGIC CODE
//    if ([cell.layer respondsToSelector:@selector(setShouldRasterize:)]) {
//        [cell.layer setShouldRasterize:YES];
//    }
    if ([cell.layer respondsToSelector:@selector(setShouldRasterize:)]) {
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        [cell.layer setShouldRasterize:YES];
    }
    
    return cell;
}

-(void)setTitleOfChoiseButton
{
    //根据当前的基准货币设置按钮的标题
    NSString *chineseNameOfCountry = [[GlobleObject getInstance].countrysName objectForKey:[GlobleObject getInstance].listOfRateBaseCountry];
    
//    DLog(@"chineseNameOfCountry = %@", chineseNameOfCountry);
//    DLog(@"chineseNameOfCountry.length = %i", chineseNameOfCountry.length);
    
    if (chineseNameOfCountry.length > 4) {
        chineseNameOfCountry = [[chineseNameOfCountry substringToIndex:3] stringByAppendingString:@"..."];
    }
    
    NSString *title = [chineseNameOfCountry stringByAppendingString:[GlobleObject getInstance].listOfRateBaseCountry];
    
    [self.btnChoiceRate setTitle:title forState:UIControlStateNormal];
}

-(NSMutableArray *)getCountryExpectBaseCountry
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListOfRate" ofType:@"plist"];
    NSMutableArray *wholeCountry = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    for (int i = 0; i < wholeCountry.count; i++) {
        NSString *code = [wholeCountry objectAtIndex:i];
        if ([code isEqualToString:[GlobleObject getInstance].listOfRateBaseCountry]) {
            [wholeCountry removeObjectAtIndex:i];
            return wholeCountry;
        }
    }
    
    return wholeCountry;
}


@end
