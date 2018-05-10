//
//  NinePiecesOfNineCollectionViewCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "CollectionGoodsTableViewCell.h"


@interface CollectionGoodsTableViewCell ()


/**
 *   图片
 */
@property(nonatomic,strong) UIImageView *plateimageView;
/**
 *   标题
 */
@property(nonatomic,strong) UILabel *platenameLabel;

@property(nonatomic,strong) UILabel *subTitlelabel;

@property(nonatomic,strong) UILabel *originalpriceLabel;
@property(nonatomic,strong) UILabel *presentpriceLabel;

@end

@implementation CollectionGoodsTableViewCell

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"CollectionGoodsTableViewCell";
    // 通过唯一标识创建cell实例
    CollectionGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[CollectionGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}


-(void)setGeneralGoodsModel:(GeneralGoodsModel *)GeneralGoodsModel{
    
    _GeneralGoodsModel=GeneralGoodsModel;
    
    
    [self.plateimageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName, GeneralGoodsModel.original_img]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    [self.platenameLabel setText:GeneralGoodsModel.goods_name];
    
    [self.subTitlelabel setText:@"同城配送"];
    
    //中划线
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %@", GeneralGoodsModel.market_price] attributes:attribtDic];
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
    _platenameLabel.contentMode=UIViewContentModeCenter;
    _platenameLabel.numberOfLines=0;
    [self.contentView addSubview:_platenameLabel];
    return _platenameLabel;
}


- (UILabel *)subTitlelabel
{
    if (_subTitlelabel == nil) {
        _subTitlelabel = [[UILabel alloc] init];
    }
    _subTitlelabel.font=PFR13Font;
    _subTitlelabel.textColor=[UIColor lightGrayColor];
    _subTitlelabel.textAlignment=NSTextAlignmentLeft;
    _subTitlelabel.contentMode=UIViewContentModeCenter;
    _subTitlelabel.numberOfLines=0;
    //    [self.contentView addSubview:_subTitlelabel];
    return _subTitlelabel;
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

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.plateimageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(80)
    .heightIs(80);
    
    
    self.platenameLabel.sd_layout
    .leftSpaceToView(self.plateimageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topEqualToView(self.plateimageView)
    .widthIs(self.contentView.width-110)
    .heightIs(20);
    
    
    self.subTitlelabel.sd_layout
    .leftSpaceToView(self.plateimageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.platenameLabel, 5)
    .widthIs(self.contentView.width-110)
    .heightIs(20);
    
    self.presentpriceLabel.sd_layout
    .bottomEqualToView(self.plateimageView)
    .leftEqualToView(self.platenameLabel)
    .autoHeightRatio(0);
    [self.presentpriceLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];
    
    self.originalpriceLabel.sd_layout
    .leftSpaceToView(self.presentpriceLabel, 5)
    .bottomEqualToView(self.presentpriceLabel)
    .autoHeightRatio(0);
    [self.originalpriceLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width/2];
    
    
}


@end

