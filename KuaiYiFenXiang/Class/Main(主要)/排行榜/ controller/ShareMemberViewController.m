//
//  ShareMemberViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShareMemberViewController.h"
#import "KYHeader.h"
#import "ShareMemberViewController.h"
#import "StoreManagementViewController.h"
#import "ImageViewController.h"

@interface ShareMemberViewController ()

@end

@implementation ShareMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBGColor;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT)];
    scroll.backgroundColor = kDefaultBGColor;
    self.title = @"角色介绍";
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
        make.height.mas_equalTo(ScaleWidth(235));
    }];
    [btn1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分享会员bg01"]];
    [btn1 addSubview:image1];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(btn1).offset(10);
        make.right.equalTo(btn1).offset(-10);
        make.height.mas_equalTo(ScaleWidth(215));
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
        make.height.mas_equalTo(ScaleWidth(235));
    }];
    [btn2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分享会员bg02"]];
    [btn2 addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(btn2).offset(10);
        make.right.equalTo(btn2).offset(-10);
        make.height.mas_equalTo(ScaleWidth(215));
    }];
    
}

- (void)click1:(UIButton *)sender {
    
    ImageViewController *vc = [[ImageViewController alloc] init];
    
    vc.name = @"快益用户";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)click2:(UIButton *)sender {
    ImageViewController *vc = [[ImageViewController alloc] init];
    
    vc.name = @"快益VIP";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
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
