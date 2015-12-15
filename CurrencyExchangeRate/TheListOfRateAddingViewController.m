//
//  TheListOfRateAddingViewController.m
//  CurrencyExchangeRate
//
//  Created by HuangZhenPeng on 12-11-19.
//  Copyright (c) 2012年 HuangZhenPeng. All rights reserved.
//

#import "TheListOfRateAddingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobleObject.h"
#import "AppUtility.h"

@interface TheListOfRateAddingViewController ()

@end

@implementation TheListOfRateAddingViewController

-(NSMutableArray *)listRateCountrys
{
    if (!_listRateCountrys) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ListOfRate" ofType:@"plist"];
        _listRateCountrys = [[NSMutableArray alloc] initWithContentsOfFile:path];
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
    
//    self.myBgImg.image = [[UIImage imageNamed:@"main-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
//    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-normal.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateNormal];
//    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button-background-style01-active.png"] resizableBackgroundImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5) setImage:nil forState:UIControlStateHighlighted];
    
//    self.listOfRateAddingTableView.layer.masksToBounds = YES;
//    self.listOfRateAddingTableView.layer.cornerRadius = 10;
    
    //设置索引列文本的颜色
    self.listOfRateAddingTableView.sectionIndexColor = [UIColor whiteColor];
    
//    [self.view setBackgroundColor:[UIColor clearColor]];
    
//    [self.listOfRateAddingTableView setBackgroundColor:[UIColor clearColor]];
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    // self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    // 添加 searchbar 到 headerview
    // self.listOfRateAddingTableView.tableHeaderView = self.searchBar;
    
//    self.searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    self.searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    self.searchDisplayController.searchResultsDelegate = self;
    
//    [self.searchDisplayController setActive:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [self setListOfRateAddingTableView:nil];
    [self setMyBgImg:nil];
    [super viewDidUnload];
}

- (IBAction)cancelDown {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.listOfRateAddingTableView) {
        return self.listRateCountrys.count;
    } else {
        // 谓词搜索
//        self.listOfRateAddingTableView.frame = CGRectMake(0, 20, DEVICE_WIDTH, DEVICE_HEIGHT - 20);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", self.searchBar.text];
        self.filterData =  [[NSArray alloc] initWithArray:[self.listRateCountrys filteredArrayUsingPredicate:predicate]];
        return self.filterData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (tableView == self.listOfRateAddingTableView) {
//        return 30;
//    }
    
    return 0;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"常用货币";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* myView = [[UIView alloc] init];
//    if(tableView == self.listOfRateAddingTableView) {
//        myView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 90, 22)];
//        titleLabel.textColor=[UIColor blackColor];
//        titleLabel.text= @"常用货币";
//        [myView addSubview:titleLabel];
//    }
//    
//    return myView;
//}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *code;
    if (tableView == self.listOfRateAddingTableView) {
        code = [self.listRateCountrys objectAtIndex:indexPath.row];
    } else {
        code = [self.filterData objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListOfRateAddingTableCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListOfRateAddingTableCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *chineseNameOfCountry = [[GlobleObject getInstance].countrysName objectForKey:code];
    chineseNameOfCountry = [chineseNameOfCountry stringByAppendingString:@" "];
    cell.textLabel.text = [chineseNameOfCountry stringByAppendingString:code];

    if ([code isEqualToString:[GlobleObject getInstance].listOfRateBaseCountry]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *code;
    if(tableView == self.listOfRateAddingTableView) {
        code = [self.listRateCountrys objectAtIndex:indexPath.row];
    } else {
        code = [self.filterData objectAtIndex:indexPath.row];
    }

    //发通知
    NSNotification *noti = [NSNotification notificationWithName:@"SelectANewBaseCountryOfListOfRate" object:code];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    //返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// 取消搜索或者改变搜索条件
- (void)resetSearch
{
    self.resultModelArr = [self.listRateCountrys copy]; //得到所有字典的副本 得到一个字典
    NSLog(@"所有字典 = %@",self.words);
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];//创建一个可变数组
    [keyArray addObjectsFromArray:[[self.allWords allKeys]sortedArrayUsingSelector:@selector(compare:)]]; //用指定的selector对array的元素进行排序
    self.keys = keyArray; //将所有key 存到一个数组里面
    NSLog(@"所有key = %@",self.keys);
}

//实现搜索方法
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsRemove = [[NSMutableArray alloc]init]; //创建一个数组存放我们所找到的空分区
    [self resetSearch];
    
    for(NSString *key in self.keys)//遍历所有的key
    {
        NSMutableArray *array = [_words valueForKey:key] ;     //得到当前键key的名称 数组
        NSMutableArray *toRemove = [[NSMutableArray alloc]init];//需要从words中删除的值 数组
        
        //实现搜索
        for(NSString *word in array) {
            //搜索时忽略大小写,把没有搜到的值放到要删除的对象数组中去
            if([word rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound) {
              [toRemove addObject:word]; //把没有搜到的内容放到 toRemove中去
            }
        }
        
        // 校对要删除的名称数组长度和名称数组长度是否相等
        if([array count] == [toRemove count]) {
            [sectionsRemove addObject:key]; //相等 则整个分区组为空
        }
        
        [array removeObjectsInArray:toRemove]; //否则 删除数组中所有与数组toRemove包含相同的元素
    }
    
    [self.keys removeObjectsInArray:sectionsRemove];// 删除整个key 也就是删除空分区，释放用来存储分区的数组，并重新加载table 这样就实现了搜索
    [_table reloadData];
}
*/

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.listOfRateAddingTableView) {
    return [[NSArray alloc] initWithObjects:@"#", @"@", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W",@"X", @"Y", @"Z", nil];
    } else {
        return nil;
    }
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    
    UIButton *cancelButton = nil;
    //[[AppUtility systemVersion] floatValue]
    if (CURRENT_DEVICE < 7.0) {
        // iOS < 7.0
        for (UIView *subView in self.searchDisplayController.searchBar.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                cancelButton = (UIButton*)subView;
            }
        }
    } else {
        UIView *topView = self.searchDisplayController.searchBar.subviews[0];
        for (UIView *subView in topView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                cancelButton = (UIButton*)subView;
            }
        }
    }
    
    if (cancelButton) {
        // 设置按钮文本
        [cancelButton setTitle:@"取消"forState:UIControlStateNormal];
    }
}

//- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
//{
//    [UIView animateWithDuration:0.25f delay:0.0f
//                        options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//                         CGRect frame = controller.searchContentsController.view.frame;
//                         CGRect frame2 = controller.searchBar.frame;
//                         frame.origin.y -= 44;
//                         frame.size.height +=44;
//                         
//                         controller.searchContentsController.view.frame = frame;
//                         [self.listOfRateAddingTableView setFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT + 44)];
//                     }
//                     completion:^(BOOL finished){
//                     }];
//}

//-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController*)controller
//{
//    // animate search bar back to its previous position and size
//    // in my case it was x=55, y=1
//    // and reduce its width by the amount moved, again 55px
//    // the UIViewAnimationOptionLayoutSubviews is IMPORTANT,
//    // otherwise you get no animation
//    // but some kind of snap-back movement
//    [UIView animateWithDuration:0.25f delay:0.0f
//                        options:UIViewAnimationOptionLayoutSubviews
//                     animations:^{
//                         CGRect frame = controller.searchContentsController.view.frame;
//                         frame.origin.y += 44;
//                         frame.size.height -=44;
//                         controller.searchContentsController.view.frame = frame;
//                         [self.listOfRateAddingTableView setFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT - 64)];
//                     }
//                     completion:^(BOOL finished){
//                         // when finished, insert any tool bar items you had
////                         [self.searchBar setItems:[NSArray arrayWithObject:self.currentLocationButton] animated:YES];
//                     }];
//}


//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    NSArray *subViews;
//
//    if ([[AppUtility systemVersion] floatValue] < 7.0) {
//        subViews = self.searchBar.subviews;
//    } else {
//        subViews = [(self.searchBar.subviews[0]) subviews];
//    }
//    
//    for (id view in subViews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton* cancelbutton = (UIButton* )view;
//            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
//            break;
//        }
//    }
//    
////    [self.searchDisplayController.searchResultsTableView reloadData];
//}

@end
