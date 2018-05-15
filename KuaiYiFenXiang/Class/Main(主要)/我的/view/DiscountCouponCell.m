//
//  DiscountCouponCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/15.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "DiscountCouponCell.h"
#import "UIImage+Avatar.h"

@implementation DiscountCouponModel

@end


@interface DiscountCouponCell ()
{
    UIImageView *backImageView; //背景图片
    UILabel *limitMoney;        //满减额度
    UILabel *statusLabel;       //状态
    
    UILabel *usableLabel;       //满多少可用
    UILabel *timeLabel;         //起止时间
}

@end

//左右间距
static CGFloat margin = 15;

@implementation DiscountCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setUI
{
    [self addLeftViews];
    
    [self addRightViews];
}

//左边视图
-(void)addLeftViews
{
    backImageView = [UIImageView new];
    backImageView.userInteractionEnabled = YES;
//    backImageView.backgroundColor = hwrandomcolor;
    
    UIView *leftBackView = [UIView new];
//    leftBackView.backgroundColor = hwrandomcolor;
    CGFloat leftViewW = ScaleWidth(92);
    
    UILabel *topLabel = [UILabel new];
    topLabel.font = Font(12);
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = HexColor(ffffff);
    
    limitMoney = [UILabel new];
    limitMoney.font = kBoldFont(15);
    limitMoney.textAlignment = NSTextAlignmentCenter;
    limitMoney.textColor = HexColor(ffffff);
    
    //虚线分割线
    UIImageView * lineView = [UIImageView new];
    
    statusLabel = [UILabel new];
    statusLabel.font = Font(12);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = HexColor(ffffff);
    
    UIView *fatherView = self.contentView;
    fatherView.backgroundColor = BACKVIEWCOLOR;
    [fatherView addSubview:backImageView];
    [backImageView addSubview:leftBackView];
    
    [leftBackView sd_addSubviews:@[
                                   topLabel,
                                   statusLabel,
                                   lineView,
                                   limitMoney,
                                   
                                   ]];
    
    //布局
    backImageView.sd_layout
    .leftSpaceToView(fatherView, margin)
    .rightSpaceToView(fatherView, margin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    ;
    
    leftBackView.sd_layout
    .leftEqualToView(backImageView)
    .topEqualToView(backImageView)
    .bottomEqualToView(backImageView)
    .widthIs(leftViewW)
    ;
    
    topLabel.sd_layout
    .centerXEqualToView(leftBackView)
    .topSpaceToView(leftBackView, 7)
    .autoHeightRatio(0)
    ;
    [topLabel setSingleLineAutoResizeWithMaxWidth:leftViewW - 20];
    topLabel.text = @"满减券";
    
    statusLabel.sd_layout
    .centerXEqualToView(leftBackView)
    .bottomSpaceToView(leftBackView, 10)
    .autoHeightRatio(0)
    ;
    [statusLabel setSingleLineAutoResizeWithMaxWidth:leftViewW - 20];
    
    lineView.sd_layout
    .centerXEqualToView(leftBackView)
    .bottomSpaceToView(statusLabel, 10)
    .widthIs(leftViewW - 20)
    .heightIs(0.5)
    ;
    [lineView updateLayout];
    lineView.contentMode = UIViewContentModeCenter;
    lineView.image = [UIImage imageWithLineWithImageView:lineView];
    
    limitMoney.sd_layout
    .centerXEqualToView(leftBackView)
    .bottomSpaceToView(lineView, 5)
    .autoHeightRatio(0)
    ;
    limitMoney.isAttributedContent = YES;
    [limitMoney setSingleLineAutoResizeWithMaxWidth:leftViewW - 20];
    
}

//右边视图
-(void)addRightViews
{
    UIView *rightBackView = [UIView new];
//    rightBackView.backgroundColor = hwrandomcolor;
    CGFloat rightViewW = ScreenW - margin * 2 - ScaleWidth(92);
    
    [backImageView addSubview:rightBackView];
    
    rightBackView.sd_layout
    .topEqualToView(backImageView)
    .rightEqualToView(backImageView)
    .bottomEqualToView(backImageView)
    .widthIs(rightViewW)
    ;
    
    UILabel *topLabel = [UILabel new];
    topLabel.font = kBoldFont(13);
    topLabel.textColor = HexColor(333333);
    
    
    timeLabel = [UILabel new];
    timeLabel.font = Font(12);
    timeLabel.textColor = HexColor(999999);
    
    
    usableLabel = [UILabel new];
    usableLabel.font = Font(12);
    usableLabel.textColor = HexColor(999999);
    
    
    [rightBackView sd_addSubviews:@[
                                    topLabel,
                                    timeLabel,
                                    usableLabel,
                                    
                                    ]];
    
    topLabel.sd_layout
    .topSpaceToView(rightBackView, 7)
    .leftSpaceToView(rightBackView, 15)
    .autoHeightRatio(0)
    ;
    [topLabel setSingleLineAutoResizeWithMaxWidth:rightViewW - 20];
    topLabel.text = @"关注领取5元券";
    
    timeLabel.sd_layout
    .bottomSpaceToView(rightBackView, 10)
    .leftEqualToView(topLabel)
    .autoHeightRatio(0)
    ;
    [timeLabel setSingleLineAutoResizeWithMaxWidth:rightViewW - 20];
//    timeLabel.text = @"2018-05-07至2018-06-07";
    
    usableLabel.sd_layout
    .bottomSpaceToView(timeLabel, 10)
    .leftEqualToView(topLabel)
    .autoHeightRatio(0)
    ;
    [usableLabel setSingleLineAutoResizeWithMaxWidth:rightViewW - 20];
//    usableLabel.text = @"满50元可用";
}

-(void)setModel:(DiscountCouponModel *)model
{
    _model = model;
    NSString *money = [@"￥" stringByAppendingString:GetSaveString(model.limit)];
    NSMutableAttributedString *attStr = [NSString RichtextString:money andstartstrlocation:1 andendstrlocation:money.length - 1 andchangcoclor:HexColor(ffffff) andchangefont:kBoldFont(30)];
    limitMoney.attributedText = attStr;
    
    timeLabel.text = [GetSaveString(model.startTime) stringByAppendingString:GetSaveString(model.endTime)];
    
    usableLabel.text = [NSString stringWithFormat:@"满%@元可用",model.usable];
    
    if (!kStringIsEmpty(model.status)) {
        switch (model.status.integerValue) {
            case 0:
            {
                statusLabel.text = @"未使用";
                backImageView.image = UIImageNamed(@"discount_redBack");
            }
                break;
            case 1:
            {
                statusLabel.text = @"已使用";
                backImageView.image = UIImageNamed(@"discount_grayBack");
            }
                break;
            case 2:
            {
                statusLabel.text = @"已过期";
                backImageView.image = UIImageNamed(@"discount_grayBack");
            }
                break;
            default:
                break;
        }
    }
}















@end
