//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//












#import "FavourableActivityDetailsTableViewCell.h"




@interface FavourableActivityDetailsTableViewCell ()

@property (nonatomic, strong) UIImageView  *youhuiImageView;
@property (nonatomic, strong) UILabel *youhuititleLabel;
@property (nonatomic, strong) UILabel *youhuisoldLabel;
@property(nonatomic,strong) UILabel *originalpriceLabel;
@property(nonatomic,strong) UILabel *presentpriceLabel;
@property (nonatomic, strong) UIButton *checkdetailsButton;
@property(nonatomic,strong) UILabel *graylineLabel;

@end






@implementation FavourableActivityDetailsTableViewCell



+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"FavourableActivityDetailsTableViewCell";
    // 通过唯一标识创建cell实例
    FavourableActivityDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[FavourableActivityDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setGoodsUnifiedModel:(GoodsUnifiedModel *)GoodsUnifiedModel{
    
    _GoodsUnifiedModel=GoodsUnifiedModel;
    
    [self.youhuiImageView sd_setImageWithURL:[NSURL URLWithString:GoodsUnifiedModel.imageurlString] placeholderImage:[UIImage imageNamed:@"youhuibanner"]];

    [self.youhuititleLabel setText:GoodsUnifiedModel.maintitleString];
    
    [self.youhuisoldLabel setText:GoodsUnifiedModel.soldString];
    
    
    [self.presentpriceLabel setText:GoodsUnifiedModel.presentpriceString];
    [self.originalpriceLabel setText:GoodsUnifiedModel.originalpriceString];

    [self.checkdetailsButton setTitle:GoodsUnifiedModel.buybuttontextString forState:UIControlStateNormal];
    
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
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

- (UILabel *)youhuititleLabel
{
    if (_youhuititleLabel == nil) {
        _youhuititleLabel = [[UILabel alloc] init];
    }
    _youhuititleLabel.font=PFR13Font;
    _youhuititleLabel.textColor=HexColor(333333);
    _youhuititleLabel.textAlignment=NSTextAlignmentLeft;
    _youhuititleLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_youhuititleLabel];
    return _youhuititleLabel;
}




- (UILabel *)youhuisoldLabel
{
    if (_youhuisoldLabel == nil) {
        _youhuisoldLabel = [[UILabel alloc] init];
    }
    _youhuisoldLabel.font=PFR9Font;
    _youhuisoldLabel.textColor=HexColor(d40000);
    _youhuisoldLabel.textAlignment=NSTextAlignmentLeft;
    _youhuisoldLabel.contentMode=UIViewContentModeCenter;
    [_youhuisoldLabel setBackgroundColor:HexColor(ffcde3)];
    [self.contentView addSubview:_youhuisoldLabel];
    return _youhuisoldLabel;
}

- (UILabel *)originalpriceLabel
{
    if (_originalpriceLabel == nil) {
        _originalpriceLabel = [[UILabel alloc] init];
    }
    _originalpriceLabel.font=PFR10Font;
    _originalpriceLabel.textColor=[UIColor grayColor];
    _originalpriceLabel.textAlignment=NSTextAlignmentCenter;
    _originalpriceLabel.contentMode=UIViewContentModeCenter;
    _originalpriceLabel.numberOfLines=0;
    [self.contentView addSubview:_originalpriceLabel];
    return _originalpriceLabel;
}



- (UILabel *)presentpriceLabel
{
    if (_presentpriceLabel == nil) {
        _presentpriceLabel = [[UILabel alloc] init];
    }
    _presentpriceLabel.font=PFR13Font;
    _presentpriceLabel.textColor=[UIColor redColor];
    _presentpriceLabel.textAlignment=NSTextAlignmentCenter;
    _presentpriceLabel.contentMode=UIViewContentModeCenter;
    _presentpriceLabel.numberOfLines=0;
    [self.contentView addSubview:_presentpriceLabel];
    return _presentpriceLabel;
}


- (UILabel *)graylineLabel
{
    if (_graylineLabel == nil) {
        _graylineLabel = [[UILabel alloc] init];
    }
    [_graylineLabel setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:_graylineLabel];
    return _graylineLabel;
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
    
    
    
    self.youhuiImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .widthIs(90)
    .heightIs(90);
    
    
    self.youhuititleLabel.sd_layout
    .topEqualToView(self.youhuiImageView)
    .leftSpaceToView(self.youhuiImageView, 15)
    .widthIs(SCREEN_WIDTH-135)
    .autoHeightRatio(0);

    self.youhuisoldLabel.sd_layout
    .topSpaceToView(self.youhuititleLabel, 10)
    .leftEqualToView(self.youhuititleLabel)
    .autoHeightRatio(0);
    [self.youhuisoldLabel setSingleLineAutoResizeWithMaxWidth:53];
    
    
    self.presentpriceLabel.sd_layout
    .topSpaceToView(self.youhuisoldLabel, 10)
    .leftEqualToView(self.youhuititleLabel)
    .autoHeightRatio(0);
    [self.presentpriceLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.originalpriceLabel.sd_layout
    .topSpaceToView(self.presentpriceLabel, 5)
    .leftEqualToView(self.youhuititleLabel)
    .autoHeightRatio(0);
    [self.originalpriceLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.graylineLabel.sd_layout
    .centerYEqualToView(self.originalpriceLabel)
    .centerXEqualToView(self.originalpriceLabel)
    .heightIs(1)
    .widthIs(40);

    self.checkdetailsButton.sd_layout
    .bottomEqualToView(self.originalpriceLabel)
    .rightEqualToView(self.youhuititleLabel)
    .widthIs(65)
    .heightIs(25);
    
    
    //设置最下边的相隔间距 来获取当前cell得行高
    [self setupAutoHeightWithBottomView:self.checkdetailsButton bottomMargin:10];
    
    
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
////重新设置cell的布局大小样式
//- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 10;
//    frame.origin.y += 10;
//    frame.size.height -= 10;
//    frame.size.width -= 20;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end




