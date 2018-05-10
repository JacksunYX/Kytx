//
//  UIBarButtonItem+Extension.m
//  yyf微博项目－16-2-6
//
//  Created by 杨毅飞 on 16/3/10.
//  Copyright © 2016年 杨毅飞. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title
{
    
    if (kStringIsEmpty(title)) {
        
        
        //设置图片
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        //按钮点击事件
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
        
        //设置尺寸
        btn.size = btn.currentBackgroundImage.size;
        
        NSLog(@"w:%lf  h:%lf  ",btn.size.width,btn.size.height);
        return  [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        
    }else if (kStringIsEmpty(image)&&kStringIsEmpty(hightimage)){
        
        
        //设置图片
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        //按钮点击事件
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
        
        [btn.titleLabel setFont:PFR15Font];
        //设置尺寸
        //btn.size=btn.currentBackgroundImage.size;
        
        btn.size=CGSizeMake(100, 40);
        
        //影响按钮内的titleLable;
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, 50, 0, 0);
        //影响按钮内部imageView
        
        //    // 直接设置按钮的图片和文字的布局样式以及之间的间隔
        //    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.0];
        
        
        return  [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        
    }else{
        
        //设置图片
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        //按钮点击事件
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn.titleLabel setFont:PFR15Font];
        //设置尺寸
        //btn.size=btn.currentBackgroundImage.size;
        
        btn.size=CGSizeMake(80, 40);
        
        //影响按钮内的titleLable;
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 0);
        //影响按钮内部imageView
        btn.imageEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 50);
        
        //    // 直接设置按钮的图片和文字的布局样式以及之间的间隔
        //    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.0];
        
        
        return  [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        
    }
    
    
}





+(UIBarButtonItem *)itemBottomWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title
{
    //设置图片
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //按钮点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightimage] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:hwcolor(135, 135, 135) forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:PFR10Font];
    
    //设置尺寸
    //btn.size=btn.currentBackgroundImage.size;
    
    btn.size=CGSizeMake(30, 30);
    
    //    //影响按钮内的titleLable;
    //    btn.titleEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 0);
    //    //影响按钮内部imageView
    //    btn.imageEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 50);
    
    // 直接设置按钮的图片和文字的布局样式以及之间的间隔
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5.0];
    
    return  [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}


@end
