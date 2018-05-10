//
//  YYDHLBaseViewController.m
//  ProvideHelper
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDHLBaseViewController.h"


@interface YYDHLBaseViewController ()

@end

@implementation YYDHLBaseViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[HttpRequest getCurrentVC].view hideBlankPageView];
    [[HttpRequest getCurrentVC].view hideErrorPageView];



    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置根控制器的属性
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBarHidden = NO;
    
    //设置视图布局属性 设置之后视图会按自己设置的布局进行相应布局
//    self.edgesForExtendedLayout = UIRectEdgeLeft;// 推荐使用

    
}

//给视图添加点击手势 在点击视图时隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //隐藏所有的键盘
    [self.view endEditing:YES];

    //隐藏所有键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    
}



@end
