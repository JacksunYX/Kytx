//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//

//@property (nonatomic, copy) NSString *cellid;
//@property (nonatomic, copy) NSString *isSelect;
//@property (nonatomic, copy) NSString *payimageUrlString;
//@property (nonatomic, copy) NSString *paytextString;
//@property (nonatomic, copy) NSString *paysmallimageUrlString;

#import "PayWayTableViewCell.h"

@interface PayWayTableViewCell ()

@property (nonatomic, strong) UIButton *payselectButton;
@property (nonatomic, strong) UIImageView *payImageview;
@property (nonatomic, strong) UILabel *paytextLabel;
@property (nonatomic, strong) UIImageView *paysmallImageview;

@end

@implementation PayWayTableViewCell

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"PayWayTableViewCell";
    // 通过唯一标识创建cell实例
    PayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[PayWayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setPayWayModel:(PayWayModel *)PayWayModel{
    
    _PayWayModel=PayWayModel;
    
    [_payselectButton setSelected:PayWayModel.isSelect];
    
    [_payImageview setImage:[UIImage imageNamed:PayWayModel.payimageUrlString]];
    
    [_paytextLabel setText:PayWayModel.paytextString];
    
    [_paysmallImageview setImage:[UIImage imageNamed:PayWayModel.paysmallimageUrlString]];
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}
- (UIButton *)payselectButton
{
    if (_payselectButton == nil) {
        _payselectButton = [[UIButton alloc] init];
    }
    [_payselectButton setImage:[UIImage imageNamed:@"normallgray"] forState:UIControlStateNormal];
    [_payselectButton setImage:[UIImage imageNamed:@"selectred"] forState:UIControlStateSelected];
    [self.contentView addSubview:_payselectButton];
    return _payselectButton;
}

- (UIImageView *)payImageview
{
    if (_payImageview == nil) {
        _payImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_payImageview];
    return _payImageview;
}
- (UILabel *)paytextLabel
{
    if (_paytextLabel == nil) {
        _paytextLabel = [[UILabel alloc] init];
    }
    _paytextLabel.font=PFR12Font;
    _paytextLabel.textColor=[UIColor blackColor];
    _paytextLabel.textAlignment=NSTextAlignmentLeft;
    _paytextLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_paytextLabel];
    return _paytextLabel;
}

- (UIImageView *)paysmallImageview
{
    if (_paysmallImageview == nil) {
        _paysmallImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_paysmallImageview];
    return _paysmallImageview;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.payselectButton.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(11)
    .heightIs(11);
    
    self.payImageview.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(_payselectButton, 10)
    .widthIs(40)
    .heightIs(40);
    
    self.paytextLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(_payImageview, 10)
    .autoHeightRatio(0);
    [self.paytextLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    self.paysmallImageview.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(_paytextLabel, 10)
    .widthIs(30)
    .heightIs(15);
    
    [self setupAutoHeightWithBottomView:self.payImageview bottomMargin:10];
    
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


