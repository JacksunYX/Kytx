//
//  KYPhoneViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYPhoneViewController.h"
#import "KYHeader.h"
#import "ChangePhoneViewController.h"

@interface KYPhoneViewController ()

@end

@implementation KYPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    self.view.backgroundColor =kDefaultBGColor;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@44);
    }];
    
    UILabel *label = [UILabel new];
    
    label.text = @"绑定手机号";
    label.font = kFont(15);
    label.textColor = kColor333;
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(15);
    }];
    
    UILabel *plabel = [UILabel new];
    
    plabel.textColor = kColor666;
    plabel.font = kFont(15);
    plabel.text = self.phone;
    
    [view addSubview:plabel];
    [plabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-15);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"     更换绑定手机号     " forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(view.mas_bottom).offset(30);
        make.height.equalTo(@44);
        make.width.mas_equalTo(270);
    }];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(UIButton *)sender {
    ChangePhoneViewController *vc= [ChangePhoneViewController new];
    vc.phone = self.phone;
    [self.navigationController pushViewController:vc animated:YES];
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
