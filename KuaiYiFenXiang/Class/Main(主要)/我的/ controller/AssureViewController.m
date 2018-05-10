//
//  AssureViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "AssureViewController.h"
#import "KYHeader.h"

@interface AssureViewController ()

@end

@implementation AssureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"担保交易";
    self.view.backgroundColor = kDefaultBGColor;
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 65)];
    a.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:a];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"担保交易_icon"]];
    [a addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(a);
        make.left.equalTo(a).offset(15);
    }];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    label.text = @"担保交易";
    label.font = [UIFont systemFontOfSize:15];
    [a addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(10);
        make.centerY.equalTo(imgView);
    }];
    
    UILabel *desc = [UILabel new];
    desc.text = @"担保交易，让您的买家购物更有保障！";
    desc.textColor = [UIColor colorWithHexString:@"999999"];
    desc.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:desc];
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(a.mas_bottom).offset(15);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btn setTitle:@"《担保交易服务条款》" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"d40000"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desc.mas_right);
        make.centerY.equalTo(desc);
    }];
    [btn addTarget:self action:@selector(rules) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rules {
    NSLog(@"条款");
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
