//
//  NSString+HTML.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

/*!
 * 过滤掉HTML标签
 *
 * @param html HTML内容
 * @param 返回喜欢去掉所有HTML标签后的字符串
 */
- (NSString *)filteredHtml;
+ (NSString *)filterHTML:(NSString *)html;

/** 去掉html格式 */
- (NSString *)removeHtmlFormat;

@end
