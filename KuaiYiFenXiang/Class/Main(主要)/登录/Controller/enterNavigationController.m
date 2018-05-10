//
//  enterNavigationController.m
//  CiDeHui
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "enterNavigationController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "AgreementViewController.h"
#import "AppDelegate.h"
#import "KYHeader.h"
#import "JPUSHService.h"
@interface enterNavigationController()<UITextFieldDelegate>



@end



@implementation enterNavigationController{
    
    YYFImgTextFiled  *usernametf;
    YYFImgTextFiled  *passwordtf;
    
    
    UIButton *agreementlableBtn;
    
    UIButton *agreementBtn;
    
    
    NSString *code_id;
    
    YYFButton *loginBtn;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(popviewconrtrollerClick) image:@"closeLoginBtn" hightimage:@"closeLoginBtn" andTitle:@""];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title=@"登 录";
    
    
    
    
    //设置视图UI
    [self setUI];
    
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setUI{
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    scrollView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    
    //设置登录页面的背景图片
    UIImageView *bgImg = [UIImageView new];
    bgImg.image = [UIImage imageNamed:@"login_bg"];
    bgImg.userInteractionEnabled = YES;
    [scrollView addSubview:bgImg];
    bgImg.sd_layout
    .topSpaceToView(scrollView, - NAVI_HEIGHT)
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .heightIs(280)
    ;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [bgImg addGestureRecognizer:singleTap];
    
    
    UIImageView *logoImageView=[[UIImageView alloc]init];
    [logoImageView setImage:[UIImage imageNamed:@"login_logo"]];
    [bgImg addSubview:logoImageView];
    logoImageView.sd_layout
    .centerXEqualToView(bgImg)
    .centerYEqualToView(bgImg)
    .widthIs(100)
    .heightIs(100);
    
    
    //设置账号输入框
    usernametf=[[YYFImgTextFiled  alloc]init];
    [usernametf addTarget:self action:@selector(textfilechange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:usernametf];
    usernametf.sd_layout
    .centerXEqualToView(scrollView)
    .topSpaceToView(bgImg,40)
    .widthIs(SCREEN_WIDTH - 100)
    .heightIs(40);
    [usernametf creattextfiled:@"login_zh" andlabletext:@"" andplaceholderstr:@"请输入账号"];
    
    //设置密码输入框
    passwordtf=[[YYFImgTextFiled  alloc]init];
    [passwordtf addTarget:self action:@selector(textfilechange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:passwordtf];
    passwordtf.sd_layout
    .centerXEqualToView(scrollView)
    .topSpaceToView(usernametf, 40)
    .widthIs(SCREEN_WIDTH-100)
    .heightIs(40);
    [passwordtf creattextfiled:@"login_mm" andlabletext:@"" andplaceholderstr:@"请输入密码"];
    
    //设置登录按钮
    loginBtn=[[YYFButton alloc]init];
    [loginBtn setBackgroundColor:[UIColor grayColor]];
    [loginBtn setUserInteractionEnabled:NO];
    loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [scrollView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginBtnDone) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.sd_layout
    .topSpaceToView(passwordtf, 50)
    .centerXEqualToView(scrollView)
    .heightIs(40)
    .widthIs(passwordtf.width);
    
    
    //设置忘记密码的按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"没有账户,去注册"];
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){5,[tncString length]-5}];
    [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]  range:NSMakeRange(0,[tncString length])];
    [registerBtn setAttributedTitle:tncString forState:UIControlStateNormal];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = PFR14Font;
    [registerBtn addTarget:self action:@selector(registerBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:registerBtn];
    registerBtn.sd_layout
    .topSpaceToView(loginBtn, 10)
    .leftEqualToView(loginBtn)
    .heightIs(20)
    .widthIs(200);
    
    
    //设置忘记密码的按钮
    UIButton *forgetPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPswBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetPswBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetPswBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    forgetPswBtn.titleLabel.font = PFR14Font;
    [forgetPswBtn addTarget:self action:@selector(forgetPswBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetPswBtn];
    forgetPswBtn.sd_layout
    .topSpaceToView(loginBtn, 10)
    .rightEqualToView(loginBtn)
    .heightIs(20)
    .widthIs(100);
    
    [scrollView setupAutoContentSizeWithBottomView:registerBtn bottomMargin:50];
    
    
    //    //添加用户协议标签
    //    agreementlableBtn=[[UIButton alloc]init];
    //    [agreementlableBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:@"我已阅读并同意《用户注册协议》"];
    //    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(7,attributedString.length-7)];
    //    [agreementlableBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    //    agreementlableBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    //    [agreementlableBtn addTarget:self action:@selector(agreementlableClick) forControlEvents:UIControlEventTouchUpInside];
    //    agreementlableBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    [self.view addSubview:agreementlableBtn];
    //    [agreementlableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view).offset(ScaleWidth(45));
    //        make.bottom.equalTo(self.view).offset(-25);
    //        make.height.mas_equalTo(30);
    ////        make.width.mas_equalTo(SCREEN_WIDTH - 100);
    //    }];
    //
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    //    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    NSMutableAttributedString* attributedString1 = [[NSMutableAttributedString alloc]initWithString:@"《风控协议》"];
    //    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(0,attributedString1.length)];
    //    [btn setAttributedTitle:attributedString1 forState:UIControlStateNormal];
    //    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    //    [btn addTarget:self action:@selector(agreementlableClick2) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btn];
    //    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(agreementlableBtn);
    //        make.left.equalTo(agreementlableBtn.mas_right);
    //    }];
    //
    
    
}



//倒计时按钮的代理方法 点击倒计时按钮处理相应的事件
- (void)btnClick:(WLCaptcheButton *)sender{
    
    NSLog(@"%@", sender.identifyKey);
    
    
    //判断输入框内容是否为空 提示用户输入相应的内容
    if (kStringIsEmpty(usernametf.text)) {
        
        LRToast(@"请输入您的手机号");
        
    }else{
        
        
        [sender fire];
        
        
    }
    
    
    
}

-(void)textfilechange:(UITextField *)textfiled{
    
    if (usernametf.text.length > 0 && passwordtf.text.length > 0) {
        
        [loginBtn setUserInteractionEnabled:YES];
        [loginBtn setBackgroundColor:NAVIGATIONBAR_COLOR];
        ;
        loginBtn.layer.borderColor=NAVIGATIONBAR_COLOR.CGColor;
        
    }else{
        
        [loginBtn setUserInteractionEnabled:NO];
        [loginBtn setBackgroundColor:[UIColor grayColor]];
        ;
        loginBtn.layer.borderColor=[UIColor grayColor].CGColor;
        
    }
    
}


//点击协议按钮取反当前的选中状态
-(void)agreementimgClick{
    
    agreementBtn.selected=!agreementBtn.isSelected;
    
}
//点击跳转到用户协议页面
-(void)agreementlableClick{
    
    AgreementViewController  *aVC=[[AgreementViewController alloc]init];
    [self.navigationController pushViewController:aVC animated:YES];
    
    
}

// 风控协议
- (void)agreementlableClick2 {
    KYWebViewController *vc= [KYWebViewController new];
    vc.name = @"风控协议";
    vc.web_url = riskcontrol_url;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击背景图片的方法 隐藏键盘
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    [self.view endEditing:YES];
    
}

//点击登录方法判断的当前用户是否输入账号密码
- (void)loginBtnDone{
    [self.view endEditing:YES];
    //如果用户没有输入账号密码就提示用户输入
    if (kStringIsEmpty(usernametf.text)||kStringIsEmpty
        (passwordtf.text)) {
        
        LRToast(@"请输入完整信息");
        
    }else{
        
        if (usernametf.text.isValidPhone) {
            
            // 设置请求参数可变数组
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setValue:usernametf.text forKey:@"username"];
            
            [dic setValue:passwordtf.text forKey:@"password"];
            if ([JPUSHService registrationID]) {
                dic[@"push_id"] = [JPUSHService registrationID];
            }
            
            [HttpRequest postWithURLString:NetRequestUrl(do_login) parameters:dic
                              isShowToastd:(BOOL)YES
                                 isShowHud:(BOOL)YES
                          isShowBlankPages:(BOOL)NO
                                   success:^(id responseObject)  {
                                       
                                       NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                       
                                       NSDictionary *userinformationdic=[responseObject objectForKey:@"result"];
                                       
                                       if (codeStr.intValue==1) {
                                           
                                           [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@",[userinformationdic objectForKey:@"token"]] forKey:@"token"];
                                           [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@",[userinformationdic objectForKey:@"user_id"]] forKey:@"user_id"];
                                           [USER_DEFAULT setObject:[NSString stringWithFormat:@"%@",[userinformationdic objectForKey:@"nickname"]] forKey:@"nickname"];
                                           AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                           delegate.isLogin = YES;
                                           [USER_DEFAULT synchronize];
                                           
                                           GCDAfter1s(^{
                                               //如果用户已经输入完全就跳转到主视图页面
                                               [self popviewconrtrollerClick];
                                           });
                                           
                                       }
                                       
                                   } failure:^(NSError *error) {
                                       //打印网络请求错误
                                       NSLog(@"%@",error);
                                       
                                   } RefreshAction:^{
                                       //执行无网络刷新回调方法
                                       
                                   }];
            
        }else{
            
            LRToast(@"请输入正确手机号");
            
        }
        
    }
    
    
}

//忘记密码点击方法
-(void)forgetPswBtnDone{
    
    ForgetPasswordViewController *forget=[[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forget  animated:YES];
    
    
}


-(void)popviewconrtrollerClick{
    
    [self.view endEditing:YES];
    if (self.normalBack) {
        if (self.backHandleBlock) {
            self.backHandleBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        YYFTabBarViewController *tab = [[YYFTabBarViewController alloc]init];
        tab.selectedIndex = 0;
        window.rootViewController= tab;
    }
    
    
    //    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[YYFNavigationController class]]) {
    //
    //        UIWindow *window=[UIApplication sharedApplication].keyWindow;
    //        YYFTabBarViewController *tab = [[YYFTabBarViewController alloc]init];
    //        tab.selectedIndex = 0;
    //        window.rootViewController= tab;
    //
    //    } else {
    //
    //        [self dismissViewControllerAnimated:YES completion:^{
    //
    //
    //        }];
    //
    //    }
    
}

//注册按钮点击方法
-(void)registerBtnDone{
    
    RegisterViewController *rVC=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:rVC  animated:YES];
    
}




@end
