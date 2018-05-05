//
//  QPStockOneCollectionViewCell.m
//  QPMyKit
//
//  Created by ChenQianPing on 17/6/10.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "QPStockOneCollectionViewCell.h"
#import "QPStockModel.h"

@interface QPStockOneCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        /** 名称*/
@property (weak, nonatomic) IBOutlet UILabel *lastTradeLabel;   /** 最新价*/
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;      /** 涨跌额,涨跌幅*/

@end

@implementation QPStockOneCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 * 重写set方法.
 */
- (void)setModel:(QPStockModel *)model {
    
    _model = model;
    
    self.nameLabel.text = model.name;
    self.lastTradeLabel.text = model.lastTrade;
    
    // 拼接字符串
    self.changeLabel.text = [NSString stringWithFormat:@"%@ %@", model.change, model.chg ];
    
    // 设置字体颜色
    
    NSString *change = [NSString stringWithFormat:@"%.2f",model.lastTrade.floatValue - model.prevClose.floatValue];
    
    if (change.floatValue>0) {
        
        self.backgroundColor = GOOGLE_RED;
        
        // self.lastTradeLabel.textColor = GOOGLE_RED;
        // self.changeLabel.textColor = GOOGLE_RED;
        
    } else if(change.floatValue<0) {
        
        self.backgroundColor = GOOGLE_GREEN;
        
        // self.lastTradeLabel.textColor = GOOGLE_GREEN;
        // self.changeLabel.textColor = GOOGLE_GREEN;
        
    } else if(change.floatValue==0.00) {
        
        self.backgroundColor = GOOGLE_RED;
        
        // self.lastTradeLabel.textColor = [UIColor blackColor];
        // self.changeLabel.textColor = [UIColor blackColor];
        
    }
    
    
 
}



@end
