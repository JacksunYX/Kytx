//
//  PayWayTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayModel.h"

@interface PayWayTableViewCell : UITableViewCell
@property (strong , nonatomic)PayWayModel *PayWayModel;
+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;
@end
