//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//












#import "TradeLogisticsTableViewCell.h"




@interface TradeLogisticsTableViewCell ()

//@property (nonatomic, copy) NSString *cellid;
//@property (nonatomic, copy) NSString *goodsnameString;
//@property (nonatomic, copy) NSString *timeString;
//@property (nonatomic, copy) NSString *goodsimageString;
//@property (nonatomic, copy) NSString *goodscontentString;
//@property (nonatomic, copy) NSString *goodsorderidString;

@property (nonatomic, strong) UILabel *goodsnameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodscontentLabel;
@property (nonatomic, strong) UILabel *goodsorderidLabel;

@end






@implementation TradeLogisticsTableViewCell



+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"TradeLogisticsTableViewCell";
    // 通过唯一标识创建cell实例
    TradeLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[TradeLogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setTradeLogisticsModel:(TradeLogisticsModel *)TradeLogisticsModel{
    
    
    _TradeLogisticsModel=TradeLogisticsModel;
    
    [self.goodsnameLabel setText:[TradeLogisticsModel.order_status isEqualToString:@"1"]?@"订单未签收":@"订单已签收"];

    [self.timeLabel setText:[NSString_Category Timestamptofixedformattime:@"YYYY-MM-dd HH:mm:ss" andTimeInterval:TradeLogisticsModel.shipping_time.integerValue]];

    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,TradeLogisticsModel.original_img]] placeholderImage:[UIImage imageNamed:@"nanzhuang"]];
    
    [self.goodscontentLabel setText:TradeLogisticsModel.goods_name];
    
    [self.goodsorderidLabel setText:[NSString stringWithFormat:@"订单编号:%@" ,TradeLogisticsModel.order_sn]];
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
}

- (UILabel *)goodsnameLabel
{
    if (_goodsnameLabel == nil) {
        _goodsnameLabel = [[UILabel alloc] init];
    }
    _goodsnameLabel.font=PFR15Font;
    _goodsnameLabel.textColor=HexColor(333333);
    _goodsnameLabel.textAlignment=NSTextAlignmentLeft;
    _goodsnameLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_goodsnameLabel];
    return _goodsnameLabel;
}


- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
    }
    _timeLabel.font=PFR10Font;
    _timeLabel.textColor=HexColor(999999);
    _timeLabel.textAlignment=NSTextAlignmentLeft;
    _timeLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_timeLabel];
    return _timeLabel;
}




- (UIImageView *)goodsImageView
{
    if (_goodsImageView == nil) {
        _goodsImageView = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_goodsImageView];
    return _goodsImageView;
}

- (UILabel *)goodscontentLabel
{
    if (_goodscontentLabel == nil) {
        _goodscontentLabel = [[UILabel alloc] init];
    }
    _goodscontentLabel.font=PFR12Font;
    _goodscontentLabel.textColor=HexColor(333333);
    _goodscontentLabel.numberOfLines=0;
    _goodscontentLabel.textAlignment=NSTextAlignmentLeft;
    _goodscontentLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_goodscontentLabel];
    return _goodscontentLabel;
}


- (UILabel *)goodsorderidLabel
{
    if (_goodsorderidLabel == nil) {
        _goodsorderidLabel = [[UILabel alloc] init];
    }
    _goodsorderidLabel.font=PFR10Font;
    _goodsorderidLabel.textColor=HexColor(999999);
    _goodsorderidLabel.textAlignment=NSTextAlignmentLeft;
    _goodsorderidLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_goodsorderidLabel];
    return _goodsorderidLabel;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.goodsnameLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    [self.goodsnameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.timeLabel.sd_layout
    .bottomEqualToView(self.goodsnameLabel)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.goodsImageView.sd_layout
    .topSpaceToView(self.timeLabel, 5)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(50)
    .heightIs(50);
    
    
    self.goodscontentLabel.sd_layout
    .topEqualToView(self.goodsImageView)
    .leftEqualToView(self.goodsnameLabel)
    .rightSpaceToView(self.goodsImageView, 10)
    .heightIs(40);
    
    
    self.goodsorderidLabel.sd_layout
    .bottomEqualToView(self.goodsImageView)
    .leftEqualToView(self.goodscontentLabel)
    .autoHeightRatio(0);
    [self.goodsorderidLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-70];
    
   
    //设置最下边的相隔间距 来获取当前cell得行高
    [self setupAutoHeightWithBottomView:self.goodsImageView bottomMargin:20];
    
    
    
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


