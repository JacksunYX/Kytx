//
//  CashModel.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *love;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) BOOL showTitle;


@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@end
