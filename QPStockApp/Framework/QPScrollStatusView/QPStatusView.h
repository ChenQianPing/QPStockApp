//
//  QPStatusView.h
//  QPYouGc
//
//  Created by ChenQianPing on 16/12/18.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QPColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol QPStatusViewDelegate <NSObject>

- (void)statusViewSelectIndex:(NSInteger)index;

@end


@interface QPStatusView : UIView

@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) UIView *lineView;                    /** 横线*/
@property (nonatomic,assign) id <QPStatusViewDelegate>delegate;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) BOOL isScroll;

/**
 * 界面书初始化
 *
 * @param titleArray 状态值
 * @param normalColor 正常标题颜色
 * @param selectedColor 选中的颜色
 * @param lineColor lineColor 下面线条颜色如果等于nil就没有线条 
 * 
 */
- (void)setUpStatusButtonWithTitlt:(NSArray *)titleArray
                       NormalColor:(UIColor *)normalColor
                     SelectedColor:(UIColor *)selectedColor
                         LineColor:(UIColor *)lineColor;

- (void)changeTag:(int)tag;

@end
