//
//  CEMenuViewController.m
//  CurrencyExchangeRate
//
//  Created by admin on 14/12/11.
//  Copyright (c) 2014年 HuangZhenPeng. All rights reserved.
//

#import "CEMenuViewController.h"
#import "RMStore.h"
#import "MyUtilities.h"
#import "AboutUsViewController.h"
#import "AboutCurrenyRateViewController.h"
#import "RateNoticeViewController.h"
#import "MobClick.h"

@interface CEMenuViewController ()<RMStoreObserver>
{
    int lastSelectViewIndex;//表示上一次选择的界面是哪个，用于在用户选择一个界面时，动画时隐藏先前的界面
}

@end

@implementation CEMenuViewController

- (void)dealloc
{
    [[RMStore defaultStore] removeStoreObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBarImageView setImage: [[UIImage imageNamed:@"v2-navigationbar-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(63, 5, 63, 5)]];
    
//    UISwipeGestureRecognizer *recongnizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recongnizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:recongnizer];
    
    lastSelectViewIndex = 0; //默认为即时汇率界面
    [[RMStore defaultStore] addStoreObserver:self];
    
    NSArray *products = @[VIP_PURCHASE, UPDATE_PURCHASE, SUPERVIP_PURCHASE];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:products] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        _productsRequestFinished = YES;
        //        [self.menuTableview reloadData];
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        [AppUtility showMBLodingWithMessage:@"请求内购商品信息失败"];
    }];
}

//-(void)handleSwipeFrom:(UISwipeGestureRecognizer *) recongnizer
//{
//    if (recongnizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//        DLog(@"swipe Left");
//        NSNotification *notify = [NSNotification notificationWithName:@"MenuLeftSwipe" object:[NSNumber numberWithInt:lastSelectViewIndex]];
//        [[NSNotificationCenter defaultCenter] postNotification:notify];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMenuBgImg:nil];
    [self setShadowView:nil];
    [self setMenuTableview:nil];
    [super viewDidUnload];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100.0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 100.f)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (0 == section) {
        RMStore *defaultStore = [RMStore defaultStore];
        BOOL updateVIP = [defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE];
        BOOL superVIP = [defaultStore isPurchasedForIdentifier:SUPERVIP_PURCHASE];
        
        if (updateVIP || superVIP) {
            //如果是超级VIP
            return 0;
        } else if ([defaultStore isPurchasedForIdentifier:VIP_PURCHASE]) {
            return 1;
        }
        
        return 2;
    } else {
        NSString *showFlag = [MobClick getConfigParams:@"showaboutus"];
        
        if (showFlag != nil && [showFlag isEqualToString:@"1"]) {
            return 3;
        } else {
            return 2;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableCell"];
//        cell.backgroundColor = [UIColor clearColor];
        
//        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main-menu-list-background.png"]];
//        bgImg.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
//        bgImg.backgroundColor = [UIColor clearColor];
//        [cell addSubview:bgImg];
        
        
//        UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-icon-style02.png"]];
//        arrowIcon.frame = CGRectMake(240 + 50, 14, 9, 15);
//        [arrowIcon setTag:22];
//        [cell addSubview:arrowIcon];
//        
//        UILabel *label = [[UILabel alloc] init];
////        label.textColor = [UIColor colorWithRed:177.0/255.0 green:157.0/255.0 blue:128.0/255.0 alpha:1.0];
//        label.textColor = [UIColor blackColor];
//        label.backgroundColor = [UIColor clearColor];
////        label.shadowColor = [UIColor blackColor];
////        label.shadowOffset = CGSizeMake(0, -1.0);
//        
//        CGRect frame = CGRectMake(10, 0, 275, 44);
//        label.frame = frame;
//        label.font = [UIFont systemFontOfSize:20];
//        [label setTag:11];
//        [cell addSubview:label];
        
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
//        cell.selectedBackgroundView = view;
    }
    
//    if (indexPath.section == 0)
//        switch (indexPath.row) {
//            case 3:
//                ((UILabel *)[cell viewWithTag:11]).text = @"即时汇率";
//                //cell.textLabel.text = @"即时汇率";
//                break;
//            case 2:
//                ((UILabel *)[cell viewWithTag:11]).text = @"汇率列表";
//                //cell.textLabel.text = @"汇率列表";
//                break;
//            case 0:
//                ((UILabel *)[cell viewWithTag:11]).text = @"提醒管理";
//                //cell.textLabel.text = @"关于我们";
//                break;
//                
//            default:
//                break;
//        }
//    else
    if (indexPath.section == 0)
    {
        ((UIImageView *)[cell viewWithTag:22]).hidden = YES;
        RMStore *defaultStore = [RMStore defaultStore];
        if ([defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE] || [defaultStore isPurchasedForIdentifier:SUPERVIP_PURCHASE]) {
            //如果是超级VIP
            switch (indexPath.row) {
                case 0:
//                    ((UILabel *)[cell viewWithTag:11]).text = @"恢复采购";
                    
//                    cell.textLabel.text = @"恢复采购";
//                    break;
                default:
                    break;
            }
        } else if ([defaultStore isPurchasedForIdentifier:VIP_PURCHASE]) {
            switch (indexPath.row) {
                case 0:
                    
                    cell.imageView.image = [UIImage imageNamed:@"v2-VIP10.png"];
                    cell.textLabel.text = @"升级超级VIP";
                    
//                    ((UILabel *)[cell viewWithTag:11]).text = @"升级超级VIP￥6";
                    break;
//                case 1:
////                    ((UILabel *)[cell viewWithTag:11]).text = @"恢复采购";
//                    cell.textLabel.text = @"恢复采购";
//                    break;
                default:
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0:
//                    ((UILabel *)[cell viewWithTag:11]).text = @"购买VIP(10条提醒)￥6";
                    
                    cell.imageView.image = [UIImage imageNamed:@"v2-VIP10.png"];
                    cell.textLabel.text = @"购买VIP (10条提醒)";
                    break;
                case 1:
//                    ((UILabel *)[cell viewWithTag:11]).text = @"购买超级VIP(20条提醒)￥12";
                    
                    cell.imageView.image = [UIImage imageNamed:@"v2-VIP20.png"];
                    cell.textLabel.text = @"购买超级VIP (20条提醒)";
                    break;
//                case 2:
////                    ((UILabel *)[cell viewWithTag:11]).text = @"恢复采购";
//                    cell.textLabel.text = @"恢复采购";
//                    break;
                default:
                    break;
            }
        }
    } else {
        switch (indexPath.row) {
            case 0:
                //                ((UILabel *)[cell viewWithTag:11]).text = @"关于即时汇率";//@"关于我们";
                cell.textLabel.text = @"恢复采购";
                cell.textLabel.textColor = [UIColor blueColor];
                break;
            case 1:
//                ((UILabel *)[cell viewWithTag:11]).text = @"关于我们";
                cell.textLabel.text = @"关于我们";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                //                ((UILabel *)[cell viewWithTag:11]).text = @"关于即时汇率";//@"关于我们";
                cell.textLabel.text = @"关于即时汇率";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                //            case 2:
                //                ((UILabel *)[cell viewWithTag:11]).text = @"提醒管理";
                //                //cell.textLabel.text = @"关于我们";
                //                break;
                //            case 3:
                //                ((UILabel *)[cell viewWithTag:11]).text = @"精品推荐";
                //                //cell.textLabel.text = @"精品推荐";
                //                break;
                //                //            case 4:
                //                //                ((UILabel *)[cell viewWithTag:11]).text = @"提醒管理";
                //                //                //cell.textLabel.text = @"精品推荐";
                //                //                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)restorePayment
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.menuTableview reloadData];
        [MyUtilities showMessage:@"恢复成功" withTitle:@"提示"];
        
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"恢复失败", @"")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
}

- (void)addPayment:(NSString *)productIdentifier
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = [[UIView alloc] initWithFrame:window.bounds];
    view.backgroundColor = [UIColor clearColor];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = view.center;
    [view addSubview:indicatorView];
    [window addSubview:view];
    [indicatorView startAnimating];
    [[RMStore defaultStore] addPayment:productIdentifier success:^(SKPaymentTransaction *transaction) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [view removeFromSuperview];
        [self.menuTableview reloadData];
        [MyUtilities showMessage:@"购买成功" withTitle:@"提示"];
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [view removeFromSuperview];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"购买失败", @"")
                                                           message:error.localizedDescription
                                                          delegate:nil
                                                 cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                                 otherButtonTitles:nil];
        [alerView show];
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RMStore *defaultStore = [RMStore defaultStore];
        if ([defaultStore isPurchasedForIdentifier:UPDATE_PURCHASE] || [defaultStore isPurchasedForIdentifier:SUPERVIP_PURCHASE]) {
            //如果是超级VIP
//            switch (indexPath.row) {
//                case 0:
//                    [self restorePayment];
//                    break;
//                default:
//                    break;
//            }
        } else if ([defaultStore isPurchasedForIdentifier:VIP_PURCHASE]) {
            switch (indexPath.row) {
                case 0:
                    [self addPayment:UPDATE_PURCHASE];
                    break;
//                case 1:
//                    [self restorePayment];
//                    break;
                default:
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0:
                    [self addPayment:VIP_PURCHASE];
                    break;
                case 1:
                    [self addPayment:UPDATE_PURCHASE];
                    break;
//                case 2:
//                    [self restorePayment];
                    break;
                default:
                    break;
            }
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    } else if (indexPath.section == 1) {
        if (0 == indexPath.row) {
            [self restorePayment];
            return;
        }
        
        //每次选择了，发送一个消息，通知用户在菜单里面选择了一项，并传递一个数组，包含两个int（0代表主界面，1代表汇率列表界面），第一个表要隐藏的界面（当前界面），第二个表示应该显示出来的界面（用户选择要显示的界面）
        //DLog(@"a");
        NSInteger row;
    //    if (indexPath.section == 0)
    //        row = indexPath.row;
    //    else
            row = 3 + indexPath.row;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self presentViewControllerWithSelectIndex:row];
    }
}

- (void)presentViewControllerWithSelectIndex:(NSInteger)index
{
    NSNumber *num2 = [NSNumber numberWithInteger:index];
    //加载界面
    switch (num2.intValue) {
        case 5:
            {
                UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                AboutCurrenyRateViewController *auvc = [sd instantiateViewControllerWithIdentifier:@"AboutCurrencyRate"];
                [self presentViewController:auvc animated:YES completion:^{
                }];
                
            }
            break;
        case 4:
            {
                UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                AboutUsViewController *auvc = [sd instantiateViewControllerWithIdentifier:@"AboutUs"];
                [self presentViewController:auvc animated:YES completion:^{
                }];
            }
            break;
        case 0:
            {
                UIStoryboard *sd = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                RateNoticeViewController *auvc = [sd instantiateViewControllerWithIdentifier:@"RateNotice"];
                [self presentViewController:auvc animated:YES completion:^{
                }];
            }
            break;
        default:
            break;
    }
}


- (void)leftMoveShadowAfterDelay
{
    [self performSelector:@selector(leftMoveShadow) withObject:nil afterDelay:0.2f];
}

-(void) leftMoveShadow
{
    [UIView beginAnimations:@"LeftMoveShadowAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    CGRect frame = self.shadowView.frame;
    frame.origin.x -= DEVICE_WIDTH;
    self.shadowView.frame = frame;
    [UIView commitAnimations];
    //    self.shadowView.hidden = YES;
    
}

-(void) leftMoveShadow1
{
    [UIView beginAnimations:@"LeftMoveShadowAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    CGRect frame = self.shadowView.frame;
    frame.origin.x = -30.f;
    self.shadowView.frame = frame;
    [UIView commitAnimations];
    //    self.shadowView.hidden = YES;
    
}

-(void) rightMoveShadow
{
    self.shadowView.hidden = NO;
    CGRect frame1 = self.shadowView.frame;
    frame1.origin.x = 0;
    
    self.shadowView.frame = frame1;
    [UIView animateWithDuration:0.3 animations:^(void){
        CGRect frame = self.shadowView.frame;
        frame.origin.x += 245;
        self.shadowView.frame = frame;
    } completion:^(BOOL resualt){
    }];
}




#pragma mark RMStoreObserver

- (void)storeProductsRequestFinished:(NSNotification*)notification
{
    [self.menuTableview reloadData];
}

- (void)storePaymentTransactionFinished:(NSNotification*)notification
{
    [self.menuTableview reloadData];
}


@end
