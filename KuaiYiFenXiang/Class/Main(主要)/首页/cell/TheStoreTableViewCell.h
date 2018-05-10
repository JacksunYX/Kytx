//
//  TheStoreCollectionViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/15.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheStoreModel.h"

@interface TheStoreTableViewCell : UITableViewCell

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@property (strong , nonatomic)TheStoreModel *TheStoreModel;

@property (nonatomic, copy) void(^didSelectedEnterStoreBlock)(TheStoreModel *model);

@end

