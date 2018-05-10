//
//  AddressTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"
#import "KYAddressModel.h"

@interface KYAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) KYAddressModel *model;
@property (nonatomic, strong) NSArray *area;

@property (nonatomic, copy) void(^didClickEditHandler)(KYAddressModel *model);
@property (nonatomic, copy) void(^didClickDeleteHandler)(KYAddressModel *model);
@property (nonatomic, copy) void(^didClickDefaultHandler)(KYAddressModel *model);

@end
