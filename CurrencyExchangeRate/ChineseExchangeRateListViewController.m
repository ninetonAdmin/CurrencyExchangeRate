//
//  ChineseExchangeRateListViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-5.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "ChineseExchangeRateListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "MyUtilities.h"

@interface ChineseExchangeRateListViewController ()


- (void)currentChineseRatesChangedHandler;

@end

@implementation ChineseExchangeRateListViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentChineseRatesChangedHandler)
                                                 name:@"TheCurrenyChineseRateIsChange"
                                               object:nil];
    
    //init subviews
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.addCountryButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"top-add-icon-normal.png"] forState:UIControlStateNormal];
//    [self.addCountryButton setBackgroundImage:[UIImage imageNamed:@"button-background-style02-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:@"top-add-icon-active.png"] forState:UIControlStateHighlighted];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
//    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"button-background-style03-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    
    [self.currentChineseRateTableView setEditing:YES animated:YES];
    //self.currentChineseRateTableView.editing = YES;
//    self.currentChineseRateTableView.layer.masksToBounds = YES;
//    self.currentChineseRateTableView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobleObject getInstance].currentChineseRates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChineseExchangeRateListCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChineseExchangeRateListCell"];
    }
    
    NSString *countryNameCode = [[GlobleObject getInstance].currentChineseRates objectAtIndex:indexPath.row];
    NSString *countryName = [[GlobleObject getInstance].countrysName stringAttribute:countryNameCode];
    countryName = [countryName stringByAppendingString:countryNameCode];
    cell.textLabel.text = countryName;
    cell.showsReorderControl = YES;
//    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *movedCountryCode = [[GlobleObject getInstance].currentChineseRates objectAtIndex:sourceIndexPath.row];
    [[GlobleObject getInstance].currentChineseRates removeObjectAtIndex:sourceIndexPath.row];
    [[GlobleObject getInstance].currentChineseRates insertObject:movedCountryCode atIndex:destinationIndexPath.row];
    
    DLog(@"GlobleObject currentChineseRates = %@", [GlobleObject getInstance].currentChineseRates);
    
    NSNotification *notify = [NSNotification notificationWithName:@"TheCurrenyChineseRateIsChange" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GlobleObject getInstance].currentChineseRates.count == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"最少也得保留一个"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[GlobleObject getInstance].currentChineseRates removeObjectAtIndex:indexPath.row];
        [self.currentChineseRateTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    NSNotification *notify = [NSNotification notificationWithName:@"TheCurrenyChineseRateIsChange" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
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

-(void)currentChineseRatesChangedHandler
{
    [self.currentChineseRateTableView reloadData];
}

- (void)viewDidUnload {
    [self setMyBgImg:nil];
    [super viewDidUnload];
}

- (IBAction)addDown {
  //  DLog(@"%i", [GlobleObject getInstance].currentChineseRates.count);
    if ([GlobleObject getInstance].currentChineseRates.count == 18) {
        [MyUtilities showMessage:@"所以国家都已添加" withTitle:@"提示"];
    } else {
        [self performSegueWithIdentifier:@"showChineseExchangeRateAdding" sender:self];
    }
}

@end
