//
//  QPScrollStatusView.h
//  QPYouGc
//
//  Created by ChenQianPing on 16/12/18.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPStatusView.h"
#import "MJRefresh.h"

/** 结构体.
 *
 *  结构体的详细描述.
 */
typedef NS_ENUM(NSInteger , ScrollTapType) {
    ScrollTapTypeWithNavigation,            //!< 含有导航栏
    ScrollTapTypeWithNavigationAndTabbar,   //!< 含有tarbar
    ScrollTapTypeWithNothing,               //!< 什么都不含有
};

@protocol QPScrollStatusDelegate<UITableViewDelegate,UITableViewDataSource>

- (void)refreshViewWithTag:(int)tag andIsHeader:(BOOL)isHeader;

@end

@interface QPScrollStatusView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,QPStatusViewDelegate> {
    
    BOOL isrefresh;
    UIColor *curSelectTabColor;
    UIColor *curNormalTabColor;
}

@property (strong,nonatomic) QPStatusView *statusView;
@property (strong,nonatomic) UIScrollView *mainScrollView;
@property (strong,nonatomic) UITableView *curTable;        /** 获取当前所选中的tableview*/
@property (strong,nonatomic) NSMutableArray *tableArr;     /** 含有的tableiview数组 */
@property (strong,nonatomic) id<QPScrollStatusDelegate> scrollStatusDelegate;

/**
 *  初始化方法,根据不同类型的自动设置frame,类型有是否有导航栏,tarbar,或者两者都没有
 *
 *  @param titleArr 标题数组
 *  @param type     箱式布局类型
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithTitleArr:(NSArray *)titleArr
                         andType:(ScrollTapType)type;

/**
 *  初始化方法,根据不同类型的自动设置frame,类型有是否有导航栏,tarbar,或者两者都没有
 *
 *  @param titleArr 标题数组
 *  @param type     箱式布局类型
 *  @param normalTabColor tab 正常的颜色
 *  @param selectTabColor tab 被选中的颜色
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithTitleArr:(NSArray *)titleArr
                         andType:(ScrollTapType)type
               andNormalTabColor:(UIColor *)normalTabColor
               andSelectTabColor:(UIColor *)selectTabColor;

/**
 *  初始化
 *
 *  @param frame    frame
 *  @param titleArr 标题
 *
 *  @return <#return value description#>
 */

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr;

@end
