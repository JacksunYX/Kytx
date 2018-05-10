//
//  LogisticsTimelineTableViewCell.h
//  NewProject
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsTimelineModel.h"
@interface LogisticsTimelineCollectionViewCell : UICollectionViewCell


/**
 *  内容模型
 */
@property(nonatomic,strong) LogisticsTimelineModel *LogisticsTimelineModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@end
