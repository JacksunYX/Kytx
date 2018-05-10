//
//  NSString+URL.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 * 转换成URL
 */
- (NSURL *)toURL;

/**
 * 把URL进行UTF8转码
 */
- (NSString *)URLEncode;

-(NSString *)URLDecodedString;



//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str;


//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str;





@end
