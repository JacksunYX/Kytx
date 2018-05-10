//
//  OfflineOrderListTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineOrderListModel.h"

@interface OfflineOrderListTableViewCell : UITableViewCell

@property (nonatomic, strong) OfflineOrderListModel *model;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void(^clickHandler) (NSString *order_sn);
@property (nonatomic, copy) void(^clickPay) (NSString *order_sn, NSString *price);
@end
