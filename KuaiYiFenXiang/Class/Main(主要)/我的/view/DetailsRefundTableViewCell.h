//
//  DetailsRefundTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/2/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsRefundModel.h"
@interface DetailsRefundTableViewCell : UITableViewCell
/**
 *  内容模型
 */
@property(nonatomic,strong) DetailsRefundModel *DetailsRefundModel;

@property (nonatomic, copy) void(^didSelectedRefundLeafletsNoButtonBlock)(DetailsRefundModel *model);

@property (nonatomic, copy) void(^didSelectedCheckLogisticsBlock)(DetailsRefundModel *model);

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;
@end
