//
//  TodayOnSaleModel.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "TodayOnSaleModel.h"

@implementation TodayOnSaleModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"onsale_id":@"id",
             };
}
@end
