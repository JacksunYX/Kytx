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


#import "DetailsRefundTableViewCell.h"

@interface DetailsRefundTableViewCell ()

@property (nonatomic, strong) UILabel *RefundTimeLineLabel;
//
@property (nonatomic, strong) UILabel *RefundRedNumLabel;
//
@property (nonatomic, strong) UILabel *RefundStatusLabel;
//
@property (nonatomic, strong) UILabel *RefundTimeLabel;
//
@property (nonatomic, strong) UILabel *RefundSubtitlelabel;

@property (nonatomic, strong) UIButton *RefundLeafletsNoButton;

@end






@implementation DetailsRefundTableViewCell



+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DetailsRefundTableViewCell";
    DetailsRefundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DetailsRefundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(void)setDetailsRefundModel:(DetailsRefundModel *)DetailsRefundModel{
    
    _DetailsRefundModel=DetailsRefundModel;
    
    [self.RefundRedNumLabel setText:DetailsRefundModel.RefundRedNumString];
    
    [self.RefundStatusLabel setText:DetailsRefundModel.RefundStatusString];

    if (kStringIsEmpty([DetailsRefundModel.RefundTimeString description])) {
        [self.RefundTimeLabel setText:[DetailsRefundModel.RefundTimeString description]];
    } else {
        [self.RefundTimeLabel setText:[NSString_Category Timestamptofixedformattime:@"YYYY-MM-dd HH:mm:ss" andTimeInterval:DetailsRefundModel.RefundTimeString.integerValue]];
    }
    

//    [self.RefundTimeLabel setText:DetailsRefundModel.RefundTimeString];

    if ([self.DetailsRefundModel.RefundSubtitleString containsString:@"快递"]) {

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:DetailsRefundModel.RefundSubtitleString]; // 改变特定范围颜色大小要用的
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,3)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, DetailsRefundModel.RefundSubtitleString.length-3)];
        [self.RefundSubtitlelabel setAttributedText:attributedString];
    
    }else{
        
        [self.RefundSubtitlelabel setText:DetailsRefundModel.RefundSubtitleString];

    }
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}



- (UILabel *)RefundTimeLineLabel
{
    if (_RefundTimeLineLabel == nil) {
        _RefundTimeLineLabel = [[UILabel alloc] init];
    }
    [self.DetailsRefundModel.RefundIsSelectString isEqualToString:@"1"]?[_RefundTimeLineLabel setBackgroundColor:[UIColor redColor]]:[_RefundTimeLineLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:_RefundTimeLineLabel];
    return _RefundTimeLineLabel;
}

- (UILabel *)RefundRedNumLabel
{
    if (_RefundRedNumLabel == nil) {
        _RefundRedNumLabel = [[UILabel alloc] init];
    }
    _RefundRedNumLabel.font=PFR15Font;
    [_RefundRedNumLabel.layer setMasksToBounds:YES];
    [_RefundRedNumLabel.layer setCornerRadius:_RefundRedNumLabel.width/2];
    [_RefundRedNumLabel setBackgroundColor:[self.DetailsRefundModel.RefundIsSelectString isEqualToString:@"1"]?[UIColor redColor]:[UIColor lightGrayColor]];
    [_RefundRedNumLabel setTextColor:[UIColor whiteColor]];
    _RefundRedNumLabel.textAlignment=NSTextAlignmentCenter;
    _RefundRedNumLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_RefundRedNumLabel];
    return _RefundRedNumLabel;
}


- (UILabel *)RefundStatusLabel
{
    if (_RefundStatusLabel == nil) {
        _RefundStatusLabel = [[UILabel alloc] init];
    }
    _RefundStatusLabel.font=PFR15Font;
    [_RefundStatusLabel setTextColor:[UIColor blackColor]];
    _RefundStatusLabel.textAlignment=NSTextAlignmentLeft;
    _RefundStatusLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_RefundStatusLabel];
    return _RefundStatusLabel;
}

- (UILabel *)RefundTimeLabel
{
    if (_RefundTimeLabel == nil) {
        _RefundTimeLabel = [[UILabel alloc] init];
    }
    _RefundTimeLabel.font=PFR13Font;
    [_RefundTimeLabel setTextColor:[UIColor lightGrayColor]];
    _RefundTimeLabel.textAlignment=NSTextAlignmentLeft;
    _RefundTimeLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_RefundTimeLabel];
    return _RefundTimeLabel;
}

- (UILabel *)RefundSubtitlelabel
{
    if (_RefundSubtitlelabel == nil) {
        _RefundSubtitlelabel = [[UILabel alloc] init];
    }
    _RefundSubtitlelabel.font=PFR13Font;
    _RefundSubtitlelabel.textAlignment=NSTextAlignmentLeft;
    _RefundSubtitlelabel.contentMode=UIViewContentModeCenter;
    if ([self.DetailsRefundModel.RefundSubtitleString containsString:@"快递"]) {
        // 1. 创建一个点击事件，点击时触发labelClick方法
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
        // 2. 将点击事件添加到label上
        [_RefundSubtitlelabel addGestureRecognizer:labelTapGestureRecognizer];
        _RefundSubtitlelabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    }else{
        [_RefundSubtitlelabel setTextColor:[UIColor lightGrayColor]];
    }
    [self.contentView addSubview:_RefundSubtitlelabel];
    return _RefundSubtitlelabel;
}

- (UIButton *)RefundLeafletsNoButton
{
    if (_RefundLeafletsNoButton == nil) {
        _RefundLeafletsNoButton = [[UIButton alloc] init];
    }
    
    if ([self.DetailsRefundModel.RefundLeafletsNoButtonUserInteractionEnabled isEqualToString:@"YES"]) {
        [_RefundLeafletsNoButton setBackgroundColor:[UIColor redColor]];
        [_RefundLeafletsNoButton setUserInteractionEnabled:YES];
    }else{
        [_RefundLeafletsNoButton setBackgroundColor:[UIColor lightGrayColor]];
        [_RefundLeafletsNoButton setUserInteractionEnabled:NO];
    }
    
    [_RefundLeafletsNoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_RefundLeafletsNoButton.layer setMasksToBounds:YES];
    [_RefundLeafletsNoButton.layer setCornerRadius:1.0]; //设置矩形四个圆角半径
    [_RefundLeafletsNoButton setTitle:@"上传单号" forState:UIControlStateNormal];
    [_RefundLeafletsNoButton.titleLabel setFont:PFR13Font];
    [self.DetailsRefundModel.RefundStatusString isEqualToString:@"买家发货"]?[self.contentView addSubview:_RefundLeafletsNoButton]:[_RefundLeafletsNoButton removeFromSuperview];
    [_RefundLeafletsNoButton addTarget:self action:@selector(RefundLeafletsNoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return _RefundLeafletsNoButton;
}

// 3. 在此方法中设置点击label后要触发的操作
- (void)labelClick {
    
    if (self.didSelectedCheckLogisticsBlock) {
        self.didSelectedCheckLogisticsBlock(self.DetailsRefundModel);
    }

}

-(void)RefundLeafletsNoButtonClick{
    
    if (self.didSelectedRefundLeafletsNoButtonBlock) {
        self.didSelectedRefundLeafletsNoButtonBlock(self.DetailsRefundModel);
    }

}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.RefundRedNumLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(20)
    .heightIs(20);
    
    self.RefundTimeLineLabel.sd_layout
    .centerYEqualToView(self.RefundRedNumLabel)
    .centerXEqualToView(self.RefundRedNumLabel)
    .widthIs(2)
    .heightIs(self.contentView.height);
    
    self.RefundStatusLabel.sd_layout
    .centerYEqualToView(self.RefundRedNumLabel)
    .leftSpaceToView(self.RefundRedNumLabel, 10)
    .autoHeightRatio(0);
    [self.RefundStatusLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    if ([self.DetailsRefundModel.RefundStatusString isEqualToString:@"买家发货"]) {
        self.RefundLeafletsNoButton.sd_layout
        .centerYEqualToView(self.RefundStatusLabel)
        .leftSpaceToView(self.RefundStatusLabel, 10)
        .widthIs(60)
        .heightIs(20);
    }
    
    self.RefundTimeLabel.sd_layout
    .centerYEqualToView(self.RefundStatusLabel)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [self.RefundTimeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.RefundSubtitlelabel.sd_layout
    .topSpaceToView(self.RefundStatusLabel, 10)
    .leftEqualToView(self.RefundStatusLabel)
    .autoHeightRatio(0);
    [self.RefundSubtitlelabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    //设置最下边的相隔间距 来获取当前cell得行高
    [self setupAutoHeightWithBottomView:self.RefundSubtitlelabel bottomMargin:30];
    
    
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
////重新设置cell的布局大小样式
//- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 10;
//    frame.origin.y += 10;
//    frame.size.height -= 10;
//    frame.size.width -= 20;
//    [super setFrame:frame];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//

@end

