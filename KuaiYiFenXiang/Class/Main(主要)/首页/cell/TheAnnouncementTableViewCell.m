//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//












#import "TheAnnouncementTableViewCell.h"




@interface TheAnnouncementTableViewCell ()


@property (nonatomic, strong) UIImageView *gonggaoImageView;
@property (nonatomic, strong) UILabel *gonggaotitleLabel;
@property (nonatomic, strong) UILabel *gonggaotimeLabel;

@end






@implementation TheAnnouncementTableViewCell



+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"TheAnnouncementTableViewCell";
    // 通过唯一标识创建cell实例
    TheAnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[TheAnnouncementTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setTheAnnouncementModel:(TheAnnouncementModel *)TheAnnouncementModel{
    
    _TheAnnouncementModel=TheAnnouncementModel;
    
    
    [self.gonggaoImageView sd_setImageWithURL:[NSURL URLWithString:TheAnnouncementModel.gonggaoimageString] placeholderImage:[UIImage imageNamed:@"gonggaoxiaoxi"]];
    
    [self.gonggaotitleLabel setText:TheAnnouncementModel.title];
    
    [self.gonggaotimeLabel setText:[NSString_Category Timestamptofixedformattime:@"YYYY-MM-dd" andTimeInterval:TheAnnouncementModel.publish_time.integerValue]];

    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
}

- (UIImageView *)gonggaoImageView
{
    if (_gonggaoImageView == nil) {
        _gonggaoImageView = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_gonggaoImageView];
    return _gonggaoImageView;
}

- (UILabel *)gonggaotitleLabel
{
    if (_gonggaotitleLabel == nil) {
        _gonggaotitleLabel = [[UILabel alloc] init];
    }
    _gonggaotitleLabel.font=PFR12Font;
    _gonggaotitleLabel.textColor=HexColor(333333);
    _gonggaotitleLabel.textAlignment=NSTextAlignmentLeft;
    _gonggaotitleLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_gonggaotitleLabel];
    return _gonggaotitleLabel;
}


- (UILabel *)gonggaotimeLabel
{
    if (_gonggaotimeLabel == nil) {
        _gonggaotimeLabel = [[UILabel alloc] init];
    }
    _gonggaotimeLabel.font=PFR10Font;
    _gonggaotimeLabel.textColor=HexColor(999999);
    _gonggaotimeLabel.textAlignment=NSTextAlignmentLeft;
    _gonggaotimeLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_gonggaotimeLabel];
    return _gonggaotimeLabel;
}




-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    self.gonggaoImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(30)
    .heightIs(30);
    
    
    self.gonggaotitleLabel.sd_layout
//    .topSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.gonggaoImageView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    [self.gonggaotitleLabel setMaxNumberOfLinesToShow:2];
    
    self.gonggaotimeLabel.sd_layout
    .topSpaceToView(self.gonggaotitleLabel, 0)
    .leftEqualToView(self.gonggaotitleLabel)
    .autoHeightRatio(0);
    [self.gonggaotimeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 100];
    
    
    
    //设置最下边的相隔间距 来获取当前cell得行高
    [self setupAutoHeightWithBottomView:self.gonggaotimeLabel bottomMargin:20];
    
    
    
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



