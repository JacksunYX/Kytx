//
//  SeleteAddressTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeleteAddressModel.h"
@interface SeleteAddressTableViewCell : UITableViewCell
@property (strong , nonatomic)SeleteAddressModel *SeleteAddressModel;
+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;
@end
