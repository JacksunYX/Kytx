//
//  GroupPayBtn.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "GroupPayBtn.h"

@interface GroupPayBtn ()
{
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    UILabel *moneyLabel;
}

@end

@implementation GroupPayBtn

-(instancetype)init
{
    if (self == [super init]) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    self.backgroundColor = kWhiteColor;
    imgView = [UIImageView new];
    imgView.userInteractionEnabled = YES;
    imgView.sd_cornerRadius = @20;
//    imgView.backgroundColor = hwrandomcolor;
    
    titleLabel = [UILabel new];
    titleLabel.textColor = kColor333;
    titleLabel.font = Font(15);
    
    subTitleLabel = [UILabel new];
    subTitleLabel.textColor = kColor999;
    subTitleLabel.font = Font(12);
    
    moneyLabel = [UILabel new];
    moneyLabel.textColor = kColord40;
    moneyLabel.font = Font(15);
    
    [self sd_addSubviews:@[
                           imgView,
                           titleLabel,
                           subTitleLabel,
                           moneyLabel,
                           ]];
    
    //添加点击事件
    MCWeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if (weakSelf.ClickBlock) {
            weakSelf.ClickBlock(self.model);
        }
    }];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)setModel:(GroupPayModel *)model
{
    _model = model;
    
    kStringIsEmpty(model.imgStr)?:[imgView setImage:UIImageNamed(model.imgStr)];
    
    kStringIsEmpty(model.title)?:[titleLabel setText:model.title];
    
    kStringIsEmpty(model.subTitle)?:[subTitleLabel setText:model.subTitle];
    
    kStringIsEmpty(model.money)?:[moneyLabel setText:[@"￥" stringByAppendingString:model.money]];
    
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //布局
    imgView.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 15)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    
    if (kStringIsEmpty(_model.subTitle)) {
        titleLabel.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(imgView, 15)
        .autoHeightRatio(0)
        ;
    }else{
        titleLabel.sd_layout
        .leftSpaceToView(imgView, 15)
        .topSpaceToView(self, 18)
        .autoHeightRatio(0)
        ;
        
        subTitleLabel.sd_layout
        .leftEqualToView(titleLabel)
        .topSpaceToView(titleLabel, 10)
        .autoHeightRatio(0)
        ;
        [subTitleLabel setSingleLineAutoResizeWithMaxWidth:ScreenW/2];
    }
    
    [titleLabel setSingleLineAutoResizeWithMaxWidth:ScreenW/2];
    
    if (!kStringIsEmpty(_model.money)) {
        moneyLabel.sd_layout
        .centerYEqualToView(self)
        .rightSpaceToView(self, 15)
        .autoHeightRatio(0)
        ;
        [moneyLabel setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
    }
    
}





@end
