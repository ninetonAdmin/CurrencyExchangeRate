//
//  YLDomobWallViewController.h
//  CalendarOS7
//
//  Created by jason luo on 1/4/14.
//  Copyright (c) 2014 YouLoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAdWallDataManager.h"
#import "DMAsyncImageView.h"
#import "DMAWAdInfo.h"
#import "DMAWConrtolInfo.h"
#import "MyCustomButton.h"
//#import "YLNewPromotionViewController.h"


typedef enum {
    DMWallCategoryGame = 1,
    DMWallCategoryApp,
    DMWallCategoryAll
} DMWallCategory;

@interface YLDomobWallViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,DMAdWallDataManagerDelegate> {
    DMAWConrtolInfo *_controlInfo;
    DMAdWallDataManager *_manager;
    
    UITableView *_tableView;
    
    UILabel *_moreLabel;
//    NSInteger _adCount;
    NSMutableArray *_adArray;
    NSMutableDictionary *_reportedAdIdDic; // 发送过展现报告的广告ID
    double _lastRequestTime;

    UIView *_mLoadingWaitView;
    UILabel *_mLoadingStatusLabel;
    UIImageView *_mNoNetworkImageView;
    UIActivityIndicatorView *_mLoadingActivityIndicator;
    
}

//@property (nonatomic, retain)
@property (nonatomic,assign) DMWallCategory wallCategory;

- (id)initWithPublisherId:(NSString *)publisherId placementId:(NSString *)placementId parentViewController:(UIViewController*)pvc;

- (void) sendCloseReport;

-(void) updateTableViewLayout;
@end
