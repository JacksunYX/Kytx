//
//  DCCustionHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#define AuxiliaryNum 100

#import "StoreDisplayHeadView.h"

// Controllers

// Models

// Views
#import "DCCustionButton.h"
// Vendors

// Categories

// Others

@interface StoreDisplayHeadView ()

/** 记录上一次选中的Button */
@property (nonatomic , weak) DCCustionButton *selectBtn;
/** 记录上一次选中的Button底部View */
@property (nonatomic , strong)UIView *selectBottomRedView;

@end

@implementation StoreDisplayHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (kStringIsEmpty(self.headImageUrl)) {
        
    }else{
        
        UIImageView *cellimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
        [cellimageview setImage:[UIImage imageNamed:@"banner2"]];
        [self addSubview:cellimageview];
        
        
        
        UIImageView *storeimageview=[[UIImageView alloc]init];
        [storeimageview setImage:[UIImage imageNamed:@"banner1"]];
        [cellimageview addSubview:storeimageview];
        storeimageview.sd_layout
        .bottomSpaceToView(cellimageview, 33)
        .leftSpaceToView(cellimageview, 15)
        .widthIs(70)
        .heightIs(70);
        
        UILabel *storenameLabel=[[UILabel alloc]init];
        [storenameLabel setTextColor:[UIColor whiteColor]];
        [storenameLabel setFont:PFR15Font];
        [storenameLabel setText:@"大喜大叔家的鞋"];
        [cellimageview addSubview:storenameLabel];
        storenameLabel.sd_layout
        .centerYEqualToView(storeimageview)
        .leftSpaceToView(storeimageview, 8)
        .autoHeightRatio(0);
        [storenameLabel setSingleLineAutoResizeWithMaxWidth:self.width];

        
      
         UIButton * collectionStoreButton = [[UIButton alloc] init];
        [collectionStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [collectionStoreButton.layer setMasksToBounds:YES];
        [collectionStoreButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        //边框宽度
        [collectionStoreButton.layer setBorderWidth:1.0];
        collectionStoreButton.layer.borderColor=[UIColor redColor].CGColor;
        collectionStoreButton.titleLabel.font=PFR10Font;
        collectionStoreButton.backgroundColor =  [UIColor redColor];//hwcolor(18, 36, 46);
        [collectionStoreButton setTitle:@"收藏店铺" forState:UIControlStateNormal];
        [cellimageview addSubview:collectionStoreButton];
        collectionStoreButton.sd_layout
        .rightSpaceToView(cellimageview, 15)
        .topEqualToView(storeimageview)
        .widthIs(60)
        .heightIs(20);
        
        
        
        
        
    }
    
    
    NSArray *titles = @[@"推荐",@"销量",@"上新",@"积分",@"价格"];
    NSArray *noImage = @[@"",@"",@"",@"topanddown",@"topanddown"];
    CGFloat btnW = self.width / titles.count;
    CGFloat btnH = 45;
    CGFloat btnY;
    if (kStringIsEmpty(self.headImageUrl)) {
        btnY = 0;
    } else {
        btnY = 175;
    }
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
    if (button.tag == 3 + AuxiliaryNum||button.tag == 4 + AuxiliaryNum) { //筛选
        !_filtrateClickBlock ? : _filtrateClickBlock();
    }else{
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
}


#pragma mark - Setter Getter Methods

@end

