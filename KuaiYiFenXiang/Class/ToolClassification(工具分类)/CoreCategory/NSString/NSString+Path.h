//
//  NSString+Path.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

/*!
 * @brief  根据文件名返回文件的路径
 * @param  fileName 文件名(使用type参数，就不能加后缀)
 * @param  type     文件后缀名
 * @return 如果文件路径存在，则返回该文件路径，否则返回nil
 */
+ (NSString *)pathWithFileName:(NSString *)fileName;
+ (NSString *)pathWithFileName:(NSString *)fileName ofType:(NSString *)type;

/*!
 * @brief 获取Documents/tmp/Cache路径
 */
+ (NSString *)documentPath;
+ (NSString *)tmpPath;
+ (NSString *)cachePath;

@end
