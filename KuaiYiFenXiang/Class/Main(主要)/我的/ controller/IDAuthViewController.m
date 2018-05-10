//
//  IDAuthViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "IDAuthViewController.h"
#import "KYHeader.h"

@interface IDAuthViewController ()

@end

@implementation IDAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = kDefaultBGColor;
    
    UILabel *alabel = [[UILabel alloc] init];
    
    alabel.text = @"真实姓名";
    alabel.font = [UIFont systemFontOfSize:12];
    alabel.textColor = kColor999;
    
    [self.view addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(10);
    }];
    
    UITextField *atf = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    atf.clearButtonMode = UITextFieldViewModeAlways;
    atf.placeholder = @"请输入与身份证一致的真实姓名";
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    atf.leftView = a;
    atf.leftViewMode = UITextFieldViewModeAlways;
    atf.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:atf];
    [atf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(alabel.mas_bottom).offset(10);
    }];
    
    UILabel *blabel = [[UILabel alloc] init];
    
    blabel.text = @"身份证号码";
    blabel.font = [UIFont systemFontOfSize:12];
    blabel.textColor = kColor999;
    
    [self.view addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(atf.mas_bottom).offset(20);
    }];
    
    UITextField *btf = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    btf.clearButtonMode = UITextFieldViewModeAlways;
    btf.placeholder = @"请输入真实的身份证号码";
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    btf.leftView = b;
    btf.leftViewMode = UITextFieldViewModeAlways;
    btf.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:btf];
    [btf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(blabel.mas_bottom).offset(10);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"开始认证" forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColor999] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(btf.mas_bottom).offset(20);
        make.height.equalTo(@44);
    }];
}

- (void)btnClicked:(UIButton *)sender {
    NSLog(@"开始认证");
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
