//
//  NinePiecesOfNineCollectionViewCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "SpecialClearanceCollectionViewCell.h"


@interface SpecialClearanceCollectionViewCell ()


/**
 *   图片
 */
@property(nonatomic,strong) UIImageView *plateimageView;

/**
 *   标题
 */
@property(nonatomic,strong) UILabel *platenameLabel;

@property(nonatomic,strong) UILabel *productspecificationsLabel;

 @property(nonatomic,strong) UILabel *activitypriceTextLabel;

@property(nonatomic,strong) UILabel *activitypriceLabel;




@end

@implementation SpecialClearanceCollectionViewCell

-(void)setGoodsUnifiedModel:(GoodsUnifiedModel *)GoodsUnifiedModel{
    
    _GoodsUnifiedModel=GoodsUnifiedModel;
    
    
    [self.plateimageView sd_setImageWithURL:[NSURL URLWithString:GoodsUnifiedModel.imageurlString] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    
    
    [self.platenameLabel setText:GoodsUnifiedModel.maintitleString];
    
    [self.productspecificationsLabel setText:GoodsUnifiedModel.productspecificationsString];
    
    [self.activitypriceTextLabel setText:@"活动价"];
    [self.activitypriceLabel setText:GoodsUnifiedModel.presentpriceString];

    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
    
}


-(UIImageView *)plateimageView{
    if (_plateimageView == nil) {
        _plateimageView = [[UIImageView alloc] init];
    }
    //    [_plateimageView.layer setMasksToBounds:YES];
    //    [_plateimageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_plateimageView];
    
    return _plateimageView;
}



- (UILabel *)platenameLabel
{
    if (_platenameLabel == nil) {
        _platenameLabel = [[UILabel alloc] init];
    }
    _platenameLabel.font=PFR13Font;
    _platenameLabel.textColor=[UIColor blackColor];
    _platenameLabel.textAlignment=NSTextAlignmentLeft;
    _platenameLabel.contentMode=UIViewContentModeCenter;
    _platenameLabel.numberOfLines=0;
    [self.contentView addSubview:_platenameLabel];
    return _platenameLabel;
}




- (UILabel *)productspecificationsLabel
{
    if (_productspecificationsLabel == nil) {
        _productspecificationsLabel = [[UILabel alloc] init];
    }
    _productspecificationsLabel.font=PFR10Font;
    _productspecificationsLabel.textColor=[UIColor grayColor];
    _productspecificationsLabel.textAlignment=NSTextAlignmentCenter;
    _productspecificationsLabel.contentMode=UIViewContentModeCenter;
    _productspecificationsLabel.numberOfLines=0;
    [self.contentView addSubview:_productspecificationsLabel];
    return _productspecificationsLabel;
}



- (UILabel *)activitypriceTextLabel
{
    if (_activitypriceTextLabel == nil) {
        _activitypriceTextLabel = [[UILabel alloc] init];
    }
    _activitypriceTextLabel.font=PFR10Font;
    _activitypriceTextLabel.textColor=[UIColor redColor];
    _activitypriceTextLabel.textAlignment=NSTextAlignmentCenter;
    _activitypriceTextLabel.contentMode=UIViewContentModeCenter;
    _activitypriceTextLabel.numberOfLines=0;
    [self.contentView addSubview:_activitypriceTextLabel];
    return _activitypriceTextLabel;
}


- (UILabel *)activitypriceLabel
{
    if (_activitypriceLabel == nil) {
        _activitypriceLabel = [[UILabel alloc] init];
    }
    _activitypriceLabel.font=PFR13Font;
    _activitypriceLabel.textColor=[UIColor redColor];
    _activitypriceLabel.textAlignment=NSTextAlignmentCenter;
    _activitypriceLabel.contentMode=UIViewContentModeCenter;
    _activitypriceLabel.numberOfLines=0;
    [self.contentView addSubview:_activitypriceLabel];
    return _activitypriceLabel;
}





-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    self.plateimageView.sd_layout
    .topSpaceToView(self.contentView, 9)
    .centerXEqualToView(self.contentView)
    .widthIs((SCREEN_WIDTH-4)/2)
    .heightIs((SCREEN_WIDTH-4)/2);
    
    
    
    
    self.platenameLabel.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(self.plateimageView, 5)
    .widthIs(self.contentView.width-10)
    .heightIs(20);
    
    
    
    self.productspecificationsLabel.sd_layout
    .topSpaceToView(self.platenameLabel, 5)
    .leftEqualToView(self.platenameLabel)
    .autoHeightRatio(0);
    [self.productspecificationsLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];


    self.activitypriceTextLabel.sd_layout
    .topSpaceToView(self.productspecificationsLabel, 5)
    .leftEqualToView(self.productspecificationsLabel)
    .autoHeightRatio(0);
    [self.activitypriceTextLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];


    self.activitypriceLabel.sd_layout
    .centerYEqualToView(self.activitypriceTextLabel)
    .leftSpaceToView(self.activitypriceTextLabel, 5)
    .autoHeightRatio(0);
    [self.activitypriceLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];
    
    
}


@end




