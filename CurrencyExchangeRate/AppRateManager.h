//
//  AppRateManager.h
//  Calendar_New_UI
//
//  Created by jason luo on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRateManager : NSObject {
    NSString *_title;
    NSString *_url;
}

//Default is 3
@property (assign, nonatomic) int showAfterLaunchCount;

//call in  "- (void)applicationDidBecomeActive:(UIApplication *)application"
+(void) appActive;
//call in "- (void)applicationDidEnterBackground:(UIApplication *)application"
+(void) appDeactive;

-(id) initWithTitle:(NSString*)title URL:(NSString*)url;
-(void) smartShow;
-(void) forceShow;

@end
