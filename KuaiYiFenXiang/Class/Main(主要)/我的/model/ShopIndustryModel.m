//
//  shopIndustryModel.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShopIndustryModel.h"
#import "MJExtension.h"

@implementation ShopIndustryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"shop_id" : @"id"
             };
}

@end
