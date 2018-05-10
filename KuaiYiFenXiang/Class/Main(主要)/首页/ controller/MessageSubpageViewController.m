//
//  OrderBaseViewController.m
//  NewProject
//
//  Created by apple on 2017/9/10.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "MessageSubpageViewController.h"

#import "TradeLogisticsViewController.h"
#import "TheAnnouncementViewController.h"
#import "FavourableActivityViewController.h"

@interface MessageSubpageViewController ()

@end

@implementation MessageSubpageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"消息";
    
    //设置上面滑动导航栏
    [self setTitleScrollView];
    
}

//设置上边的滑动导航栏以及相应的属性
-(void)setTitleScrollView{
    
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    // 设置标题字体
    // 推荐方式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight,CGFloat *titleWidth) {
        *titleHeight = 44;
        *titleScrollViewColor=[UIColor whiteColor];
        // 设置标题字体
        *titleFont = PFR18Font;
        //选中字体颜色
        *selColor=NAVIGATIONBAR_COLOR;
        
    }];
    
    
    
    
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        // 标题填充模式
        //下划线颜色
        *underLineColor = NAVIGATIONBAR_COLOR;
        
        
    }];
    
    
    
    //滚动字体缩放
    //    [self setUpTitleScale:^(CGFloat *titleScale) {
    //        *titleScale=1.1;
    //    }];
    
    
    
    
    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域,详情请看FullChildViewController
    //    self.isfullScreen = YES;
    
    
    [self setUpContentViewFrame:^(UIView *contentView) {
        
        [contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT)];
        
    }];
    
}


// 添加所有子控制器  由于页面加载先后问题暂未解决所以先手动添加
- (void)setUpAllViewController
{
    //在相应的页面控制器进行数据设置
    //所有订单界面
    TradeLogisticsViewController *tlvc = [[TradeLogisticsViewController alloc] init];
    tlvc.title = @"交易物流";
    [self addChildViewController:tlvc];
    
    
    //待付款界面
    TheAnnouncementViewController *tavc = [[TheAnnouncementViewController alloc] init];
    tavc.title = @"公告";
    [self addChildViewController:tavc];
    
    
    //待发货界面
    FavourableActivityViewController *favc = [[FavourableActivityViewController alloc] init];
    favc.title = @"优惠活动";
    [self addChildViewController:favc];
    
    
    
}

@end

