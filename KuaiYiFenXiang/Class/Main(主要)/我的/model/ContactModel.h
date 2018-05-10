//
//  contactModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *role_name;
@property (nonatomic, strong) NSString *reg_time;
@property (nonatomic, strong) NSString *head_pic;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL showTitle;

@end
