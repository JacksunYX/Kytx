//
//  UserPay3ViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "UserPay3ViewController.h"
#import "KYHeader.h"
#import "SecurityViewController.h"

@interface UserPay3ViewController ()

@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UIButton *ri;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation UserPay3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"核实身份";
    self.time = 60;
    UITextField *tf2 = [[UITextField alloc] init];
    
    self.tf2 = tf2;
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.font = kFont(15);
    tf2.textColor = kColor666;
    tf2.placeholder = @"请输入验证码";
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
    
    UIView *rightview= [UIView new];
    rightview.backgroundColor = [UIColor whiteColor];
    rightview.frame = CGRectMake(0, 0, 105, 50);
    
    UIButton *ri = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ri setTitle:@"获取验证码" forState:UIControlStateNormal];
    [ri setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [ri addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    ri.titleLabel.font = kFont(15);
    [ri setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    ri.layer.cornerRadius = 3;
    ri.layer.masksToBounds = YES;
    
    [rightview addSubview:ri];
    ri.frame = CGRectMake(0, 10, 100, 30);
    self.ri = ri;
    
    self.tf2.rightView = rightview;
    self.tf2.rightViewMode = UITextFieldViewModeAlways;
    [tf2 becomeFirstResponder];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
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
}

- (void)next:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = self.mobile;
    dict[@"password"] = self.pwd;
    dict[@"password2"] = self.confirm;
    dict[@"mobile_code"] = self.tf2.text;
    dict[@"type"] = @"2";
    [HttpRequest postWithTokenURLString:NetRequestUrl(changepwd) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[SecurityViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    } failure:nil RefreshAction:nil];
}

- (void)getCode:(UIButton *)sender {
    
    [HttpRequest postWithURLString:NetRequestUrl(sendValidate) parameters:[@{@"type" : @"4", @"send" : self.mobile} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        //        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            self.timer = timer;
            [self.ri setBackgroundImage:[KYHeader imageWithColor:kColor666] forState:UIControlStateNormal];
            self.ri.userInteractionEnabled = NO;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [timer fire];
            
            UILabel *descLabel = [UILabel new];
            NSString *temp = [self.mobile substringWithRange: NSMakeRange(3, 4)];
            temp = [self.mobile stringByReplacingOccurrencesOfString:temp withString:@"****"];
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:[@"* 验证码已发送至当前绑定手机号" stringByAppendingString:temp]];
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
    } failure:nil RefreshAction:nil];
}

- (void)timerAction {
    self.time--;
    
    [self.ri setTitle:[NSString stringWithFormat:@"重新发送(%@)", @(self.time).description] forState:UIControlStateNormal];
    if (self.time == 0) {
        self.time = 60;
        [self.timer invalidate];
        self.timer = nil;
        [self.ri setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
        [self.ri setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.ri.userInteractionEnabled = YES;
    }
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
