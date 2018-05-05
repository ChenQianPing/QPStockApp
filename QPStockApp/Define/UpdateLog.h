//
//  UpdateLog.h
//  更新日志
//
//  Created by ChenQianPing on 17/6/13.
//  Copyright © 2017年 ChenQianPing. All rights reserved.
//

#ifndef UpdateLog_h
#define UpdateLog_h


/*******************************************************************************

 # 17-06-22
 * 定时刷新;
 
 # 17-06-24
 * iOS股票瀑布流的实现;
 * 用的tableview实现的,向下滑动的时候,最上面的一行不动,向右滑动的时候,最左边的一行不动;
 http://www.cnblogs.com/sunkaifeng/p/5089870.html
 
 # 每天的涨跌停
 * 涨停强度
 http://stock.jrj.com.cn/tzzs/zdtwdj/zdforce.shtml
 * 跌停强度
 http://stock.jrj.com.cn/tzzs/zdtwdj/dtforce.shtml
 
 # 获取当天破50天新高的股票.为什么不获取60天呢?因为大家都在用,用的人多了就不准了.

 # 17-06-25
 * 封装QPSqlite3Helper组件;
 * 增加本地数据库的支持,数据库为Sqlite,可以用MesaSQLite查看数据库文件;
 * 自选股支持新增股票＼删除股票;tableView滑动删除自选股;
 
 
 * MesaSQLite数据库简单使用
 http://blog.csdn.net/wsxzk123/article/details/17282325
 * ios开发之SQLite数据库打开工具MesaSQLite
 http://download.csdn.net/detail/u013087513/9194187
 
 
 

 
 
********************************************************************************/

#endif /* UpdateLog_h */
