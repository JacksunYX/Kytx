//
//  VIPOrderGoodsTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/25.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoodsModel.h"

@interface VIPOrderGoodsTableViewCell : UITableViewCell
@property (strong , nonatomic)OrderGoodsModel *OrderGoodsModel;
+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@end
