//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//

#import "SeleteAddressTableViewCell.h"

@interface SeleteAddressTableViewCell ()

@property (nonatomic, strong) UIImageView *bgImageview;

@property (nonatomic, strong) UIImageView *leftsmalladdressImageview;
@property (nonatomic, strong) UILabel *shouhuorenLabel;
@property (nonatomic, strong) UIImageView *morensmallImageview;
@property (nonatomic, strong) UILabel *phonenumLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *rightsmallImageview;

@property (nonatomic, strong) UILabel *shouhuoLabel;    //收货地址：

@end

@implementation SeleteAddressTableViewCell

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"SeleteAddressTableViewCell";
    // 通过唯一标识创建cell实例
    SeleteAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[SeleteAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
//    {
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [self setUpViews];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgImageview.sd_layout
    .centerXEqualToView(self.contentView)
    .centerYEqualToView(self.contentView)
    .widthIs(ScreenW)
    .heightIs(80)
    ;
    
    self.leftsmalladdressImageview.sd_layout
    .centerYEqualToView(self.bgImageview)
    .leftSpaceToView(self.bgImageview, 10)
    .widthIs(18)
    .heightIs(18);
    
    self.phonenumLabel.sd_layout
    .rightSpaceToView(self.bgImageview, 34)
    .topSpaceToView(self.bgImageview, 10)
    .autoHeightRatio(0);
    [self.phonenumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    self.rightsmallImageview.sd_layout
    .centerYEqualToView(_leftsmalladdressImageview)
    .rightSpaceToView(self.bgImageview, 10)
    .widthIs(9)
    .heightIs(14);

    self.shouhuorenLabel.sd_layout
    .topSpaceToView(self.bgImageview, 10)
    .leftSpaceToView(_leftsmalladdressImageview, 10)
//    .autoHeightRatio(0)
    .heightIs(10)
    ;
    [self.shouhuorenLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];

    if ([self.SeleteAddressModel.shouhuoaddressString isEqualToString:@"请选择收货地址"]) {
        
        self.addressLabel.sd_layout
        .leftSpaceToView(_leftsmalladdressImageview, 10)
        .centerYEqualToView(self.bgImageview)
        .rightSpaceToView(self.bgImageview, 39)
        .autoHeightRatio(0)
        ;
    }else{
        
        self.shouhuoLabel.sd_layout
        .leftSpaceToView(_leftsmalladdressImageview, 10)
        .topSpaceToView(self.shouhuorenLabel, 10)
        .autoHeightRatio(0)
        ;
        [self.shouhuoLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        self.addressLabel.sd_layout
        .leftSpaceToView(self.shouhuoLabel, 0)
        .topSpaceToView(self.shouhuorenLabel, 10)
        .rightSpaceToView(self.bgImageview, 34)
        .autoHeightRatio(0)
        ;
    }
    
    
    
//    self.morensmallImageview.sd_layout
//    .centerYEqualToView(_shouhuorenLabel)
//    .leftSpaceToView(_shouhuorenLabel, 10)
//    .widthIs(30)
//    .heightIs(13);
    
}

-(void)setSeleteAddressModel:(SeleteAddressModel *)SeleteAddressModel{
    
    _SeleteAddressModel=SeleteAddressModel;
    
    [self.bgImageview setImage:UIImageNamed(SeleteAddressModel.bgUrlString)];
    
    [self.leftsmalladdressImageview setImage:UIImageNamed(SeleteAddressModel.leftsmalladdressUrlString)];
    
    [self.shouhuorenLabel setText:[NSString stringWithFormat:@"%@", SeleteAddressModel.shouhuorenString]];
//    [self.morensmallImageview setImage:[UIImage imageNamed:SeleteAddressModel.morensmallUrlString]];
//    self.morensmallImageview.image = [UIImage imageNamed:@"moren"];
    [self.phonenumLabel setText:SeleteAddressModel.phonenumString];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@",SeleteAddressModel.shouhuoaddressString]];
    [self.rightsmallImageview setImage:[UIImage imageNamed:SeleteAddressModel.rightsmallUrlString]];
    
    if (kStringIsEmpty(self.SeleteAddressModel.shouhuorenString)) {
        self.shouhuorenLabel.hidden = YES;
        self.phonenumLabel.hidden = YES;
    } else {
        self.shouhuorenLabel.hidden = NO;
        self.phonenumLabel.hidden = NO;
    }
    
    if ([self.SeleteAddressModel.shouhuoaddressString isEqualToString:@"请选择收货地址"]) {
        self.shouhuoLabel.hidden = YES;
    }else{
        self.shouhuoLabel.hidden = NO;
        self.shouhuoLabel.text = @"收货地址：";
    }
    
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}


- (UIImageView *)bgImageview
{
    if (_bgImageview == nil) {
        _bgImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_bgImageview];
    return _bgImageview;
}

- (UIImageView *)leftsmalladdressImageview
{
    if (_leftsmalladdressImageview == nil) {
        _leftsmalladdressImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.bgImageview addSubview:_leftsmalladdressImageview];
    return _leftsmalladdressImageview;
}

-(UILabel *)shouhuoLabel
{
    if (!_shouhuoLabel) {
        _shouhuoLabel = [[UILabel alloc] init];
    }
    [self.bgImageview addSubview:_shouhuoLabel];
    _shouhuoLabel.font = PFR12Font;
    kStringIsEmpty(self.SeleteAddressModel.bgUrlString)?[_shouhuoLabel setTextColor:[UIColor blackColor]]:[_shouhuoLabel setTextColor:[UIColor whiteColor]];
    _shouhuoLabel.textAlignment = NSTextAlignmentLeft;
    _shouhuoLabel.contentMode = UIViewContentModeCenter;
    return _shouhuoLabel;
}

- (UILabel *)shouhuorenLabel
{
    if (_shouhuorenLabel == nil) {
        _shouhuorenLabel = [[UILabel alloc] init];
    }
    _shouhuorenLabel.font=PFR12Font;
    kStringIsEmpty(self.SeleteAddressModel.bgUrlString)?[_shouhuorenLabel setTextColor:[UIColor blackColor]]:[_shouhuorenLabel setTextColor:[UIColor whiteColor]];
    _shouhuorenLabel.textAlignment=NSTextAlignmentLeft;
    _shouhuorenLabel.contentMode=UIViewContentModeCenter;
//    kStringIsEmpty(self.SeleteAddressModel.shouhuorenString)?[_shouhuorenLabel removeFromSuperview]:[self.bgImageview addSubview:_shouhuorenLabel];
    [self.bgImageview addSubview:_shouhuorenLabel];
    return _shouhuorenLabel;
}
- (UIImageView *)morensmallImageview
{
    if (_morensmallImageview == nil) {
        _morensmallImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    kStringIsEmpty(self.SeleteAddressModel.shouhuorenString)?[_morensmallImageview removeFromSuperview]:[self.bgImageview addSubview:_morensmallImageview];
    return _morensmallImageview;
}
- (UILabel *)phonenumLabel
{
    if (_phonenumLabel == nil) {
        _phonenumLabel = [[UILabel alloc] init];
    }
    _phonenumLabel.font=PFR12Font;
    kStringIsEmpty(self.SeleteAddressModel.bgUrlString)?[_phonenumLabel setTextColor:[UIColor blackColor]]:[_phonenumLabel setTextColor:[UIColor whiteColor]];
    _phonenumLabel.textAlignment=NSTextAlignmentLeft;
    _phonenumLabel.contentMode=UIViewContentModeCenter;
    [self.bgImageview addSubview:_phonenumLabel];
    return _phonenumLabel;
}
- (UILabel *)addressLabel
{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
    }
    _addressLabel.font=PFR12Font;
    kStringIsEmpty(self.SeleteAddressModel.bgUrlString)?[_addressLabel setTextColor:[UIColor blackColor]]:[_addressLabel setTextColor:[UIColor whiteColor]];
    _addressLabel.textAlignment=NSTextAlignmentLeft;
    _addressLabel.contentMode=UIViewContentModeCenter;
    [self.bgImageview addSubview:_addressLabel];
    return _addressLabel;
}
- (UIImageView *)rightsmallImageview
{
    if (_rightsmallImageview == nil) {
        _rightsmallImageview = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.bgImageview addSubview:_rightsmallImageview];
    return _rightsmallImageview;
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


