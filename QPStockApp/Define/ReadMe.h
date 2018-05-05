//
//  ReadMe.h
//  QPStockApp
//
//  Created by ChenQianPing on 17/6/13.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#ifndef ReadMe_h
#define ReadMe_h

/*******************************************************************************
 
 * QPContainerApp,QPStockApp  集装箱
 * 一个实时获取股票数据的iOS应用程序;
 
 * 参考资料:
 http://www.cnblogs.com/ldlchina/p/4822406.html
 http://www.cnblogs.com/ldlchina/p/4822406.html
 https://github.com/ldlchina/Mystock
 
 目前支持以下功能:
 * 1.实时更新股票数据;
 * 2.添加删除关注股票;
 * 3.如果股票有大额委托挂单,发生消息提醒.
 
 * 首页＼推荐＼自选股(提醒)＼资讯＼我的(团队),关于
 * 牛股都到碗里来.
 
 # 量化选股
 
 ## 基本面
 * 小市值(中线);
 * 高送转(中线);
 * 股权激励(中线);
 * 跌破定向增发价(中线);
 * 重要股东增持(中线);
 * 跌破每股净资产(中线);
 * 每股净资产高增长(中线);
 * 业绩预计扭亏(中线);
 * 业绩预盈且大幅增长(中线);
 * 现金流高增长(中线);
 
 
 ## 技术/行情面
 * 3日内严重超跌(短线);
 * 沿30日线攀升(短线);
 * 突破放量(短线);
 * 连涨3天(短线);
 * 5日内上涨超过30%(短线);
 * 近5日有两次以上涨停(短线);
 * 一阳三线;
 * MACD金叉(短线);
 
 *  http://hq.sinajs.cn/list=sh000001
 * var hq_str_sh000001="
 000001 代码 symbol
 上证指数 名称 ** name
 ,3147.4533 开盘(开)
 ,3150.3336 昨收
 ,3158.4004 最新,现价 ** last_trade
 ,3165.9197 最高(高)
 ,3146.1075 最低(低)
 ,0
 ,0
 ,160136334 总手 16014万手  160136334/10000.0,除1万,不保留小数点,四舍五入;
 ,181584884790 金额(额) 1815.8亿 计算公式:181584884790/100000000.0,除1亿,保留一位小数点;
 ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 ,2017-06-09  日期
 ,15:01:03,00" 刷新时间,建议每隔两秒发送请求获取数据;
 
 手工计算涨跌额 change,涨幅% chg
 
 ** change = 3158.4004 - 3150.3336 = 8.07 保留二位小数;
 ** chg = 8.07 / 3158.4004 * 100  =  0.2555090861817267 保留二位小数,加上%;
 ;
 *
 
 * var hq_str_sz002460="赣锋锂业
 ,39.100
 ,38.730
 ,39.520
 ,39.800
 ,38.420
 ,39.520  买1
 ,39.530  卖1
 ,20913280,817537273.520,53979,39.520,39300,39.510,90600,39.500,26058,39.490,19400,39.480,17700,39.530,6658,39.540,34000,39.550,2900,39.560,5700,39.570,2017-06-09,16:35:03,00";
 
 * http://hq.sinajs.cn/list=sz000027
 var hq_str_sz000027="深圳能源
 ,6.750  开盘(开),今开
 ,6.800  昨收
 ,6.880  最新,现价,最新价 **last_trade
 ,7.030  最高(高)
 ,6.720  最低(低)
 ,6.880  买1 竞买价,即“买一”报价;
 ,6.890  卖1 竞卖价，即“卖一”报价;
 ,30979647  总手,成交量(手) 30.98万
 ,212559647.880  金额(额) 2.13亿
 
 ,34515,6.880  买1 6.88 345手 ＝ 34515/100
 ,75783,6.870  买2 6.87 758手
 ,214584,6.860 买3 6.86 2146手
 ,144342,6.850 买4 6.85 1443手
 ,68400,6.840  买5 6.84 684手
 
 ,169945,6.890 卖1 6.89 1699手
 ,224800,6.900 卖2 6.90 2248手
 ,80000,6.910  卖3 6.91 800手
 ,87630,6.920  卖4 6.92 876手
 ,98250,6.930  卖5 6.93 982手
 
 ,2017-06-09
 ,16:35:03,00";
 
 chg% = (6.880 - 6.800)/6.800*100 = 1.176470588235295% 四舍五入,保留二位小数
 
 * https://zhidao.baidu.com/question/208980903.html
 
 * 正式启动集装箱项目
 * 集装箱App是一款基于大数据的股票信息软件,提供分级基金溢价/折价套利机会分析;
 * 提供潜力股票推荐以及高危个股警示,为炒股用户提供辅助参考,2秒即更新一次数据.
 * 每两秒钟更新一次;
 * 个人量化交易者的自由之路;
 * 什么是量化策略
 http://www.cnblogs.com/quant/p/6091035.html
 
 * 股票行情的变化,是以秒为单位的,一到开盘,每秒钟都要更新每支股票的变化;
 * 试了新浪的接口,一次最多只能查150支股票左右;
 
 * # 股票自动买卖
 * 股票自动交易系统依据一定的规则或策略,比如MACD金叉或死叉,KDJ,超买 超卖,海龟交易系统,亚当理论,GSV.
 * 但是这类规则和策略无非只解决了技术层面的一些东西.从整体 的测试来看,并没有达到一个另人可以满意的成绩.
 * 也许这些东西在它刚开始发行的时候也是很牛B的曾经统治了股票市场一段时间.
 
 * 千发股票 股票自动交易平台
 * http://www.qianfa.net/TradeHelper.html

 
 * 获取股票历史数据和当前数据的API
 http://www.cnblogs.com/ldlchina/p/5392670.html
 * 实时获取股票信息API
 http://www.cnblogs.com/phpxuetang/p/4519446.html
 * 获取实时股票数据与股票数据接口API
 http://www.cnblogs.com/godwar/archive/2011/02/12/1952555.html
 
 * iOS选项卡
 http://www.jianshu.com/p/3ea8ed769569
 https://github.com/heysunnyboy/scrollTapLayout
 
 * 一个采用python获取股票数据的开源库,相当全,及一些量化投资策略库
 http://www.cnblogs.com/welhzh/p/5972107.html
 
 * TuShare
 * TuShare是一个免费、开源的python财经数据接口包.
 * 主要实现对股票等金融数据从数据采集、清洗加工 到 数据存储的过程,
 * 能够为金融分析人员提供快速、整洁、和多样的便于分析的数据,
 * 为他们在数据获取方面极大地减轻工作量,使他们更加专注于策略和模型的研究与实现上.
 
 * http://tushare.org
 
 * 沪深行情_网易财经
 http://quotes.money.163.com/stock
 
 * 证监会行业分类表
 http://www.csindex.com.cn/sseportal/csiportal/xzzx/querydownloadlist.do
 https://github.com/ErikXu/SPA.Simple/blob/master/SimpleStock.Downloader/Downloader.cs
 
 * 关于我的兼职创业历程
 http://www.cnblogs.com/hongyin163/p/mandata.html
 
 * iOS 股票K线图、分时图
 http://www.jianshu.com/p/7e765a0e73c8
 https://github.com/cclion/CCLKLineChartView
 
 * pandas 0.20.2 documentation
 http://pandas.pydata.org/pandas-docs/stable/api.html
 
 * KChart
 https://github.com/YongbaoWang/KChart
 
 * 投资决策参考
 http://cfxyz.com/stock/
 https://github.com/cforth/stock
 
 * 廖雪峰的官方网站
 http://www.liaoxuefeng.com/
 
 * RiceQuant米筐量化交易平台
 https://www.ricequant.com/
 
********************************************************************************/


#endif /* ReadMe_h */



