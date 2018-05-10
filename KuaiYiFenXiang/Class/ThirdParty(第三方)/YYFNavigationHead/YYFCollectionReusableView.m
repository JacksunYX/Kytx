//
//  DCCustionHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#define AuxiliaryNum 100

#import "YYFCollectionReusableView.h"

// Controllers

// Models

// Views
#import "DCCustionButton.h"
// Vendors

// Categories

// Others


#import "DCSpeedy.h"

@interface YYFCollectionReusableView ()

/** 记录上一次选中的Button */
@property (nonatomic , weak) DCCustionButton *selectBtn;
/** 记录上一次选中的Button底部View */
@property (nonatomic , strong)UIView *selectBottomRedView;

@end

@implementation YYFCollectionReusableView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"推荐",@"人气",@"最新",@"进度"];
    NSArray *noImage = @[@"icon_Arrow2",@"icon_Arrow2",@"icon_Arrow2",@"icon_Arrow2"];
    CGFloat btnW = self.width / titles.count;
    CGFloat btnH = self.height;
    CGFloat btnY = 0;
    for (NSInteger i = 0; i < titles.count; i++) {
        DCCustionButton *button = [DCCustionButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [self addSubview:button];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:noImage[i]] forState:UIControlStateNormal];
        button.tag = i + AuxiliaryNum;
        CGFloat btnX = i * btnW;
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self buttonClick:button]; //默认选择第一个
        }
    }
    
    [DCSpeedy dc_setUpAcrossPartingLineWith:self WithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.4]];
}

#pragma mark - 按钮点击
- (void)buttonClick:(DCCustionButton *)button
{
//    if (button.tag == 3 + AuxiliaryNum) { //筛选
//        !_filtrateClickBlock ? : _filtrateClickBlock();
//    }else{
        _selectBottomRedView.hidden = YES;
        [_selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        UIView *bottomRedView = [[UIView alloc] init];
        [self addSubview:bottomRedView];
        bottomRedView.backgroundColor = [UIColor redColor];
        bottomRedView.width = button.width;
        bottomRedView.height = 3;
        bottomRedView.y = button.height - bottomRedView.height;
        bottomRedView.x = button.x;
        bottomRedView.hidden = NO;
        
        _selectBtn = button;
        _selectBottomRedView = bottomRedView;
    
    
    if (self.returnValueBlock) {
        //将自己的值传出去，完成传值
        self.returnValueBlock(button.titleLabel.text);
    }

    
//    }
}


#pragma mark - Setter Getter Methods

@end
