//
//  FavourableActivityTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavourableActivityModel.h"
#import "DiscountListModel.h"


@interface FavourableActivityTableViewCell : UITableViewCell

/**
 *  内容模型
 */
@property(nonatomic,strong) FavourableActivityModel *FavourableActivityModel;

@property(nonatomic,strong) DiscountListModel *discountModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;


@end
