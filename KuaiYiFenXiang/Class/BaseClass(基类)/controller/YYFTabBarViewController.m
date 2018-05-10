//
//  YYFTabBarViewController.m
//  慈德汇
//
//  Created by apple on 11/11/16.
//  Copyright © 2016年 杨毅飞. All rights reserved.
//

#import "YYFTabBarViewController.h"
#import "YYFNavigationController.h"


//首页
#import "HomePageViewController.h"
//附近(Vip)
#import "NearViewController.h"
//排行榜
#import "ListViewController.h"
//购物车
#import "ShoppingCarViewController.h"
//我的
#import "MyViewController.h"

@interface YYFTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic,assign) NSInteger  indexFlag;//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0

@end

@implementation YYFTabBarViewController

- (void)viewDidLoad {
        [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    
    
    HomePageViewController *hpvc=[[HomePageViewController alloc]init];
    [self addchildvc:hpvc title:@"首页" image:@"shouye_normal" selectedimage:@"shouye_select"];
    
    
    NearViewController *nvc=[[NearViewController alloc]init];
    [self addchildvc:nvc title:@"VIP" image:@"fujin_normal" selectedimage:@"fujin_select"];


    ListViewController *lvc=[[ListViewController alloc]init];
    [self addchildvc:lvc title:@"排行榜" image:@"paihangbang_normal" selectedimage:@"paihangbang_select"];    //设置主要控制器
    
    
    ShoppingCarViewController *scvc=[[ShoppingCarViewController alloc]init];
    [self addchildvc:scvc title:@"购物车" image:@"gouwuche_normal" selectedimage:@"gouwuche_select"];    //设置主要控制器

    
    
    MyViewController *mvc=[[MyViewController alloc]init];
    [self addchildvc:mvc title:@"我的" image:@"wode_normal" selectedimage:@"wode_select"];
    

    self.delegate = self;
    

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"我的"]) {
        self.selectedIndex = 0;
    }
}


-(void)addchildvc:(UIViewController *)childvc  title:(NSString *)title  image:(NSString *)image  selectedimage:(NSString *)selectedimage{
    
    //3.设置子控制器
    //childvc.view.backgroundColor=hwrandomcolor;
    
    
    //    childvc.tabBarItem.title=title;
    //设置导航控制器文字
    //   childvc.navigationItem.title=title;
    
    
    //这句话可以同时设置上边和下边的文字
    childvc.title=title;
    childvc.tabBarItem.image=[UIImage imageNamed:image];
    // 声明图片按照原始的样子显示出来
    childvc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    childvc.tabBarItem.image=[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //设置文字的样式
    NSMutableDictionary *textattrs=[NSMutableDictionary dictionary];
    textattrs[NSForegroundColorAttributeName]=hwcolor(51, 51, 51);
    
    NSMutableDictionary *selecttextattrs=[NSMutableDictionary dictionary];
    selecttextattrs[NSForegroundColorAttributeName]=hwcolor(225, 39, 39);
    
    [childvc.tabBarItem setTitleTextAttributes:textattrs forState:UIControlStateNormal];
    [childvc.tabBarItem setTitleTextAttributes:selecttextattrs forState:UIControlStateSelected];

    //设置tabbar背景颜色
    [[UITabBar appearance] setBarTintColor:hwcolor(255, 255, 255)];

    //设置tabbar透明
    [UITabBar appearance].translucent = NO;
    
    //去掉tabbar上横线
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@""]];
    [[UITabBar appearance] setShadowImage:img];

    
    
    //先给外边传进来的小控制器包装成一个导航控制器
    YYFNavigationController *nav=[[YYFNavigationController alloc]initWithRootViewController:childvc];
    //添加子控制器
    [self addChildViewController:nav];
    
    
}






#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
    
}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    
    
    //里面的排序错乱 点击按钮取出的对象不一致
//    原因: 在TabBarItem设置的title与在控制器
//    设置的title不一致导致的(系统的BUG)
//    解决办法: 在控制器中设置title的时候使用self.navigationItem.title = @“自己设置的不同title";
    
    
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    NSLog(@"%lu-----%@",(unsigned long)self.selectedIndex,tabBarButtons);
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
//    for (UIView *imageView in tabBarButton.subviews) {
//        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [tabBarButton.layer addAnimation:animation forKey:nil];
//        }
//    }
}




//不同的按钮点击动画 只需要更换相应的代码即可
//1、先放大，再缩小
//
//复制代码
////放大效果，并回到原位
//CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
////速度控制函数，控制动画运行的节奏
//animation.timingFunction = [CAMediaTimingFunction functionWithName:];
//animation.duration = 0.2;       //执行时间
//animation.repeatCount = 1;      //执行次数
//animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
//animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
//animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
//[[arry[index] layer] addAnimation:animation forKey:nil];
//复制代码
//
//
//2、Z轴旋转
//
//复制代码
////z轴旋转180度
//CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////速度控制函数，控制动画运行的节奏
//animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//animation.duration = 0.2;       //执行时间
//animation.repeatCount = 1;      //执行次数
//animation.removedOnCompletion = YES;
//animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
//animation.toValue = [NSNumber numberWithFloat:M_PI];     //结束伸缩倍数
//[[arry[index] layer] addAnimation:animation forKey:nil];
//复制代码
//
//
//3、Y轴位移
//
//复制代码
////向上移动
//CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
////速度控制函数，控制动画运行的节奏
//animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//animation.duration = 0.2;       //执行时间
//animation.repeatCount = 1;      //执行次数
//animation.removedOnCompletion = YES;
//animation.fromValue = [NSNumber numberWithFloat:0];   //初始伸缩倍数
//animation.toValue = [NSNumber numberWithFloat:-10];     //结束伸缩倍数
//[[arry[index] layer] addAnimation:animation forKey:nil];
//复制代码
//
//
//4、放大并保持
//
//复制代码
////放大效果
//CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
////速度控制函数，控制动画运行的节奏
//animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//animation.duration = 0.2;       //执行时间
//animation.repeatCount = 1;      //执行次数
//animation.removedOnCompletion = NO;
//animation.fillMode = kCAFillModeForwards;           //保证动画效果延续
//animation.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
//animation.toValue = [NSNumber numberWithFloat:1.15];     //结束伸缩倍数
//[[arry[index] layer] addAnimation:animation forKey:nil];
////移除其他tabbar的动画
//for (int i = 0; i<arry.count; i++) {
//    if (i != index) {
//        [[arry[i] layer] removeAllAnimations];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
