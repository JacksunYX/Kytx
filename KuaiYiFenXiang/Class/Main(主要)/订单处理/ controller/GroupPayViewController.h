//
//  GroupPayViewController.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//
//组合支付界面

#import <UIKit/UIKit.h>
#import "MineBaseViewController.h"

@interface GroupPayViewController : MineBaseViewController

@property (nonatomic,copy) NSString *order_shop;    //订单号
@property (nonatomic,copy) NSString *consume_money; //消费余额
@property (nonatomic,copy) NSString *money;         //余额
@property (nonatomic,copy) NSString *total;         //用户总余额
@property (nonatomic,copy) NSString *payTotal;      //需要支付的总价

@property (nonatomic,copy) NSString *order_name;    //订单名称
@end
