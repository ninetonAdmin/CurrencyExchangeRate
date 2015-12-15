//
//  CalcRateAddingListViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-13.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "CalcRateAddingListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "MyUtilities.h"


@interface CalcRateAddingListViewController ()

@end

@implementation CalcRateAddingListViewController

@synthesize countryNeedToAddArray = _countryNeedToAddArray;
@synthesize countryNeedToAddDic = _countryNeedToAddDic;

-(NSDictionary *)countryNeedToAddDic
{
    //这里同中国汇率相同的地方很像，有疑问请参考那里
    if (!_countryNeedToAddDic) {
        _countryNeedToAddDic = [[NSMutableDictionary alloc] init];
        
        NSArray *countrys = [[GlobleObject getInstance].countrysName allKeys];
//        DLog(@"countrys = %@", countrys);
        for (NSString *countryCode in countrys) {
//            BOOL hasTheCountry = NO;
//            
//            for (NSString *existCountryCode in [GlobleObject getInstance].currenteCalcRates) {
//                //DLog(@"countryCode %@", countryCode);
//                //DLog(@"existCountryCode %@", existCountryCode);
//                
//                if ([countryCode isEqualToString:existCountryCode]) {
//                    hasTheCountry = YES;
//                    //DLog(@"hasTheCountry : %@", countryCode);
//                    break;
//                }
//            }
//            
//            if (!hasTheCountry) {
//                //0代表需要添加列表中的该货币没有被用户选择添加进入当前汇率计算器列表，1相反
//                [_countryNeedToAddDic setValue:[[NSNumber alloc]initWithInt:0] forKey:countryCode];
//                // DLog(@"Dont hasTheCountry now adding: %@", countryCode);
//                // DLog(@"countryNeedToAddDic 000ocount = %i", _countryNeedToAddDic.count);
//            }
            
            
            if (![[GlobleObject getInstance].currenteCalcRates containsObject:countryCode])
            {
                [_countryNeedToAddDic setValue:[[NSNumber alloc]initWithInt:0] forKey:countryCode];
            }
        }
    }
    //DLog(@"countryNeedToAddDic = %@", _countryNeedToAddDic);
    return _countryNeedToAddDic;
}

-(NSArray *)countryNeedToAddArray
{
    if (!_countryNeedToAddArray) {
//        _countryNeedToAddArray = [self.countryNeedToAddDic allKeys];
//        NSSortDescriptor *sortD = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//        _countryNeedToAddArray = [_countryNeedToAddArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortD]];
        
        //        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        _countryNeedToAddArray = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ListOfRate" ofType:@"plist"];
        NSMutableArray *wholeCountry = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
//        NSArray *countrys = [[GlobleObject getInstance].countrysName allKeys];
//        DLog(@"countrys = %@", wholeCountry);
        
        for (NSString *countryCode in wholeCountry) {
//            BOOL hasTheCountry = NO;
//            
//            for (NSString *existCountryCode in [GlobleObject getInstance].currenteCalcRates) {
//                //DLog(@"countryCode %@", countryCode);
//                //DLog(@"existCountryCode %@", existCountryCode);
//                
//                if ([countryCode isEqualToString:existCountryCode]) {
//                    hasTheCountry = YES;
//                    //DLog(@"hasTheCountry : %@", countryCode);
//                    break;
//                }
//            }
//            
//            if (!hasTheCountry) {
//                //[dic setValue:@"" forKey:countryCode];
//                //                 DLog(@"Dont hasTheCountry now adding: %@", countryCode);
//                // DLog(@"countryNeedToAddDic 000ocount = %i", _countryNeedToAddDic.count);
//                [_countryNeedToAddArray addObject:countryCode];
//            }
            
            if (![[GlobleObject getInstance].currenteCalcRates containsObject:countryCode])
                [_countryNeedToAddArray addObject:countryCode];
        }
        //        DLog(@"qqqqqqqqqqqqqqqqqqqqqq = %@", _countryNeedToAddArray);
        //        _countryNeedToAddArray = [dic allKeys];
        
        //        NSSortDescriptor *sortD = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
        //        _countryNeedToAddArray = [_countryNeedToAddArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortD]];
    }
    return _countryNeedToAddArray;
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
    
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    
//    self.currentAddingTableView.layer.masksToBounds = YES;
//    self.currentAddingTableView.layer.cornerRadius = 10;
    
    DLog(@"calc :: countryNeedToAddArray = %@", self.countryNeedToAddArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDoneButton:nil];
    [self setCurrentAddingTableView:nil];
    [self setMyBgImg:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.countryNeedToAddDic.count == 0) {
//        [MyUtilities showMessage:@"所以国家都已经添加完了" withTitle:@"提示"];
//    }
    return self.countryNeedToAddDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalcRateAddingListCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalcRateAddingListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *countryCode = [self.countryNeedToAddArray objectAtIndex:indexPath.row];
    NSString *name = [countryCode stringByAppendingFormat:@"  %@",[[GlobleObject getInstance].countrysName objectForKey:countryCode]];
//
    cell.textLabel.text = name;
//    
    NSNumber *num = [self.countryNeedToAddDic objectForKey:countryCode];
    if (num.intValue == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath:indexPath];
    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSNumber *number = [[NSNumber alloc] initWithInt:1];
        [self.countryNeedToAddDic setValue:number forKey:[self.countryNeedToAddArray objectAtIndex:indexPath.row]];
    } else {
        oneCell.accessoryType = UITableViewCellAccessoryNone;
        NSNumber *number = [[NSNumber alloc] initWithInt:0];
        [self.countryNeedToAddDic setValue:number forKey:[self.countryNeedToAddArray objectAtIndex:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)addingDone {
//    DLog(@"addingDone : self.countryNeedToAddDic = %@", self.countryNeedToAddDic);
    for (NSString *countryCode in self.countryNeedToAddDic) {
        NSNumber *num = [self.countryNeedToAddDic objectForKey:countryCode];
        int flag = num.intValue;
        if (flag == 1) {
            [[GlobleObject getInstance].currenteCalcRates addObject:countryCode];
        }
    }
    
    NSNotification *notify = [NSNotification notificationWithName:@"TheCurrenyCalcRateIsChange" object:self];//通知主页计算机刷新
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
    NSNotification *notify01 = [NSNotification notificationWithName:@"TheCurrenyCalcRateIsChangeList" object:self];//通知计算机编辑列表刷新
    [[NSNotificationCenter defaultCenter] postNotification:notify01];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancleDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
