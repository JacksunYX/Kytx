//
//  DCCustionHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#define AuxiliaryNum 100

#import "DCCustionHeadView.h"

// Controllers

// Models

// Views
#import "DCCustionButton.h"
// Vendors

// Categories

// Others

@interface DCCustionHeadView ()

/** 记录上一次选中的Button */
@property (nonatomic , weak) DCCustionButton *selectBtn;
/** 记录上一次选中的Button底部View */
@property (nonatomic , strong)UIView *selectBottomRedView;

@end

@implementation DCCustionHeadView

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
    
    NSArray *titles = @[@"销量",@"推荐",@"上新",@"积分",@"价格"];
    NSArray *noImage = @[@"",@"",@"",@"topanddown",@"topanddown"];
    CGFloat btnW = self.width / titles.count;
    CGFloat btnH = 45;
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
    
    NSString *selecttypestring=[NSString new];
    
    if (button.tag == 3 + AuxiliaryNum||button.tag == 4 + AuxiliaryNum) { //筛选
        _selectBottomRedView.hidden = YES;
        [_selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.selected=!button.selected;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if (button.tag==3 + AuxiliaryNum) {
            for (DCCustionButton * btn in self.subviews) {
                if (btn.tag == 4 + AuxiliaryNum) { //筛选
                    [btn setSelected:NO];
                    [btn setImage:[UIImage imageNamed:@"topanddown"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
            }
        if (button.selected==YES) {
            selecttypestring=@"4";
            [button setImage:[UIImage imageNamed:@"top"] forState:UIControlStateSelected];
        }else{
            selecttypestring=@"5";
            [button setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        }
        }else{
            for (DCCustionButton * btn in self.subviews) {
                if (btn.tag == 3 + AuxiliaryNum) { //筛选
                    [btn setSelected:NO];
                    [btn setImage:[UIImage imageNamed:@"topanddown"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
            }
            if (button.selected==YES) {
                selecttypestring=@"7";
                [button setImage:[UIImage imageNamed:@"top"] forState:UIControlStateSelected];
            }else{
                selecttypestring=@"6";
                [button setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
            }
        }
        !_filtrateClickBlock ? : _filtrateClickBlock();
    }else{
        
        selecttypestring=[NSString stringWithFormat:@"%ld",button.tag-AuxiliaryNum+1];

        for (DCCustionButton * btn in self.subviews) {
            if (btn.tag == 3 + AuxiliaryNum||btn.tag == 4 + AuxiliaryNum) { //筛选
                [btn setSelected:NO];
                [btn setImage:[UIImage imageNamed:@"topanddown"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        }
        _selectBottomRedView.hidden = YES;
        [_selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        UIView *bottomRedView = [[UIView alloc] init];
        [self addSubview:bottomRedView];
        bottomRedView.backgroundColor = [UIColor redColor];
        bottomRedView.width = button.width;
        bottomRedView.height = 3;
        if (kStringIsEmpty(self.headImageUrl)) {
            bottomRedView.y = button.height - bottomRedView.height;
        } else {
            bottomRedView.y = 175+button.height - bottomRedView.height;
        }
        bottomRedView.x = button.x;
        bottomRedView.hidden = NO;
        
        _selectBtn = button;
        _selectBottomRedView = bottomRedView;
    }
    
    __weak typeof(self) weakself = self;
    
    if (weakself.dccustionheadviewblock) {
        //将自己的值传出去，完成传值
        weakself.dccustionheadviewblock(selecttypestring);
    }
    
}


#pragma mark - Setter Getter Methods

@end
