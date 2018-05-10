//
//  UITextField+Placeholder.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Placeholder)

/**
 * 设置占位符的文字颜色
 *
 * @param placeholderColor 新颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor;

/**
 * 设置占位符的文字字体
 *
 * @param placeholderFont 新字体
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont;

@end
