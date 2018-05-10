//
//  UIButton+pressMode.h
//  GlobalAuto
//
//  Created by 王立 on 16/6/25.
//  Copyright © 2016年 jmhqmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (pressMode)

/**
 * 给UIButton添加点击效果
 */
-(void)_addTarget:(id)target action:(SEL)action;

@end
