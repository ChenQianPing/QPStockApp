//
//  QPStockDetailViewController.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/14.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPStockModel.h"

@interface QPStockDetailViewController : UIViewController

@property (nonatomic,strong) QPStockModel *model;
@property (nonatomic,strong) NSString *fullSymbol;

@end
