//
//  AppDelegate.m
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/13.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppLifeCircle.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+RootController.h"
#import "QPStockHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setAppWindows];
    [self setTabbarController];
    [self setRootViewController];
    
    [QPStockHelper initDb];
    
    // [QPStockHelper mockTable];

    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
