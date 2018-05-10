//
//  GetDiscountView.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "GetDiscountView.h"

@interface GetDiscountView()
{
    UIImageView *showViewImg;
}
@end

@implementation GetDiscountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    if (self == [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        [self setBaseView];
    }
    return self;
}

-(void)setBaseView
{
    showViewImg = [UIImageView new];
    showViewImg.userInteractionEnabled = YES;
    [self addSubview:showViewImg];
    
    showViewImg.sd_layout
    .widthIs(325)
    .heightIs(282)
    .topSpaceToView(self, 100)
    .centerXEqualToView(self)
//    .centerYEqualToView(self)
    ;
    showViewImg.image =UIImageNamed(@"discount_BakcImg");
    
    //领取按钮
    UIButton *getBtn = [UIButton new];
    [showViewImg addSubview:getBtn];
    getBtn.sd_layout
    .centerXEqualToView(showViewImg)
    .widthIs(150)
    .heightIs(50)
    .bottomSpaceToView(showViewImg, 50)
    ;
    
    getBtn.backgroundColor = [UIColor clearColor];
    [getBtn addTarget:self action:@selector(getDiscount:) forControlEvents:UIControlEventTouchUpInside];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton new];
    [self addSubview:closeBtn];
    
    closeBtn.sd_layout
    .leftSpaceToView(showViewImg, -20)
    .bottomSpaceToView(showViewImg, -20)
    .widthIs(40)
    .heightIs(40)
    ;
    [closeBtn setImage:UIImageNamed(@"discount_Close") forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius = 20;
    closeBtn.layer.masksToBounds = YES;
    
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
}

//领取按钮点击事件
-(void)getDiscount:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.getDiscountBlock) {
            self.getDiscountBlock();
        }
    }];
}

//关闭按钮点击事件
-(void)closeView:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.closeBlock) {
            self.closeBlock();
        }
    }];
    
}











@end
