//
//  QPScrollStatusView.m
//  QPYouGc
//
//  Created by ChenQianPing on 16/12/18.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

#import "QPScrollStatusView.h"

@implementation QPScrollStatusView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr {

    self = [super initWithFrame:frame];
    [self setStatusViewWithTitle:titleArr];
    return self;
}

- (instancetype)initWithTitleArr:(NSArray *)titleArr andType:(ScrollTapType)type {

    if (type == ScrollTapTypeWithNavigation) {
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    } else if(type == ScrollTapTypeWithNavigationAndTabbar) {
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49)];
    } else if(type == ScrollTapTypeWithNothing) {
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }

    [self setStatusViewWithTitle:titleArr];
    return self;
}

- (instancetype)initWithTitleArr:(NSArray *)titleArr andType:(ScrollTapType)type andNormalTabColor:(UIColor *)normalTabColor andSelectTabColor:(UIColor *)selectTabColor {

    if (type == ScrollTapTypeWithNavigation) {
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    } else if(type == ScrollTapTypeWithNavigationAndTabbar) {
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49)];
    } else if(type == ScrollTapTypeWithNothing) {
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    curNormalTabColor = normalTabColor;
    curSelectTabColor = selectTabColor;
    [self setStatusViewWithTitle:titleArr];
    return self;
    
}

- (void)setStatusViewWithTitle:(NSArray *)titleArr {
    
    // 1.statusView
    float height = self.frame.size.height;
    self.statusView = [[QPStatusView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    self.statusView.delegate = self;
    self.statusView.isScroll = YES;
    if (curNormalTabColor && curSelectTabColor) {
        [self.statusView setUpStatusButtonWithTitlt:titleArr NormalColor:curNormalTabColor SelectedColor:curSelectTabColor LineColor:QPColor(10, 193, 147, 1)];
    } else {
        [self.statusView setUpStatusButtonWithTitlt:titleArr NormalColor:QPColor(154, 156, 156, 1) SelectedColor:QPColor(40, 171, 227, 1) LineColor:QPColor(40, 171, 227, 1)];
    }
    [self addSubview:self.statusView];
    
    // 2.sessionLine
    float y = 45;
    UIView *sessionLine = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 5)];
    sessionLine.backgroundColor = QPColor(242, 242, 242, 1);
    [self addSubview:sessionLine];
    
    // 3.mainScrollView
    y+=5;
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, height-y)];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    float mainScrollH = _mainScrollView.frame.size.height;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth*titleArr.count, mainScrollH);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_mainScrollView];
    
    _tableArr = [NSMutableArray array];
    for ( int i = 0; i < titleArr.count; i++) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, mainScrollH)];
        table.tableFooterView = [[UIView alloc]init];
        table.delegate = self;
        table.dataSource = self;
        table.tag = i+1;
        
        // 去掉分割线
        table.separatorStyle = UITableViewCellSelectionStyleNone;
        table.backgroundColor = [UIColor groupTableViewBackgroundColor];

        // 定义复用的cell
        
        // 1.待审批 - TableViewCell
        UINib *nib = [UINib nibWithNibName:@"YGCApproveTableViewCell" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:@"cell"];
        
        // 2.暂无数据 - TableViewCell
        UINib *noNib = [UINib nibWithNibName:@"TGCNoTableViewCell" bundle:nil];
        [table registerNib:noNib forCellReuseIdentifier:@"noCell"];

        
        __weak QPScrollStatusView *weakSelf = self;
        table.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            isrefresh = YES;
            if (_scrollStatusDelegate) {
                
                [weakSelf.scrollStatusDelegate refreshViewWithTag:i+1 andIsHeader:YES];
                [table.mj_header endRefreshing];
                isrefresh = NO;
            }
        }];
        table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            isrefresh = YES;
            if (_scrollStatusDelegate) {
                isrefresh = YES;
                [weakSelf.scrollStatusDelegate refreshViewWithTag:i+1 andIsHeader:NO];
            }
            [table.mj_footer endRefreshing];
            isrefresh = NO;
        }];
        [_tableArr addObject:table];
        [_mainScrollView addSubview:table];
    }
    
    // 获取当前tableview
    if (_tableArr.count > 0) {
        _curTable = _tableArr[0];
    }
    
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_scrollStatusDelegate) {
        if ([_scrollStatusDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            return  [_scrollStatusDelegate numberOfSectionsInTableView:tableView];
            
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_scrollStatusDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_scrollStatusDelegate) {
        if ([_scrollStatusDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            return [_scrollStatusDelegate tableView:tableView numberOfRowsInSection:section];
        }
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_scrollStatusDelegate) {
        if ([_scrollStatusDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] ) {
            return [_scrollStatusDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
        
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_scrollStatusDelegate) {
        if ([_scrollStatusDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            return [_scrollStatusDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(![scrollView isKindOfClass:[UITableView class]]) {
        if (isrefresh == NO) {
            int scrollIndex = scrollView.contentOffset.x/kScreenWidth;
            [_statusView changeTag:scrollIndex];
            _curTable = _tableArr[scrollIndex];
        }
    }
}

- (void)statusViewSelectIndex:(NSInteger)index {
    [_mainScrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
    _curTable = _tableArr[index];
}


@end
