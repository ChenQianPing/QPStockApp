//
//  QPStockOneTableViewCell.m
//  QPMyKit
//
//  Created by ChenQianPing on 17/6/11.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "QPStockOneTableViewCell.h"
#import "QPStockModel.h"

@interface QPStockOneTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;      /** 名称*/
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;    /** 代码*/
@property (weak, nonatomic) IBOutlet UILabel *lastTradeLabel; /** 最新价*/
@property (weak, nonatomic) IBOutlet UILabel *chgLabel;       /** 涨跌幅%*/

@end

@implementation QPStockOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 * 重写set方法;
 */
- (void)setModel:(QPStockModel *)model {
    
    _model = model;

    // 把模型的数据设置给子控件;
    self.nameLabel.text = model.name;
    self.symbolLabel.text = model.symbol;
    self.lastTradeLabel.text = model.lastTrade;
    self.chgLabel.text = model.chg;
    
    // 设置字体颜色
    
    
    if ([model.lastTrade isEqual:@"--"]) {
        
        self.lastTradeLabel.textColor = [UIColor grayColor];
        self.chgLabel.textColor = [UIColor grayColor];
        
    } else {
        
        NSString *change = [NSString stringWithFormat:@"%.2f",model.lastTrade.floatValue - model.prevClose.floatValue];
        
        if (change.floatValue>0) {
            
            self.lastTradeLabel.textColor = GOOGLE_RED;
            self.chgLabel.textColor = GOOGLE_RED;

        } else if(change.floatValue<0) {
            
            self.lastTradeLabel.textColor = GOOGLE_GREEN;
            self.chgLabel.textColor = GOOGLE_GREEN;

        } else if(change.floatValue==0.00) {
            
            self.lastTradeLabel.textColor = [UIColor blackColor];
            self.chgLabel.textColor = [UIColor blackColor];

        }
        
    }

    
    
}

+ (instancetype)stockCellWithTableView:(UITableView *)tableview {
    
    static NSString *ID = @"stock_cell";
    QPStockOneTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QPStockOneTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
    
}

@end
