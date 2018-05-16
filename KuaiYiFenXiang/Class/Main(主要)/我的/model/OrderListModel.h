//
//  OrderListModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodListModel;
@interface OrderListModel : NSObject

@property (nonatomic, strong) NSArray<GoodListModel *> *goods_list;
@property (nonatomic, assign) CGFloat order_amount;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *pay_refund;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *pay_time;
@property (nonatomic, strong) NSString *shipping_status;
@property (nonatomic, strong) NSString *shipping_time;
@property (nonatomic, strong) NSString *business_note;
@property (nonatomic, strong) NSString *business_status;
@property (nonatomic, strong) NSString *business_time;
@property (nonatomic, strong) NSString *user_cancel;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *all_postage;
@property (nonatomic, strong) NSString *all_num;
@property (nonatomic, strong) NSString *shipping_price;
@property (nonatomic, strong) NSString *refund_again;
@property (nonatomic, strong) NSString *business_id;
@property (nonatomic, strong) NSString *is_vip;
@property (nonatomic, strong) NSString *terrace_status;
@property (nonatomic, strong) NSString *service;
//新增
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *business_confirm;
@property (nonatomic, strong) NSString *ship_code;
@property (nonatomic, strong) NSString *parent_sn;

@end

@interface GoodListModel : NSObject

@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *goods_num;
@property (nonatomic, assign) CGFloat goods_price;
@property (nonatomic, assign) CGFloat market_price;
@property (nonatomic, assign) CGFloat postage;
@property (nonatomic, strong) NSString *loves;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *original_img;
@property (nonatomic, strong) NSString *spec_key_name;
@property (nonatomic, strong) NSString *shipping_code;
@property (nonatomic, strong) NSString *business_confirm;
@property (nonatomic, strong) NSString *invoice_no;
@property (nonatomic, strong) NSString *maijiafahuo;


@end
