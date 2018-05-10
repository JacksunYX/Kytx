//
//  GoPayViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/26.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MineBaseViewController.h"

@interface GoPayViewController : MineBaseViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, copy) void(^handler)();
@end
