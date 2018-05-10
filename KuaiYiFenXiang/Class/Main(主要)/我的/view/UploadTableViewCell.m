//
//  UploadTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/24.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "UploadTableViewCell.h"
#import "KYHeader.h"

@interface UploadTableViewCell ()

@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;

@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;
@property (nonatomic, strong) UIButton *btn6;

@end

@implementation UploadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label1 = [UILabel new];
        _label1.text = @"上传身份证照：";
        _label1.textColor = kColor333;
        _label1.font = kFont(13);
        
        [self.contentView addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.width.mas_equalTo(130);
        }];
        
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_btn1 setTitle:@"身份证正面" forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        _btn1.layer.cornerRadius = 5;
//        _btn1.layer.masksToBounds = YES;
        _btn1.layer.borderWidth = 1;
        _btn1.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        _btn1.tag = 1001;
        [self.contentView addSubview:_btn1];
        [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label1.mas_right).offset(15);
            make.top.equalTo(_label1);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        UILabel *alabel = [UILabel new];
        
        alabel.textColor = kColor333;
        alabel.font = kFont(12);
        alabel.text = @"身份证正面";
        
        [_btn1 addSubview:alabel];
        [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_btn1);
            make.bottom.equalTo(_btn1).offset(-10);
        }];
        
        _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btn4 setTitle:@"查看示例" forState:UIControlStateNormal];
        _btn4.titleLabel.font = kFont(13);
        _btn4.tag = 1004;
        [_btn4 setTitleColor:kColord40 forState:UIControlStateNormal];

        [self.contentView addSubview:_btn4];
        [_btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_btn1.mas_right).offset(15);
            make.centerY.equalTo(_btn1);
            make.size.mas_equalTo(CGSizeMake(70, 40));
        }];
        
        _label2 = [UILabel new];
        _label2.text = @"";
        _label2.textColor = kColor333;
        _label2.font = kFont(13);
        
        [self.contentView addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_btn1.mas_bottom).offset(15);
            make.width.mas_equalTo(130);
        }];
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_btn2 setTitle:@"身份证反面" forState:UIControlStateNormal];
//        _btn2.backgroundColor = [UIColor redColor];
        [_btn2 setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        _btn2.tag = 1002;
        _btn2.layer.cornerRadius = 5;
//        _btn2.layer.masksToBounds = YES;
        _btn2.layer.borderWidth = 1;
        _btn2.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        [self.contentView addSubview:_btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label2.mas_right).offset(15);
            make.top.equalTo(_label2);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        UILabel *blabel = [UILabel new];
        
        blabel.textColor = kColor333;
        blabel.font = kFont(12);
        blabel.text = @"身份证反面";
        
        [_btn2 addSubview:blabel];
        [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_btn2);
            make.bottom.equalTo(_btn2).offset(-10);
        }];
        
        _btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btn5 setTitle:@"查看示例" forState:UIControlStateNormal];
        _btn5.titleLabel.font = kFont(13);
        _btn5.tag = 1005;
        [_btn5 setTitleColor:kColord40 forState:UIControlStateNormal];
        
        [self.contentView addSubview:_btn5];
        [_btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_btn2.mas_right).offset(15);
            make.centerY.equalTo(_btn2);
            make.size.mas_equalTo(CGSizeMake(70, 40));
        }];
        
        //=================
        _label3 = [UILabel new];
        _label3.text = @"上传店铺照片：";
        _label3.textColor = kColor333;
        _label3.font = kFont(13);
        
        [self.contentView addSubview:_label3];
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_btn2.mas_bottom).offset(15);
            make.width.mas_equalTo(130);
        }];
        
        _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_btn3 setTitle:@"店铺照" forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
//        _btn3.backgroundColor = [UIColor redColor];
        _btn3.layer.cornerRadius = 5;
//        _btn3.layer.masksToBounds = YES;
        _btn3.layer.borderWidth = 1;
        _btn3.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        _btn3.tag = 1003;
        [self.contentView addSubview:_btn3];
        [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label3.mas_right).offset(15);
            make.top.equalTo(_label3);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        UILabel *clabel = [UILabel new];
        
        clabel.textColor = kColor333;
        clabel.font = kFont(12);
        clabel.text = @"店铺照";
        
        [_btn3 addSubview:clabel];
        [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_btn3);
            make.bottom.equalTo(_btn3).offset(-10);
        }];
        
        _btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btn6 setTitle:@"查看示例" forState:UIControlStateNormal];
        _btn6.titleLabel.font = kFont(13);
        _btn6.tag = 1006;
        [_btn6 setTitleColor:kColord40 forState:UIControlStateNormal];
        
        [self.contentView addSubview:_btn6];
        [_btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_btn3.mas_right).offset(15);
            make.centerY.equalTo(_btn3);
            make.size.mas_equalTo(CGSizeMake(70, 40));
        }];
        
        
        [_btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn4 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn5 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn6 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UIButton *)btn1 {
    return _btn1;
}

- (UIButton *)btn2 {
    return _btn2;
}

- (UIButton *)btn3 {
    return _btn3;
}

- (void)click:(UIButton *)sender {
    if (self.clickHandler) {
        self.clickHandler(sender.tag - 1000);
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
