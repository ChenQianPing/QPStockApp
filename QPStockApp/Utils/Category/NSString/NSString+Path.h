//
//  NSString+Path.h
//  沙盒
//
//  Created by 小果 on 14-7-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

+ (NSString *)documentPath;  // 文档目录
+ (NSString *)cachePath;     // 缓存目录
+ (NSString *)tempPath;      // 临时目录

- (NSString *)appendDocumentPath;    // 添加文档路径
- (NSString *)appendCachePath;       // 添加缓存路径
- (NSString *)appendTempPath;        // 添加临时路径

@end
