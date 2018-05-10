//
//  TodayOnSaleModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

//今日特价版块模型
@interface TodayOnSaleModel : NSObject

@property(nonatomic,copy)NSString *onsale_id;
@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,copy)NSString *startime;

@property(nonatomic,copy)NSString *goods_id_1;
@property(nonatomic,copy)NSString *goods_id_2;
@property(nonatomic,copy)NSString *goods_id_3;

@property(nonatomic,copy)NSString *image_1;
@property(nonatomic,copy)NSString *image_2;
@property(nonatomic,copy)NSString *image_3;

@property(nonatomic,copy)NSString *type;

@end
