//
//  DiscountListModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//
//优惠活动模型


#import <Foundation/Foundation.h>

@interface DiscountListModel : NSObject

@property (nonatomic,copy) NSString *discount_id;
@property (nonatomic,copy) NSString *favourable;    //标题
@property (nonatomic,copy) NSString *image;         //图片
@property (nonatomic,copy) NSString *startime;      //活动开始时间
@property (nonatomic,copy) NSString *endtime;       //活动开始时间
@property (nonatomic,copy) NSString *type;          //活动类型
@property (nonatomic,copy) NSString *content;       //活动内容
@property (nonatomic,copy) NSString *on_time;       //活动是否失效 1-过期 2-活动中 3-未开始

@end
