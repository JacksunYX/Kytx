//
//  NinePiecesOfNineCollectionViewCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OfflineOrdersTableViewCell.h"

@interface OfflineOrdersTableViewCell ()


@property(nonatomic,strong) UILabel *ordersnLabel;

@property(nonatomic,strong) UILabel *addtimeLabel;

@property(nonatomic,strong) UIImageView *orderImageView;

@property(nonatomic,strong) UILabel *usernameTitleLabel;
@property(nonatomic,strong) UILabel *userphoneLabel;

@property(nonatomic,strong) UILabel *ordermoneyTitleLabel;
@property(nonatomic,strong) UILabel *ordermoneyLabel;

@property(nonatomic,strong) UIView *orderBgView;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *ordersnBackView;

@end

@implementation OfflineOrdersTableViewCell

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"OfflineOrdersTableViewCell";
    // 通过唯一标识创建cell实例
    OfflineOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[OfflineOrdersTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
//    {
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    
    
    return cell;
}
-(void)setOfflineOrdersModel:(OfflineOrdersModel *)OfflineOrdersModel{
    
    _OfflineOrdersModel = OfflineOrdersModel;
    
    
    
    [self.ordersnLabel setText:[NSString stringWithFormat:@"订单编号:%@",OfflineOrdersModel.order_sn]];
    
    [self.addtimeLabel setText:OfflineOrdersModel.add_time];
    
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,OfflineOrdersModel.head_pic]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    [self.usernameTitleLabel setText:@"付款人"];
    
    [self.userphoneLabel setText:OfflineOrdersModel.mobile];
    
    [self.ordermoneyTitleLabel setText:@"消费金额"];
    
    [self.ordermoneyLabel setText:[OfflineOrdersModel.money stringByAppendingString:@"元"]];
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}

//- (UIView *)line {
//    if (!_line) {
//        _line = [UIView new];
//        
//        _line.backgroundColor = kColor999;
//        [self.contentView addSubview:_line];
//        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(headview);
//            make.height.mas_equalTo(1);
//        }];
//    }
//}

-(UIView *)orderBgView{
    if (_orderBgView == nil) {
        _orderBgView = [[UIView alloc] init];
    }
    [_orderBgView setBackgroundColor:BACKVIEWCOLOR];
    [self.contentView addSubview:_orderBgView];
    return _orderBgView;
}

-(UIImageView *)orderImageView{
    if (_orderImageView == nil) {
        _orderImageView = [[UIImageView alloc] init];
    }
    //    [_plateimageView.layer setMasksToBounds:YES];
    //    [_plateimageView.layer setCornerRadius:_plateimageView.width/4];
    [self.contentView addSubview:_orderImageView];
    
    return _orderImageView;
}

-(UIView *)ordersnBackView
{
    if (!_ordersnBackView) {
        _ordersnBackView = [UIView new];
        _ordersnBackView.backgroundColor = kWhiteColor;
        _ordersnBackView.layer.borderWidth = 0.5;
        _ordersnBackView.layer.borderColor = kWhite(0.9).CGColor;
    }
    [self.contentView addSubview:_ordersnBackView];
    return _ordersnBackView;
}

- (UILabel *)ordersnLabel
{
    if (_ordersnLabel == nil) {
        _ordersnLabel = [[UILabel alloc] init];
    }
    _ordersnLabel.font = PFR14Font;
    _ordersnLabel.textColor=[UIColor blackColor];
    _ordersnLabel.textAlignment = NSTextAlignmentLeft;
//    _ordersnLabel.contentMode = UIViewContentModeCenter;
    _ordersnLabel.numberOfLines = 1;
    
    [self.contentView addSubview:_ordersnLabel];
    return _ordersnLabel;
}

- (UILabel *)addtimeLabel
{
    if (_addtimeLabel == nil) {
        _addtimeLabel = [[UILabel alloc] init];
    }
    _addtimeLabel.font = PFR14Font;
    _addtimeLabel.textColor=[UIColor lightGrayColor];
    _addtimeLabel.textAlignment=NSTextAlignmentRight;
//    _addtimeLabel.contentMode=UIViewContentModeCenter;
    _addtimeLabel.numberOfLines = 1;
    [self.contentView addSubview:_addtimeLabel];
    return _addtimeLabel;
}

- (UILabel *)usernameTitleLabel
{
    if (_usernameTitleLabel == nil) {
        _usernameTitleLabel = [[UILabel alloc] init];
    }
    _usernameTitleLabel.font=PFR15Font;
    _usernameTitleLabel.textColor=[UIColor blackColor];
    _usernameTitleLabel.textAlignment=NSTextAlignmentLeft;
    _usernameTitleLabel.contentMode=UIViewContentModeCenter;
    _usernameTitleLabel.numberOfLines=0;
    [self.contentView addSubview:_usernameTitleLabel];
    return _usernameTitleLabel;
}

- (UILabel *)userphoneLabel
{
    if (_userphoneLabel == nil) {
        _userphoneLabel = [[UILabel alloc] init];
    }
    _userphoneLabel.font=PFR15Font;
    _userphoneLabel.textColor=[UIColor blackColor];
    _userphoneLabel.textAlignment=NSTextAlignmentLeft;
    _userphoneLabel.contentMode=UIViewContentModeCenter;
    _userphoneLabel.numberOfLines=0;
    [self.contentView addSubview:_userphoneLabel];
    return _userphoneLabel;
}

- (UILabel *)ordermoneyTitleLabel
{
    if (_ordermoneyTitleLabel == nil) {
        _ordermoneyTitleLabel = [[UILabel alloc] init];
    }
    _ordermoneyTitleLabel.font=PFR15Font;
    _ordermoneyTitleLabel.textColor=[UIColor blackColor];
    _ordermoneyTitleLabel.textAlignment=NSTextAlignmentRight;
    _ordermoneyTitleLabel.contentMode=UIViewContentModeCenter;
    _ordermoneyTitleLabel.numberOfLines=0;
    [self.contentView addSubview:_ordermoneyTitleLabel];
    return _ordermoneyTitleLabel;
}

- (UILabel *)ordermoneyLabel
{
    if (_ordermoneyLabel == nil) {
        _ordermoneyLabel = [[UILabel alloc] init];
    }
    _ordermoneyLabel.font=PFR15Font;
    _ordermoneyLabel.textColor=[UIColor redColor];
    _ordermoneyLabel.textAlignment=NSTextAlignmentRight;
    _ordermoneyLabel.contentMode=UIViewContentModeCenter;
    _ordermoneyLabel.numberOfLines=0;
    [self.contentView addSubview:_ordermoneyLabel];
    return _ordermoneyLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.ordersnBackView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(30)
    ;
    
    
    self.ordersnLabel.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
//    .autoHeightRatio(0)
    .heightIs(30)
    ;
    [self.ordersnLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH*2/3];
    
    self.addtimeLabel.sd_layout
    .centerYEqualToView(self.ordersnLabel)
    .rightSpaceToView(self.contentView, 10)
//    .autoHeightRatio(0)
    .heightIs(30)
    ;
    
    [self.addtimeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH*1/3];
    
    self.orderBgView.sd_layout
    .topSpaceToView(self.ordersnBackView, 0)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    self.orderImageView.sd_layout
    .topSpaceToView(self.ordersnLabel, 10)
    .leftEqualToView(self.ordersnLabel)
    .widthIs(80)
    .heightIs(80);
    
    self.usernameTitleLabel.sd_layout
//    .centerYEqualToView(self.orderImageView)
    .topEqualToView(self.orderImageView)
    .leftSpaceToView(self.orderImageView, 10)
    .autoHeightRatio(0);
    [self.usernameTitleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];

    self.userphoneLabel.sd_layout
    .leftEqualToView(self.usernameTitleLabel)
    .topSpaceToView(self.usernameTitleLabel, 10)
    .autoHeightRatio(0);
    [self.userphoneLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    self.ordermoneyTitleLabel.sd_layout
    .centerYEqualToView(self.usernameTitleLabel)
    .rightEqualToView(self.addtimeLabel)
    .autoHeightRatio(0);
    [self.ordermoneyTitleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    self.ordermoneyLabel.sd_layout
    .rightEqualToView(self.ordermoneyTitleLabel)
    .topSpaceToView(self.ordermoneyTitleLabel, 0)
    .autoHeightRatio(0);
    [self.ordermoneyLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    
}


@end


