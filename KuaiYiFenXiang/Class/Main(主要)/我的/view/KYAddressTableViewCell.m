//
//  AddressTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYAddressTableViewCell.h"
#import "KYHeader.h"

@interface KYAddressTableViewCell ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *phoneLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UIButton *defaultBtn;
@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UIButton *deleteBtn;


@end

@implementation KYAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [self createLabel];
        _nameLabel.text = @"文戬";
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(20);
        }];
        
        _phoneLabel = [self createLabel];
        _phoneLabel.text = @"186****5507 ";
        [self.contentView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(35);
            make.centerY.equalTo(_nameLabel);
        }];
        
        _addressLabel = [self createLabel];
        _addressLabel.text = @"湖北省武汉市江夏区武大航域2区A2";
        [self.contentView addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(15);
            make.right.equalTo(self.contentView);
        }];
        
        UIView *line = [UIView new];
        
        line.backgroundColor = kDefaultBGColor;
        
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addressLabel.mas_bottom).offset(20);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        
        _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _defaultBtn.backgroundColor = [UIColor greenColor];
        
        [self.contentView addSubview:_defaultBtn];
//        [_defaultBtn setBackgroundImage:[KYHeader imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(line.mas_bottom);
            make.width.equalTo(@70);
            make.bottom.equalTo(self.contentView);
        }];
        
        [_defaultBtn addTarget:self action:@selector(defaultAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"默认地址"]];
        [_defaultBtn addSubview:dot];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_defaultBtn);
            make.centerY.equalTo(_defaultBtn);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        UILabel *alabel = [self createLabel];
        alabel.text = @"默认地址";
        [_defaultBtn addSubview:alabel];
        [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dot.mas_right).offset(5);
            make.centerY.equalTo(dot);
        }];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteBtn.backgroundColor = [UIColor redColor];
        [_deleteBtn addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_defaultBtn);
            make.right.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, 40));
        }];
        
        UIImageView *del = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"删除icon"]];
        [_deleteBtn addSubview:del];
        [del mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_deleteBtn);
            make.centerY.equalTo(_deleteBtn);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *blabel = [self createLabel];
        blabel.text = @"删除";
        [_deleteBtn addSubview:blabel];
        [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(del.mas_right).offset(5);
            make.centerY.equalTo(del);
        }];
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _editBtn.backgroundColor = [UIColor greenColor];
        [_editBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_defaultBtn);
            make.right.equalTo(_deleteBtn.mas_left).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, 40));
        }];
        
        UIImageView *edit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"编辑icon"]];
        [_editBtn addSubview:edit];
        [edit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_editBtn);
            make.centerY.equalTo(_editBtn);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *clabel = [self createLabel];
        clabel.text = @"编辑";
        [_editBtn addSubview:clabel];
        [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(edit.mas_right).offset(5);
            make.centerY.equalTo(_editBtn);
           
        }];
    }
    return self;
}
- (void)defaultAddress:(UIButton *)sender {
    NSLog(@"设置默认地址");
    if (sender.isSelected) {
        return;
    }
    sender.selected = !sender.isSelected;
    UIImageView *img;
    for (UIView *sub in sender.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            img = (UIImageView *)sub;
        }
    }
    if (sender.isSelected) {
        img.image = [UIImage imageNamed:@"默认地址_s"];
        if (self.didClickDefaultHandler) {
            self.didClickDefaultHandler(self.model);
        }
    } else {
        img.image = [UIImage imageNamed:@"默认地址"];
    }
}

- (void)editAddress:(UIButton *)sender {
    if (self.didClickEditHandler) {
        self.didClickEditHandler(self.model);
    }
}

- (void)deleteAddress:(UIButton *)sender {
    if (self.didClickDeleteHandler) {
        self.didClickDeleteHandler(self.model);
    }
}
- (UILabel *)createLabel {
    UILabel *label = [UILabel new];
    label.textColor = kColor666;
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

- (void)setModel:(KYAddressModel *)model {
    _model = model;
    
    self.nameLabel.text = model.consignee;
    self.phoneLabel.text = model.mobile;
    
    NSString *province = @"";
    NSString *city= @"";
    NSString *district= @"";
    NSString *twon= @"";
    
    for (AreaModel *amodel in self.area) {
        if ([amodel.area_id isEqualToString:model.province]) {
            province = amodel.name;
        }
        
        if ([amodel.area_id isEqualToString:model.city]) {
            city = amodel.name;
        }
        if ([amodel.area_id isEqualToString:model.district]) {
            district = amodel.name;
        }
        if ([amodel.area_id isEqualToString:model.twon]) {
            twon = amodel.name;
        }
    }
    self.addressLabel.text = [[[[province stringByAppendingString:city] stringByAppendingString:district] stringByAppendingString:twon] stringByAppendingString:model.address];
    
    if (model.is_default) {
        self.defaultBtn.selected = YES;
        UIImageView *img;
        for (UIView *sub in self.defaultBtn.subviews) {
            if ([sub isKindOfClass:[UIImageView class]]) {
                img = (UIImageView *)sub;
            }
        }
        img.image = [UIImage imageNamed:@"默认地址_s"];
    } else {
        self.defaultBtn.selected = NO;
        UIImageView *img;
        for (UIView *sub in self.defaultBtn.subviews) {
            if ([sub isKindOfClass:[UIImageView class]]) {
                img = (UIImageView *)sub;
            }
        }
        img.image = [UIImage imageNamed:@"默认地址"];
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
