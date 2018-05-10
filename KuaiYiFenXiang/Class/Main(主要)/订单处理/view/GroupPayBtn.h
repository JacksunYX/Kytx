//
//  GroupPayBtn.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//
//用在组合支付展示的自定义btn

#import <UIKit/UIKit.h>
#import "GroupPayModel.h"

typedef void(^ClickHandle)(GroupPayModel *model);

@interface GroupPayBtn : UIView

@property (nonatomic,strong) GroupPayModel *model;

@property (nonatomic,copy) ClickHandle ClickBlock;

@end
