//
//  ChineseExchangeRateAddingListViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-7.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "ChineseExchangeRateAddingListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"

@interface ChineseExchangeRateAddingListViewController ()
{
    
}
@end


@implementation ChineseExchangeRateAddingListViewController

@synthesize countryNeedToAddDic = _countryNeedToAddDic;
@synthesize countryNeedToAddArray = _countryNeedToAddArray;

-(NSDictionary *)countryNeedToAddDic
{
    if (!_countryNeedToAddDic)
    {
        _countryNeedToAddDic = [[NSMutableDictionary alloc] init];
        
        NSArray *countrys = [[GlobleObject getInstance].chineseRates allKeys];
        DLog(@"countrys = %@", countrys);
        for (NSString *countryCode in countrys) {
            BOOL hasTheCountry = NO;
            
            for (NSString *existCountryCode in [GlobleObject getInstance].currentChineseRates) {
                //DLog(@"countryCode %@", countryCode);
                //DLog(@"existCountryCode %@", existCountryCode);
                
                if ([countryCode isEqualToString:existCountryCode]) {
                    hasTheCountry = YES;
                    //DLog(@"hasTheCountry : %@", countryCode);
                    break;
                }
            }
            
            if (!hasTheCountry) {
                //0代表需要添加列表中的该货币没有被用户选择添加进入当前中国汇率列表，1相反
                [_countryNeedToAddDic setValue:[[NSNumber alloc]initWithInt:0] forKey:countryCode];
                // DLog(@"Dont hasTheCountry now adding: %@", countryCode);
               // DLog(@"countryNeedToAddDic 000ocount = %i", _countryNeedToAddDic.count);
            }
        }
    }
    //DLog(@"countryNeedToAddDic = %@", _countryNeedToAddDic);
    return _countryNeedToAddDic;
}

-(NSArray *)countryNeedToAddArray
{
    if (!_countryNeedToAddArray) {
        _countryNeedToAddArray = [self.countryNeedToAddDic allKeys];
        NSSortDescriptor *sortD = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
        _countryNeedToAddArray = [_countryNeedToAddArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortD]];
    }
    return _countryNeedToAddArray;
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
	// Do any additional setup after loading the view.
    
    //init views
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    
//    self.currencyAddingTableView.layer.masksToBounds = YES;
//    self.currencyAddingTableView.layer.cornerRadius = 10;
    
    //order the countryNeedToAddArray
//    NSSortDescriptor *sortD = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//    self.countryNeedToAddArray = [self.countryNeedToAddArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortD]];
    DLog(@"countryNeedToAddArray = %@", self.countryNeedToAddArray);
    
    //[self.countryNeedToAddDic ]
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCurrencyAddingTableView:nil];
    [self setDoneButton:nil];
    [self setMyBgImg:nil];
    [super viewDidUnload];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countryNeedToAddDic.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChineseExchangeRateAddingListCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChineseExchangeRateAddingListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *countryCode = [self.countryNeedToAddArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [countryCode stringByAppendingFormat:@"  %@",[[GlobleObject getInstance].countrysName objectForKey:countryCode]];;
    
    NSNumber *num = [self.countryNeedToAddDic objectForKey:countryCode];
    if (num.intValue == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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

- (IBAction)addingDone:(id)sender
{
    DLog(@"addingDone : self.countryNeedToAddDic = %@", self.countryNeedToAddDic);
    for (NSString *countryCode in self.countryNeedToAddDic)
    {
        NSNumber *num = [self.countryNeedToAddDic objectForKey:countryCode];
        int flag = num.intValue;
        if (flag == 1) {
            [[GlobleObject getInstance].currentChineseRates addObject:countryCode];
        }
    }

    NSNotification *notify = [NSNotification notificationWithName:@"TheCurrenyChineseRateIsChange" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancleAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

















@end
