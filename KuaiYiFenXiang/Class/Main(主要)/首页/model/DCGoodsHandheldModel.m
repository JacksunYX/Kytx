//
//  DCGoodsHandheldModel.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/21.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "DCGoodsHandheldModel.h"

@implementation DCGoodsHandheldModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idstring":@"id",
             @"img":@"image",
             @"name":@"active_name",
             };
}

@end
