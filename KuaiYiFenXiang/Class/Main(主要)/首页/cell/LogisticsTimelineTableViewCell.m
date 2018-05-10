//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//



////
//@property (nonatomic, copy) NSString *logisticsStatusString;
////
//@property (nonatomic, copy) NSString *logisticsAddressString;
////
//@property (nonatomic, copy) NSString *logisticsTimeString;


#import "LogisticsTimelineTableViewCell.h"



@interface LogisticsTimelineTableViewCell ()


@property (nonatomic, strong) UIImageView *logisticsStatusImageView;

@property (nonatomic, strong) UILabel *logisticsTimeLineLabel;

@property (nonatomic, strong) UILabel *logisticsAddressLabel;

@property (nonatomic, strong) UILabel *logisticsTimeLabel;


@end






@implementation LogisticsTimelineTableViewCell




-(void)setLogisticsTimelineModel:(LogisticsTimelineModel *)LogisticsTimelineModel{
    
    
    
    _LogisticsTimelineModel=LogisticsTimelineModel;
    
    
    [self.logisticsStatusImageView setImage:[LogisticsTimelineModel.logisticsStatusString isEqualToString:@"0"]?[UIImage imageNamed:@"xuanzhong_green"]:[UIImage imageNamed:@"weixuanzhong_gray"]];
    
    [self.logisticsAddressLabel setText:LogisticsTimelineModel.status];
    
    [self.logisticsTimeLabel setText:LogisticsTimelineModel.time];
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
}




- (UIImageView *)logisticsStatusImageView
{
    if (_logisticsStatusImageView == nil) {
        _logisticsStatusImageView = [[UIImageView alloc] init];
    }
    [self.contentView addSubview:_logisticsStatusImageView];
    return _logisticsStatusImageView;
}




- (UILabel *)logisticsTimeLineLabel
{
    if (_logisticsTimeLineLabel == nil) {
        _logisticsTimeLineLabel = [[UILabel alloc] init];
    }
    [_logisticsTimeLineLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:_logisticsTimeLineLabel];
    return _logisticsTimeLineLabel;
}




- (UILabel *)logisticsAddressLabel
{
    if (_logisticsAddressLabel == nil) {
        _logisticsAddressLabel = [[UILabel alloc] init];
    }
    _logisticsAddressLabel.font=PFR15Font;
    [_logisticsAddressLabel setTextColor:[self.LogisticsTimelineModel.logisticsStatusString isEqualToString:@"0"]?[UIColor greenColor]:[UIColor lightGrayColor]];
    _logisticsAddressLabel.textAlignment=NSTextAlignmentLeft;
    _logisticsAddressLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_logisticsAddressLabel];
    return _logisticsAddressLabel;
}


- (UILabel *)logisticsTimeLabel
{
    if (_logisticsTimeLabel == nil) {
        _logisticsTimeLabel = [[UILabel alloc] init];
    }
    _logisticsTimeLabel.font=PFR13Font;
    [_logisticsTimeLabel setTextColor:[self.LogisticsTimelineModel.logisticsStatusString isEqualToString:@"0"]?[UIColor greenColor]:[UIColor lightGrayColor]];
    _logisticsTimeLabel.textAlignment=NSTextAlignmentLeft;
    _logisticsTimeLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_logisticsTimeLabel];
    return _logisticsTimeLabel;
}




-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    self.logisticsTimeLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 30)
    .autoHeightRatio(0);
    [self.logisticsTimeLabel setSingleLineAutoResizeWithMaxWidth:40];
    
    
    
    self.logisticsTimeLineLabel.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.logisticsTimeLabel, 20)
    .widthIs(1)
    .heightIs(self.contentView.height);
    
    
    
    self.logisticsStatusImageView.sd_layout
    .centerXEqualToView(self.logisticsTimeLineLabel)
    .centerYIs(self.contentView.height/3)
    .widthIs(15)
    .heightIs(15);
    
    
    
    self.logisticsAddressLabel.sd_layout
    .centerYEqualToView(self.logisticsTimeLabel)
    .leftSpaceToView(self.logisticsStatusImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.logisticsTimeLabel bottomMargin:20];
    
    
}




@end
