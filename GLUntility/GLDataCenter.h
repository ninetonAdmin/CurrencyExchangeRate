//
//  GLDataCenter.h
//  NewDianDianProj
//
//  Created by dimmy on 14-6-28.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLDataCenter : NSObject

@property(nonatomic,assign) BOOL showDot;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, strong) NSMutableArray *allGdtNativeAdDatas;


+(GLDataCenter*)sharedInstance;

-(void)initData;

//-(NSArray*)getArticlesFromServerOf:(NSDate*)date;
//- (NSArray *)getArticlesFromServerOf:(NSDate *)date andPageNum:(NSInteger)aPage;

//-(NSDictionary*)getArticlesFromLocal;
//-(void)saveArticles:(NSDictionary*)dic;

//-(NSDate*)getRandomDateInLegalRange:(int)year month:(int)month day:(int)day;

@end
