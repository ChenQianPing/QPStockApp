//
//  QPStockTwoTableViewCell.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/14.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QPStockTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

/** 最新价*/
@property (weak, nonatomic) IBOutlet UILabel *lastTradeLabel;
/** 涨跌额*/
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
/** 涨跌幅(%)*/
@property (weak, nonatomic) IBOutlet UILabel *chgLabel;

/** 最高(高)*/
@property (weak, nonatomic) IBOutlet UILabel *highestLabel;
/** 最低(低)*/
@property (weak, nonatomic) IBOutlet UILabel *lowestLabel;
/** 开盘(开),今开*/
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
/** 昨收*/
@property (weak, nonatomic) IBOutlet UILabel *prevCloseLabel;
/** 金额(额) 2.13亿*/
@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;
/** 总手,成交量(hand 手) 30.98万*/
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end
