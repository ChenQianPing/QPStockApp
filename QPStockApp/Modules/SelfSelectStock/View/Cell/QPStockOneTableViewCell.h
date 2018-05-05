//
//  QPStockOneTableViewCell.h
//  自选股列表Cell
//
//  Created by ChenQianPing on 17/6/11.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPStockModel;

@interface QPStockOneTableViewCell : UITableViewCell

@property (nonatomic,strong) QPStockModel *model;

/**
 * 封装一个创建自定义cell的方法;
 */
+ (instancetype)stockCellWithTableView:(UITableView *)tableview;

@end
