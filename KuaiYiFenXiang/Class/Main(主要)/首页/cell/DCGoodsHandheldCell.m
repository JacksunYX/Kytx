//
//  DCGoodsHandheldCell.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodsHandheldCell.h"


@interface DCGoodsHandheldCell ()

/* 图片 */
@property (strong , nonatomic)UIImageView *handheldImageView;
@property (strong , nonatomic)UILabel *nameLabel;
@property (strong , nonatomic)UILabel *depictLabel;

@end

@implementation DCGoodsHandheldCell

-(void)setDCGoodsHandheldModel:(DCGoodsHandheldModel *)DCGoodsHandheldModel{
    
    _DCGoodsHandheldModel=DCGoodsHandheldModel;
    
//    self.handheldImageView.backgroundColor = hwrandomcolor;
    [self.handheldImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,DCGoodsHandheldModel.img]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    [self.nameLabel setText:DCGoodsHandheldModel.name];
    
    [self.depictLabel setText:DCGoodsHandheldModel.depict];

    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}

-(UIImageView *)handheldImageView{
    if (_handheldImageView == nil) {
        _handheldImageView = [[UIImageView alloc] init];
    }
//    [_handheldImageView.layer setMasksToBounds:YES];
//    [_handheldImageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_handheldImageView];
    
    return _handheldImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
    }
    _nameLabel.font=PFR15Font;
    kStringIsEmpty(self.DCGoodsHandheldModel.depict)?[_nameLabel setTextColor:hwcolor(255, 255, 255)]:[_nameLabel setTextColor:hwrandomcolor];
    !kStringIsEmpty(self.DCGoodsHandheldModel.depict)?:[_nameLabel setBackgroundColor:hwcolor(119, 100, 85)];
    !kStringIsEmpty(self.DCGoodsHandheldModel.depict)?:[_nameLabel setAlpha:0.6];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.contentMode=UIViewContentModeCenter;
    _nameLabel.numberOfLines=0;
    kStringIsEmpty(self.DCGoodsHandheldModel.name)?[_nameLabel removeFromSuperview]:[self.contentView addSubview:_nameLabel];
    return _nameLabel;
}

- (UILabel *)depictLabel
{
    if (_depictLabel == nil) {
        _depictLabel = [[UILabel alloc] init];
    }
    _depictLabel.font=PFR10Font;
    _depictLabel.textColor=hwrandomcolor;
    _depictLabel.textAlignment=NSTextAlignmentCenter;
    _depictLabel.contentMode=UIViewContentModeCenter;
    _depictLabel.numberOfLines=0;
    kStringIsEmpty(self.DCGoodsHandheldModel.depict)?[_depictLabel removeFromSuperview]:[self.contentView addSubview:_depictLabel];
    return _depictLabel;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.handheldImageView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .widthIs(self.contentView.width)
    .heightIs(self.contentView.height);
    
    if(kStringIsEmpty(self.DCGoodsHandheldModel.name)&&kStringIsEmpty(self.DCGoodsHandheldModel.depict)) {
        
    }else{
        
        if (kStringIsEmpty(self.DCGoodsHandheldModel.depict)){
            self.nameLabel.sd_layout
            .leftSpaceToView(self.contentView, 0)
            .bottomSpaceToView(self.contentView, 0)
            .widthIs(self.contentView.width)
            .autoHeightRatio(0);
        }else{
            self.nameLabel.sd_layout
            .leftSpaceToView(self.contentView, 10)
            .topSpaceToView(self.contentView, 0)
            .autoHeightRatio(0);
            [self.nameLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width];

            self.depictLabel.sd_layout
            .leftEqualToView(self.nameLabel)
            .topSpaceToView(self.nameLabel, 0)
            .autoHeightRatio(0);
            [self.depictLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width];
        }
        
    }
    self.nameLabel.hidden = YES;
    
}

@end
