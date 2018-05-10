//
//  MoneyModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, strong) NSString *type;



@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@end
