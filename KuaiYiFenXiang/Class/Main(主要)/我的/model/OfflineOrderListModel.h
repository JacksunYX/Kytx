//
//  OfflineOrderListModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfflineOrderListModel : NSObject

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *umobile;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *ratio;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *head_pic;
@property (nonatomic, strong) NSString *nickname;
@end
