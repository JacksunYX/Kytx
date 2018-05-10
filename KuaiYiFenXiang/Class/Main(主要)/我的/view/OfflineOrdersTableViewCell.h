//
//  OfflineOrdersTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/3/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineOrdersModel.h"
@interface OfflineOrdersTableViewCell : UITableViewCell
+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@property (strong , nonatomic)OfflineOrdersModel *OfflineOrdersModel;
@end
