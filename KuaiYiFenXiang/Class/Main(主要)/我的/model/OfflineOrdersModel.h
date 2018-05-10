//
//  OfflineOrdersModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/3/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

//mobile = 17800000001;
//add_time = 2017-12-20;
//is_go = 0;
//order_id = 1061;
//order_sn = 2017122016285070;
//name = 测试店铺04;
//money = 1111.00;

@interface OfflineOrdersModel : NSObject

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *is_go;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *business_id;

@end
