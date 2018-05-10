//
//  UserPayViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/28.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MineBaseViewController.h"

@interface UserPayViewController : MineBaseViewController

@property (nonatomic, strong) NSString *business_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *shop_name;

@property (nonatomic, assign) NSInteger ratio;
@property (nonatomic, assign) NSInteger mutiply;

@end
