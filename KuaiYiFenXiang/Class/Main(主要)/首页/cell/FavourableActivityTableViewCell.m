//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//












#import "FavourableActivityTableViewCell.h"




@interface FavourableActivityTableViewCell ()


@property (nonatomic, strong) UILabel *youhuititleLabel;
@property (nonatomic, strong) UILabel *youhuitimeLabel;
@property (nonatomic, strong) UIImageView  *youhuiImageView;
@property (nonatomic, strong) UILabel *noticeLabel; //提示文字，活动是否进行中
@property (nonatomic, strong) UILabel *youhuicontentLabel;
@property (nonatomic, strong) UIButton *checkdetailsButton;

@end






@implementation FavourableActivityTableViewCell



+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"FavourableActivityTableViewCell";
    // 通过唯一标识创建cell实例
    FavourableActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[FavourableActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setFavourableActivityModel:(FavourableActivityModel *)FavourableActivityModel{
    
    _FavourableActivityModel = FavourableActivityModel;
    
    [self.youhuititleLabel setText:FavourableActivityModel.youhuititleString];
    
    [self.youhuitimeLabel setText:FavourableActivityModel.youhuitimeString];

    [self.youhuiImageView sd_setImageWithURL:[NSURL URLWithString:FavourableActivityModel.youhuiimageString] placeholderImage:[UIImage imageNamed:@"youhuibanner"]];
    
    [self.youhuicontentLabel setText:FavourableActivityModel.youhuicontentString];
    
    [self.checkdetailsButton setTitle:FavourableActivityModel.checkdetailsBtnString forState:UIControlStateNormal];
    
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
}

-(void)setDiscountModel:(DiscountListModel *)discountModel
{
    _discountModel = discountModel;
    
    kStringIsEmpty(discountModel.favourable)?:[self.youhuititleLabel setText:discountModel.favourable];
    
    //计算起止时间
    NSString *startTime;
    NSString *endTime;
    if (!kStringIsEmpty(discountModel.startime)) {
        startTime = [NSString_Category Timestamptofixedformattime:@"yyyy-MM-dd" andTimeInterval:discountModel.startime.integerValue];
    }
    
    if (!kStringIsEmpty(discountModel.endtime)) {
        endTime = [NSString_Category Timestamptofixedformattime:@"yyyy-MM-dd" andTimeInterval:discountModel.endtime.integerValue];
    }
    
    NSString *timeStr = [startTime stringByAppendingFormat:@"--%@",endTime];
    if (!kStringIsEmpty(timeStr)) {
        [self.youhuitimeLabel setText:timeStr];
    }
    
    kStringIsEmpty(discountModel.image)?:[self.youhuiImageView sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:discountModel.image]]];
    
    kStringIsEmpty(discountModel.content)?:[self.youhuicontentLabel setText:discountModel.content];
    
    if (!kStringIsEmpty(discountModel.content)) {
        NSString *str = [discountModel.content stringByAppendingString:@"  立即查看>>"];
        //添加富文本属性
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange rang = NSMakeRange(str.length - 6, 6);
        [attText addAttribute:NSFontAttributeName value:Font(14) range:rang];
        [attText addAttribute:NSForegroundColorAttributeName value:kColord40 range:rang];
        [attText addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:rang];
        
        self.youhuicontentLabel.attributedText = attText;
    }
    
    if (discountModel.on_time.integerValue == 1) {  //过期
        self.noticeLabel.hidden = NO;
        self.noticeLabel.text = @"已结束";
    }else if(discountModel.on_time.integerValue == 3){
        self.noticeLabel.hidden = NO;
        self.noticeLabel.text = @"未开始";
    }else{
        self.noticeLabel.hidden = YES;
//        NSLog(@"活动进行中...");
    }
    
    
    
//    [self.checkdetailsButton setTitle:@"查看详情" forState:UIControlStateNormal];
    
    [self layoutSubviews];
}

- (UILabel *)youhuititleLabel
{
    if (_youhuititleLabel == nil) {
        _youhuititleLabel = [[UILabel alloc] init];
    }
    _youhuititleLabel.font=PFR15Font;
    _youhuititleLabel.textColor=HexColor(333333);
    _youhuititleLabel.textAlignment=NSTextAlignmentLeft;
    _youhuititleLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_youhuititleLabel];
    return _youhuititleLabel;
}


- (UILabel *)youhuitimeLabel
{
    if (_youhuitimeLabel == nil) {
        _youhuitimeLabel = [[UILabel alloc] init];
    }
    _youhuitimeLabel.font=PFR10Font;
    _youhuitimeLabel.textColor=HexColor(999999);
    _youhuitimeLabel.textAlignment=NSTextAlignmentLeft;
    _youhuitimeLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_youhuitimeLabel];
    return _youhuitimeLabel;
}



- (UIImageView *)youhuiImageView
{
    if (_youhuiImageView == nil) {
        _youhuiImageView = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_youhuiImageView];
    return _youhuiImageView;
}

-(UILabel *)noticeLabel
{
    if (!_noticeLabel) {
        _noticeLabel = [UILabel new];
        _noticeLabel.textColor = kWhiteColor;
        _noticeLabel.font = Font(18);
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.backgroundColor = RGBA(0, 0, 0, 0.3);
        [self.youhuiImageView addSubview:_noticeLabel];
    }
    return _noticeLabel;
}

- (UILabel *)youhuicontentLabel
{
    if (_youhuicontentLabel == nil) {
        _youhuicontentLabel = [[UILabel alloc] init];
        _youhuicontentLabel.font = PFR14Font;
        _youhuicontentLabel.textColor = HexColor(333333);
        _youhuicontentLabel.textAlignment=NSTextAlignmentLeft;
    }
//    _youhuicontentLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_youhuicontentLabel];
    return _youhuicontentLabel;
}



- (UIButton *)checkdetailsButton
{
    if (_checkdetailsButton == nil) {
        _checkdetailsButton = [[UIButton alloc] init];
    }
    [_checkdetailsButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_checkdetailsButton.layer setMasksToBounds:YES];
    [_checkdetailsButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    //边框宽度
    [_checkdetailsButton.layer setBorderWidth:1.0];
    _checkdetailsButton.layer.borderColor=[UIColor redColor].CGColor;
    _checkdetailsButton.titleLabel.font=PFR10Font;
    _checkdetailsButton.backgroundColor =  [UIColor whiteColor];//hwcolor(18, 36, 46);
    [self.contentView addSubview:_checkdetailsButton];
    return _checkdetailsButton;
}




-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    self.youhuititleLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    [self.youhuititleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.youhuitimeLabel.sd_layout
    .bottomEqualToView(self.youhuititleLabel)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [self.youhuitimeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.youhuiImageView.sd_layout
    .leftEqualToView(self.youhuititleLabel)
    .topSpaceToView(self.youhuititleLabel, 10)
    .rightEqualToView(self.youhuitimeLabel)
    .heightIs(170);
    
    self.noticeLabel.sd_layout
    .leftEqualToView(self.youhuiImageView)
    .rightEqualToView(self.youhuiImageView)
    .topEqualToView(self.youhuiImageView)
    .bottomEqualToView(self.youhuiImageView)
    ;
    
    self.youhuicontentLabel.sd_layout
    .leftEqualToView(self.youhuititleLabel)
    .topSpaceToView(self.youhuiImageView, 15)
//    .widthIs(SCREEN_WIDTH * 0.6)
    .rightEqualToView(self.youhuitimeLabel)
    .autoHeightRatio(0)
    ;
    self.youhuicontentLabel.isAttributedContent = YES;
    [self.youhuicontentLabel setMaxNumberOfLinesToShow:3];

//    self.checkdetailsButton.sd_layout
//    .centerYEqualToView(self.youhuicontentLabel)
//    .rightEqualToView(self.youhuitimeLabel)
//    .widthIs(60)
//    .heightIs(20);
    
    
    
    //设置最下边的相隔间距 来获取当前cell行高
    [self setupAutoHeightWithBottomView:self.youhuicontentLabel bottomMargin:20];
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//重新设置cell的布局大小样式
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end




