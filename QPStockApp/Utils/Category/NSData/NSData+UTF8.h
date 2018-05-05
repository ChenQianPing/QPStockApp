//
//  NSData+UTF8.h
//  QPMyKit
//
//  Created by ChenQianPing on 17/6/11.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (UTF8)

- (NSString *)utf8String;
- (NSData *)UTF8Data;
- (NSData *)replaceNoUtf8:(NSData *)data;

@end
