//
//  MyOrderDetailsViewController.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/2/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "YYDHLBaseViewController.h"
@class OrderListModel;
@interface MyOrderDetailsViewController : YYDHLBaseViewController
@property (nonatomic, copy) NSString *order_snstring;
@property (nonatomic, copy) NSString *btntextstring;
@property (nonatomic, strong) NSDictionary *resultdic;
@property (nonatomic, strong) NSArray *orderinformationArray;
@property (nonatomic, copy) NSString *isshowrefundBtnString;
@property (nonatomic, copy) NSString *isshowRefundPopView;
@property (nonatomic, copy) void(^refreshHandler) ();
// 线上订单不显示下面的view
@property (nonatomic, assign) BOOL noShowBot;

@property (nonatomic, strong) OrderListModel *olmodel;

@property (nonatomic,assign) NSInteger currentIndex;

@end
