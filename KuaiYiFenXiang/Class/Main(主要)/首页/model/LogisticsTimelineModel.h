//
//  LogisticsTimelineModel.h
//  NewProject
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsTimelineModel : NSObject


//
@property (nonatomic, copy) NSString *logisticsStatusString;
//
@property (nonatomic, copy) NSString *time;
//
@property (nonatomic, copy) NSString *status;


+ (instancetype)initWithDic:(NSDictionary *)dic;



@end
