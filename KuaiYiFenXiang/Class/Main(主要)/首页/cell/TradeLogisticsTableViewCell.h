//
//  TradeLogisticsTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeLogisticsModel.h"

@interface TradeLogisticsTableViewCell : UITableViewCell

/**
 *  内容模型
 */
@property(nonatomic,strong) TradeLogisticsModel *TradeLogisticsModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@end
