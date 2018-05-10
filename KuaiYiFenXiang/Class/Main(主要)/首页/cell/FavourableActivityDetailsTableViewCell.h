//
//  FavourableActivityDetailsTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsUnifiedModel.h"

@interface FavourableActivityDetailsTableViewCell : UITableViewCell

/**
 *  内容模型
 */
@property(nonatomic,strong) GoodsUnifiedModel *GoodsUnifiedModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@end
