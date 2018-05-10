//
//  YYFButton.m
//  CiDeHui
//
//  Created by 杨毅飞 on 16/11/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYFButton.h"

@implementation YYFButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.layer setMasksToBounds:YES];
//        [self.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        //边框宽度
        [self.layer setBorderWidth:1.0];
        //    //设置边框颜色有两种方法：第一种如下:
        //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
        //    [box.actionButton.layer setBorderColor:colorref];//边框颜色
        //第二种方法如下:
        self.layer.borderColor=NAVIGATIONBAR_COLOR.CGColor;
        self.titleLabel.font=[UIFont systemFontOfSize:20];
        self.backgroundColor=  NAVIGATIONBAR_COLOR;//hwcolor(18, 36, 46);
        self.size=CGSizeMake(SCREEN_WIDTH*0.9, 40);
    }
    
    return self;
}

@end
