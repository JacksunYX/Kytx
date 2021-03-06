//
//  YYFNavigationController.m
//  慈德汇
//
//  Created by 杨毅飞 on 16/11/11.
//  Copyright © 2016年 杨毅飞. All rights reserved.
//

#import "YYFNavigationController.h"
@interface YYFNavigationController ()

@end

@implementation YYFNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //统一设置navigationBar的样式
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    
    //设置导航栏半透明
    [UINavigationBar appearance].translucent = NO;
    
//    [self hideNavigationDownLine];
    
    [self.navigationBar setTitleTextAttributes:
    
    @{NSFontAttributeName:[UIFont systemFontOfSize:18],
    
    NSForegroundColorAttributeName:HexColor(#333333)}];

}

/**
 显示导航栏下的横线
 */
-(void)showNavigationDownLine
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:kWhite(0.8)]];
}


/**
 去除导航栏横线
 */
-(void)hideNavigationDownLine
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


//重写这个方法的目的是为了拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //判断如果是不是首页控制器 然后统一设置
    if (self.childViewControllers.count > 0) {
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置左边按钮
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"BACK" hightimage:@"BACK" andTitle:@""];
        
        //设置右边按钮
        

    }else{
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    
    [super pushViewController:viewController animated:animated];
    
}

//如果点击左边按钮就返回上级页面
-(void)back{
    

    [self popViewControllerAnimated:YES];
    
}

//设置右边按钮点击事件直接跳转到根控制器
-(void)more{
    
    [self popToRootViewControllerAnimated:YES];
    
}




@end
