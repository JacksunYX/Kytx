//
//  JVShopcartCell.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "JVShopcartCountView.h"

@interface JVShopcartCell ()

@property (nonatomic, strong) UIView *shopcartBgView;
@property (nonatomic, strong) UIImageView *activitysmallImageView;
@property (nonatomic, strong) UILabel *activitysmallTextLabel;
@property (nonatomic, strong) UIButton *productSelectButton;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *productNameLable;
@property (nonatomic, strong) UILabel *productSizeLable;
@property (nonatomic, strong) UILabel *productPriceLable;
@property (nonatomic, strong) UILabel *originalpriceLabel;
@property (nonatomic, strong) UILabel *graylineLabel;
@property (nonatomic, strong) JVShopcartCountView *shopcartCountView;
@property (nonatomic, strong) UILabel *productStockLable;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
//小计
@property (nonatomic, strong) UILabel *subtotalLabel;
//删除
@property (nonatomic, strong) UIButton *deleteButton;

//防止误触发跳转详情页，添加一个专门提供点击跳转事件的遮罩
@property (nonatomic, strong) UIView *clickView;

@end

@implementation JVShopcartCell{
    
    NSInteger productPriceIt;
    NSInteger productCountIt;
    
}


+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"JVShopcartCell";
    // 通过唯一标识创建cell实例
    JVShopcartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[JVShopcartCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}


-(void)setJVShopcartProductModel:(JVShopcartProductModel *)JVShopcartProductModel{
    
    _JVShopcartProductModel=JVShopcartProductModel;
    
    [self.shopcartBgView setBackgroundColor:[UIColor whiteColor]];
    
    self.activitysmallImageView.image = [UIImage imageNamed:JVShopcartProductModel.activitysmallimageurlString];
    
    self.activitysmallTextLabel.text = JVShopcartProductModel.activitysmalltextString;
    
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,JVShopcartProductModel.productPicUri]]];
    
//    self.productNameLable.text = [NSString stringWithFormat:@"%@%@%@", JVShopcartProductModel.brandName, JVShopcartProductModel.productStyle, JVShopcartProductModel.productType];
    
    self.productNameLable.text = [NSString stringWithFormat:@"%@", JVShopcartProductModel.productName];

    //    self.productSizeLable.text = [NSString stringWithFormat:@"W:%ld H:%ld D:%ld", JVShopcartProductModel.specWidth, JVShopcartProductModel.specHeight, JVShopcartProductModel.specLength];
    
    self.productSizeLable.text = [NSString stringWithFormat:@"%@", JVShopcartProductModel.spec_key_name];
    
    self.productPriceLable.text = [NSString stringWithFormat:@"￥%.2f", JVShopcartProductModel.productPrice];
    
    //中划线
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f", JVShopcartProductModel.originPrice] attributes:attribtDic];
    [self.originalpriceLabel setAttributedText:attribtStr];
    
    productPriceIt=JVShopcartProductModel.productPrice;
    
    self.productSelectButton.selected = JVShopcartProductModel.isSelected;
    
    [self.shopcartCountView configureShopcartCountViewWithProductCount:JVShopcartProductModel.productQty productStock:JVShopcartProductModel.productStocks];
    
    self.productStockLable.text = [NSString stringWithFormat:@"库存:%ld", JVShopcartProductModel.productStocks];
    
    //进行默认的价格计算
    self.subtotalLabel.text=[NSString stringWithFormat:@"小计:￥%ld",JVShopcartProductModel.productQty*productPriceIt];
    
    
    [self setupViews];
    
    
}

- (void)setupViews {
    
    
    [self.contentView addSubview:self.shopcartBgView];
    [self.shopcartBgView addSubview:self.activitysmallImageView];
    [self.shopcartBgView addSubview:self.activitysmallTextLabel];
    [self.shopcartBgView addSubview:self.productSelectButton];
    [self.shopcartBgView addSubview:self.productImageView];
    [self.shopcartBgView addSubview:self.productNameLable];
    [self.shopcartBgView addSubview:self.productSizeLable];
    [self.shopcartBgView addSubview:self.productPriceLable];
    [self.shopcartBgView addSubview:self.originalpriceLabel];
    [self.shopcartBgView addSubview:self.shopcartCountView];
    [self.shopcartBgView addSubview:self.productStockLable];
    [self.shopcartBgView addSubview:self.topLineView];
//    [self.shopcartBgView addSubview:self.bottomLineView];
//    [self.shopcartBgView addSubview:self.subtotalLabel];
//    [self.shopcartBgView addSubview:self.deleteButton];
    [self.shopcartBgView addSubview:self.clickView];
    [self layoutSubviews];
    
}


- (void)productSelectButtonAction {
    self.productSelectButton.selected = !self.productSelectButton.isSelected;
    if (self.shopcartCellBlock) {
        self.shopcartCellBlock(self.productSelectButton.selected);
    }
}

- (UIImageView *)activitysmallImageView {
    if (_activitysmallImageView == nil){
        _activitysmallImageView = [[UIImageView alloc] init];
    }
    return _activitysmallImageView;
}
- (UILabel *)activitysmallTextLabel {
    if (_activitysmallTextLabel == nil){
        _activitysmallTextLabel = [[UILabel alloc] init];
        _activitysmallTextLabel.font = [UIFont systemFontOfSize:10];
        _activitysmallTextLabel.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
    }
    return _activitysmallTextLabel;
}
- (UIButton *)productSelectButton
{
    if(_productSelectButton == nil)
    {
        _productSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_productSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_productSelectButton addTarget:self action:@selector(productSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _productSelectButton;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil){
        _productImageView = [[UIImageView alloc] init];
        _productImageView.userInteractionEnabled = YES;
    }
    return _productImageView;
}

- (UILabel *)productNameLable {
    if (_productNameLable == nil){
        _productNameLable = [[UILabel alloc] init];
        _productNameLable.font = [UIFont systemFontOfSize:13];
        _productNameLable.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
        _productNameLable.numberOfLines = 2;
    }
    return _productNameLable;
}

- (UILabel *)productSizeLable {
    if (_productSizeLable == nil){
        _productSizeLable = [[UILabel alloc] init];
        if(ScreenW>=414 && ScreenH >=736){
            _productSizeLable.numberOfLines = 2;
        }else{
            _productSizeLable.numberOfLines = 1;
        }
        _productSizeLable.font = [UIFont systemFontOfSize:10];
        _productSizeLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productSizeLable;
}

- (UILabel *)productPriceLable {
    if (_productPriceLable == nil){
        _productPriceLable = [[UILabel alloc] init];
        _productPriceLable.font = [UIFont systemFontOfSize:14];
        _productPriceLable.textColor = [UIColor colorWithRed:0.918  green:0.141  blue:0.137 alpha:1];
    }
    return _productPriceLable;
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
    return _originalpriceLabel;
}


- (JVShopcartCountView *)shopcartCountView {
    if (_shopcartCountView == nil){
        _shopcartCountView = [[JVShopcartCountView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        
        _shopcartCountView.shopcartCountViewEditBlock = ^(NSInteger count){
            
            productCountIt=count;
            
            
            
            //在进行商品数量的变化时进行相应的cell刷新
            if (weakSelf.shopcartCellEditBlock) {
                
                weakSelf.shopcartCellEditBlock(count);
                
            }
            
            
            
        };
    }
    return _shopcartCountView;
}

- (UILabel *)productStockLable {
    if (_productStockLable == nil){
        _productStockLable = [[UILabel alloc] init];
        _productStockLable.font = [UIFont systemFontOfSize:13];
        _productStockLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productStockLable;
}

- (UIView *)shopcartBgView {
    if (_shopcartBgView == nil){
        _shopcartBgView = [[UIView alloc] init];
        _shopcartBgView.backgroundColor = [UIColor whiteColor];
    }
    return _shopcartBgView;
}

- (UIView *)topLineView {
    if (_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    }
    return _bottomLineView;
}

- (UILabel *)subtotalLabel {
    if (_subtotalLabel == nil){
        _subtotalLabel = [[UILabel alloc] init];
        [_subtotalLabel setTextColor:[UIColor redColor]];
        [_subtotalLabel setFont:PFR13Font];
    }
    return _subtotalLabel;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil){
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:PFR13Font];
        [_deleteButton  setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"删除icon"] forState:UIControlStateNormal];
        [_deleteButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.0];
        [_deleteButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _deleteButton;
}

-(UIView *)clickView
{
    if (!_clickView) {
        _clickView = [UIView new];
        _clickView.backgroundColor = [UIColor clearColor];
        MCWeakSelf;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {

            if (weakSelf.shopcartCellDidClickBlock) {
                weakSelf.shopcartCellDidClickBlock();
            }
        }];
        tap.numberOfTapsRequired = 1;
        [_clickView addGestureRecognizer:tap];
    }
    return _clickView;
}

-(void)deleteBtnClick:(UIButton *)sender
{
    // 进行删除的回调
    if (self.returnValueBlock) {
        //将自己的值传出去，完成传值
        self.returnValueBlock(self);
    }
    NSLog(@"删除---------%@",self);
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    //    if (kStringIsEmpty(self.JVShopcartProductModel.activitysmalltextString)) {
    //
    //        [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(self.shopcartBgView).offset(50);
    //            make.top.equalTo(self.shopcartBgView).offset(10);
    //            make.size.mas_equalTo(CGSizeMake(75, 75));
    //        }];
    //
    //    }else{
    //
    //        [self.activitysmallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(self.shopcartBgView).offset(10);
    //            make.top.equalTo(self.shopcartBgView).offset(10);
    //            make.size.mas_equalTo(CGSizeMake(25, 13));
    //        }];
    //
    //        [self.activitysmallTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(self.activitysmallImageView.mas_right).offset(5);
    //            make.centerY.equalTo(self.activitysmallImageView);
    //            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 13));
    //        }];
    //
    //        [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(self.shopcartBgView).offset(50);
    //            make.top.equalTo(self.activitysmallImageView.mas_bottom).offset(10);
    //            make.size.mas_equalTo(CGSizeMake(75, 75));
    //        }];
    //
    //    }
    //
    //
    //    [self.productSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.shopcartBgView).offset(10);
    //        make.centerY.equalTo(self.productImageView);
    //        make.size.mas_equalTo(CGSizeMake(12, 12));
    //    }];
    //
    //
    //
    //    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.productImageView.mas_right).offset(10);
    //        make.top.equalTo(self.productImageView).offset(0);
    //        make.right.equalTo(self.shopcartBgView).offset(-5);
    //    }];
    //
    //
    //    [self.productSizeLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.productImageView.mas_right).offset(10);
    //        make.top.equalTo(self.productNameLable.mas_bottom);
    //        make.right.equalTo(self.shopcartBgView).offset(-5);
    //        make.height.equalTo(@20);
    //    }];
    //
    //    [self.productPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.productImageView.mas_right).offset(10);
    //        make.bottom.equalTo(self.productImageView.mas_bottom).offset(0);
    //        make.width.equalTo(@45);
    //        make.height.equalTo(@20);
    //    }];
    //
    //    [self.originalpriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.productPriceLable.mas_right).offset(0);
    //        make.centerY.equalTo(self.productPriceLable);
    //        make.width.equalTo(@30);
    //        make.height.equalTo(@20);
    //    }];
    //
    //
    //    [self.productStockLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.shopcartBgView.mas_right).offset(-16);
    //        make.centerY.equalTo(self.productPriceLable);
    //    }];
    //
    //    [self.shopcartCountView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.productStockLable.mas_left).offset(-16);
    //        make.bottom.equalTo(self.productImageView).offset(0);
    //        make.size.mas_equalTo(CGSizeMake(78, 20));
    //    }];
    //
    //
    //
    //    [self.shopcartBgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.contentView);
    //    }];
    //
    //    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.shopcartBgView).offset(0);
    //        make.top.right.equalTo(self.shopcartBgView);
    //        make.height.equalTo(@1);
    //    }];
    //
    //
    //
    //
    //
    //
    //
    ////    [self.goodsProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.left.equalTo(self.shopcartBgView).offset(10);
    ////        make.top.equalTo(self.productImageView.mas_bottom).offset(10);
    ////        make.height.equalTo(@10.0);
    ////        make.width.equalTo(@(SCREEN_WIDTH-20));
    ////
    ////    }];
    ////
    ////
    ////
    ////
    ////
    ////    [self.alwaysneedtoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.left.equalTo(self.goodsProgressView);
    ////        make.top.equalTo(self.goodsProgressView).offset(10);
    ////    }];
    ////
    ////
    ////
    ////    [self.announcedprogressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.centerX.equalTo(self.goodsProgressView);
    ////        make.top.equalTo(self.goodsProgressView).offset(10);
    ////    }];
    ////
    ////
    ////    [self.surplusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.right.equalTo(self.goodsProgressView);
    ////        make.top.equalTo(self.goodsProgressView).offset(10);
    ////    }];
    //
    //
    //    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.shopcartBgView).offset(0);
    //        make.right.equalTo(self.shopcartBgView).offset(0);
    //        make.top.equalTo(self.productImageView.mas_bottom).offset(10);
    //        make.height.equalTo(@1);
    //    }];
    //
    //
    //
    //
    //
    //
    //    [self.subtotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.shopcartBgView).offset(10);
    //        make.top.equalTo(self.bottomLineView).offset(10);
    //    }];
    //
    //
    //    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.subtotalLabel);
    //        make.top.equalTo(self.bottomLineView).offset(8);
    //        make.right.equalTo(self.shopcartBgView).offset(0);
    //        make.size.mas_equalTo(CGSizeMake(80, 30));
    //    }];
    
    
    
    
    
    self.shopcartBgView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .widthIs(self.contentView.width)
    .heightIs(self.contentView.height);
    
    
    self.topLineView.sd_layout
    .topEqualToView(self.shopcartBgView)
    .leftEqualToView(self.shopcartBgView)
    .widthIs(self.contentView.width)
    .heightIs(1);
    
    if (kStringIsEmpty(self.JVShopcartProductModel.activitysmalltextString)) {
        
        self.productImageView.sd_layout
        .leftSpaceToView(self.shopcartBgView, 50)
        .topSpaceToView(self.shopcartBgView, 10)
        .widthIs(75)
        .heightIs(75);
        
    }else{
        
        self.activitysmallImageView.sd_layout
        .leftSpaceToView(self.shopcartBgView, 10)
        .topSpaceToView(self.shopcartBgView, 10)
        .widthIs(25)
        .heightIs(13);
        
        self.activitysmallTextLabel.sd_layout
        .centerYEqualToView(self.activitysmallImageView)
        .leftSpaceToView(self.activitysmallImageView, 5)
        .autoHeightRatio(0);
        [self.activitysmallTextLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
        
        
        self.productImageView.sd_layout
        .leftSpaceToView(self.shopcartBgView, 50)
        .topSpaceToView(self.activitysmallImageView, 10)
        .widthIs(75)
        .heightIs(75);
        
    }
    
    
    self.productSelectButton.sd_layout
    .leftSpaceToView(self.shopcartBgView, 10)
    .centerYEqualToView(self.productImageView)
    .widthIs(30)
    .heightIs(30);
    
    
//    self.productNameLable.sd_layout
//    .topEqualToView(self.productImageView)
//    .leftSpaceToView(self.productImageView, 10)
//    .rightEqualToView(self.contentView).offset(-10)
//    .autoHeightRatio(0);
//    [self.productNameLable setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-150];
    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView);
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        
    }];
    
    
    self.productPriceLable.sd_layout
    .bottomEqualToView(self.productImageView)
    .leftEqualToView(self.productNameLable)
    .autoHeightRatio(0);
    [self.productPriceLable setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    self.originalpriceLabel.sd_layout
    .centerYEqualToView(self.productPriceLable)
    .leftSpaceToView(self.productPriceLable, 10)
    .autoHeightRatio(0);
    [self.originalpriceLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    self.productStockLable.sd_layout
    .centerYEqualToView(self.productImageView)
    .rightSpaceToView(self.shopcartBgView, 16)
    .autoHeightRatio(0);
    [self.productStockLable setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    self.productSizeLable.sd_layout
    .topSpaceToView(self.productNameLable, 0)
    .leftEqualToView(self.productNameLable)
    .rightSpaceToView(self.productStockLable, 10)
    .autoHeightRatio(0);
//    [self.productSizeLable setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    self.shopcartCountView.sd_layout
    .rightSpaceToView(self.shopcartBgView, 10)
    .bottomEqualToView(self.productImageView)
    .widthIs(78)
    .heightIs(20);
    
//    self.bottomLineView.sd_layout
//    .topSpaceToView(self.productImageView, 10)
//    .leftEqualToView(self.shopcartBgView)
//    .widthIs(self.contentView.width)
//    .heightIs(1);
    
//    self.subtotalLabel.sd_layout
//    .topSpaceToView(self.bottomLineView, 10)
//    .leftSpaceToView(self.shopcartBgView, 10)
//    .autoHeightRatio(0);
//    [self.subtotalLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
//
//    self.deleteButton.sd_layout
//    .centerYEqualToView(self.subtotalLabel)
//    .rightSpaceToView(self.shopcartBgView, 10)
//    .widthIs(80)
//    .heightIs(30);
    
    _clickView.sd_layout
    .leftEqualToView(self.productImageView)
    .topEqualToView(self.productImageView)
    .bottomEqualToView(self.productImageView)
//    .rightSpaceToView(self.shopcartBgView, ScreenW/2)
    .widthIs(ScreenW/2)
    ;
    
    [self setupAutoHeightWithBottomView:self.bottomLineView bottomMargin:10];
    
    
}


+(CGFloat)cellHight:(JVShopcartProductModel *)jvspModel{
    
    if (kStringIsEmpty(jvspModel.activitysmalltextString)) {
        return SCREEN_WIDTH/4.3;
    }else{
        return SCREEN_WIDTH/2.65;
    }
    
}


@end

