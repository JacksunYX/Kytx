//
//  UIButton+pressMode.m
//  GlobalAuto
//
//  Created by 王立 on 16/6/25.
//  Copyright © 2016年 jmhqmc. All rights reserved.
//

#import "UIButton+pressMode.h"





@implementation UIButton (pressMode)

-(void)_addTarget:(id)target action:(SEL)action
{
    [super addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(pressDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(pressOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(pressUp:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)pressDown:(UIButton *)btn
{
    [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:0.4]];
}
-(void)pressOutSide:(UIButton *)btn
{
    [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:1.0]];
}
-(void)pressUp:(UIButton *)btn
{
    [self setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:1.0]];
}

@end
