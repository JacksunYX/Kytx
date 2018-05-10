//
//  NSString+Category.h
//  ProvideHelper
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+HTML.h"
#import "NSString+Path.h"
#import "NSString+URL.h"
#import "NSString+STRegex.h"
#import "NSString+Ext.h"
#import "NSString+Encryption.h"
@interface NSString_Category : NSString

//时间戳转固定格式时间
+ (NSString *)Timestamptofixedformattime:(NSString *)format andTimeInterval:(NSTimeInterval)timeinterval;

//获取当前时间
//format: @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
+ (NSString *)currentDateWithFormat:(NSString *)format;
/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime;

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

//利用正则表达式验证
+ (BOOL)isAvailableEmail:(NSString *)email;
//判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string;
//判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2;
//判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string;
//将字典对象转换为 JSON 字符串
+ (NSString *)jsonPrettyStringEncoded:(NSDictionary *)dictionary;
//将数组对象转换为 JSON 字符串
+ (NSString *)jsonPrettyStringEncode:(NSArray *)array;


//将手机号中间四位加*
+ (NSString *)string1:(NSString *)string1 stringByReplacingString2:(NSString *)string2;

-(void)ReplaceString2:(NSString *)strng WithString:(NSString *)string1;
///
- (NSString*)parseString:(NSString*)string;

#pragma mark - 根据字符串计算字符串高度
- (CGRect)getStringHeightWithWidth:(CGFloat)wide font:(CGFloat)font;

#pragma mark - 根据字符串计算字符串宽度
- (CGRect)getStringWidthWithHeight:(CGFloat)high font:(CGFloat)font;

#pragma mark - 根据字符串计算字符串长度
+ (NSUInteger)calculateLengthWithStr:(NSString*)text;


@end
