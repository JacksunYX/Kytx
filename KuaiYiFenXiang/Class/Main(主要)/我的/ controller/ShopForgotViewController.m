//
//  ShopForgotViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShopForgotViewController.h"
#import "ShopForgot2ViewController.h"

@interface ShopForgotViewController ()

@property (nonatomic, strong) UITextField *tf2;

@end

@implementation ShopForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"核实身份";
    UITextField *tf2 = [[UITextField alloc] init];
    
    self.tf2 = tf2;
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.font = kFont(15);
    tf2.textColor = kColor666;
    tf2.placeholder = @"请输入实名认证的身份证号";
    UIView *left2 = [UIView new];
    left2.backgroundColor = kWhiteColor;
    left2.frame = CGRectMake(0, 0, 15, 44);
    tf2.leftView = left2;
    tf2.leftViewMode = UITextFieldViewModeAlways;
    tf2.backgroundColor = kWhiteColor;
    
    [self.view addSubview:tf2];
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.view).offset(10);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(16);
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tf2.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(ScaleWidth(280));
        make.height.mas_equalTo(50);
    }];
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *descLabel = [UILabel new];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:@"* 通过验证身份信息确保本人操作"];
    [attstr addAttribute:NSForegroundColorAttributeName value:kColord40 range:NSMakeRange(0, 1)];
    [attstr addAttribute:NSForegroundColorAttributeName value:kColor666 range:NSMakeRange(1, attstr.length-1)];
    [descLabel setAttributedText:attstr];
    descLabel.font = kFont(13);
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.tf2.mas_bottom).offset(10);
        make.right.equalTo(self.view);
    }];
}

- (void)next:(UIButton *)sender {
    ShopForgot2ViewController *vc = [ShopForgot2ViewController new];
    vc.idStr = self.tf2.text;
    [self.navigationController pushViewController:vc animated:YES];
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

