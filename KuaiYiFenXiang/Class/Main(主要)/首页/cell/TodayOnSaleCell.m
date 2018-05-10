//
//  TodayOnSaleCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "TodayOnSaleCell.h"

@interface TodayOnSaleCell()
{
    UIImageView *leftImg;           //左边的图片
    UIImageView *rightTopImg;       //右上
    UIImageView *rightBottomImg;    //右下
}
@end

@implementation TodayOnSaleCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    leftImg = [UIImageView new];
    rightTopImg = [UIImageView new];
    rightBottomImg = [UIImageView new];
//    leftImg.backgroundColor = [UIColor redColor];
//    rightTopImg.backgroundColor = [UIColor yellowColor];
//    rightBottomImg.backgroundColor = [UIColor blueColor];
    [self.contentView sd_addSubviews:@[
                                       leftImg,
                                       rightTopImg,
                                       rightBottomImg
                                       ]];
    //布局
    leftImg.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs((ScreenW - 5)/2)
    ;
    
    rightTopImg.sd_layout
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .widthIs((ScreenW - 5)/2)
    .heightIs((TodayOnSaleCellHeight - 5)/2)
    ;
    
    rightBottomImg.sd_layout
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .widthIs((ScreenW - 5)/2)
    .heightIs((TodayOnSaleCellHeight - 5)/2)
    ;
    
    leftImg.userInteractionEnabled = YES;
    rightTopImg.userInteractionEnabled = YES;
    rightBottomImg.userInteractionEnabled = YES;
    leftImg.tag = 0;
    rightTopImg.tag = 1;
    rightBottomImg.tag = 2;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    [leftImg addGestureRecognizer:tap1];
    [rightTopImg addGestureRecognizer:tap2];
    [rightBottomImg addGestureRecognizer:tap3];
    
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    NSInteger touchIndex = [gesture.view tag];
    if ([self.delegate respondsToSelector:@selector(clickonRow:OnIndex:)]) {
//        [self.delegate clickOnIndex:touchIndex];
        [self.delegate clickonRow:self.tag OnIndex:touchIndex];
    }
}

//设置数据
-(void)setupViewWithDataArr:(NSArray *)dataArr
{
    
}

-(void)setModel:(TodayOnSaleModel *)model
{
    _model = model;
    [leftImg sd_setImageWithURL:JointImgUrl(model.image_1) placeholderImage:nil];
    [rightTopImg sd_setImageWithURL:JointImgUrl(model.image_2) placeholderImage:nil];
    [rightBottomImg sd_setImageWithURL:JointImgUrl(model.image_3) placeholderImage:nil];
}







@end
