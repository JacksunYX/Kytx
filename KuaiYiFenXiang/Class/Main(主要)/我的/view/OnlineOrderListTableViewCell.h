//
//  OnlineOrderListTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface OnlineOrderListTableViewCell : UITableViewCell
@property (nonatomic, strong) OrderListModel *OrderListModel;
@property (nonatomic, strong) GoodListModel *GoodListModel;
@end
