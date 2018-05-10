//
//  HomePageSecondCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "HomePageSecondCell.h"

@interface HomePageSecondCell ()
{
    UIImageView *imgV;
    UILabel *goodName;
    UILabel *shop_price;    //店面价
    UILabel *market_price;  //市场价
    UIView *line;   //横线
    UIImageView *shoppingIcon;  //购物车图标
}
@end

@implementation HomePageSecondCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    imgV = [UIImageView new];
    goodName = [UILabel new];
    shop_price = [UILabel new];
    market_price = [UILabel new];
    shoppingIcon = [UIImageView new];
    
    [self.contentView sd_addSubviews:@[
                                       imgV,
                                       goodName,
                                       shop_price,
                                       market_price,
                                       shoppingIcon,
                                       
                                       ]];
    //布局
    imgV.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs((SCREEN_WIDTH - 30) * 0.5)
    ;
//    imgV.backgroundColor = hwrandomcolor;
    
    goodName.sd_layout
    .topSpaceToView(imgV, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
//    .autoHeightRatio(0)
    .heightIs(15)
    ;
//    goodName.backgroundColor = hwrandomcolor;
    
    shop_price.sd_layout
    .topSpaceToView(goodName, 15)
    .leftSpaceToView(self.contentView, 5)
    .heightIs(15)
    ;
    shop_price.textColor = [UIColor redColor];
    [shop_price setSingleLineAutoResizeWithMaxWidth:ScreenW/5];
    
    market_price.sd_layout
    .centerYEqualToView(shop_price)
    .leftSpaceToView(shop_price, 5)
    .heightIs(10)
    ;
    market_price.font = Font(10);
    market_price.textColor = [UIColor grayColor];
    [market_price setSingleLineAutoResizeWithMaxWidth:50];
    
    shoppingIcon.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(shop_price)
    .widthIs(19)
    .heightIs(17)
    ;
    [shoppingIcon setImage:UIImageNamed(@"addshoppingcarimage")];
    
    line = [UIView new];
    [market_price addSubview:line];
    line.sd_layout
    .centerYEqualToView(market_price)
    .leftEqualToView(market_price)
    .rightEqualToView(market_price)
    .heightIs(1)
    ;
    line.backgroundColor = [UIColor grayColor];
    line.hidden = YES;
}

-(void)setModel:(GeneralGoodsModel *)model
{
    _model = model;
    kStringIsEmpty(model.original_img)?:[imgV sd_setImageWithURL:JointImgUrl(model.original_img)];
    goodName.text = model.goods_name;
    
    if (kStringIsEmpty(model.shop_price)) {
        shop_price.text = @"暂无店面价";
    }else{
        shop_price.text = [@"￥" stringByAppendingString:model.shop_price];
    }
    
    if (kStringIsEmpty(model.market_price)) {
        market_price.text = @"暂无市场价";
        line.hidden = YES;
    }else{
        market_price.text = [@"￥" stringByAppendingString:model.market_price];
        line.hidden = NO;
    }

}






@end
