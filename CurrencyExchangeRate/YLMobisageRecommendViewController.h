//
//  YLMobisageRecommendViewController.h
//  iMagReader
//
//  Created by zuo wq on 13-9-30.
//
//

#import <UIKit/UIKit.h>
#import "MobiSageSDK.h"

@interface YLMobisageRecommendViewController : UITableViewController<MobiSageRecommendDelegate>
@property (nonatomic, retain) MSRecommendContentView *recommendView;
@end
