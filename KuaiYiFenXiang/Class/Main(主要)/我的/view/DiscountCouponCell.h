//
//  DiscountCouponCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/15.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCouponModel :NSObject

@property (nonatomic,copy) NSString *limit;     //额度
@property (nonatomic,copy) NSString *usable;    //满多少可用
@property (nonatomic,copy) NSString *startTime;  //开始时间
@property (nonatomic,copy) NSString *endTime;   //结束时间
@property (nonatomic,copy) NSString *status;    //状态(0可用、1已用、2过期)

@end

#define DiscountCouponCellID @"DiscountCouponCellID"

@interface DiscountCouponCell : UITableViewCell

@property (nonatomic,strong) DiscountCouponModel *model;

@end
