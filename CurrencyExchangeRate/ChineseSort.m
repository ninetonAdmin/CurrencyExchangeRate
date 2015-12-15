//
//  ChineseSort.m
//  CurrencyExchangeRate
//
//  Created by YouLoft520 on 15/6/25.
//  Copyright (c) 2015年 HuangZhenPeng. All rights reserved.
//

#import "ChineseSort.h"
#import "ChineseString.h"
#import "PinYin.h"

@implementation ChineseSort

+ (NSArray *)srot:(NSArray *)stringsToSort
{
    // 获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    
    for(int i=0; i<[stringsToSort count]; i++)
    {
        ChineseString *chineseString = [[ChineseString alloc]init];
        
        chineseString.string = [NSString stringWithString:[stringsToSort objectAtIndex:i]];
        
        if(chineseString.string == nil || 0 == chineseString.string.length){
            chineseString.string = @"";
        }
        
        NSString *pinYinResult = [NSString string];
        for(int j=0; j<[chineseString.string rangeOfString:@" "].location; j++) {
            NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
            pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
        }
            
        chineseString.pinYin = pinYinResult;
        [chineseStringsArray addObject:chineseString];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    // 如果有需要，再把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
    }
    
    return result;
}

@end
