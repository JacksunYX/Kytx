//
//  OnlineOrderViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MineBaseViewController.h"
#import "OrderListModel.h"

@interface OnlineOrderViewController : MineBaseViewController

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray<OrderListModel *>*dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger index;

@end
