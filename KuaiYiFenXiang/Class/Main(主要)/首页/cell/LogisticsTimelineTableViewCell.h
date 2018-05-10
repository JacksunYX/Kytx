//
//  LogisticsTimelineTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsTimelineModel.h"
@interface LogisticsTimelineTableViewCell : UITableViewCell
/**
 *  内容模型
 */
@property(nonatomic,strong) LogisticsTimelineModel *LogisticsTimelineModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;
@end
