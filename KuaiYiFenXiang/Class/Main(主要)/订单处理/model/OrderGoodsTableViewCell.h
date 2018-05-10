//
//  OrderGoodsTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoodsModel.h"
@interface OrderGoodsTableViewCell : UITableViewCell
@property (strong , nonatomic)OrderGoodsModel *OrderGoodsModel;
+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) void(^didClickrefundBtnHandler)(NSString *ordersnstring);
@end
