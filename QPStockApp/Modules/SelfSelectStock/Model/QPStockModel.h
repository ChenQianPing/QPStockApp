//
//  QPStockModel.h
//  QPMyKit
//
//  Created by ChenQianPing on 17/6/11.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPStockModel : NSObject

/** 完整的代码,如:sz000812,sz000027*/
@property (nonatomic,copy) NSString *fullSymbol;
/** 名称*/
@property (nonatomic,copy) NSString *name;
/** 代码*/
@property (nonatomic,copy) NSString *symbol;
/** 最新价*/
@property (nonatomic,copy) NSString *lastTrade;
/** 涨跌额*/
@property (nonatomic,copy) NSString *change;
/** 涨跌幅(%)*/
@property (nonatomic,copy) NSString *chg;
/** 开盘(开),今开*/
@property (nonatomic,copy) NSString *open;
/** 昨收*/
@property (nonatomic,copy) NSString *prevClose;
/** 最高(高)*/
@property (nonatomic,copy) NSString *highest;
/** 最低(低)*/
@property (nonatomic,copy) NSString *lowest;
/** 总手,成交量(hand 手) 30.98万*/
@property (nonatomic,copy) NSString *volume;
/** 金额(额) 2.13亿*/
@property (nonatomic,copy) NSString *turnover;

/** 日期,时间*/
@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *b1;
@property (nonatomic,copy) NSString *b2;
@property (nonatomic,copy) NSString *b3;
@property (nonatomic,copy) NSString *b4;
@property (nonatomic,copy) NSString *b5;

@property (nonatomic,copy) NSString *bp1;
@property (nonatomic,copy) NSString *bp2;
@property (nonatomic,copy) NSString *bp3;
@property (nonatomic,copy) NSString *bp4;
@property (nonatomic,copy) NSString *bp5;

@property (nonatomic,copy) NSString *s1;
@property (nonatomic,copy) NSString *s2;
@property (nonatomic,copy) NSString *s3;
@property (nonatomic,copy) NSString *s4;
@property (nonatomic,copy) NSString *s5;

@property (nonatomic,copy) NSString *sp1;
@property (nonatomic,copy) NSString *sp2;
@property (nonatomic,copy) NSString *sp3;
@property (nonatomic,copy) NSString *sp4;
@property (nonatomic,copy) NSString *sp5;



@end
