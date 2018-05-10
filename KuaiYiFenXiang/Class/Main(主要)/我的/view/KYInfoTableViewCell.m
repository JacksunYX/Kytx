//
//  KYInfoTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYInfoTableViewCell.h"
#import "KYHeader.h"

@interface  KYInfoTableViewCell()

@end

@implementation KYInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = kColor666;
        _nameLabel.font = kFont(15);
        
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(140);
        }];
        
        _holder = [[UITextField alloc] init];
        _holder.textColor = kColor999;
        _holder.font = kFont(15);
        _holder.userInteractionEnabled = NO;
//        _holder.text = @"999";
        [self.contentView addSubview:_holder];
        [_holder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self).offset(-30);
        }];
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.holder.placeholder = placeholder;
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
