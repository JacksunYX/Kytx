//
//  PayChangeViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "PayChangeViewController.h"
#import "KYHeader.h"
#import "SecurityViewController.h"
#import "UIButton+countDown.h"

@interface PayChangeViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UIButton *ri;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PayChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付密码设置";
    self.view.backgroundColor = kDefaultBGColor;
    [self configUI];
    self.time = 60;
    
    if (self.showNotice) {
        LRToast(@"您还未设置过支付密码，请先设置支付密码");
    }
}

- (void)configUI {
    UITextField *tf1 = [[UITextField alloc] init];
    
    self.tf1 = tf1;
    tf1.font = kFont(15);
    tf1.textColor = kColor666;
    tf1.placeholder = @"请输入手机号码";
    if (self.mobile) {
        tf1.text = self.mobile;
        self.tf1.enabled = NO;
    }
    UIView *left1 = [UIView new];
    left1.backgroundColor = kWhiteColor;
    left1.frame = CGRectMake(0, 0, 15, 44);
    tf1.leftView = left1;
    tf1.leftViewMode = UITextFieldViewModeAlways;
    tf1.backgroundColor = kWhiteColor;
    tf1.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:tf1];
    [tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.view).offset(10);
    }];
    
    UITextField *tf2 = [[UITextField alloc] init];
    
    self.tf2 = tf2;
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.font = kFont(15);
    tf2.textColor = kColor666;
    tf2.placeholder = @"验证码";
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
        make.top.equalTo(tf1.mas_bottom);
    }];
    
    UIView *rightview= [UIView new];
    rightview.backgroundColor = [UIColor whiteColor];
    rightview.frame = CGRectMake(0, 0, 105, 50);
    
    UIButton *ri = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ri setTitle:@"获取验证码" forState:UIControlStateNormal];
    [ri setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [ri addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    ri.titleLabel.font = kFont(15);
//    [ri setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    ri.backgroundColor = NAVIGATIONBAR_COLOR;
    ri.layer.cornerRadius = 3;
    ri.layer.masksToBounds = YES;
    
    [rightview addSubview:ri];
    ri.frame = CGRectMake(0, 10, 100, 30);
    self.ri = ri;
    
    self.tf2.rightView = rightview;
    self.tf2.rightViewMode = UITextFieldViewModeAlways;
    
    UITextField *tf3 = [[UITextField alloc] init];
    
    self.tf3 = tf3;
    tf3.font = kFont(15);
    tf3.keyboardType = UIKeyboardTypeDefault;
    tf3.textColor = kColor666;
    tf3.placeholder = @"请输入支付密码";
    UIView *left3 = [UIView new];
    left3.backgroundColor = kWhiteColor;
    left3.frame = CGRectMake(0, 0, 15, 44);
    tf3.leftView = left3;
    tf3.leftViewMode = UITextFieldViewModeAlways;
    tf3.backgroundColor = kWhiteColor;
    tf3.secureTextEntry = YES;
    
    [self.view addSubview:tf3];
    [tf3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.top.equalTo(tf2.mas_bottom);
    }];
    
    UITextField *tf4 = [[UITextField alloc] init];
    
    self.tf4 = tf4;
    tf4.secureTextEntry = YES;
    tf4.font = kFont(15);
    tf4.textColor = kColor666;
    tf4.placeholder = @"请再次输入支付密码";
    UIView *left4 = [UIView new];
    left4.backgroundColor = kWhiteColor;
    left4.frame = CGRectMake(0, 0, 15, 44);
    tf4.leftView = left4;
    tf4.leftViewMode = UITextFieldViewModeAlways;
    tf4.backgroundColor = kWhiteColor;
    tf4.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:tf4];
    [tf4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.tf3.mas_bottom);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(tf1);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(tf2);
    }];
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(tf3);
    }];
    
    UILabel *descLabel = [UILabel new];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:@"* 请输入6-20位纯数字/字母/半角符号组合"];
    [attstr addAttribute:NSForegroundColorAttributeName value:kColord40 range:NSMakeRange(0, 1)];
    [attstr addAttribute:NSForegroundColorAttributeName value:kColor666 range:NSMakeRange(1, attstr.length-1)];
    descLabel.font = kFont(13);
    [descLabel setAttributedText:attstr];
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(tf4.mas_bottom).offset(10);
        make.right.equalTo(self.view);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(16);
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(ScaleWidth(280));
        make.height.mas_equalTo(50);
    }];
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)next:(UIButton *)sender {
    
    if (self.tf2.text.length <= 0) {
        LRToast(@"请输入验证码");
        return;
    }
    
    if (self.tf3.text.length < 6 || self.tf4.text.length > 20) {
        LRToast(@"密码应为6-20位纯数字/字母/半角符号组合")
        return;
    }
    
    if (![self.tf3.text isEqualToString:self.tf4.text]) {
        LRToast(@"两次输入的密码不同，请重新输入");
        return;
    }
    
    //判断输入密码是否符合要求
    if (self.tf3.text.checkPassWord) {
    
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"mobile"] = self.tf1.text;
        dict[@"password2"] = self.tf4.text;
        dict[@"mobile_code"] = self.tf2.text;
        dict[@"type"] = @"2";
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(changepwd) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                
                GCDAfter1s(^{
                    for (UIViewController *vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[SecurityViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                            return ;
                        }
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }
        } failure:nil RefreshAction:nil];
        
    }else{
        LRToast(@"请输入6-20位的纯数字/字母/半角符号的组合");
    }
}

- (void)getCode:(UIButton *)sender {
    
    [HttpRequest postWithURLString:NetRequestUrl(sendValidate) parameters:[@{@"type" : @"5", @"send" : self.tf1.text} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        //        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
//            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//            self.timer = timer;
//            [self.ri setBackgroundImage:[KYHeader imageWithColor:kColor666] forState:UIControlStateNormal];
//            self.ri.userInteractionEnabled = NO;
//            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//            [timer fire];
            [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:NAVIGATIONBAR_COLOR countColor:[UIColor grayColor]];
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


//判断是否输入的是纯数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
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
