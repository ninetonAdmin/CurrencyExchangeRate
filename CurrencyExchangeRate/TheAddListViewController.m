//
//  TestViewController.m
//  CurrencyExchangeRate
//
//  Created by YouLoft520 on 15/6/23.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import "TheAddListViewController.h"

#import "GlobleObject.h"
#import "PinYin.h"
#import "ChineseSort.h"
#import "JCRBlurView.h"

@interface TheAddListViewController ()
{
    NSMutableDictionary *dataDic;
    
    // 索引数组
    NSMutableArray *dataSource;
    // 数据源
    NSArray *dataBase;
    // 数据模板
    NSArray *dataTemp;
}
@end

@implementation TheAddListViewController

- (instancetype)initWithBg:(UIImage *)img
{
    self = [super init];
    
    if(self) {
        self.bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [self.bgImageview setBackgroundColor:[UIColor whiteColor]];
        [self.bgImageview setImage:img];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.view setBackgroundColor:[UIColor blackColor]];
//    [self.view setAlpha:0.97];
    
//    JCRBlurView *blurView = [JCRBlurView new];
//    [blurView setFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    [blurView setBlurTintColor:nil];
//    [blurView setAlpha:0.94];
//    [self.view addSubview:blurView];

    // 模糊背景
    [self.view addSubview:self.bgImageview];
    
    // 黑色透明背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.8];
    [self.view addSubview:bgView];
    
    // 标题栏
    UIView *headerView;
    if (CURRENT_DEVICE < 7.0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, DEVICE_WIDTH, 64)];
    } else {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    }
    [self.view addSubview:headerView];
    
    // 添加closeButton
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 55, 37)];
    [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [headerView addSubview:self.closeBtn];
    
    // 标题
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(55, 23, DEVICE_WIDTH - 110, 37)];
    self.titleLable.text = @"货币转换";
    self.titleLable.textColor = [UIColor whiteColor];
    self.titleLable.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.titleLable];
    
    // 添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT - 64) style:UITableViewStylePlain];
    [self.tableView setSeparatorColor:[UIColor grayColor]];
    [self.tableView setAutoresizesSubviews:YES];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    // 改变索引及其背景颜色
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    // 添加搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    self.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchBar.translucent = YES;
    self.searchBar.showsCancelButton = NO;
    [self.searchBar setPlaceholder:@"搜索货币名称或英文缩写"];
    [self.searchBar setDelegate:self];
    [self.searchBar sizeToFit];
    [self.tableView setTableHeaderView:self.searchBar];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    // 数据字典 key-Array
    dataDic = [NSMutableDictionary dictionary];
    // 索引数组
    dataSource = [NSMutableArray  array];
    // 数据源
    dataBase = [NSArray array];
    // 数据模板
    dataTemp = [NSArray array];
    
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    // 取消选中的cell
    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
    
    for(NSIndexPath * indexPath in indexPaths) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

- (NSString *)splitNameCode:(NSString *)strNameCode
{
    NSArray* dataArray = [strNameCode componentsSeparatedByString: @" "];
    return [dataArray objectAtIndex:dataArray.count - 1];
}

- (NSArray *)searData:(NSString *) keyWord
{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (NSString *strNameCode in dataTemp)
    {
        if ([strNameCode containsString:keyWord]) {
            [tempArr addObject:[strNameCode copy]];
        }
    }
    
    return tempArr;
}

- (void)initData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListOfRate" ofType:@"plist"];
    NSArray *dataArr = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *dataFormatArr = [[NSMutableArray alloc] init];
    for (NSString *countryCode in dataArr) {
        [dataFormatArr addObject:[[[GlobleObject getInstance].countrysName objectForKey:countryCode] stringByAppendingFormat:@"  %@", countryCode]];
    }
    
    // 汉字首字母排序
    dataTemp = [ChineseSort srot:dataFormatArr];
    dataBase = [dataTemp copy];
    
    // 初始化数据
    for (NSString *countryName in dataBase)
    {
        NSString *upperCase = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([countryName characterAtIndex:0])] uppercaseString];
        NSMutableArray *arr = [dataDic objectForKey:upperCase];
        
        if (!arr) {
            [dataSource addObject:upperCase];
            arr = [[NSMutableArray alloc] initWithObjects:countryName, nil];
            [dataDic setValue:arr forKey:upperCase];
        } else {
            [arr addObject:countryName];
        }
    }
}


#pragma mark - SearchBar Delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击取消按钮");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击了按钮");
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchBar %@", searchText);
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length > 0) {
        self.tableView.sectionIndexColor = [UIColor clearColor];
        dataBase = [self searData:[searchText uppercaseString]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } else {
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return dataSource;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 搜索过程中检索不可用
    NSString *str = self.searchBar.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        return -1;
    }
    
    NSInteger count = 0;
//    NSLog(@"%@-%d", title, index);
    
    for(NSString *character in dataSource)
    {
        if([character isEqualToString:title]) {
            return count;
        }
        
        count ++;
    }
    
    return 0;
}

// 返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSString *str = self.searchBar.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        return 1;
    } else {
        return [dataSource count];
    }
}

// 返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [dataSource objectAtIndex:section];
}

// 返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *str = self.searchBar.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        return dataBase.count;
    } else {
        return ((NSMutableArray *)[dataDic objectForKey:dataSource[section]]).count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = RGBColor(243.0f, 243.0f, 243.0f, 1.0f);
    }
    
    NSString *str = self.searchBar.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        cell.textLabel.text = dataBase[indexPath.row];
    } else {
        cell.textLabel.text = ((NSMutableArray *)([dataDic objectForKey:dataSource[indexPath.section]]))[indexPath.row];
    }
    
    NSLog(@"%@", cell.textLabel.text);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *code;
    NSString *str = self.searchBar.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length > 0) {
        code = dataBase[indexPath.row];
    } else {
        code = ((NSMutableArray *)([dataDic objectForKey:dataSource[indexPath.section]]))[indexPath.row];
    }
    
    code = [self splitNameCode:code];
    
    //发通知
    NSNotification *noti = [NSNotification notificationWithName:@"SelectANewBaseCountryOfListOfRate" object:code];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    //返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Event

- (void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}

@end
