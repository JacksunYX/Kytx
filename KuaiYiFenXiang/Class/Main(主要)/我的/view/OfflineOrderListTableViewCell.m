//
//  OfflineOrderListTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OfflineOrderListTableViewCell.h"
#import "KYHeader.h"

@interface OfflineOrderListTableViewCell ()

@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *aview;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UILabel *ratioDescLabel;
@property (nonatomic, strong) UILabel *ratioLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *statusBtn;

@end

@implementation OfflineOrderListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _orderLabel = [UILabel new];
        
        _orderLabel.textColor = kColor333;
        _orderLabel.font = kFont(13);
        _orderLabel.text = @"订单编号：1111111111111";
        
        [self.contentView addSubview:_orderLabel];
        [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(15);
        }];
        
        _timeLabel  = [UILabel new];
        
        _timeLabel.textColor = kColord40;
        _timeLabel.font = kFont(13);
        _timeLabel.text = @"2099-13-31 24:00:00";
        
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_orderLabel);
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_orderLabel.mas_bottom).offset(5);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(15);
        }];
        
        _aview = [UIView new];
        
        _aview.backgroundColor = kDefaultBGColor;
        
        [self.contentView addSubview:_aview];
        [_aview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(_timeLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(105);
        }];
        
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-头像"]];
        
        [_aview addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_aview).offset(15);
            make.centerY.equalTo(_aview);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        _userNameLabel = [UILabel new];
        
        _userNameLabel.textColor = kColor333;
        _userNameLabel.font = kFont(13);
        _userNameLabel.text = @"用户名";
        
        [_aview addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(10);
            make.bottom.equalTo(_iconImageView.mas_centerY).offset(-5);
        }];
        
        _mobileLabel = [UILabel new];
        
        _mobileLabel.textColor = kColor333;
        _mobileLabel.font = kFont(12);
        
        [_aview addSubview:_mobileLabel];
        [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_centerY).offset(5);
            make.left.equalTo(_userNameLabel);
        }];
        
        _costLabel = [UILabel new];
        
        _costLabel.textColor = kColor666;
        _costLabel.font = kFont(12);
        _costLabel.text = @"消费金额：10000元";
        
        [_aview addSubview:_costLabel];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_aview).offset(-15);
            make.centerY.equalTo(_userNameLabel);
        }];
        
        _payLabel = [UILabel new];
        
        _payLabel.textColor = kColor333;
        _payLabel.font = kFont(12);
        _payLabel.text = @"代付金额：5000元";
        
        [_aview addSubview:_payLabel];
        [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_costLabel);
            make.centerY.equalTo(_mobileLabel);
        }];
        
        _ratioDescLabel = [UILabel new];
        
        _ratioDescLabel.textColor = kColor333;
        _ratioDescLabel.font = kFont(13);
        _ratioDescLabel.text = @"商家让利比：";
        
        [self.contentView addSubview:_ratioDescLabel];
        [_ratioDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_aview.mas_bottom).offset(15);
            make.height.mas_equalTo(15);
        }];
        
        _ratioLabel = [UILabel new];
        
        _ratioLabel.textColor = kColord40;
        _ratioLabel.font = kFont(13);
        _ratioLabel.text = @"50%";
        
        [self.contentView addSubview:_ratioLabel];
        [_ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_ratioDescLabel.mas_right);
            make.centerY.equalTo(_ratioDescLabel);
            make.height.mas_equalTo(15);
        }];
        
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_statusBtn setTitleColor:kColord40 forState:UIControlStateNormal];
        [_statusBtn setTitle:@"  交易成功  " forState:UIControlStateNormal];
        _statusBtn.layer.cornerRadius = 3;
        _statusBtn.layer.borderColor = kColord40.CGColor;
        _statusBtn.layer.borderWidth = 0.5;
        _statusBtn.titleLabel.font = kFont(13);
        [_statusBtn addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_statusBtn];
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_ratioLabel);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(15);
        }];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteBtn setTitle:@"  删除订单  " forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = kFont(13);
        _deleteBtn.layer.cornerRadius = 3;
        _deleteBtn.layer.borderColor = kColor333.CGColor;
        _deleteBtn.layer.borderWidth = 0.5;
        [_deleteBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_ratioLabel);
            make.right.equalTo(_statusBtn.mas_left).offset(-15);
            make.height.mas_equalTo(15); 
        }];
    }
    return self;
}

- (void)setModel:(OfflineOrderListModel *)model {
    _model = model;
    
    self.orderLabel.text = [@"订单编号：" stringByAppendingString:model.order_sn];
    self.timeLabel.text = model.createtime;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:model.head_pic]] placeholderImage:[UIImage imageNamed:@"我的-头像"]];
    self.userNameLabel.text = model.nickname;
    self.mobileLabel.text = model.umobile;
    if (self.type == 1) {
        self.deleteBtn.hidden = NO;
        self.costLabel.text = [NSString stringWithFormat:@"消费金额：%.2f元", model.money.floatValue];
        self.payLabel.text = [NSString stringWithFormat:@"代付金额：%.2f元", model.money.floatValue * model.ratio.floatValue/100];
    } else if (self.type == 2) {
        self.deleteBtn.hidden = YES;
        self.costLabel.text = [NSString stringWithFormat:@"订单金额：%.2f元", model.money.floatValue];
        self.payLabel.text = [NSString stringWithFormat:@"消费金额：%.2f元", model.money.floatValue];
    }
    self.ratioLabel.text = [model.ratio stringByAppendingString:@"%"];
    if (model.pay_status.integerValue == 1) {
        // 已支付
        self.deleteBtn.hidden = YES;
        [self.statusBtn setTitle:@"  交易成功  " forState:UIControlStateNormal];
        self.statusBtn.layer.borderWidth = 0;
    } else {
//        self.deleteBtn.hidden = NO;
        self.deleteBtn.hidden = YES;    //这里修改为隐藏，只是供商家查看，不提供删除操作
        [self.statusBtn setTitle:@"  未支付  " forState:UIControlStateNormal];
        self.statusBtn.layer.borderWidth = 0.5;
    }
        
}

- (void)click:(UIButton *)sender {
    if (self.clickHandler) {
        self.clickHandler(self.model.order_sn);
    }
}

- (void)click1:(UIButton *)sender {
    if (self.clickPay && self.type == 1) {
        self.clickPay(self.model.order_sn, @([self.model.money floatValue] * self.model.ratio.floatValue/100).description);
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
