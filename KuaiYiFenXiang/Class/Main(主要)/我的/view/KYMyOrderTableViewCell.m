//
//  KYMyOrderTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYMyOrderTableViewCell.h"
#import "KYHeader.h"

@interface KYMyOrderTableViewCell ()

@property (nonatomic, strong) UILabel *dot1;
@property (nonatomic, strong) UILabel *dot2;
@property (nonatomic, strong) UILabel *dot3;
@property (nonatomic, strong) UILabel *dot4;
@property (nonatomic, strong) UILabel *dot5;

@end

@implementation KYMyOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"我的订单";
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:ScaleWidth(13)];
        [self.contentView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(ScaleWidth(16));
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        
        [self.contentView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(ScaleWidth(-15));
            make.top.equalTo(nameLabel);
            make.size.mas_equalTo(CGSizeMake(ScaleWidth(8.5), ScaleWidth(13)));
        }];
        
        UIButton *descbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [descbtn setTitle:@"查看全部订单" forState:UIControlStateNormal];
        descbtn.titleLabel.font = [UIFont systemFontOfSize:ScaleWidth(13)];
        [descbtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [descbtn addTarget:self action:@selector(checkAllOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:descbtn];
        
        [descbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(arrow);
            make.right.equalTo(arrow.mas_left).offset(ScaleWidth(-10));
        }];
        
        
        
        UIImageView *orderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的订单"]];
//        orderImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:orderImageView];
        [orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(ScaleHeight(72));
            make.width.equalTo(self.contentView);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = CELLBORDERCOLOR;
        [orderImageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(orderImageView);
            make.top.equalTo(orderImageView.mas_top).offset(10);
            make.height.mas_equalTo(0.5);
        }];
        
        __block UIButton *last;
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            btn.tag = 1000 + i;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.contentView);
                } else {
                    make.left.equalTo(last.mas_right);
                }
                last = btn;
                make.top.bottom.equalTo(orderImageView);
                make.width.mas_equalTo(SCREEN_WIDTH/5);
            }];
            
            UIImageView *timageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"椭圆608"]];
            timageview.hidden = YES;
            [self.contentView addSubview:timageview];
            [timageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(15, 15));
                make.left.equalTo(btn.mas_right).offset(-ScaleWidth(25));
                make.centerY.equalTo(btn.mas_top).offset(ScaleWidth(20));
            }];
            
            UILabel *dot1 = [UILabel new];
            
            dot1.text = @"";
            dot1.textColor = kWhiteColor;
            dot1.backgroundColor = [UIColor clearColor];
            dot1.font = kFont(9);
            dot1.hidden = YES;
            
            [timageview addSubview:dot1];
            [dot1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(timageview);

            }];
            
            switch (i+1) {
                case 1:
                    self.dot1 = dot1;
                    break;
                case 2:
                    self.dot2 = dot1;
                    break;
                case 3:
                    self.dot3 = dot1;
                    break;
                case 4:
                    self.dot4 = dot1;
                    break;
                case 5:
                    self.dot5 = dot1;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)dot1WithText:(NSString *)text {
    if (text.integerValue == 0) {
        self.dot1.hidden = YES;
        self.dot1.superview.hidden = YES;
    } else {
        self.dot1.hidden = NO;
        self.dot1.superview.hidden = NO;
        if (text.integerValue > 99) {
            self.dot1.text = @"99+";
        } else {
            self.dot1.text = text;
        }
    }
}

- (void)dot2WithText:(NSString *)text {
    if (text.integerValue == 0) {
        self.dot2.hidden = YES;
        self.dot2.superview.hidden = YES;
    }else {
        self.dot2.hidden = NO;
         self.dot2.superview.hidden = NO;
        if (text.integerValue > 99) {
            self.dot2.text = @"99+";
        } else {
            self.dot2.text = text;
        }
    }
}
- (void)dot3WithText:(NSString *)text {
    if (text.integerValue == 0) {
        self.dot3.hidden = YES;
        self.dot3.superview.hidden = YES;
    }else {
        self.dot3.hidden = NO;
        self.dot3.superview.hidden = NO;

        if (text.integerValue > 99) {
            self.dot3.text = @"99+";
        } else {
            self.dot3.text = text;
        }
    }
}
- (void)dot4WithText:(NSString *)text {
    if (text.integerValue == 0) {
        self.dot4.hidden = YES;
        self.dot4.superview.hidden = YES;
    }else {
        self.dot4.hidden = NO;
        self.dot4.superview.hidden = NO;
        if (text.integerValue > 99) {
            self.dot4.text = @"99+";
        } else {
            self.dot4.text = text;
        }
    }
}
- (void)dot5WithText:(NSString *)text {
    if (text.integerValue == 0) {
        self.dot5.hidden = YES;
        self.dot5.superview.hidden = YES;
    }else {
        self.dot5.hidden = NO;
        self.dot5.superview.hidden = NO;
        if (text.integerValue > 99) {
            self.dot5.text = @"99+";
        } else {
            self.dot5.text = text;
        }
    }
}
- (void)checkAllOrder:(UIButton *)sender {
    if (self.checkAllOrderHandler) {
        self.checkAllOrderHandler();
    }
}


- (void)orderClick:(UIButton *)sender {

    switch (sender.tag) {
        case 1000:
            NSLog(@"代付款");
            break;
        case 1001:
            NSLog(@"待发货");
            break;
        case 1002:
            NSLog(@"待收货");
            break;
        case 1003:
            NSLog(@"已完成");
            break;
        case 1004:
            NSLog(@"退款");
            break;
            
        default:
            break;
    }
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
