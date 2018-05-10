//
//  DCEmptyCartView.m
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCEmptyCartView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCEmptyCartView ()

/* imageView */
@property (strong , nonatomic)UIImageView *emptyImageView;
/* 架构模拟购物车按钮 */
@property (strong , nonatomic)UIButton *collectionButton;
@property (strong , nonatomic)UIButton *browseButton;
@end

@implementation DCEmptyCartView

#pragma mark - Intial
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _emptyImageView = [[UIImageView alloc] init];
    _emptyImageView.image = [UIImage imageNamed:@"emptycar"];
    [self addSubview:_emptyImageView];
    
    _collectionButton=[[UIButton alloc]init];
    [_collectionButton setTitleColor:hwcolor(201, 35, 35) forState:UIControlStateNormal];
    [_collectionButton.layer setMasksToBounds:YES];
    [_collectionButton.layer setCornerRadius:5.0];
    [_collectionButton.layer setBorderWidth:1.0];
    _collectionButton.layer.borderColor=hwcolor(201, 35, 35).CGColor;
    _collectionButton.titleLabel.font=[UIFont systemFontOfSize:13];
    _collectionButton.backgroundColor=  [UIColor whiteColor];
    [_collectionButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self addSubview:_collectionButton];
    [_collectionButton addTarget:self action:@selector(collectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _browseButton=[[UIButton alloc]init];
    [_browseButton setTitleColor:hwcolor(201, 35, 35) forState:UIControlStateNormal];
    [_browseButton.layer setMasksToBounds:YES];
    [_browseButton.layer setCornerRadius:5.0];
    [_browseButton.layer setBorderWidth:1.0];
    _browseButton.layer.borderColor=hwcolor(201, 35, 35).CGColor;
    _browseButton.titleLabel.font=[UIFont systemFontOfSize:13];
    _browseButton.backgroundColor=  [UIColor whiteColor];
    [_browseButton setTitle:@"逛逛9.9" forState:UIControlStateNormal];
    [self addSubview:_browseButton];
    [_browseButton addTarget:self action:@selector(browseButtonClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _emptyImageView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(167)
    .heightIs(100);
    
    _collectionButton.sd_layout
    .topSpaceToView(_emptyImageView, 25)
    .leftSpaceToView(self, 80)
    .widthIs(100)
    .heightIs(25);
    
    _browseButton.sd_layout
    .topSpaceToView(_emptyImageView, 25)
    .rightSpaceToView(self, 80)
    .widthIs(100)
    .heightIs(25);

}

#pragma mark - Setter Getter Methods



#pragma mark - 点击事件
- (void)collectionButtonClick
{
    !_collectionButtonClickBlock ? : _collectionButtonClickBlock();
}

#pragma mark - 点击事件
- (void)browseButtonClick
{
    !_browseButtonClickBlock ? : _browseButtonClickBlock();
}

@end
