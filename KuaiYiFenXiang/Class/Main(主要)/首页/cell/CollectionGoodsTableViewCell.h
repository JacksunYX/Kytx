//
//  CollectionGoodsTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/3/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionGoodsTableViewCell : UITableViewCell
@property (strong , nonatomic)GeneralGoodsModel *GeneralGoodsModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@end
