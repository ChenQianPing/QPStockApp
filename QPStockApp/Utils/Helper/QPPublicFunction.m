//
//  QPPublicFunction.m
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/25.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "QPPublicFunction.h"

@implementation QPPublicFunction


/**
 * 获取当前时间;
 */
+ (NSString *)getCurrentTime {
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *result = [dateformatter stringFromDate:senddate];
    return result;
}

@end
