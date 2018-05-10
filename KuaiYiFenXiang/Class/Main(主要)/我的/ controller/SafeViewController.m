//
//  SafeViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "SafeViewController.h"
#import "KYHeader.h"
#import "LoginChangeViewController.h"
#import "PayChangeViewController.h"
@interface SafeViewController ()

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"账户安全";
    
    UIButton *aview = [self viewWithLeft:@"登录密码设置" right:@"设置"];
    
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *bview= [self viewWithLeft:@"支付密码设置" right:@"设置"];
    
    [self.view addSubview:bview];
    [bview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(aview.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(aview);
        make.height.mas_equalTo(1);
    }];
    
    [aview addTarget:self action:@selector(loginpassword:) forControlEvents:UIControlEventTouchUpInside];
    [bview addTarget:self action:@selector(paypassword:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)viewWithLeft:(NSString *)left right:(NSString *)right {
    UIButton *aview = [UIButton buttonWithType:UIButtonTypeCustom];
//    [aview setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    aview.backgroundColor = kWhiteColor;
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"安全设置锁"]];
    [aview addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview);
        make.left.equalTo(aview).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *alabel = [UILabel new];
    
    alabel.font = kFont(15);
    alabel.textColor = kColor666;
    alabel.text = left;
    
    [aview addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(10);
        make.centerY.equalTo(imageview);
    }];
    
    UIImageView *rightimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头"]];
    [aview addSubview:rightimage];
    [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(aview);
        make.size.mas_equalTo(CGSizeMake(8.5, 13));
    }];
    
    UILabel *blabel = [UILabel new];
    blabel.font = kFont(15);
    blabel.textColor = kColor666;
    blabel.text = right;
    
    [aview addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightimage.mas_left).offset(-10);
        make.centerY.equalTo(imageview);
    }];
    
    
    return aview;
}

- (void)loginpassword:(UIButton *)sender {
    LoginChangeViewController *vc = [LoginChangeViewController new];
    vc.mobile = self.mobile;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)paypassword:(UIButton *)sender {
    [self Determineifthereisapaymentpassword];
}

//进行支付之前先判断用户是否设置了支付密码 如果没有设置跳转到设置页面
-(void)Determineifthereisapaymentpassword{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        PayChangeViewController *vc = [PayChangeViewController new];
        vc.mobile = self.mobile;
        if ([res[@"code"] integerValue] == 1) {
            
        } else {
            vc.showNotice = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:nil RefreshAction:nil];
    
    
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
