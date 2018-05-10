//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//

//@property (nonatomic, copy) NSString *cellid;
//@property (nonatomic, copy) NSString *ordergoodsimgUrlString;
//@property (nonatomic, copy) NSString *ordergoodstitleString;
//@property (nonatomic, copy) NSString *ordergoodsxianjiaString;
//@property (nonatomic, copy) NSString *ordergoodssubtitleString;
//@property (nonatomic, copy) NSString *ordergoodsxianjiaString;
//@property (nonatomic, copy) NSString *ordergoodscountString;
//@property (nonatomic, copy) NSString *ordergoodssmallimgUrlString;

#import "OrderGoodsTableViewCell.h"

@interface OrderGoodsTableViewCell ()

@property (nonatomic, strong) UIImageView *ordergoodsImageview;
@property (nonatomic, strong) UIImageView *ordergoodssmallImageview;

@property (nonatomic, strong) UILabel *ordergoodstitleLabel;
@property (nonatomic, strong) UILabel *ordergoodsxianjiaLabel;
@property (nonatomic, strong) UILabel *ordergoodssubtitleLabel;
@property (nonatomic, strong) UILabel *ordergoodsyuanjiaLabel;
@property (nonatomic, strong) UILabel *ordergoodscountLabel;
@property (nonatomic, strong) UIButton *refundBtn;

@end

@implementation OrderGoodsTableViewCell

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"OrderGoodsTableViewCell";
    // 通过唯一标识创建cell实例
    OrderGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[OrderGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setOrderGoodsModel:(OrderGoodsModel *)OrderGoodsModel{
    
    _OrderGoodsModel=OrderGoodsModel;
    
    [self.ordergoodsImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,OrderGoodsModel.ordergoodsimgUrlString]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    [self.ordergoodssmallImageview setImage:[UIImage imageNamed:OrderGoodsModel.ordergoodssmallimgUrlString]];
    
    [self.ordergoodstitleLabel setText:OrderGoodsModel.ordergoodstitleString];
    
    [self.ordergoodsxianjiaLabel setText:[NSString stringWithFormat:@"￥ %@",OrderGoodsModel.ordergoodsxianjiaString]];
    
    [self.ordergoodssubtitleLabel setText:OrderGoodsModel.ordergoodssubtitleString];
    
    //中划线
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %@",OrderGoodsModel.ordergoodsyuanjiaString] attributes:attribtDic];
    [self.ordergoodsyuanjiaLabel setAttributedText:attribtStr];
    
    [self.ordergoodscountLabel setText:[NSString stringWithFormat:@"x %@",OrderGoodsModel.ordergoodscountString]];
    
    [self.refundBtn setTitle:@"退款售后" forState:UIControlStateNormal];
    self.refundBtn.hidden = YES;
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}
- (UIImageView *)ordergoodsImageview
{
    if (_ordergoodsImageview == nil) {
        _ordergoodsImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_ordergoodsImageview];
    return _ordergoodsImageview;
}

- (UIImageView *)ordergoodssmallImageview
{
    if (_ordergoodssmallImageview == nil) {
        _ordergoodssmallImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_ordergoodssmallImageview];
    return _ordergoodssmallImageview;
}
- (UILabel *)ordergoodstitleLabel
{
    if (_ordergoodstitleLabel == nil) {
        _ordergoodstitleLabel = [[UILabel alloc] init];
    }
    _ordergoodstitleLabel.font=PFR12Font;
    _ordergoodstitleLabel.textColor=[UIColor darkGrayColor];
    _ordergoodstitleLabel.textAlignment=NSTextAlignmentLeft;
    _ordergoodstitleLabel.contentMode=UIViewContentModeCenter;
    _ordergoodstitleLabel.numberOfLines=2;
    [self.contentView addSubview:_ordergoodstitleLabel];
    return _ordergoodstitleLabel;
}
- (UILabel *)ordergoodsxianjiaLabel
{
    if (_ordergoodsxianjiaLabel == nil) {
        _ordergoodsxianjiaLabel = [[UILabel alloc] init];
    }
    _ordergoodsxianjiaLabel.font=PFR12Font;
    _ordergoodsxianjiaLabel.textColor=[UIColor blackColor];
    _ordergoodsxianjiaLabel.textAlignment=NSTextAlignmentLeft;
    _ordergoodsxianjiaLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_ordergoodsxianjiaLabel];
    return _ordergoodsxianjiaLabel;
}
- (UILabel *)ordergoodssubtitleLabel
{
    if (_ordergoodssubtitleLabel == nil) {
        _ordergoodssubtitleLabel = [[UILabel alloc] init];
    }
    _ordergoodssubtitleLabel.font=PFR10Font;
    _ordergoodssubtitleLabel.textColor=[UIColor grayColor];
    _ordergoodssubtitleLabel.textAlignment=NSTextAlignmentLeft;
    _ordergoodssubtitleLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_ordergoodssubtitleLabel];
    return _ordergoodssubtitleLabel;
}
- (UILabel *)ordergoodsyuanjiaLabel
{
    if (_ordergoodsyuanjiaLabel == nil) {
        _ordergoodsyuanjiaLabel = [[UILabel alloc] init];
    }
    _ordergoodsyuanjiaLabel.font=PFR10Font;
    _ordergoodsyuanjiaLabel.textColor=[UIColor grayColor];
    _ordergoodsyuanjiaLabel.textAlignment=NSTextAlignmentLeft;
    _ordergoodsyuanjiaLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_ordergoodsyuanjiaLabel];
    return _ordergoodsyuanjiaLabel;
}
- (UILabel *)ordergoodscountLabel
{
    if (_ordergoodscountLabel == nil) {
        _ordergoodscountLabel = [[UILabel alloc] init];
    }
    _ordergoodscountLabel.font=PFR10Font;
    _ordergoodscountLabel.textColor=[UIColor grayColor];
    _ordergoodscountLabel.textAlignment=NSTextAlignmentLeft;
    _ordergoodscountLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_ordergoodscountLabel];
    return _ordergoodscountLabel;
}

- (UIButton *)refundBtn
{
    if (_refundBtn == nil) {
        _refundBtn = [[UIButton alloc] init];
    }
    [_refundBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_refundBtn.layer setMasksToBounds:YES];
    [_refundBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [_refundBtn.layer setBorderWidth:1.0];
    _refundBtn.layer.borderColor=[UIColor redColor].CGColor;
    _refundBtn.titleLabel.font=PFR12Font;
    _refundBtn.backgroundColor=  [UIColor whiteColor];//hwcolor(18, 36, 46);
    [_refundBtn addTarget:self action:@selector(refundBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ![self.OrderGoodsModel.isshowrefundBtnString isEqualToString:@"show"]?:[self.contentView addSubview:_refundBtn];
    return _refundBtn;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.ordergoodsImageview.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(80)
    .heightIs(80);
    
    self.ordergoodsxianjiaLabel.sd_layout
    .topEqualToView(_ordergoodsImageview)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    [self.ordergoodsxianjiaLabel setSingleLineAutoResizeWithMaxWidth:60];
    
    self.ordergoodstitleLabel.sd_layout
    .topEqualToView(_ordergoodsImageview)
    .leftSpaceToView(_ordergoodsImageview, 10)
    .rightSpaceToView(self.ordergoodsxianjiaLabel, 10)
    .heightIs(40);

    self.ordergoodssubtitleLabel.sd_layout
    .topSpaceToView(_ordergoodstitleLabel, 5)
    .leftEqualToView(_ordergoodstitleLabel)
    .rightSpaceToView(self.ordergoodsxianjiaLabel, 10)
    .autoHeightRatio(0);
    [self.ordergoodssubtitleLabel setMaxNumberOfLinesToShow:1];
//    [self.ordergoodssubtitleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    self.ordergoodsyuanjiaLabel.sd_layout
//    .rightEqualToView(_ordergoodsxianjiaLabel)
    .centerXEqualToView(_ordergoodsxianjiaLabel)
    .centerYEqualToView(_ordergoodssubtitleLabel)
    .autoHeightRatio(0);
//    [self.ordergoodssubtitleLabel setMaxNumberOfLinesToShow:1];
    [self.ordergoodsyuanjiaLabel setSingleLineAutoResizeWithMaxWidth:60];
    
    self.ordergoodscountLabel.sd_layout
    .rightEqualToView(_ordergoodsyuanjiaLabel)
    .topSpaceToView(_ordergoodsyuanjiaLabel, 5)
    .autoHeightRatio(0);
    [self.ordergoodscountLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    self.ordergoodssmallImageview.sd_layout
    .leftEqualToView(_ordergoodstitleLabel)
    .bottomEqualToView(_ordergoodsImageview)
    .widthIs(40)
    .heightIs(15);
    
    self.refundBtn.sd_layout
    .rightEqualToView(_ordergoodscountLabel)
    .centerYEqualToView(self.ordergoodssmallImageview)
    .widthIs(50)
    .heightIs(15);
    
    //设置最下边的相隔间距 来获取当前cell得行高
    [self setupAutoHeightWithBottomView:self.ordergoodsImageview bottomMargin:5];
    
    
    
}

-(void)refundBtnClick{
    if (self.didClickrefundBtnHandler) {
    self.didClickrefundBtnHandler(self.OrderGoodsModel.cellid);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
////重新设置cell的布局大小样式
//- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 5;
//    frame.origin.y += 5;
//    frame.size.height -= 5;
//    frame.size.width -= 10;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end


