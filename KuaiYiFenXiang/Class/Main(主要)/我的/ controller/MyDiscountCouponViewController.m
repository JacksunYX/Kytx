//
//  MyDiscountCouponViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MyDiscountCouponViewController.h"
#import "DiscountCouponChildVC.h"

@interface MyDiscountCouponViewController ()

@end

@implementation MyDiscountCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的优惠券";
    self.view.backgroundColor = BACKVIEWCOLOR;
    
    [self setTitleScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//设置上边的滑动导航栏以及相应的属性
-(void)setTitleScrollView{
    
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    // 设置标题字体
    // 推荐方式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight,CGFloat *titleWidth) {
        *titleHeight = 45;
        *titleWidth = ScreenW/3;
        *titleScrollViewColor=[UIColor whiteColor];
        // 设置标题字体
        *titleFont = PFR15Font;
        //选中字体颜色
        *selColor = NAVIGATIONBAR_COLOR;
        
    }];
    
    
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        // 标题填充模式
        //下划线颜色
        *underLineColor = NAVIGATIONBAR_COLOR;
        *isUnderLineEqualTitleWidth = YES;
        *isUnderLineDelayScroll = YES;
    }];
    
    
    [self setUpContentViewFrame:^(UIView *contentView) {
        
        [contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT)];
        
    }];
    
}

// 添加所有子控制器  由于页面加载先后问题暂未解决所以先手动添加
- (void)setUpAllViewController
{
    DiscountCouponChildVC *firstVC = [DiscountCouponChildVC new];
    firstVC.title = @"未使用";
    firstVC.type = 1;
    [self addChildViewController:firstVC];
    
    DiscountCouponChildVC *secondVC = [DiscountCouponChildVC new];
    secondVC.title = @"已使用";
    secondVC.type = 2;
    [self addChildViewController:secondVC];
    
    DiscountCouponChildVC *thirdC = [DiscountCouponChildVC new];
    thirdC.title = @"已过期";
    thirdC.type = 3;
    [self addChildViewController:thirdC];
    
}










@end
