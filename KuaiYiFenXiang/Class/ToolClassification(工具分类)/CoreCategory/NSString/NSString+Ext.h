//
//  NSString+Ext.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 对NSString有用的扩展类
 * 
 * @author huangyibiao
 */
@interface NSString (Ext)

/*!
 * 去掉空格符号操作，分别是去掉左边的空格、去掉右边的空格、去掉两边的空格、去掉所有空格、去掉所有字母、
 * 去掉字符中中所有的指定的字符
 *
 * @return 处理后的字符串
 */
- (NSString *)trimLeft;
- (NSString *)trimRight;
- (NSString *)trim;
- (NSString *)trimAll;
- (NSString *)trimLetters;
- (NSString *)trimCharacter:(unichar)character;
- (NSString *)trimWhitespace;
- (NSUInteger)numberOfLines;

- (NSString *)insertAbbr:(NSString *)abbrStr;

/*!
 * @brief 判断是否是空串/判断去掉两边的空格后是否是空串
 *
 * @return YES表示是空串，NO表示非空
 */
- (BOOL)isEmpty;
- (BOOL)isTrimEmpty;

- (NSString *)nullString;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

/*!
 * 添加前缀、后缀（不修改self）
 *
 * @param prefix-前缀 subfix-后缀
 * @param 返回添加后的字符串
 */
- (NSString *)addPrefix:(NSString *)prefix;
- (NSString *)addSubfix:(NSString *)subfix;

@end
