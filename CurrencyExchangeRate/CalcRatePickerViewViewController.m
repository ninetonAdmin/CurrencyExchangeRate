//
//  CalcRatePickerViewViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-14.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "CalcRatePickerViewViewController.h"
#import "GlobleObject.h"

@interface CalcRatePickerViewViewController ()

@end

@implementation CalcRatePickerViewViewController

@synthesize countryNeedToAddArray = _countryNeedToAddArray;
@synthesize currentAddingCountryCode = _currentAddingCountryCode;

-(NSArray *)countryNeedToAddArray
{
    if (!_countryNeedToAddArray) {
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        _countryNeedToAddArray = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ListOfRate" ofType:@"plist"];
        NSMutableArray *wholeCountry = [[NSMutableArray alloc] initWithContentsOfFile:path];
//        NSArray *countrys = [[GlobleObject getInstance].countrysName allKeys];
        //DLog(@"countrys = %@", wholeCountry);
        for (NSString *countryCode in wholeCountry) {
            BOOL hasTheCountry = NO;
            
            for (NSString *existCountryCode in [GlobleObject getInstance].currenteCalcRates) {
                //DLog(@"countryCode %@", countryCode);
                //DLog(@"existCountryCode %@", existCountryCode);
                
                if ([countryCode isEqualToString:existCountryCode]) {
                    hasTheCountry = YES;
                    //DLog(@"hasTheCountry : %@", countryCode);
                    break;
                }
            }
            
            if (!hasTheCountry) {
                //[dic setValue:@"" forKey:countryCode];
//                 DLog(@"Dont hasTheCountry now adding: %@", countryCode);
                // DLog(@"countryNeedToAddDic 000ocount = %i", _countryNeedToAddDic.count);
                [_countryNeedToAddArray addObject:countryCode];
            }
        }
        
        if (_countryNeedToAddArray.count == 0) {
            [_countryNeedToAddArray addObject:@" "];
        }
//        DLog(@"qqqqqqqqqqqqqqqqqqqqqq = %@", _countryNeedToAddArray);
//        _countryNeedToAddArray = [dic allKeys];
        
//        NSSortDescriptor *sortD = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
//        _countryNeedToAddArray = [_countryNeedToAddArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortD]];
    }
    //DLog(@"ggggggg%@", _countryNeedToAddArray);
    return _countryNeedToAddArray;
}

-(NSString *)currentAddingCountryCode
{
    if (!_currentAddingCountryCode) {
        _currentAddingCountryCode = [self.countryNeedToAddArray objectAtIndex:0];
    }
    
    return _currentAddingCountryCode;
}

- (IBAction)clickCancel {
    NSNotification *notify = [NSNotification notificationWithName:@"DisMissThePickerView" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

- (IBAction)clickAdd {
    //添加计算器国家逻辑
    
    
    DLog(@"2%@", self.currentAddingCountryCode);
    //1
    [[GlobleObject getInstance].currenteCalcRates addObject:self.currentAddingCountryCode];
    DLog(@"1%@", [GlobleObject getInstance].currenteCalcRates);
    //DLog(@"22222222222222222");
    //2
    NSNotification *notify = [NSNotification notificationWithName:@"DisMissThePickerView" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
    //3
    NSNotification *notify1 = [NSNotification notificationWithName:@"ThePickerViewIsAdding" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify1];
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
    
    [self.myAddButton setBackgroundImage:[UIImage imageNamed:@"quick-add-button-enter-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
    [self.myAddButton setBackgroundImage:[UIImage imageNamed:@"quick-add-button-enter--active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
    [self.myCancelButton setBackgroundImage:[UIImage imageNamed:@"quick-add-button-cancel-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
    [self.myCancelButton setBackgroundImage:[UIImage imageNamed:@"quick-add-button-cancel-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
    NSNotification *notify = [NSNotification notificationWithName:@"ThePickerViewDidSelectRow" object:[self.countryNeedToAddArray objectAtIndex:0]];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    DLog(@"viewWillAppear--------------------");
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    DLog(@"viewDidAppear--------------------");
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    DLog(@"viewDidDisappear--------------------");
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.countryNeedToAddArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@ %@", [self.countryNeedToAddArray objectAtIndex:row], [[GlobleObject getInstance].countrysName objectForKey:[self.countryNeedToAddArray objectAtIndex:row]]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNotification *notify = [NSNotification notificationWithName:@"ThePickerViewDidSelectRow" object:[self.countryNeedToAddArray objectAtIndex:row]];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
    
    self.currentAddingCountryCode = [self.countryNeedToAddArray objectAtIndex:row];
}

- (void)viewDidUnload {
    [self setMyCancelButton:nil];
    [self setMyAddButton:nil];
    [self setMyPickerView:nil];
    [super viewDidUnload];
}
@end
