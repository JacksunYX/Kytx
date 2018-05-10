//
//  VIPDetailModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/25.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Business_infoModel;
@interface VIPDetailModel : NSObject
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *original_img;
@property (nonatomic, strong) NSString *sales_sum;
@property (nonatomic, strong) NSArray *detail_img;
@property (nonatomic, strong) Business_infoModel *business_info;
@end

@interface Business_infoModel :NSObject
@property (nonatomic, strong) NSString *business_id;
@property (nonatomic, strong) NSString *name;
@end
