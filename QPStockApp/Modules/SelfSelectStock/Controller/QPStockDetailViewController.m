//
//  QPStockDetailViewController.m
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/14.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#import "QPStockDetailViewController.h"

#import "QPStockHelper.h"
#import "QPStockModel.h"
#import "QPStockTwoTableViewCell.h"
#import "QPStockThreeTableViewCell.h"
#import "QPStockFourableViewCell.h"

@interface QPStockDetailViewController ()<UITableViewDataSource,UITableViewDelegate> {
    
    NSString *imageUrl;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *data1Array;   /** 数据源1*/
@property (nonatomic,strong) QPStockModel *stockNowModel;

@end

@implementation QPStockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [NSString stringWithFormat:@"%@ (%@)", _model.name, _model.symbol ];
    
    imageUrl = @"http://image.sinajs.cn/newchart/min/n/";
    imageUrl = [NSString stringWithFormat:@"%@%@.gif", imageUrl, _fullSymbol ];
    

    [self setTableView];
    
    [self initMJRefresh];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableView {
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UINib *nibOne = [UINib nibWithNibName:@"QPStockTwoTableViewCell" bundle:nil];
    [self.tableView registerNib:nibOne forCellReuseIdentifier:@"cellOne"];
    
    UINib *nibTwo = [UINib nibWithNibName:@"QPStockThreeTableViewCell" bundle:nil];
    [self.tableView registerNib:nibTwo forCellReuseIdentifier:@"cellTwo"];
    
    UINib *nibThree = [UINib nibWithNibName:@"QPStockFourableViewCell" bundle:nil];
    [self.tableView registerNib:nibThree forCellReuseIdentifier:@"cellThree"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}


- (void)initMJRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadingData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadingData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)loadingData {
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.发送GET请求
    
    NSString *url = @"http://hq.sinajs.cn/list=";
    
    url = [NSString stringWithFormat:@"%@%@", url, _fullSymbol ];
    
    NSLog(@"url:%@",url);
    
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // NSLog(@"responseObject:%@", responseObject);
        
        [self.data1Array removeAllObjects];
        
        [QPStockHelper parseRequestResult:responseObject dataArray:self.data1Array];
        
        if (self.data1Array.count) {
            
            self.stockNowModel = self.data1Array[0];
            
            // NSLog(@"lastTrade:%@",self.stockNowModel.lastTrade);
            
            [self.tableView reloadData];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        QPStockTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne" forIndexPath:indexPath];
        
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *change = [NSString stringWithFormat:@"%.2f",_stockNowModel.lastTrade.floatValue - _stockNowModel.prevClose.floatValue];
        
        if (change.floatValue>0) {
            
            // NSLog(@">0:%f",change.floatValue);
            cell.bgView.backgroundColor = GOOGLE_RED;
            
        } else if(change.floatValue<0) {
            
            // NSLog(@"<0:%f",change.floatValue);
            cell.bgView.backgroundColor = GOOGLE_GREEN;
            
        }
        
        cell.lastTradeLabel.text = _stockNowModel.lastTrade;
        cell.changeLabel.text = _stockNowModel.change;
        cell.chgLabel.text = _stockNowModel.chg;
        
        cell.highestLabel.text = _stockNowModel.highest;
        cell.lowestLabel.text = _stockNowModel.lowest;
        cell.openLabel.text = _stockNowModel.open;
        cell.prevCloseLabel.text = _stockNowModel.prevClose;
        cell.turnoverLabel.text = _stockNowModel.turnover;
        cell.volumeLabel.text = _stockNowModel.volume;

        return cell;
        
        
        
    } else if (indexPath.row == 1) {
        
        QPStockThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo" forIndexPath:indexPath];
        
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        // NSLog(@"imageUrl:%@",imageUrl);
        
        /**
         * 让sdwebimage不缓存图片,SDWebImageRefreshCached.
         * options所有选项.
         *
         * SDWebImageRetryFailed.                 失败后重试.
         * SDWebImageLowPriority.                 UI交互期间开始下载,导致延迟下载比如UIScrollView减速.
         * SDWebImageCacheMemoryOnly.             只进行内存缓存.
         * SDWebImageProgressiveDownload.         这个标志可以渐进式下载,显示的图像是逐步在下载.
         * SDWebImageRefreshCached.               刷新缓存.
         * SDWebImageContinueInBackground.        后台下载.
         * SDWebImageAllowInvalidSSLCertificates. 允许使用无效的SSL证书.
         * SDWebImageHighPriority.                优先下载.
         * SDWebImageDelayPlaceholder.            延迟占位符.
         * SDWebImageTransformAnimatedImage.      改变动画形象.
         */
        
        NSUInteger row = [indexPath row];

        [cell.minImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage imageNamed:@"min.gif"]
                                      options:SDWebImageRefreshCached];
        
        cell.minButton.tag = row;
        [cell.minButton addTarget:self action:@selector(minButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.dailyButton.tag = row;
        [cell.dailyButton addTarget:self action:@selector(dailyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.weeklyButton.tag = row;
        [cell.weeklyButton addTarget:self action:@selector(weeklyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.monthlyButton.tag = row;
        [cell.monthlyButton addTarget:self action:@selector(monthlyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
        
        
    } else {
        
        QPStockFourableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree" forIndexPath:indexPath];
        
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 买1－买5
        cell.b1Label.text = _stockNowModel.bp1;
        cell.b2Label.text = _stockNowModel.bp2;
        cell.b3Label.text = _stockNowModel.bp3;
        cell.b4Label.text = _stockNowModel.bp4;
        cell.b5Label.text = _stockNowModel.bp5;

        cell.bp1Label.text = _stockNowModel.b1;
        cell.bp2Label.text = _stockNowModel.b2;
        cell.bp3Label.text = _stockNowModel.b3;
        cell.bp4Label.text = _stockNowModel.b4;
        cell.bp5Label.text = _stockNowModel.b5;
        
        // 三目运算符
        cell.b1Label.textColor = _stockNowModel.bp1.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.b2Label.textColor = _stockNowModel.bp2.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.b3Label.textColor = _stockNowModel.bp3.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.b4Label.textColor = _stockNowModel.bp4.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.b5Label.textColor = _stockNowModel.bp5.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        
        // 卖1－卖5
        cell.s1Label.text = _stockNowModel.sp1;
        cell.s2Label.text = _stockNowModel.sp2;
        cell.s3Label.text = _stockNowModel.sp3;
        cell.s4Label.text = _stockNowModel.sp4;
        cell.s5Label.text = _stockNowModel.sp5;
        
        cell.sp1Label.text = _stockNowModel.s1;
        cell.sp2Label.text = _stockNowModel.s2;
        cell.sp3Label.text = _stockNowModel.s3;
        cell.sp4Label.text = _stockNowModel.s4;
        cell.sp5Label.text = _stockNowModel.s5;
        
        cell.s1Label.textColor = _stockNowModel.sp1.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.s2Label.textColor = _stockNowModel.sp2.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.s3Label.textColor = _stockNowModel.sp3.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.s4Label.textColor = _stockNowModel.sp4.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        cell.s5Label.textColor = _stockNowModel.sp5.floatValue>=_stockNowModel.prevClose.floatValue?GOOGLE_RED:GOOGLE_GREEN;
        
        
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 160;
        
    } else if (indexPath.row == 1) {
        
        return 200;
        
    } else {
        
        return 130;
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

/**
 * tableView设置UITableViewStyleGrouped顶部没有空余高度;
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

/**
 * 分时线.
 */
- (void)minButtonClick:(UIButton *)button {
    
    NSLog(@"minButtonClick");
    
    imageUrl = @"http://image.sinajs.cn/newchart/min/n/";
    imageUrl = [NSString stringWithFormat:@"%@%@.gif", imageUrl, _fullSymbol ];
    
    [_tableView reloadData];

}

/**
 * 日K线.
 */
- (void)dailyButtonClick:(UIButton *)button {
    
    NSLog(@"dailyButtonClick");
    
    imageUrl = @"http://image.sinajs.cn/newchart/daily/n/";
    imageUrl = [NSString stringWithFormat:@"%@%@.gif", imageUrl, _fullSymbol ];
    
    [_tableView reloadData];
    
}

/**
 * 周K线.
 */
- (void)weeklyButtonClick:(UIButton *)button {
    
    NSLog(@"weeklyButtonClick");
    
    imageUrl = @"http://image.sinajs.cn/newchart/weekly/n/";
    imageUrl = [NSString stringWithFormat:@"%@%@.gif", imageUrl, _fullSymbol ];
    
    [_tableView reloadData];
    
}

/**
 * 月K线.
 */
- (void)monthlyButtonClick:(UIButton *)button {
    
    NSLog(@"monthlyButtonClick");
    
    imageUrl = @"http://image.sinajs.cn/newchart/monthly/n/";
    imageUrl = [NSString stringWithFormat:@"%@%@.gif", imageUrl, _fullSymbol ];
    
    [_tableView reloadData];
}

/**
 * 数据源
 */
- (NSMutableArray *)data1Array {
 
    if (!_data1Array) {
        _data1Array = [NSMutableArray array];
    }
    return _data1Array;
}

@end
