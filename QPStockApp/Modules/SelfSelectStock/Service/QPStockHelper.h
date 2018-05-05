//
//  QPStockHelper.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/14.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPSqlite3Helper.h"

@interface QPStockHelper : NSObject

+ (void)parseRequestResult:(NSData *)data
                 dataArray:(NSMutableArray *)dataArray;

+ (void)initDb;

+ (NSString*)findByTable;
+ (void)deleteTable:(NSString*)fullSymbol;
+ (void)insertTable:(NSString*)fullSymbol;

+ (void)mockTable;

@end
