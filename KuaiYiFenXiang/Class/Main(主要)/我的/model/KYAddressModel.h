//
//  AddressModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYAddressModel : NSObject
@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *twon;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL is_default;
@end
