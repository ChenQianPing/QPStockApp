//
//  QPStockThreeTableViewCell.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/15.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QPStockThreeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *minImageView;

@property (weak, nonatomic) IBOutlet UIButton *minButton;
@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlyButton;




@end
