//
//  AppRateManager.m
//  Calendar_New_UI
//
//  Created by jason luo on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppRateManager.h"
//#import "iMagReaderAppDelegate.h"
//#import "ReadTextBaseController.h"

@implementation AppRateManager
@synthesize showAfterLaunchCount;


+(NSString*) launchCountKey {
    return [NSString stringWithFormat:@"AppRateManager.Launch-%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

+(void) appActive {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSDate date] forKey:@"AppRateManager.Begin"];
    NSString *appLaunchKey = [AppRateManager launchCountKey];
    NSNumber *launch = [userDefault objectForKey:appLaunchKey];
    int newLaunch = 1;
    if (nil != launch) {
        newLaunch = [launch intValue]+1;
    }
    [userDefault setObject:[NSNumber numberWithInt:newLaunch] forKey:appLaunchKey];
    [userDefault synchronize];
}

+(void) appDeactive {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *begin = [userDefault objectForKey:@"AppRateManager.Begin"];
    if (nil != begin) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:begin];
        NSTimeInterval oldInterval = interval;
        NSTimeInterval newInterval = interval;
        NSNumber *last = [userDefault objectForKey:@"AppRateManager.Last"];
        if (nil != last) {
            oldInterval = [last doubleValue];
            newInterval = (interval + oldInterval)/2.0;
        }
        [userDefault setObject:[NSNumber numberWithDouble:newInterval] forKey:@"AppRateManager.Last"];
        [userDefault synchronize];
    }
}

-(id) initWithTitle:(NSString*)title URL:(NSString*)url {
    self = [super init];
    if (self) {
        self.showAfterLaunchCount = 2;
        _title = [title copy];
        _url = [url copy];
    }
    return self;
}

-(void) smartShow {
//    [self performSelector:@selector(forceShow) withObject:nil afterDelay:3];
//    return;
    
    int launchCount = [[[NSUserDefaults standardUserDefaults] objectForKey:[AppRateManager launchCountKey]] intValue];
    NSTimeInterval lastTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppRateManager.Last"] doubleValue];
    NSString *skipVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppRateManager.Skip"];
    
    if (![skipVersion isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]) {
        if (launchCount > self.showAfterLaunchCount) {
            if (lastTime > 45) {//平均时长：60合适。
                [self performSelector:@selector(forceShow) withObject:nil afterDelay:lastTime-10];
            }
        }
    }
}

-(void) forceShow {
//    if ([MAINAPPDELEGATE.navViewController.visibleViewController isKindOfClass:[ReadTextBaseController class]]) {
//        return;
//    }
//    
//    MYLog(@"MAINAPPDELEGATE.navViewController.visibleViewController = %@", MAINAPPDELEGATE.navViewController.visibleViewController);
    
    if (nil != _title && nil != _url) {
        //self = [self retain];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_title delegate:self cancelButtonTitle:@"好" otherButtonTitles:@"下次再说",@"不再提醒", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    @try {
        switch (buttonIndex) {
            case 1://next time
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:[AppRateManager launchCountKey]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[StatisticHelper sendUmengEvent:@"RateClick" withLabel:@"Next"];
                break;
            case 0://ok
 
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                //[StatisticHelper sendUmengEvent:@"RateClick" withLabel:@"Accept"];
            case 2://never for this version
                [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"AppRateManager.Skip"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (buttonIndex == 2) {
                    //[StatisticHelper sendUmengEvent:@"RateClick" withLabel:@"Deny"];
                }
                break;
            default:
                break;
        }
        //[self release];
    }
    @catch (NSException *exception) {
        DLog(@"exception:%@",exception);
    }
}

-(void) dealloc {
    [super dealloc];
    
    [_title release];
    [_url release];
}

@end
