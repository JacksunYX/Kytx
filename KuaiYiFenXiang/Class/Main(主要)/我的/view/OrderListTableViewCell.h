//
//  OrderListTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@interface OrderListTableViewCell : UITableViewCell
@property (nonatomic, strong) OrderListModel *OrderListModel;
@property (nonatomic, strong) GoodListModel *GoodListModel;
@end
