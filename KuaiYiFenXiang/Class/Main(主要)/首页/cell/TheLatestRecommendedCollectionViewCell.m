//
//  NinePiecesOfNineCollectionViewCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "TheLatestRecommendedCollectionViewCell.h"


@interface TheLatestRecommendedCollectionViewCell ()


/**
 *   图片
 */
@property(nonatomic,strong) UIImageView *plateimageView;

  /**
 *   标题
 */
@property(nonatomic,strong) UILabel *platenameLabel;


@property(nonatomic,strong) UILabel *originalpriceLabel;
@property(nonatomic,strong) UILabel *presentpriceLabel;

@property(nonatomic,strong) UILabel *graylineLabel;



@end

@implementation TheLatestRecommendedCollectionViewCell

-(void)setGoodsUnifiedModel:(GoodsUnifiedModel *)GoodsUnifiedModel{
    
    _GoodsUnifiedModel=GoodsUnifiedModel;
    
    
    [self.plateimageView sd_setImageWithURL:[NSURL URLWithString:GoodsUnifiedModel.imageurlString] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
 
 
    [self.platenameLabel setText:GoodsUnifiedModel.maintitleString];
    
    [self.originalpriceLabel   setText:GoodsUnifiedModel.originalpriceString];
    
    [self.presentpriceLabel   setText:GoodsUnifiedModel.presentpriceString];
    
 
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
    
}

-(void)setGeneralGoodsModel:(GeneralGoodsModel *)GeneralGoodsModel{
    
    _GeneralGoodsModel=GeneralGoodsModel;
    
    
    [self.plateimageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName, GeneralGoodsModel.original_img]] placeholderImage:[UIImage imageNamed:@"applogo"]];
 
    [self.platenameLabel setText:GeneralGoodsModel.goods_name];
    
    //中划线
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", GeneralGoodsModel.market_price] attributes:attribtDic];
    [self.originalpriceLabel setAttributedText:attribtStr];

    [self.presentpriceLabel   setText:[NSString stringWithFormat:@"¥ %@", GeneralGoodsModel.shop_price]];

    
    
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
//    _platenameLabel.contentMode=UIViewContentModeCenter;
    _platenameLabel.numberOfLines = 2;
    [self.contentView addSubview:_platenameLabel];
    return _platenameLabel;
}




- (UILabel *)originalpriceLabel
{
    if (_originalpriceLabel == nil) {
        _originalpriceLabel = [[UILabel alloc] init];
    }
    _originalpriceLabel.font=PFR10Font;
    _originalpriceLabel.textColor=[UIColor grayColor];
    _originalpriceLabel.textAlignment=NSTextAlignmentCenter;
    _originalpriceLabel.contentMode=UIViewContentModeCenter;
    _originalpriceLabel.numberOfLines=0;
    [self.contentView addSubview:_originalpriceLabel];
    return _originalpriceLabel;
}



- (UILabel *)presentpriceLabel
{
    if (_presentpriceLabel == nil) {
        _presentpriceLabel = [[UILabel alloc] init];
    }
    _presentpriceLabel.font=PFR13Font;
    _presentpriceLabel.textColor=[UIColor redColor];
    _presentpriceLabel.textAlignment=NSTextAlignmentCenter;
    _presentpriceLabel.contentMode=UIViewContentModeCenter;
    _presentpriceLabel.numberOfLines=0;
    [self.contentView addSubview:_presentpriceLabel];
    return _presentpriceLabel;
}


- (UILabel *)graylineLabel
{
    if (_graylineLabel == nil) {
        _graylineLabel = [[UILabel alloc] init];
    }
    [_graylineLabel setBackgroundColor:[UIColor grayColor]];
//    [self.contentView addSubview:_graylineLabel];
    return _graylineLabel;
}






-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    self.plateimageView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .centerXEqualToView(self.contentView)
    .widthIs((SCREEN_WIDTH-4)/2)
    .heightIs((SCREEN_WIDTH-4)/2);
    
    
  
    
    self.platenameLabel.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(self.plateimageView, 5)
//    .widthIs(self.contentView.width-10)
    .heightIs(40)
    ;
    
    
    
    self.presentpriceLabel.sd_layout
    .topSpaceToView(self.platenameLabel, 5)
    .leftEqualToView(self.platenameLabel)
//    .autoHeightRatio(0)
    .heightIs(10)
    ;
    [self.presentpriceLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];
    
    
    self.originalpriceLabel.sd_layout
    .leftSpaceToView(self.presentpriceLabel, 5)
    .bottomEqualToView(self.presentpriceLabel)
//    .autoHeightRatio(0)
    .heightIs(10)
    ;
    [self.originalpriceLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];
    
    
    
    self.graylineLabel.sd_layout
    .centerYEqualToView(self.originalpriceLabel)
    .centerXEqualToView(self.originalpriceLabel)
    .heightIs(1)
    .widthIs(40);
    
    
    
    
    
}


@end



