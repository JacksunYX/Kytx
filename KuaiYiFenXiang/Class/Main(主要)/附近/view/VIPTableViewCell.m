//
//  VIPTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/24.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "VIPTableViewCell.h"
#import "KYHeader.h"

@interface VIPTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *vipTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *pointLabel;


@end

@implementation VIPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"login_logo"];
        
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        _vipTitleLabel = [UILabel new];
        
        _vipTitleLabel.font = kFont(13);
        _vipTitleLabel.numberOfLines = 2;
        _vipTitleLabel.textColor = kColor333;
        _vipTitleLabel.text = @"【VIP赠品】福建特级铁观音";
        
        [self.contentView addSubview:_vipTitleLabel];
        [_vipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(15);
            make.top.equalTo(_iconImageView);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积"]];
        
        [self.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.left.equalTo(_vipTitleLabel);
            make.bottom.equalTo(_iconImageView);
        }];
        
        _pointLabel = [UILabel new];
        
        _pointLabel.text = @"3.99分";
        _pointLabel.textColor = kColor333;
        _pointLabel.font = kFont(12);
        
        [self.contentView addSubview:_pointLabel];
        [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_right).offset(5);
            make.centerY.equalTo(imageview);
        }];
        
        _priceLabel = [UILabel new];
        
        _priceLabel.font = kFont(15);
        _priceLabel.textColor = kColord40;
        _priceLabel.text = @"￥399.00";
        
        [self.contentView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_vipTitleLabel);
            make.bottom.equalTo(_pointLabel.mas_top).offset(-10);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
        [btn setTitle:@" 购买升级VIP " forState:UIControlStateNormal];
        [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = kFont(12);
        
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 23));
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)click:(UIButton *)sender {
    if (self.clickHandler) {
        self.clickHandler(self.model);
    }
}

- (void)setModel:(VIPDetailModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:model.original_img]]];
    self.vipTitleLabel.text = model.goods_name;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
