//
//  VIPTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/24.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPDetailModel.h"

@interface VIPTableViewCell : UITableViewCell

@property (nonatomic, strong) VIPDetailModel *model;
@property (nonatomic, copy) void(^clickHandler)(VIPDetailModel *model);

@end
