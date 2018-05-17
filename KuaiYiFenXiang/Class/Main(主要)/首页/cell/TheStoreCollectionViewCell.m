//
//  NinePiecesOfNineCollectionViewCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "TheStoreCollectionViewCell.h"

@interface TheStoreCollectionViewCell ()


/**
 *   图片
 */
@property(nonatomic,strong) UIImageView *storeLogoImageView;
/**
 *   标题
 */
@property(nonatomic,strong) UILabel *storeiNameLabel;

@property(nonatomic,strong) UIButton *enterStoreButton;

@property(nonatomic,strong) UILabel *shopIntroductionLabel;

@property(nonatomic,strong) UIImageView *shopPictureImageView1;
@property(nonatomic,strong) UIImageView *shopPictureImageView2;
@property(nonatomic,strong) UIImageView *shopPictureImageView3;

@end

@implementation TheStoreCollectionViewCell

-(void)setTheStoreModel:(TheStoreModel *)TheStoreModel{
    
    _TheStoreModel=TheStoreModel;
    
    [self.storeLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,TheStoreModel.logo]] placeholderImage:[UIImage imageNamed:@"店铺logo"]];
    
    [self.storeiNameLabel setText:TheStoreModel.name];
    
    [self.enterStoreButton setTitle:TheStoreModel.enterStoreString forState:UIControlStateNormal];
    
    [self.shopIntroductionLabel setText:[NSString stringWithFormat:@"销量:%@件  共%@件商品",TheStoreModel.sale_num,TheStoreModel.good_num]];

    TheStoreModel.shopPictureArray.count<1?:kStringIsEmpty(TheStoreModel.shopPictureArray[0])?:[self.shopPictureImageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,TheStoreModel.shopPictureArray[0]]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    TheStoreModel.shopPictureArray.count<2?:kStringIsEmpty(TheStoreModel.shopPictureArray[1])?:[self.shopPictureImageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,TheStoreModel.shopPictureArray[1]]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    TheStoreModel.shopPictureArray.count<3?:kStringIsEmpty(TheStoreModel.shopPictureArray[2])?:[self.shopPictureImageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,TheStoreModel.shopPictureArray[2]]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
    
}


-(UIImageView *)storeLogoImageView{
    if (_storeLogoImageView == nil) {
        _storeLogoImageView = [[UIImageView alloc] init];
    }
    //    [_plateimageView.layer setMasksToBounds:YES];
    //    [_plateimageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_storeLogoImageView];
    
    return _storeLogoImageView;
}


- (UILabel *)storeiNameLabel
{
    if (_storeiNameLabel == nil) {
        _storeiNameLabel = [[UILabel alloc] init];
    }
    _storeiNameLabel.font=PFR15Font;
    _storeiNameLabel.textColor=[UIColor blackColor];
    _storeiNameLabel.textAlignment=NSTextAlignmentLeft;
    _storeiNameLabel.contentMode=UIViewContentModeCenter;
    _storeiNameLabel.numberOfLines=0;
    [self.contentView addSubview:_storeiNameLabel];
    return _storeiNameLabel;
}


- (UIButton *)enterStoreButton
{
    if (_enterStoreButton == nil) {
        _enterStoreButton = [[UIButton alloc] init];
    }
    [_enterStoreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_enterStoreButton.layer setMasksToBounds:YES];
    [_enterStoreButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    //边框宽度
    [_enterStoreButton.layer setBorderWidth:1.0];
    _enterStoreButton.layer.borderColor=[UIColor redColor].CGColor;
    _enterStoreButton.titleLabel.font = PFR12Font;
    _enterStoreButton.backgroundColor =  [UIColor whiteColor];//hwcolor(18, 36, 46);
    [self.contentView addSubview:_enterStoreButton];
    [_enterStoreButton addTarget:self action:@selector(enterStoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return _enterStoreButton;
}

-(void)enterStoreButtonClick{
    
    if (self.didSelectedEnterStoreBlock) {
        self.didSelectedEnterStoreBlock(self.TheStoreModel);
    }
    
}

- (UILabel *)shopIntroductionLabel
{
    if (_shopIntroductionLabel == nil) {
        _shopIntroductionLabel = [[UILabel alloc] init];
    }
    _shopIntroductionLabel.font=PFR13Font;
    _shopIntroductionLabel.textColor=HexColor(666666);
    _shopIntroductionLabel.textAlignment=NSTextAlignmentLeft;
    _shopIntroductionLabel.contentMode=UIViewContentModeCenter;
    _shopIntroductionLabel.numberOfLines=0;
    [self.contentView addSubview:_shopIntroductionLabel];
    return _shopIntroductionLabel;
}

-(UIImageView *)shopPictureImageView1{
    if (_shopPictureImageView1 == nil) {
        _shopPictureImageView1 = [[UIImageView alloc] init];
    }
    //    [_plateimageView.layer setMasksToBounds:YES];
    //    [_plateimageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_shopPictureImageView1];
    
    return _shopPictureImageView1;
}

-(UIImageView *)shopPictureImageView2{
    if (_shopPictureImageView2 == nil) {
        _shopPictureImageView2 = [[UIImageView alloc] init];
    }
    //    [_plateimageView.layer setMasksToBounds:YES];
    //    [_plateimageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_shopPictureImageView2];
    
    return _shopPictureImageView2;
}

-(UIImageView *)shopPictureImageView3{
    if (_shopPictureImageView3 == nil) {
        _shopPictureImageView3 = [[UIImageView alloc] init];
    }
    //    [_plateimageView.layer setMasksToBounds:YES];
    //    [_plateimageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_shopPictureImageView3];
    
    return _shopPictureImageView3;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    //    /**
    //     *   图片
    //     */
    //    @property(nonatomic,strong) UIImageView *storeLogoImageView;
    //    /**
    //     *   标题
    //     */
    //    @property(nonatomic,strong) UILabel *storeiNameLabel;
    //
    //    @property(nonatomic,strong) UIButton *enterStoreButton;
    //
    //    @property(nonatomic,strong) UILabel *shopIntroductionLabel;
    //
    //    @property(nonatomic,strong) UIImageView *shopPictureImageView1;
    //    @property(nonatomic,strong) UIImageView *shopPictureImageView2;
    //    @property(nonatomic,strong) UIImageView *shopPictureImageView3;
    //
    
    
    
    self.storeLogoImageView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(40)
    .heightIs(40);
    
    self.storeiNameLabel.sd_layout
    .leftSpaceToView(self.storeLogoImageView, 10)
    .centerYEqualToView(self.storeLogoImageView)
    .autoHeightRatio(0)
    ;
    [self.storeiNameLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width-75];
    
    self.enterStoreButton.sd_layout
    .rightSpaceToView(self.contentView, 16)
    .centerYEqualToView(self.storeLogoImageView)
    .widthIs(80)
    .heightIs(30);
    
    self.shopIntroductionLabel.sd_layout
    .topSpaceToView(self.storeLogoImageView, 10)
    .leftEqualToView(self.storeLogoImageView)
//    .autoHeightRatio(0)
    .heightIs(10)
    ;
    [self.shopIntroductionLabel setSingleLineAutoResizeWithMaxWidth:self.contentView.width-30];
    
    
    self.shopPictureImageView1.sd_layout
    .topSpaceToView(self.shopIntroductionLabel, 10)
    .leftEqualToView(self.storeLogoImageView)
    .widthIs((SCREEN_WIDTH-40)/3)
    .heightIs((SCREEN_WIDTH-40)/3);
    
    self.shopPictureImageView2.sd_layout
    .topEqualToView(self.shopPictureImageView1)
    .leftSpaceToView(self.shopPictureImageView1, 5)
    .widthIs((SCREEN_WIDTH-40)/3)
    .heightIs((SCREEN_WIDTH-40)/3);
    
    self.shopPictureImageView3.sd_layout
    .topEqualToView(self.shopPictureImageView2)
    .leftSpaceToView(self.shopPictureImageView2, 5)
    .widthIs((SCREEN_WIDTH-40)/3)
    .heightIs((SCREEN_WIDTH-40)/3);
    
}


@end

