//
//  EarnPointViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "EarnPointViewController.h"
#import "MyShareViewController.h"

@interface EarnPointViewController ()



@end

@implementation EarnPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赚积分";
    
    self.view.backgroundColor = kDefaultBGColor;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT)];
    scroll.backgroundColor = kDefaultBGColor;
    [self.view addSubview:scroll];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.layer.cornerRadius = 5;
    [btn1 setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    btn1.layer.masksToBounds = YES;
    
    [scroll addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(ScaleWidth(345));
        make.top.equalTo(scroll).offset(10);
        make.height.mas_equalTo(ScaleWidth(245));
    }];
    [btn1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label1 = [UILabel new];
    
    label1.text = @"我的分享";
    label1.font = [UIFont boldSystemFontOfSize:15];
    label1.textColor = kColor333;
    
    [btn1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1).offset(10);
        make.top.equalTo(btn1);
        make.height.mas_equalTo(40);
    }];
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG117.jpeg"]];
    [btn1 addSubview:image1];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1).offset(10);
        make.top.equalTo(btn1).offset(40);
        make.right.equalTo(btn1).offset(-10);
        make.height.mas_equalTo(ScaleWidth(175));
    }];
    
    UILabel *alabel = [UILabel new];
    alabel.textColor = kColor333;
    alabel.text = @"分享赚积分，一起来购物。";
    alabel.font = kFont(12);
    [btn1 addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image1.mas_bottom).offset(10);
        make.left.right.equalTo(image1);
    }];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2.layer.cornerRadius = 5;
    [btn2 setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    btn2.layer.masksToBounds = YES;
    
    [scroll addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(ScaleWidth(345));
        make.top.equalTo(btn1.mas_bottom).offset(10);
        make.height.mas_equalTo(ScaleWidth(245));
    }];
    [btn2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label2 = [UILabel new];
    
    label2.text = @"购物送积分";
    label2.font = [UIFont boldSystemFontOfSize:15];
    label2.textColor = kColor333;
    
    [btn2 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn2).offset(10);
        make.top.equalTo(btn2);
        make.height.mas_equalTo(40);
    }];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG116.jpeg"]];
    [btn2 addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn2).offset(10);
        make.top.equalTo(btn2).offset(40);
        make.right.equalTo(btn2).offset(-10);
        make.height.mas_equalTo(ScaleWidth(175));
    }];
    
    UILabel *blabel = [UILabel new];
    blabel.textColor = kColor333;
    blabel.text = @"你敢买我就敢送。";
    blabel.font = kFont(12);
    [btn2 addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image2.mas_bottom).offset(10);
        make.left.right.equalTo(image2);
    }];
    
}

- (void)click1:(UIButton *)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MyShareViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)click2:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    YYFTabBarViewController *tab = [UIApplication sharedApplication].keyWindow.rootViewController;
    tab.selectedIndex = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
