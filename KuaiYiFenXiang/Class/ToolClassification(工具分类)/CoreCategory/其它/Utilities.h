//
//  Utilities.h
//  B
//
//  Created by MacOS on 15/6/19.
//  Copyright (c) 2015年 MacOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject


/**
 *16进制颜色转换为UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
//获取当前的时间 yyyy-MM-dd HH:mm:ss
+(NSString *)currentTime;
//NSString的转换NSDate yyyy-MM-dd HH:mm:ss
+(NSDate *)dateFromString:(NSString *)dateString;

@end
