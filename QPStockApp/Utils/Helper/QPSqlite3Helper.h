//
//  QPSqlite3Helper.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/25.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

/**
 * IOS Sqlite3数据库增删改查
 * http://www.cnblogs.com/gccbuaa/p/6714491.html
 * http://www.cnblogs.com/whzhaochao/p/5023435.html
 */

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface QPSqlite3Helper : NSObject

/**
 创建一个表
 @param sql 执行的SQL语句
 @param dataName 数据库名称
 */
+ (void)createTable:(NSString*)sql
        dataBaseName:(NSString*)dataName;

/**
 * 执行SQL语句,主要完成增加、修改、删除
 @param sql 执行的SQL语句
 @param params SQL语句中的参数
 @param dataName 数据库名称
 */
+ (BOOL)execSql:(NSString*)sql
          parmas:(NSArray*)params
    dataBaseName:(NSString*)dataName;

/**
 * 选择数据
 @param sql 执行的SQL语句
 @param params SQL语句中的参数
 @param dataName 数据库名称
 */
+ (NSMutableArray*)selectSql:(NSString*)sql
                       parmas:(NSArray*)params
                 dataBaseName:(NSString*)dataName;

+ (void)initSqlite3:(NSString*)dataName createsql:(NSString*)createsql;

@end
