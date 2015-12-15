//
//  YLMobisageRecommendViewController.m
//  iMagReader
//
//  Created by zuo wq on 13-9-30.
//
//

#import "YLMobisageRecommendViewController.h"
#import "MyUtilities.h"
#import <StoreKit/StoreKit.h>
#import "MobClick.h"

#define MobiSage_Table_Recommend_Tag 1001  //表格式荐计划视图的tag值

#define RecommendAdCount 10

@interface YLMobisageRecommendViewController () <SKStoreProductViewControllerDelegate>

@end

@implementation YLMobisageRecommendViewController

- (void)dealloc
{
    [_recommendView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"应用推荐";
    self.recommendView = [[[MSRecommendContentView alloc] initWithdelegate:self width:(UIUserInterfaceIdiomPad==UI_USER_INTERFACE_IDIOM()?500:300) adCount:RecommendAdCount] autorelease];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.recommendView addSubview:label];
    [label release];
    self.recommendView.tag=MobiSage_Table_Recommend_Tag;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self setupOurRecommendView];
}




- (void)setupOurRecommendView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 112.f)];
    titleView.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(16.f, 20.f, 60.f, 60.f);
    [button setBackgroundImage:[UIImage imageNamed:@"wnl-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calendarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(91.f, 20.f, 60.f, 60.f);
    [button setBackgroundImage:[UIImage imageNamed:@"tqyb-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(weatherIndicateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10.f;
    [titleView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(168.f, 20.f, 60.f, 60.f);
    [button setBackgroundImage:[UIImage imageNamed:@"shuxiang-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(243.f, 20.f, 60.f, 60.f);
    [button setBackgroundImage:[UIImage imageNamed:@"yitao-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(yitaoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10.f;
    [titleView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28.f, 83.f, 36.f, 15.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"万年历";
    [titleView addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(85.f, 83.f, 72.f, 15.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"中央天气预报";
    [titleView addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(174.f, 83.f, 48.f, 15.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"书香云集";
    [titleView addSubview:label];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(261.f, 83.f, 24.f, 15.f)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"易淘";
    [titleView addSubview:label];
    [label release];
    
    self.tableView.tableHeaderView = titleView;
    [titleView release];
}

//NSString *openUrl = [NSString stringWithFormat:@"youloft.%@://",appid];
//if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:openUrl]]) {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[openUrl stringByAppendingFormat:@"schmId=%@", SelfItunesAppId]]];
//}


- (void)openAppId:(NSString *)appId
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ourapplist" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if ([str rangeOfString:appId].location!=NSNotFound) {
        NSString *openUrl = [NSString stringWithFormat:@"youloft.%@://",appId];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:openUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[openUrl stringByAppendingFormat:@"schmId=%@", @"youloft.570604441"]]];
            return;
        }
        else
        {
            if (DeviceSystemMajorVersion() >= 6.0) {
                [self showStoreViewByIdentifer:appId];
                return;
            }
            else
            {
                NSString *urlString = nil;
                if ([appId isEqualToString:@"455611831"])
                    urlString = @"https://itunes.apple.com/cn/app/zhong-yang-tian-qi-yu-bao/id455611831?mt=8";
                else if ([appId isEqualToString:@"419805549"])
                    urlString = @"https://itunes.apple.com/cn/app/wan-nian-li/id419805549?mt=8";
                else if ([appId isEqualToString:@"535742398"])
                    urlString = @"https://itunes.apple.com/cn/app/shu-xiang-yun-ji/id535742398?mt=8";
                else if ([appId isEqualToString:@"635194542"])
                    urlString = @"https://itunes.apple.com/cn/app/yi-tao-tao-bao-gou-wu-di-yi/id635194542?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }
        }
    }
}

- (void)calendarButtonPressed:(id)sender
{
    NSLog(@"calendar");
    [self openAppId:@"419805549"];
}

- (void)weatherIndicateButtonPressed:(id)sender
{
    NSLog(@"weather");
    [self openAppId:@"455611831"];
}

- (void)bookButtonPressed:(id)sender
{
    NSLog(@"book");
    NSString *sxid = [MobClick getConfigParams:@"sxyjappid"];
    if (!sxid || sxid.length != 9) {
        sxid = @"535742398";
    }
    [self openAppId:sxid];
}


- (void)yitaoButtonPressed:(id)sender
{
    [self openAppId:@"635194542"];
}

- (void)backButtonPressed
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        
        cell.textLabel.text = nil;
        UIView *subView = [cell.contentView viewWithTag:MobiSage_Table_Recommend_Tag];
    
        if (subView != self.recommendView) {
            
            [cell.contentView addSubview:self.recommendView];
        }
    
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 157 * RecommendAdCount * (300.0/640.0);
}

#pragma mark - MobiSageRecommendDelegate 委托函数
#pragma mark

- (UIViewController *)viewControllerForPresentingModalView {
    
    return self;
}
    
#pragma mark SKStoreProductViewControllerDelegate

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showStoreViewByIdentifer:(NSString*)appid {
    
    SKStoreProductViewController *storeViewController = [[[SKStoreProductViewController alloc] init] autorelease];
    
    storeViewController.delegate = self;
    
    int intAppId = [appid intValue];
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:[NSNumber numberWithInteger:intAppId]};
    
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                   }];
    
    //    if (result)
    [self presentViewController:storeViewController
                       animated:YES
                     completion:nil];
    
}
@end
