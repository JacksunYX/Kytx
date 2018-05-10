//
//  HomePageAdvertiseModel.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "HomePageAdvertiseModel.h"

@implementation HomePageAdvertiseModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ad_id":@"id"};
}

@end

@implementation AdvertiseSonModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"son_id":@"id"};
}

@end





