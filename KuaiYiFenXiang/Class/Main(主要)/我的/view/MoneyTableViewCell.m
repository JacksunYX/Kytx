//
//  MoneyTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MoneyTableViewCell.h"
#import "KYHeader.h"

@interface MoneyTableViewCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *titleView;

@end
@implementation MoneyTableViewCell

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
        
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积分明细"]];
        
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([reuseIdentifier isEqualToString:@"cell2"]) {
                make.top.equalTo(self.contentView).offset(52.5);
            } else {
                make.top.equalTo(self.contentView).offset(22.5);
            }
            make.left.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _descLabel = [UILabel new];
        
        _descLabel.text = @"冻结金额";
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
        _scoreLabel.text = @"+100";
        
        [self.contentView addSubview:_scoreLabel];
        [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_iconImageView);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (void)setModel:(MoneyModel *)model {
    _model = model;
    
    self.descLabel.text = model.content;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    self.timeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.add_time.floatValue]];
    self.scoreLabel.text = [@"+" stringByAppendingString:model.money];
    if (model.showTitle) {
        NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
        fomatter.dateFormat = @"MM月dd日";
        self.titleView.font = kFont(15);
        self.titleView.text = [fomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.model.add_time.floatValue]];
    }
    
    if (self.celltype == 2) {
        // 冻结
        self.descLabel.text = @"冻结金额";
        self.scoreLabel.text = [@"-" stringByAppendingString:model.money];
        self.scoreLabel.textColor = kColor333;
        self.iconImageView.image = [UIImage imageNamed:@"冻结明细icon"];
    } else if (self.celltype == 3) {
        // 金额
        if ([model.type isEqualToString:@"1"]) {
            
            self.scoreLabel.text = [@"-" stringByAppendingString:model.money];
            self.scoreLabel.textColor = kColor333;
        } else if ([model.type isEqualToString:@"2"]) {
            self.scoreLabel.text = [@"+" stringByAppendingString:model.money];
            self.scoreLabel.textColor = kColord40;
        }
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
