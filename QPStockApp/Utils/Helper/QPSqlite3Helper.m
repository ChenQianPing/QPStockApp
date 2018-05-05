//
//  QPSqlite3Helper.m
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/25.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//



#import "QPSqlite3Helper.h"

@implementation QPSqlite3Helper

/**
 * 获取沙盒目录
 @param name :追加的目录
 */
+ (NSString*)DataBaseName:(NSString *) name {
    NSString *fileName = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",name];
    return fileName;
}

+ (void)createTable:(NSString*)sql
        dataBaseName:(NSString*)dataName {
    
    sqlite3 *sqlite=nil;
    NSString *fileName=[self DataBaseName:dataName];
    
    // 打开数据库
    int result= sqlite3_open([fileName UTF8String], &sqlite);
    if (result!=SQLITE_OK) {
        NSLog(@"打开失败");
    } else {
        const char* sqlCh=[sql UTF8String];
        char* error;
        // 执行SQL
        int result=sqlite3_exec(sqlite, sqlCh, NULL, NULL, &error);
        if (result!=SQLITE_OK) {
            NSLog(@"创建失败%s",error);
            sqlite3_close(sqlite);
            return ;
        }
        // 关闭数据库
        sqlite3_close(sqlite);
        NSLog(@"创建成功");
    }
}

+ (BOOL)execSql:(NSString*)sql
         parmas:(NSArray*)params
   dataBaseName:(NSString*)dataName {
    
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    // 打开数据库
    NSString *fileName = [self DataBaseName:dataName];
    int result= sqlite3_open([fileName UTF8String], &sqlite);
    if (result!=SQLITE_OK) {
        NSLog(@"打开失败");
        return NO;
    }
    
    NSLog(@"sql:%@",sql);
    NSLog(@"params:%@",params);
    
    const char* sqlCh=[sql UTF8String];
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, sqlCh, -1, &stmt, NULL);
    // 绑定参数
    for (int i=0; i<params.count; i++) {
        NSString *parm=[params objectAtIndex:i];
        
        NSLog(@"parm:%@",parm);
        sqlite3_bind_text(stmt, i+1, [parm UTF8String], -1, NULL);
    }
    // 执行SQL
    result=sqlite3_step(stmt);
    if (result==SQLITE_ERROR || result==SQLITE_MISUSE) {
        NSLog(@"执行SQL语句失败");
        sqlite3_close(sqlite);
        return  NO;
    }
    // 关闭数据库句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    NSLog(@"执行成功！");
    return YES;
    
}

+ (NSMutableArray*)selectSql:(NSString*)sql
                      parmas:(NSArray*)params
                dataBaseName:(NSString*)dataName {
    
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    // 打开数据库
    NSString *fileName = [self DataBaseName:dataName];
    int result = sqlite3_open([fileName UTF8String], &sqlite);
    if (result!=SQLITE_OK) {
        NSLog(@"打开失败");
        return nil;
    }
    
    const char* sqlCh=[sql UTF8String];
    // 编译SQL语句
    sqlite3_prepare_v2(sqlite, sqlCh, -1, &stmt, NULL);
    // 绑定参数
    for (int i=0; i<params.count; i++) {
        NSString *param=[params objectAtIndex:i];
        sqlite3_bind_text(stmt, i+1, [param UTF8String], -1, NULL);
    }
    
    // 执行查询语句
    result = sqlite3_step(stmt);
    NSMutableArray *resultData=[NSMutableArray array];
    // 遍历结果
    while (result==SQLITE_ROW) {
        NSMutableDictionary *resultRow=[NSMutableDictionary dictionary];
        // 获取字段个数
        int col_count = sqlite3_column_count(stmt);
        for (int i=0; i<col_count; i++) {
            // 获取字段名称
            const char*columName = sqlite3_column_name(stmt,i);
            // 获取字段值
            char* columValue = (char*)sqlite3_column_text(stmt, i);
            NSString  *columkeyStr = [NSString stringWithCString:columName encoding:NSUTF8StringEncoding];
            NSString *columValueStr=[NSString stringWithCString:columValue encoding:NSUTF8StringEncoding];
            [resultRow setObject:columValueStr forKey:columkeyStr];
        }
        [resultData addObject:resultRow];
        result = sqlite3_step(stmt);
    }
    // 关闭数据库句柄
    sqlite3_finalize(stmt);
    // 关闭数据库
    sqlite3_close(sqlite);
    NSLog(@"查询完!");
    return  resultData;
    
}

+ (void)initSqlite3:(NSString*)dataName createsql:(NSString*)createsql {
    
    /**
     * 数据库名:stock.db
     * 表名:self_stock
     * 具体内容:
     * id integer,自动增量  主键Id
     * phone text,手机号
     * fullSymbol text, 完整的代码,如:sz000812,sz000027
     * time text,时间
     
     * dataName:stock.db
     * createsql:create table if not exists self_stock(id integer primary key autoincrement,phone text,fullSymbol text,time text
     */
    
    sqlite3 *dataBase;
    NSString *databasePath;
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:dataName]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
            char *errmsg;
            const char *createsql = createsql;
            if (sqlite3_exec(dataBase, createsql, NULL, NULL, &errmsg)!=SQLITE_OK) {
                NSLog(@"create table failed.");
            }
        }
        else {
            NSLog(@"create/open failed.");
        }
    }
    else {
        NSLog(@"create/open success.");
    }
    
    
}

@end







