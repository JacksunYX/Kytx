//
//  DCGoodsYouLikeCell.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#define cellWH ScreenW * 0.5 - 50

#import "DCGoodsYouLikeCell.h"

// Controllers

// Models
#import "DCRecommendItem.h"
// Views

// Vendors
// Categories

// Others

@interface DCGoodsYouLikeCell ()

/* 图片 */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* 标题 */
@property (strong , nonatomic)UILabel *goodsLabel;
/* 价格 */
@property (strong , nonatomic)UILabel *priceLabel;

@property (strong , nonatomic)UIImageView *newsImageView;


@end

@implementation DCGoodsYouLikeCell

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
    self.backgroundColor = [UIColor whiteColor];
    _goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_goodsImageView];
    
    _newsImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_newsImageView];
    
    _goodsLabel = [[UILabel alloc] init];
    _goodsLabel.font = PFR12Font;
    _goodsLabel.numberOfLines = 2;
    _goodsLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_goodsLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = PFR15Font;
    [self.contentView addSubview:_priceLabel];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgW = (SCREEN_WIDTH - 10) * 0.5 - 20;
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(imgW, imgW));
    }];
    
    [_newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(5);
//        make.top.mas_equalTo(_goodsImageView.mas_bottom).offset(13);
        make.centerY.equalTo(_goodsLabel.mas_centerY);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(10);
    }];
    
    [_goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_newsImageView.mas_right)setOffset:10];
        make.width.mas_equalTo(self.contentView).multipliedBy(0.7);
//        make.height.mas_equalTo(30);
        [make.top.mas_equalTo(_goodsImageView.mas_bottom)setOffset:13];
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_newsImageView);
        make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
//        make.top.mas_equalTo(self.goodsLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    _goodsLabel.preferredMaxLayoutWidth = ((SCREEN_WIDTH - 10)/2) * 0.7;
    [_goodsLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}


#pragma mark - Setter Getter Methods
- (void)setYouLikeItem:(NewproductrecommendationModel *)youLikeItem
{
    _youLikeItem=youLikeItem;
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,youLikeItem.original_img]]];
    [_newsImageView setImage:[UIImage imageNamed:@"new"]];
    _goodsLabel.text = youLikeItem.goods_name;
    _priceLabel.text = [NSString stringWithFormat:@"¥ %@",youLikeItem.shop_price];

}

#pragma mark - 点击事件
- (void)lookSameGoods
{
    !_lookSameBlock ? : _lookSameBlock();
}

@end
