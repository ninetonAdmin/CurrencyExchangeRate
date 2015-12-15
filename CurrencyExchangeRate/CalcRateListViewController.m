//
//  CalcRateListViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-12.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "CalcRateListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "MyUtilities.h"

@interface CalcRateListViewController ()

@end

@implementation CalcRateListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //当添加新国家时，reloadData tableView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentCalcRatesChangedHandler) name:@"TheCurrenyCalcRateIsChangeList" object:nil];
    
    //init subviews
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.addCountryButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"top-add-icon-normal.png"] forState:UIControlStateNormal];
//    [self.addCountryButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"top-add-icon-active.png"] forState:UIControlStateHighlighted];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    
    [self.currentCalcRateTableView setEditing:YES animated:YES];
    //self.currentChineseRateTableView.editing = YES;
//    self.currentCalcRateTableView.layer.masksToBounds = YES;
//    self.currentCalcRateTableView.layer.cornerRadius = 10;
}

-(void)currentCalcRatesChangedHandler
{
    [self.currentCalcRateTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editDone {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addDown {
    if ([GlobleObject getInstance].currenteCalcRates.count == 52) {
        [MyUtilities showMessage:@"所有的国家币种都已添加" withTitle:@"提示"];
    }else
    {
        [self performSegueWithIdentifier:@"showCalcAddingListView" sender:self];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [GlobleObject getInstance].currenteCalcRates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalcRateListCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalcRateListCell"];
    }
    
    NSString *countryNameCode = [[GlobleObject getInstance].currenteCalcRates objectAtIndex:indexPath.row];
    NSString *countryName = [[GlobleObject getInstance].countrysName objectForKey:countryNameCode];
    countryName = [countryName stringByAppendingString:countryNameCode];
    cell.textLabel.text = countryName;
    cell.showsReorderControl = YES;
    //    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)
sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *movedCountryCode = [[GlobleObject getInstance].currenteCalcRates objectAtIndex:sourceIndexPath.row];
    [[GlobleObject getInstance].currenteCalcRates removeObjectAtIndex:sourceIndexPath.row];
    [[GlobleObject getInstance].currenteCalcRates insertObject:movedCountryCode atIndex:destinationIndexPath.row];
    
    DLog(@"GlobleObject currenteCalcRates = %@", [GlobleObject getInstance].currenteCalcRates);
    
    NSNotification *notify = [NSNotification notificationWithName:@"TheCurrenyCalcRateIsChange" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([GlobleObject getInstance].currenteCalcRates.count == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最少也得保留一个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[GlobleObject getInstance].currenteCalcRates removeObjectAtIndex:indexPath.row];
        [self.currentCalcRateTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    NSNotification *notify = [NSNotification notificationWithName:@"TheCurrenyCalcRateIsChange" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

- (void)viewDidUnload {
    [self setMyBgImg:nil];
    [super viewDidUnload];
}
@end
