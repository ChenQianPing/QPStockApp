//
//  AppDelegate+RootController.m
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/13.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "PrefixHeader.pch"

@interface AppDelegate()<RDVTabBarControllerDelegate,UIScrollViewDelegate,UITabBarControllerDelegate>

@end

@implementation AppDelegate (RootController)

#pragma mark - window实例
- (void)setAppWindows {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}

#pragma mark - tabbar实例
- (void)setTabbarController {
    // 创建4个视图控制器
    HomePageViewController *oneVC = [[HomePageViewController alloc] init];
    RecommendViewController *twoVC  = [[RecommendViewController alloc] init];
    QPSelfStockViewController *threeVC = [[QPSelfStockViewController alloc] init];
    AboutMeViewController *fourVC = [[AboutMeViewController alloc] init];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[oneVC,twoVC,threeVC,fourVC]];
    self.viewController = tabBarController;
    
    tabBarController.delegate = self;
    [self customizeTabBarForController:tabBarController];
    
    /**
     * 默认的selectedViewController是索引为0的视图控制器;
     * 我们也可以通过设置这个值,来设置初始选中的tabBarItem!
     *
     */
    
    tabBarController.navigationItem.title = @"自选股";
    tabBarController.selectedIndex = 2;
    
    
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    // Customize the tabBar background
    UIImage *finishedImage = [self createImageWithColor:[UIColor lightTextColor]];
    UIImage *unfinishedImage = [self createImageWithColor:[UIColor lightTextColor]];
    
    // 这里添加tabBarIcon图片
    NSArray *tabBarItemImages = @[@"tpo_tab_home",@"tpo_tab_found",@"tpo_tab_course",@"tpo_tab_user"];
    NSArray *selectedImages = @[@"tpo_tab_home_pre",@"tpo_tab_found_pre",@"tpo_tab_course_pre",@"tpo_tab_user_pre"];
    
    NSInteger index = 0;
    
    // 设置tabbar透明属性
    [[tabBarController tabBar] setTranslucent:YES];
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        
        // 设置tabberItem的选中和未选中图片
        UIImage *selectedimage = [UIImage imageNamed:[selectedImages objectAtIndex:index]];
        UIImage *unselectedimage = [UIImage imageNamed:[tabBarItemImages objectAtIndex:index]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        // 修改tabberItem的title颜色
        NSDictionary *unseleAtrr = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:11],
                                     NSForegroundColorAttributeName: VTColor(65, 85, 129),
                                     };
        NSDictionary *seleAtrr = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:11],
                                   NSForegroundColorAttributeName: Main_Color,
                                   };
        [item setUnselectedTitleAttributes:unseleAtrr];
        [item setSelectedTitleAttributes:seleAtrr];
        
        [item setTitle:@[@"首页",@"推荐",@"自选股",@"关于"][index]];
        index++;
    }
}

/**
 * 设置标题
 */
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[HomePageViewController class]]) {
        tabBarController.navigationItem.title = @"首页";
    }
    if ([viewController isKindOfClass:[RecommendViewController class]]) {
        tabBarController.navigationItem.title = @"推荐";
    }
    if ([viewController isKindOfClass:[QPSelfStockViewController class]]) {
        tabBarController.navigationItem.title = @"自选股";
    }
    if ([viewController isKindOfClass:[AboutMeViewController class]]) {
        tabBarController.navigationItem.title = @"关于";
    }
}


#pragma mark - 设置根视图
- (void)setRootViewController {
    
    if ([SZUserDefault objectForKey:@"isOne"]) {
        // 不是第一次安装
        [self setRoot];
    } else {
        
        UIViewController *emptyView = [[UIViewController alloc]init];
        self.window.rootViewController = emptyView;
        [self createLoadingScrollView];
    }
    
}

- (void)setRoot {
    
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    // navc.navigationBar.barTintColor = Main_Color;
    navc.navigationBar.barTintColor = [UIColor lightTextColor];
    
    navc.navigationBar.shadowImage = [[UIImage alloc] init];
    [navc.navigationBar setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [navc.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    navc.navigationBar.tintColor = [UIColor blackColor];
    
    self.window.rootViewController = navc;
    
}




#pragma mark - 首次启动轮播图
- (void)createLoadingScrollView {
    // 引导页
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    sc.pagingEnabled = YES;
    sc.delegate = self;
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:sc];
    
    NSArray *arr = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    for (NSInteger i = 0; i<arr.count; i++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, self.window.frame.size.height)];
        img.image = [UIImage imageNamed:arr[i]];
        [sc addSubview:img];
        
        img.userInteractionEnabled = YES;
        if (i == arr.count - 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake((self.window.frame.size.width/2)-50, kScreenH-110, 100, 40);
            btn.backgroundColor = Main_Color;
            [btn setTitle:@"开始体验" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = Main_Color.CGColor;
        }
    }
    sc.contentSize = CGSizeMake(kScreenW*arr.count, self.window.frame.size.height);
}

- (void)goToMain {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"isOne" forKey:@"isOne"];
    [user synchronize];
    [self setRoot];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x>kScreenW *4+30) {
        [self goToMain];
    }
}


#pragma mark - Private Methods
- (UIImage *)createImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
