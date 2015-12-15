//
//  UIDevice+Helper.m
//  MaHuaDouDou
//
//  Created by dimmy on 14-2-10.
//  Copyright (c) 2014年 nineton. All rights reserved.
//

#import "UIDevice+Helper.h"

@interface UIDevice (Private)
@end

@implementation UIDevice (Helper)
- (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }  
    return jailbroken;  
}  
@end
