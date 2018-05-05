//
//  QPStockHelper.m
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/14.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "QPStockHelper.h"
#import "QPStockModel.h"

#define DB_NAME @"selfStock.db";

@implementation QPStockHelper

+ (void)initDb {

    NSString *dataName = DB_NAME;
    NSString *createsql = @"create table if not exists stockInfo(id integer primary key autoincrement,phone text,fullSymbol text,time text)";
    
    [QPSqlite3Helper initSqlite3:dataName createsql:createsql];
 
}

+ (void)mockTable {
    
    [self insertTable:@"sz000027"];
    [self insertTable:@"sz000812"];
    [self insertTable:@"sh600011"];
    [self insertTable:@"sz002650"];
    [self insertTable:@"sh600995"];
    [self insertTable:@"sh600519"];
    [self insertTable:@"sz002460"];
    [self insertTable:@"sh600435"];
    [self insertTable:@"sh600089"];
    [self insertTable:@"sh601669"];
    [self insertTable:@"sz002230"];
    [self insertTable:@"sz300205"];
 
}

+ (NSString*)findByTable {
    
    NSString *phone =@"13312520027";
    
    NSString *selectTable = @"select id,phone,fullSymbol,time from stockInfo where phone=?";
    
    NSArray *selectParam=@[phone];
    
    NSString *dataName = DB_NAME;

    
    // 得到数据源;
    NSMutableArray *result = [QPSqlite3Helper selectSql:selectTable parmas:selectParam dataBaseName:dataName];

    // 生成逗号分隔的NSString;
    NSString *lstFullSymbol = @"";
    NSString *tempSymbol = @"";
    
    // NSLog(@"result:%lu",(unsigned long)result.count);
    
    for (int i=0; i<result.count; i++) {
        NSMutableDictionary *dict=[result objectAtIndex:i];
        
        tempSymbol = [dict objectForKey:@"fullSymbol"];
        
        // NSString拼接字符串
        if (i==result.count-1) {
            lstFullSymbol = [lstFullSymbol stringByAppendingFormat:@"%@",tempSymbol];
        } else {
            lstFullSymbol = [lstFullSymbol stringByAppendingFormat:@"%@,",tempSymbol];
        }
    }
    
    // NSLog(@"lstFullSymbol:%@",lstFullSymbol);
    
    return lstFullSymbol;
}

+ (void)deleteTable:(NSString*)fullSymbol {
    
    NSString *dataName = DB_NAME;
    
    NSString *phone =@"13312520027";
    // 删除数据
    NSString *deleteTable = @"delete from stockInfo where phone=? and fullSymbol=?";
    NSArray *deleteParams = @[phone,fullSymbol];
    [QPSqlite3Helper execSql:deleteTable parmas:deleteParams dataBaseName:dataName];
    
}

+ (void)insertTable:(NSString*)fullSymbol {
    
    NSString *dataName = DB_NAME;
    
    NSString *phone =@"13312520027";
    
    NSString *time = [QPPublicFunction getCurrentTime];
    
    // 添加数据
    NSString *insertTable = @"insert into stockInfo (phone,fullSymbol,time) values (?,?,?)";
    NSArray  *insertParmas = @[phone,fullSymbol,time];
    [QPSqlite3Helper execSql:insertTable parmas:insertParmas dataBaseName:dataName];
}

/**
 * 解析请求返回的NSData
 */
+ (void)parseRequestResult:(NSData *)data
                 dataArray:(NSMutableArray *)dataArray {
    
    // 声明一个gbk编码类型
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // 使用如下方法:将获取到的数据按照gbkEncoding的方式进行编码,结果将是正常的汉字
    NSString *responseStr = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    
    // NSLog(@"responseStr:%@",responseStr);
    
    // 字符串\n替换""
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseStr = [responseStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    // NSLog(@"responseStr=%@",responseStr);
    
    // 字符串按照;分隔成数组;
    NSArray *array = [responseStr componentsSeparatedByString:@";"];
    // NSLog(@"array:%@",array);
    
    // 最后一个元素
    // NSLog(@"lastObejct:%@", [array lastObject]);
    
    // 遍历数组
    for (NSString *element in array) {
        // NSLog(@"element :%@", element);
        
        if([element isEmpty]) {
            
            // NSLog(@"element isEmpty");
            
        } else {
            
            // NSLog(@"element isNotEmpty");
            
            // 字符串按照,分隔成数组;
            NSArray *values = [element componentsSeparatedByString:@","];
            
            // NSLog(@"values:%@",values);
            
            QPStockModel* stockNow = [[QPStockModel alloc] init];
            // 按照所给出的位置,长度,任意地从字符串中截取子串;
            
            stockNow.fullSymbol = [values[0] substringWithRange:NSMakeRange(11, 8)];
            
            // NSLog(@"fullSymbol:%@",stockNow.fullSymbol);
            
            stockNow.symbol = [values[0] substringWithRange:NSMakeRange(13, 6)];
            stockNow.name = [values[0] substringFromIndex:21];
            
            // 今开
            NSString *open = values[1];
            open = [NSString stringWithFormat:@"%.2f",open.floatValue];
            // 昨收
            NSString *prevClose = values[2];
            prevClose = [NSString stringWithFormat:@"%.2f",prevClose.floatValue];
            // 最新价,保留小数点2位
            NSString *lastTrade = values[3];
            lastTrade = [NSString stringWithFormat:@"%.2f",lastTrade.floatValue];
            
            stockNow.open = open;
            stockNow.prevClose = prevClose;
            // 停牌情况
            if ([lastTrade isEqual:@"0.00"]) {
                lastTrade = @"--";
            }
            stockNow.lastTrade = lastTrade;
            
            NSString *change = @"";
            NSString *chg = @"";
            
            if ([lastTrade isEqual:@"--"]) {
                
                change = @"--";
                
            } else {
                
                // 涨跌额,涨跌幅(%) = (今日收盘价-昨日收盘价)/昨日收盘价*100%
                change = [NSString stringWithFormat:@"%.2f",lastTrade.floatValue - prevClose.floatValue];
                
                chg = [NSString stringWithFormat:@"%.2f",change.floatValue/prevClose.floatValue * 100];
                
            }
            
            // NSLog(@"change:%@",change);  // -0.11
            
            
            
            /**
             * 如果涨跌>0,则格式为+chg%,红色表示;
             * 如果涨跌=0,则格式为chg%,黑色表示;
             * 如果涨跌<0,则格式为-chg%,绿色表示;
             * 股票停牌情况,--;
             */
            
            if ([change isEqual:@"--"]) {
                chg = @"--";
            } else {
                
                if (change.floatValue>0) {
                    // 在NSString中显示%号,如果想在NSString中显示%就需要用%%;
                    chg = [NSString stringWithFormat:@"+%@%%",chg];
                    change = [NSString stringWithFormat:@"+%@",change];
                } else if(change.floatValue<0) {
                    chg = [NSString stringWithFormat:@"%@%%",chg];
                    change = [NSString stringWithFormat:@"%@",change];
                } else if(change.floatValue==0) {
                    chg = chg;
                    change = change;
                }
                
            }
            
            
            stockNow.change = change;
            stockNow.chg = chg;
            
            
            NSString *highest = values[4];
            highest = [NSString stringWithFormat:@"%.2f",highest.floatValue];
            NSString *lowest = values[5];
            lowest = [NSString stringWithFormat:@"%.2f",lowest.floatValue];
            
            stockNow.highest = highest;
            stockNow.lowest = lowest;
            
            NSString *volume = values[8];
            // NSLog(@"volume:%@",volume);
            volume = [NSString stringWithFormat:@"%.2f万手",volume.floatValue/100/10000];
            
            NSString *turnover = values[9];
            // NSLog(@"turnover:%@",turnover);
            turnover = [NSString stringWithFormat:@"%.2f亿",turnover.floatValue/100000000];
            
            stockNow.volume = volume;
            stockNow.turnover = turnover;
            
            NSString *b1 = values[10];
            b1 = [NSString stringWithFormat:@"%.0f",b1.floatValue/100];
            NSString *b2 = values[12];
            b2 = [NSString stringWithFormat:@"%.0f",b2.floatValue/100];
            NSString *b3 = values[14];
            b3 = [NSString stringWithFormat:@"%.0f",b3.floatValue/100];
            NSString *b4 = values[16];
            b4 = [NSString stringWithFormat:@"%.0f",b4.floatValue/100];
            NSString *b5 = values[18];
            b5 = [NSString stringWithFormat:@"%.0f",b5.floatValue/100];
            
            NSString *bp1 = values[11];
            bp1 = [NSString stringWithFormat:@"%.2f",bp1.floatValue];
            NSString *bp2 = values[13];
            bp2 = [NSString stringWithFormat:@"%.2f",bp2.floatValue];
            NSString *bp3 = values[15];
            bp3 = [NSString stringWithFormat:@"%.2f",bp3.floatValue];
            NSString *bp4 = values[17];
            bp4 = [NSString stringWithFormat:@"%.2f",bp4.floatValue];
            NSString *bp5 = values[19];
            bp5 = [NSString stringWithFormat:@"%.2f",bp5.floatValue];
            
            NSString *s1 = values[20];
            s1 = [NSString stringWithFormat:@"%.0f",s1.floatValue/100];
            NSString *s2 = values[22];
            s2 = [NSString stringWithFormat:@"%.0f",s2.floatValue/100];
            NSString *s3 = values[24];
            s3 = [NSString stringWithFormat:@"%.0f",s3.floatValue/100];
            NSString *s4 = values[26];
            s4 = [NSString stringWithFormat:@"%.0f",s4.floatValue/100];
            NSString *s5 = values[28];
            s5 = [NSString stringWithFormat:@"%.0f",s5.floatValue/100];
            
            NSString *sp1 = values[21];
            sp1 = [NSString stringWithFormat:@"%.2f",sp1.floatValue];
            NSString *sp2 = values[23];
            sp2 = [NSString stringWithFormat:@"%.2f",sp2.floatValue];
            NSString *sp3 = values[25];
            sp3 = [NSString stringWithFormat:@"%.2f",sp3.floatValue];
            NSString *sp4 = values[27];
            sp4 = [NSString stringWithFormat:@"%.2f",sp4.floatValue];
            NSString *sp5 = values[29];
            sp5 = [NSString stringWithFormat:@"%.2f",sp5.floatValue];
            
            stockNow.b1 = b1;
            stockNow.b2 = b2;
            stockNow.b3 = b3;
            stockNow.b4 = b4;
            stockNow.b5 = b5;
            
            stockNow.bp1 = bp1;
            stockNow.bp2 = bp2;
            stockNow.bp3 = bp3;
            stockNow.bp4 = bp4;
            stockNow.bp5 = bp5;
            
            stockNow.s1 = s1;
            stockNow.s2 = s2;
            stockNow.s3 = s3;
            stockNow.s4 = s4;
            stockNow.s5 = s5;
            
            stockNow.sp1 = sp1;
            stockNow.sp2 = sp2;
            stockNow.sp3 = sp3;
            stockNow.sp4 = sp4;
            stockNow.sp5 = sp5;
            
            stockNow.time = [NSString stringWithFormat:@"%@_%@", values[values.count-3], values[values.count - 2] ];

            
            [dataArray addObject:stockNow];
            
            
        }
        
    }
    
}

@end
