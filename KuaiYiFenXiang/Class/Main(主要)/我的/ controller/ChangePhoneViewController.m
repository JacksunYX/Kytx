//
//  ChangePhoneViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "KYHeader.h"
#import "ModfiPhoneViewController.h"

@interface ChangePhoneViewController ()

@property (nonatomic, strong) UITextField *aview;


@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"核实身份";
    self.view.backgroundColor =kDefaultBGColor;
    
    UITextField *view = [[UITextField alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@44);
    }];
    view.placeholder = @"请输入验证码";
    view.font = kFont(15);
    self.aview = view;
    
    UIView *aview = [UIView new];
    aview.frame = CGRectMake(0, 0, 15, 40);
    aview.backgroundColor = kWhiteColor;
    view.leftView = aview;
    view.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *bview= [UIView new];
    bview.backgroundColor = [UIColor whiteColor];
    bview.frame = CGRectMake(0, 0, 105, 40);
    
    UIButton *ri = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ri setTitle:@"获取验证码" forState:UIControlStateNormal];
    [ri setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [ri addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    ri.titleLabel.font = kFont(13);
    [ri setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    ri.layer.cornerRadius = 3;
    ri.layer.masksToBounds = YES;
    
    [bview addSubview:ri];
    ri.frame = CGRectMake(0, 10, 90, 30);
//    [ri mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(view);
////        make.right.equalTo(view).offset(-15);
//        make.left.equalTo(bview);
//        make.size.mas_equalTo(CGSizeMake(90, 20));
//    }];
    
    view.rightView = bview;
    view.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *btn = [UIButton    buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"     确定     " forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(view.mas_bottom).offset(40);
        make.height.equalTo(@44);
        make.width.mas_equalTo(270);
    }];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getCode:(UIButton *)sender {
    [HttpRequest postWithTokenURLString:NetRequestUrl(sendValidate) parameters:[@{@"type" : @"6", @"send" : self.phone} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        UILabel *label = [UILabel new];
        label.text = [@"验证码已发送至当前绑定手机号" stringByAppendingString:self.phone];
        label.font = kFont(12);
        label.textColor = kColor666;
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.aview.mas_bottom).offset(10);
        }];
    } failure:nil RefreshAction:nil];
}

- (void)click:(UIButton *)sender {
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(changmobile) parameters:[@{@"type" : @"2", @"mobile" : self.phone, @"mobile_code" : self.aview.text} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            ModfiPhoneViewController *vc= [ModfiPhoneViewController new];
            vc.phone = self.phone;
            vc.code = self.aview.text;
            [self.navigationController pushViewController:vc animated:YES];            
        }
        
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
