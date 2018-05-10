//
//  TradeLogisticsModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeLogisticsModel : NSObject

@property (nonatomic, copy) NSString *cellid;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *shipping_time;
@property (nonatomic, copy) NSString *original_img;
@property (nonatomic, copy) NSString *goods_remark;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *shipping_code;
@property (nonatomic, copy) NSString *invoice_no;

@end
