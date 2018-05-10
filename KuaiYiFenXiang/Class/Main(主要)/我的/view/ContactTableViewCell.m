//
//  ContactTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ContactTableViewCell.h"

#import "KYHeader.h"

@interface ContactTableViewCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *titleView;

@end

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if ([reuseIdentifier isEqualToString:@"cell2"]) {
            UIView *view = [UIView new];
            view.backgroundColor = kDefaultBGColor;
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.contentView);
                make.height.mas_equalTo(40);
            }];
            
            UILabel *label = [UILabel new];
            self.titleView = label;
            label.textColor = kColor333;
            
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(view).offset(15);
            }];
        }
        
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage new]];
        
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([reuseIdentifier isEqualToString:@"cell2"]) {
                make.bottom.equalTo(self.contentView).offset(-12.5);
            } else {
                make.bottom.equalTo(self.contentView).offset(-12.5);
            }
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _descLabel = [UILabel new];
        
        _descLabel.text = @"商家【胖胖火锅店】快捷订单获得激励积分";
        _descLabel.font = kFont(15);
        _descLabel.textColor = kColor333;
        _descLabel.numberOfLines = 2;
        //        _descLabel.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([reuseIdentifier isEqualToString:@"cell2"]) {
                make.top.equalTo(self.contentView).offset(55);
            } else {
                make.top.equalTo(self.contentView).offset(15);
            }
            make.left.equalTo(_iconImageView.mas_right).offset(15);
            make.width.mas_equalTo(ScaleWidth(240));
        }];
        
        _timeLabel = [UILabel new];
        
        _timeLabel.textColor = kColor999;
        _timeLabel.text = @"09:45:32";
        _timeLabel.font = kFont(13);
        
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_descLabel);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        _scoreLabel = [UILabel new];
        
        _scoreLabel.textColor = kColord40;
        _scoreLabel.font = kFont(15);
        _scoreLabel.text = @"分享使者";
        
        [self.contentView addSubview:_scoreLabel];
        [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_iconImageView);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setModel:(ContactModel *)model {
    _model = model;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    self.timeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.reg_time.floatValue]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:kStringIsEmpty(model.head_pic) ? @"" : model.head_pic ]] placeholderImage:[UIImage imageNamed:@"分享使者icon"]];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@", [model.mobile substringToIndex:3], @"****", [model.mobile substringWithRange:NSMakeRange(7, 4)]];
    _scoreLabel.text = model.role_name;
    self.descLabel.text = str;

    if (model.showTitle) {
        NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
        fomatter.dateFormat = @"MM月dd日";
        self.titleView.font = kFont(15);
        self.titleView.text = [fomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.model.reg_time.floatValue]];
    }
}

@end
