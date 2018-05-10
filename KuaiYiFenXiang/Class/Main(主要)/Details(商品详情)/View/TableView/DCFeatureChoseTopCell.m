//
//  DCFeatureChoseTopCell.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureChoseTopCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCFeatureChoseTopCell ()

/* 取消 */
@property (strong , nonatomic)UIButton *crossButton;

/* '积'字图标 */
@property (strong , nonatomic)UIImageView *integralIcon;

@end

@implementation DCFeatureChoseTopCell

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUpUI
{
    _crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_crossButton setImage:[UIImage imageNamed:@"icon_cha"] forState:0];
    [_crossButton addTarget:self action:@selector(crossButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_crossButton];
    
    _goodImageView = [UIImageView new];
    [self addSubview:_goodImageView];
    
    _goodPriceLabel = [UILabel new];
    _goodPriceLabel.font = PFR18Font;
    _goodPriceLabel.textColor = [UIColor redColor];
    
    [self addSubview:_goodPriceLabel];
    
    _chooseAttLabel = [UILabel new];
    _chooseAttLabel.numberOfLines = 2;
    if (ScreenW<=320&&ScreenH<=568) {
        _chooseAttLabel.font = PFR10Font;
    }else{
        _chooseAttLabel.font = PFR12Font;
    }
    
    [self addSubview:_chooseAttLabel];
    
    _storecountLabel = [UILabel new];
    _storecountLabel.numberOfLines = 2;
    _storecountLabel.font = PFR14Font;
    [self addSubview:_storecountLabel];
    
    _integralIcon = [UIImageView new];
    _integralIcon.image =UIImageNamed(@"gaojifen");
    [self addSubview:_integralIcon];
    
    _integralLabel = [UILabel new];
    _integralLabel.font = PFR14Font;
    _integralLabel.numberOfLines = 1;
    [self addSubview:_integralLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_crossButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_goodImageView.mas_right)setOffset:DCMargin];
        [make.top.mas_equalTo(_goodImageView)setOffset:DCMargin];
    }];
    
    [_chooseAttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_goodPriceLabel);
//        make.right.mas_equalTo(_crossButton.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        [make.top.mas_equalTo(_goodPriceLabel.mas_bottom)setOffset:5];
    }];
    
    [_storecountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_goodPriceLabel);
//        make.right.mas_equalTo(_crossButton.mas_left);
//        [make.top.mas_equalTo(_chooseAttLabel.mas_bottom)setOffset:5];
        make.left.equalTo(_goodPriceLabel.mas_right).offset(10);
        make.centerY.equalTo(_goodPriceLabel);
//        make.top.equalTo(_goodPriceLabel.mas_top);
//        make.right.equalTo(_crossButton.mas_left).offset(10);
    }];
    //暂时不写考虑抗拉伸的问题
    
    [_integralIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_storecountLabel.mas_right).offset(10);
        make.centerY.equalTo(_goodPriceLabel);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
    
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_integralIcon.mas_right).offset(5);
//        make.top.equalTo(_storecountLabel.mas_top);
        make.centerY.equalTo(_goodPriceLabel);
        make.right.equalTo(_crossButton.mas_left).offset(-10);
    }];
//    _integralLabel.text = @"积分：20";
}


- (void)crossButtonClick
{
    !_crossButtonClickBlock ?: _crossButtonClickBlock();
}

#pragma mark - Setter Getter Methods


@end
