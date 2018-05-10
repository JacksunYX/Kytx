//
//  OrderGoodsModel.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoodsModel : NSObject
@property (nonatomic, copy) NSString *cellid;
@property (nonatomic, copy) NSString *ordergoodsimgUrlString;
@property (nonatomic, copy) NSString *ordergoodstitleString;
@property (nonatomic, copy) NSString *ordergoodsxianjiaString;
@property (nonatomic, copy) NSString *ordergoodssubtitleString;
@property (nonatomic, copy) NSString *ordergoodsyuanjiaString;
@property (nonatomic, copy) NSString *ordergoodscountString;
@property (nonatomic, copy) NSString *ordergoodssmallimgUrlString;
@property (nonatomic, copy) NSString *isshowrefundBtnString;
@property (nonatomic, copy) NSString *shipping_code;
@property (nonatomic, copy) NSString *invoice_no;


@end
