//
//  MyOrderTableViewCell.m
//  NewProject
//
//  Created by apple on 2017/8/4.
//  strongright © 2017年 JuNiao. All rights reserved.
//












#import "MessageTableViewCell.h"




@interface MessageTableViewCell ()


@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UILabel *messagetitleLabel;
//@property (nonatomic, strong) UILabel *messagesubtitleLabel;



@end






@implementation MessageTableViewCell



+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView{
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"MessageTableViewCell";
    // 通过唯一标识创建cell实例
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    return cell;
}



-(void)setMessageModel:(MessageModel *)MessageModel{
    
    
    _MessageModel=MessageModel;
    
    [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:MessageModel.messageimagestring] placeholderImage:[UIImage imageNamed:@"messagelogo"]];
    
    [self.messagetitleLabel setText:MessageModel.message];

//    [self.messagesubtitleLabel setText:MessageModel.send_time];
    
    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
    
}
- (UIImageView *)messageImageView
{
    if (_messageImageView == nil) {
        _messageImageView = [[UIImageView alloc] init];
    }
    //    _stateImageView.layer.cornerRadius = _stateImageView.width/2;
    //    [_stateImageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:_messageImageView];
    return _messageImageView;
}

- (UILabel *)messagetitleLabel
{
    if (_messagetitleLabel == nil) {
        _messagetitleLabel = [[UILabel alloc] init];
    }
    _messagetitleLabel.font=PFR12Font;
    _messagetitleLabel.numberOfLines = 2;
    _messagetitleLabel.textColor=HexColor(333333);
    _messagetitleLabel.textAlignment=NSTextAlignmentLeft;
    _messagetitleLabel.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_messagetitleLabel];
    return _messagetitleLabel;
}


//- (UILabel *)messagesubtitleLabel
//{
//    if (_messagesubtitleLabel == nil) {
//        _messagesubtitleLabel = [[UILabel alloc] init];
//    }
//    _messagesubtitleLabel.font=PFR10Font;
//    _messagesubtitleLabel.textColor=HexColor(999999);
//    _messagesubtitleLabel.textAlignment=NSTextAlignmentLeft;
//    _messagesubtitleLabel.contentMode=UIViewContentModeCenter;
//    [self.contentView addSubview:_messagesubtitleLabel];
//    return _messagesubtitleLabel;
//}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    self.messageImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(40)
    .heightIs(40);
    
    
    self.messagetitleLabel.sd_layout
//    .topEqualToView(self.messageImageView)
    .centerYEqualToView(self.messageImageView)
    .leftSpaceToView(self.messageImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
//    [self.messagetitleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
//    self.messagesubtitleLabel.sd_layout
//    .bottomEqualToView(self.messageImageView)
//    .leftEqualToView(self.messagetitleLabel)
//    .autoHeightRatio(0);
//    [self.messagesubtitleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    //设置最下边的相隔间距 来获取当前cell得行高
//    [self setupAutoHeightWithBottomView:self.messagesubtitleLabel bottomMargin:10];
    
    
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//重新设置cell的布局大小样式
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 5;
    frame.origin.y += 5;
    frame.size.height -= 5;
    frame.size.width -= 10;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

