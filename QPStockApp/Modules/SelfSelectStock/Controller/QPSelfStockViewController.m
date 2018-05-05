//
//  QPSelfStockViewController.m
//  QPMyKit
//
//  Created by ChenQianPing on 17/6/10.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "QPSelfStockViewController.h"
#import "QPStockOneCollectionViewCell.h"
#import "QPStockModel.h"
#import "QPStockOneTableViewCell.h"
#import "QPStockHelper.h"
#import "QPStockDetailViewController.h"


@interface QPSelfStockViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data1Array;   /** 数据源1*/
@property (nonatomic, strong) NSMutableArray *data2Array;   /** 数据源2*/

@end

@implementation QPSelfStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"自选股";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setupCollectionView];
    
    [self initMJRefresh];
    
    [self.tableView.mj_header beginRefreshing];
    
    // [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshStock) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)getStockIndex {
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.发送GET请求
    
    NSString *url = @"http://hq.sinajs.cn/list=sh000001,sz399001,sz399006";
    
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // NSLog(@"responseObject:%@", responseObject);
        
        [self.data1Array removeAllObjects];
        
        [QPStockHelper parseRequestResult:responseObject dataArray:self.data1Array];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    

}



- (void)getSelfStock {
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.发送GET请求
    
    NSString *lstFullSymbol = [QPStockHelper findByTable];

    NSString *url = @"http://hq.sinajs.cn/list=";
    
    url = [url stringByAppendingFormat:@"%@",lstFullSymbol];
    
    NSLog(@"url:%@",url);
    
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // NSLog(@"responseObject:%@", responseObject);
        
        [self.data2Array removeAllObjects];
        
        [QPStockHelper parseRequestResult:responseObject dataArray:self.data2Array];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)initMJRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)loadNewData {
    
    NSLog(@"上拉加载");
    
    [self getStockIndex];
    
    [self getSelfStock];
    
    
}

- (void)loadMoreData {
    NSLog(@"下拉刷新");
    
    [self getStockIndex];
    
    [self getSelfStock];

    
}

- (void)refreshStock {
    
    NSLog(@"定时刷新");
    
    [self getStockIndex];
    
    [self getSelfStock];
    
}

- (void)setupCollectionView {
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    // 注册Cell,必须要有
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QPStockOneCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44.0f;
    
}

#pragma mark - UICollectionViewDataSource

/**
 * section的数量.
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 * 某个section里有多少个item.
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.data1Array.count;
}

/**
 * 对于某个位置应该显示什么样的cell.
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QPStockOneCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.data1Array[indexPath.item];
    return cell;
    
}

/**
 * 设置item的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((kScreenW - 20) / 3, 80);
}

/** 
 * 设置垂直间距,默认的垂直和水平间距都是10.
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

/**
 * 设置水平间距;
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

/**
 * 四周的边距;
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data2Array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // NSLog(@"indexPath.row:%ld",(long)indexPath.row);
    
    // 获取模型数据
    QPStockModel *model = self.data2Array[indexPath.row];
    
    // 通过xib的方式来创建单元格
    QPStockOneTableViewCell *cell = [QPStockOneTableViewCell stockCellWithTableView:tableView];
    
    // 把模型设置给单元格
    cell.model = model;
    
    // 返回单元格
    return cell;
    
}


/**
 *  表格点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    QPStockDetailViewController *detailVc = [[QPStockDetailViewController alloc] init];
    
    // 获取模型数据
    QPStockModel *model = self.data2Array[indexPath.row];
    
    detailVc.model = model;
    detailVc.fullSymbol = model.fullSymbol;
    
    NSLog(@"fullSymbol:%@", model.fullSymbol);
    [self.navigationController pushViewController:detailVc animated:YES];
}

/**
 * tableView滑动删除.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // 设置可以编辑
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 返回此值时,Cell会做出响应显示Delete
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 设置了这行代码会显示汉字”删除"
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete");

        QPStockModel *model = self.data2Array[indexPath.row];
        
        // 1.数据库删除数据
        NSString *fullSymbol = model.fullSymbol;
        NSLog(@"fullSymbol---%@",fullSymbol);
        [QPStockHelper deleteTable:fullSymbol];

        
        /**
         * 2.data2Array删除数据
         * data2Array为当前table中显示的array;
         * 注意:下面这句必须要加,否则会抛异常;
         */
        [self.data2Array removeObjectAtIndex:[indexPath row]];
        
        // 3.移除 tableView中的数据
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        

    }
}



#pragma mark - SetterAndGetter
/**
 * 数据源
 */
- (NSMutableArray *)data1Array {
    if (!_data1Array) {
        _data1Array = [NSMutableArray array];
    }
    return _data1Array;
}

- (NSMutableArray *)data2Array {
    
    if (!_data2Array) {
        _data2Array = [NSMutableArray array];

    }
    
    return _data2Array;

}

@end
