//
//  RateNoticeCountryChangeViewController.m
//  CurrencyExchangeRate
//
//  Created by 严明俊 on 13-10-15.
//  Copyright (c) 2013年 HuangZhenPeng. All rights reserved.
//

#import "RateNoticeCountryChangeViewController.h"
#import "GlobleObject.h"

@interface RateNoticeCountryChangeViewController ()

@end

@implementation RateNoticeCountryChangeViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)listRateCountrys
{
    if (!_listRateCountrys) {
        NSArray *countrys = [[GlobleObject getInstance].chineseRates allKeys];
        _listRateCountrys = countrys;
    }
    
    return _listRateCountrys;
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
    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
//    self.table.layer.masksToBounds = YES;
//    self.table.layer.cornerRadius = 10;
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setTable:nil];
    [self setMyBgImg:nil];
    [super viewDidUnload];
}
- (IBAction)cancelDown {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listRateCountrys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *code = [self.listRateCountrys objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListOfRateAddingTableCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListOfRateAddingTableCell"];
    }
    
    NSString *chineseNameOfCountry = [[GlobleObject getInstance].countrysName objectForKey:code];
    
    NSString *title = [chineseNameOfCountry stringByAppendingString:code];
    
    if ([code isEqualToString:self.countryCode]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentController changeCountry:[self.listRateCountrys objectAtIndex:indexPath.row]];
    //返回
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
