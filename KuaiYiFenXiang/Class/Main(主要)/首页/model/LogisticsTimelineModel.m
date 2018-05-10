//
//  LogisticsTimelineModel.m
//  NewProject
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "LogisticsTimelineModel.h"

@implementation LogisticsTimelineModel


+ (instancetype)initWithDic:(NSDictionary *)dic{
    
    LogisticsTimelineModel *LogisticsTimeline = [self new];
    
    [LogisticsTimeline setValuesForKeysWithDictionary:dic];
    
    return LogisticsTimeline;
    
}
//必须要写此方法不然如果没有相应的字段就会造成崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}


@end
