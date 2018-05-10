//
//  ClassificationTitleHeadView.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ClassificationTitleHeadView.h"

@interface ClassificationTitleHeadView ()

@property (strong , nonatomic)UIImageView *headimageview;

@property (strong , nonatomic)UILabel *titleLabel;

@property (strong , nonatomic)UILabel *subtitleLabel;

@property (strong , nonatomic)UILabel *leftlineLabel;
@property (strong , nonatomic)UILabel *rightlineLabel;

@end

@implementation ClassificationTitleHeadView


-(void)setClassificationTitleHeadModel:(ClassificationTitleHeadModel *)ClassificationTitleHeadModel{
    
    _ClassificationTitleHeadModel=ClassificationTitleHeadModel;
    
    [self.headimageview setImage:[UIImage imageNamed:ClassificationTitleHeadModel.ad_code]];
//    [self.headimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,ClassificationTitleHeadModel.ad_code]] placeholderImage:[UIImage imageNamed:@"applogo"]];
    
    [self.titleLabel setText:ClassificationTitleHeadModel.ad_titlename];
    
    [self.subtitleLabel setText:ClassificationTitleHeadModel.ad_subtitlename];

    //一定要调用布局方法进行布局
    [self layoutSubviews];
    
}

-(UIImageView *)headimageview{
    if (_headimageview == nil) {
        _headimageview = [[UIImageView alloc] init];
    }
    if (self.ClassificationTitleHeadModel.IsRoundedcorners.integerValue==0) {
        [_headimageview.layer setMasksToBounds:YES];
        [_headimageview.layer setCornerRadius:10.0];
    }else{
        
    }
    [self addSubview:_headimageview];
    
    return _headimageview;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    _titleLabel.font=PFR18Font;
    [_titleLabel setTextColor:kColord40];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.contentMode=UIViewContentModeCenter;
    _titleLabel.numberOfLines=0;
    [self addSubview:_titleLabel];
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] init];
    }
    _subtitleLabel.font=PFR12Font;
    [_subtitleLabel setTextColor:[UIColor grayColor]];
    _subtitleLabel.textAlignment=NSTextAlignmentCenter;
    _subtitleLabel.contentMode=UIViewContentModeCenter;
    _subtitleLabel.numberOfLines=0;
    [self addSubview:_subtitleLabel];
    return _subtitleLabel;
}

- (UILabel *)leftlineLabel
{
    if (_leftlineLabel == nil) {
        _leftlineLabel = [[UILabel alloc] init];
    }
    [_leftlineLabel setBackgroundColor:hwcolor(204, 204, 204)];
    [self addSubview:_leftlineLabel];
    return _leftlineLabel;
}

- (UILabel *)rightlineLabel
{
    if (_rightlineLabel == nil) {
        _rightlineLabel = [[UILabel alloc] init];
    }
    [_rightlineLabel setBackgroundColor:hwcolor(204, 204, 204)];
    [self addSubview:_rightlineLabel];
    return _rightlineLabel;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.headimageview,15)
    .centerXEqualToView(self)
    .autoHeightRatio(0);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    self.leftlineLabel.sd_layout
    .centerYEqualToView(self.titleLabel)
    .leftSpaceToView(self, 40)
    .heightIs(1)
    .rightSpaceToView(self.titleLabel, 9);
    
    self.rightlineLabel.sd_layout
    .centerYEqualToView(self.titleLabel)
    .rightSpaceToView(self, 40)
    .heightIs(1)
    .leftSpaceToView(self.titleLabel, 9);
    
    self.subtitleLabel.sd_layout
    .topSpaceToView(self.titleLabel, 10)
    .centerXEqualToView(self)
    .autoHeightRatio(0);
    [self.subtitleLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    
    NSInteger type = self.ClassificationTitleHeadModel.IsRoundedcorners.integerValue;
    if (type == 3) {
        self.headimageview.sd_layout
        .topSpaceToView(self, 20)
        .centerXEqualToView(self)
        .widthIs(SCREEN_WIDTH-36)
        .heightIs(85);
        self.leftlineLabel.hidden = YES;
        self.rightlineLabel.hidden = YES;
        self.titleLabel.hidden = YES;
        self.subtitleLabel.hidden = YES;
        return;
    }else if (type == 0) {
        self.headimageview.sd_layout
        .topSpaceToView(self, 15)
        .centerXEqualToView(self)
        .widthIs(SCREEN_WIDTH-30)
        .heightIs(150-30);
    }else if (type == 4){
        self.titleLabel.sd_layout
        .topSpaceToView(self,15)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        [self updateLayout];
        self.leftlineLabel.hidden = NO;
        self.rightlineLabel.hidden = NO;
        self.titleLabel.hidden = NO;
        self.subtitleLabel.hidden = NO;
        return;
    }else{
        self.headimageview.sd_layout
        .topEqualToView(self)
        .centerXEqualToView(self)
        .widthIs(SCREEN_WIDTH)
        .heightIs(150);
    }

}




@end


