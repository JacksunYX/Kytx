//
//  VIPDetailViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/25.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MineBaseViewController.h"
#import "VIPDetailModel.h"

@interface VIPDetailViewController : MineBaseViewController
@property (nonatomic, strong) VIPDetailModel *model;
@property (nonatomic, strong) NSDictionary *address;
@end
