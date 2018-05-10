//
//  RecordModel.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "RecordModel.h"
#import "MJExtension.h"
@interface RecordModel ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end
@implementation RecordModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"record_id" : @"id"
             };
}
- (NSInteger)year {
    self.formatter.dateFormat = @"yyyy";
    
    NSString *str = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.add_time.floatValue]];
    return str.integerValue;
}

- (NSInteger)month {
    self.formatter.dateFormat = @"MM";
    
    NSString *str = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.add_time.floatValue]];
    return str.integerValue;
}

- (NSInteger)day {
    self.formatter.dateFormat = @"dd";
    
    NSString *str = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.add_time.floatValue]];
    return str.integerValue;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return _formatter;
}
@end
