//
//  AppDelegate+RootController.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/13.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootController)

/**
 * window实例
 */
- (void)setAppWindows;

/**
 * tabbar实例
 */
- (void)setTabbarController;

/**
 * 设置根视图
 */
- (void)setRootViewController;

/**
 * 首次启动轮播图
 */
- (void)createLoadingScrollView;

@end
