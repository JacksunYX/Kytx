//
//  UIBarButtonItem+Extension.h
//  yyf微博项目－16-2-6
//
//  Created by 杨毅飞 on 16/3/10.
//  Copyright © 2016年 杨毅飞. All rights reserved.
//


@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title;


+(UIBarButtonItem *)itemBottomWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title;


@end
