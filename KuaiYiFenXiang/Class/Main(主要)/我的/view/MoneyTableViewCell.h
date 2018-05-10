//
//  MoneyTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyModel.h"

@interface MoneyTableViewCell : UITableViewCell
@property (nonatomic, strong) MoneyModel *model;
@property (nonatomic, assign) NSInteger celltype;
@end
