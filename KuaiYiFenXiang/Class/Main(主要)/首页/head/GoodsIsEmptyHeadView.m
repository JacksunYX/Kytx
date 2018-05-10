//
//  DCEmptyCartView.m
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "GoodsIsEmptyHeadView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface GoodsIsEmptyHeadView ()

/* imageView */
@property (strong , nonatomic)UIImageView *emptyImageView;
/* 标语 */
@property (strong , nonatomic)UILabel *sloganLabel;
/* 广告 */
@property (strong , nonatomic)UILabel *adLabel;
/* 架构模拟购物车按钮 */
@property (strong , nonatomic)UIButton *buyingButton;

@property (strong , nonatomic)UIView *whiteview;

@property (strong , nonatomic)UIImageView *recommendedImageview;

@end

@implementation GoodsIsEmptyHeadView

#pragma mark - Intial
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    
    
    _whiteview = [[UIView alloc]init];
    [_whiteview setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_whiteview];
    
    
    _emptyImageView = [[UIImageView alloc] init];
    _emptyImageView.image = [UIImage imageNamed:@"goodsisempty"];
    [_whiteview addSubview:_emptyImageView];
    
    _sloganLabel = [[UILabel alloc] init];
    _sloganLabel.textColor = [UIColor darkGrayColor];
   
    _sloganLabel.font = PFR15Font;
    _sloganLabel.textAlignment = NSTextAlignmentCenter;
    _sloganLabel.numberOfLines = 0;
    [_whiteview addSubview:_sloganLabel];
    
    _recommendedImageview = [[UIImageView alloc]init];
    [_recommendedImageview setImage:[UIImage imageNamed:@"zuixintuijian"]];
    [self addSubview:_recommendedImageview];
    
//    _adLabel = [[UILabel alloc] init];
//    _adLabel.textColor = [UIColor orangeColor];
//    _adLabel.font = PFR14Font;
//    _adLabel.text = @"DC超市 酒水茗茶，全城畅想 →";
//    _adLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_adLabel];
//
//    _buyingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _buyingButton.titleLabel.font = PFR14Font;
//    [_buyingButton setTitle:@"立即抢购" forState:UIControlStateNormal];
//    [_buyingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _buyingButton.backgroundColor = [UIColor whiteColor];
//    [_buyingButton addTarget:self action:@selector(buyingButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_buyingButton];
}
- (void)setType:(NSInteger)type {
    _type = type;
    if (self.type == 1) {
        _emptyImageView.image = [UIImage imageNamed:@"goodsisempty"];
        _sloganLabel.text = @"没有找到您要的商品哦\n换个词再试试吧!";
    } else if (self.type == 2){
        _emptyImageView.image = [UIImage imageNamed:@"goodsisempty"];
        _sloganLabel.text = @"没有找到您要的店铺哦\n换个词再试试吧!";
    } else if (self.type == 3){
        _emptyImageView.image = [UIImage imageNamed:@"noLogisticsData"];
        _sloganLabel.text = @"暂无物流信息!";
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_whiteview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 220));
    }];
    
    [_emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_whiteview);
        make.top.mas_equalTo(_whiteview).offset(50);
        if (SCREEN_WIDTH == 568) {
            make.size.mas_equalTo(CGSizeMake(100, 76));
        }else{
            make.size.mas_equalTo(CGSizeMake(100, 76));
        }
    }];
    
    [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_whiteview);
        [make.top.mas_equalTo(_emptyImageView.mas_bottom)setOffset:14];
    }];

    [_recommendedImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80, 23));
    }];

//    [_adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        [make.top.mas_equalTo(_sloganLabel.mas_bottom)setOffset:10];
//    }];
//
//    [_buyingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        [make.top.mas_equalTo(_adLabel.mas_bottom)setOffset:10 * 2];
//        make.size.mas_equalTo(CGSizeMake(120, 35));
//    }];
}

#pragma mark - Setter Getter Methods



#pragma mark - 点击事件
- (void)buyingButtonClick
{

}

@end

