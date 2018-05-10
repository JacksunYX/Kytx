//
//  DCBrandsSortHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCBrandsSortHeadView.h"

// Controllers

// Models
#import "DCClassMianItem.h"
// Views

// Vendors

// Categories

// Others

@interface DCBrandsSortHeadView ()

@property (strong , nonatomic)UIImageView *titleImageView;

/* 头部标题Label */
@property (strong , nonatomic)UILabel *headLabel;
@property (strong , nonatomic)UILabel *leftlineLabel;
@property (strong , nonatomic)UILabel *rightLineLabel;

@end

@implementation DCBrandsSortHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
#pragma mark - UI
- (void)setUpUI
{
    
    _titleImageView=[[UIImageView alloc]init];
    [self addSubview:_titleImageView];
    
    _headLabel = [[UILabel alloc] init];
    _headLabel.font = PFR13Font;
    _headLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_headLabel];
    
    _leftlineLabel = [[UILabel alloc] init];
    [_leftlineLabel setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:_leftlineLabel];

    _rightLineLabel = [[UILabel alloc] init];
    [_rightLineLabel setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:_rightLineLabel];
    
    
//    if (kStringIsEmpty(self.headTitle.titleimageUrl)) {

    _headLabel.sd_layout
    .bottomEqualToView(self)
    .centerXEqualToView(self)
    .autoHeightRatio(0);
    [_headLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    _leftlineLabel.sd_layout
    .centerYEqualToView(_headLabel)
    .rightSpaceToView(_headLabel, 10)
    .widthIs(30)
    .heightIs(1);
    
    
    _rightLineLabel.sd_layout
    .centerYEqualToView(_headLabel)
    .leftSpaceToView(_headLabel, 10)
    .widthIs(30)
    .heightIs(1);
        
//    }else{
//        
//        _titleImageView.sd_layout
//        .topSpaceToView(self, 15)
//        .leftSpaceToView(self, 15)
//        .rightSpaceToView(self, 15)
//        .heightIs(100);
//        
//        _headLabel.sd_layout
//        .topSpaceToView(_titleImageView, 15)
//        .centerXEqualToView(self)
//        .autoHeightRatio(0);
//        [_headLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
//        
//        _leftlineLabel.sd_layout
//        .centerYEqualToView(_headLabel)
//        .rightSpaceToView(_headLabel, 10)
//        .widthIs(30)
//        .heightIs(1);
//        
//        
//        _rightLineLabel.sd_layout
//        .centerYEqualToView(_headLabel)
//        .leftSpaceToView(_headLabel, 10)
//        .widthIs(30)
//        .heightIs(1);
// 
//        
//    }


}

#pragma mark - Setter Getter Methods
- (void)setHeadTitle:(DCClassMianItem *)headTitle
{
    _headTitle = headTitle;
    _headLabel.text = headTitle.title;
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:headTitle.titleimageUrl ] placeholderImage:[UIImage imageNamed:@"applogo"]];
}

@end
