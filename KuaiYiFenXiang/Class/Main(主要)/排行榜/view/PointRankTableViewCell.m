//
//  PointRankTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "PointRankTableViewCell.h"
#import "KYHeader.h"

@implementation PointRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageview = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageview];
        [_iconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        _iconLabel = [[UILabel alloc] init];
        
        _iconLabel.layer.cornerRadius = 9;
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        _iconLabel.layer.masksToBounds = YES;
        _iconLabel.backgroundColor = kColord40;
        _iconLabel.textColor = kWhiteColor;
        _iconLabel.adjustsFontSizeToFitWidth = YES;
        _iconLabel.font = kFont(15);
        [self.contentView addSubview:_iconLabel];
        [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(3.5);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        _nameLabel = [UILabel new];
        
        _nameLabel.font = kFont(15);
        _nameLabel.textColor = kColor666;
        
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(40);
        }];
        
        _pointLabel = [UILabel new];
        
        _pointLabel.textColor = kColor333;
        _pointLabel.font = kFont(15);
        
        [self.contentView addSubview:_pointLabel];
        [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-25);
        }];
    }
    return self;
}

- (void)setType:(NSInteger)type {
    _type = type;
    
    if (type == 0) {
        self.iconLabel.hidden = YES;
        self.iconImageview.hidden = NO;
        self.iconImageview.image = [UIImage imageNamed:@"积分排行榜01"];
    } else if (type == 1) {
        self.iconLabel.hidden = YES;
        self.iconImageview.hidden = NO;
        self.iconImageview.image = [UIImage imageNamed:@"积分排行榜02"];
    } else if (type == 2) {
        self.iconLabel.hidden = YES;
        self.iconImageview.hidden = NO;
        self.iconImageview.image = [UIImage imageNamed:@"积分排行榜03"];
    } else {
        self.iconLabel.hidden = NO;
        self.iconImageview.hidden = YES;

    }
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
