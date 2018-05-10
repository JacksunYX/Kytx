//
//  MyOrderListViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface MyOrderListViewController : UIViewController

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray<OrderListModel *>*dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger index;

@end
