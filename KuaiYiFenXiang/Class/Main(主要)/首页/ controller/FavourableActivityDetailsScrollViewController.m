//
//  FavourableActivityDetailsScrollViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/18.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "FavourableActivityDetailsScrollViewController.h"
#import "FavourableActivityDetailsViewController.h"

@interface FavourableActivityDetailsScrollViewController ()<UIScrollViewDelegate>{
         //在私有扩展中创建一个属性
         UIScrollView *_scrollView;
    
}

@end

@implementation FavourableActivityDetailsScrollViewController

- (void)viewDidLoad
{
         [super viewDidLoad];

    
        self.navigationItem.title = @"新年大钜惠";

         // 1.创建UIScrollView
         UIScrollView *scrollView = [[UIScrollView alloc] init];
         scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); // frame中的size指UIScrollView的可视范围
         scrollView.backgroundColor = BACKVIEWCOLOR;
         scrollView.delegate=self;
         [self.view addSubview:scrollView];

         // 2.创建UIImageView（图片）
         UIImageView *imageView = [[UIImageView alloc] init];
         imageView.image = [UIImage imageNamed:@"youhuibanner"];
         imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
         [scrollView addSubview:imageView];
    
    
        UIImageView *recommendedImageview = [[UIImageView alloc]init];
        [recommendedImageview setImage:[UIImage imageNamed:@"zuixintuijian"]];
        [scrollView addSubview:recommendedImageview];
        recommendedImageview.sd_layout
        .topSpaceToView(imageView, 15)
        .centerXEqualToView(scrollView)
        .widthIs(SCREEN_WIDTH-80)
        .heightIs(23);
    
    
        FavourableActivityDetailsViewController *fadvc=[[FavourableActivityDetailsViewController alloc]init];
        [scrollView addSubview:fadvc.view];
        [self addChildViewController:fadvc];
        fadvc.view.sd_layout
        .topSpaceToView(recommendedImageview, 15)
        .centerXEqualToView(scrollView)
        .widthIs(SCREEN_WIDTH)
        .heightIs(SCREEN_HEIGHT-80);
    
    

         // 3.设置scrollView的属性

         // 设置UIScrollView的滚动范围（内容大小）
         scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+210);

         // 隐藏水平滚动条
         scrollView.showsHorizontalScrollIndicator = NO;
         scrollView.showsVerticalScrollIndicator = NO;

         // 用来记录scrollview滚动的位置
        //    scrollView.contentOffset = ;

         // 去掉弹簧效果
        //    scrollView.bounces = NO;

         // 增加额外的滚动区域（逆时针，上、左、下、右）
         // top  left  bottom  right
         scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

         _scrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY-----%f",offsetY);
    
}


- (void)down:(UIButton *)sender {
    
         [UIView animateWithDuration:1.0 animations:^{
                 //三个步骤
                 CGPoint offset = _scrollView.contentOffset;
                 offset.y += 150;
                 _scrollView.contentOffset = offset;

                 //_scrollView.contentOffset = CGPointMake(0, 0);
        }];
    
}

@end
