//
//  PhoneVerificationViewController.m
//  NewProject
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AgreementViewController.h"

#import "UIButton+countDown.h"

#import "RegisterSecondViewController.h"

@interface ForgetPasswordViewController ()



@end

@implementation ForgetPasswordViewController{
    
    
    YYFImgTextFiled *tf1;
    YYFImgTextFiled *tf2;
    YYFImgTextFiled *tf3;
    
    
    NSString *code_id;
    
    UIView *popview;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"找回密码";
    
  
    
    tf1=[[YYFImgTextFiled alloc]init];
    tf2=[[YYFImgTextFiled alloc]init];
    tf3=[[YYFImgTextFiled alloc]init];
    tf3.secureTextEntry = YES;
    [self.view addSubview:tf1];
    [self.view addSubview:tf2];
    [self.view addSubview:tf3];
    
    //通过循环创建多个文本输入框
    for (int i=0; i<4; i++) {
        
        
        //这里用for循环来设置多个相同的控件 之前用switch会造成多个对象相同
        if (i==0) {
            
            tf1.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 25+40*i+i*30)
            .widthIs(SCREEN_WIDTH-56)
            .heightIs(40);
            [tf1 creattextfiled:@"reg_phone" andlabletext:@"" andplaceholderstr:@"请输入手机号码"];
            
            
        }else if (i==1)
        {
            tf2.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 25+40*i+i*30)
            .widthIs(SCREEN_WIDTH-56)
            .heightIs(40);
            [tf2 creattextfiled:@"reg_yzm" andlabletext:@"" andplaceholderstr:@"验证码"];
            
            
        }else if (i==2){
            
            tf3.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 25+40*i+i*30)
            .widthIs(SCREEN_WIDTH-56)
            .heightIs(40);
            [tf3 creattextfiled:@"login_mm" andlabletext:@"" andplaceholderstr:@"请输入6-20位的纯数字/字母/半角符号组合"];
            
        }else{
            
            
            
        }
        
        
        
    }
    
    
    //在相应的文本输入框添加倒计时按钮
    tf2.clearButtonMode = UITextFieldViewModeNever;
//    WLCaptcheButton *btn = [[WLCaptcheButton alloc]init];
//    btn.identifyKey = @"grayK";
//    [btn.overlayLabel setFont:PFR13Font];
//    btn.disabledBackgroundColor = [UIColor grayColor];
//    btn.disabledTitleColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = NAVIGATIONBAR_COLOR;
    
    btn.titleLabel.font = PFR13Font;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tf2 addSubview:btn];
    btn.sd_layout
    .centerYEqualToView(tf2)
    .rightSpaceToView(tf2, 10)
    .widthIs(100)
    .heightIs(tf2.height-10);
    
    [tf2 limitTextLength:6];
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    
    //设置确认按钮
    YYFButton *okBtn=[[YYFButton alloc]init];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    okBtn.sd_layout
    .topSpaceToView(tf3, 40)
    .centerXEqualToView(self.view)
    .widthIs(290)
    .heightIs(44);
    
    
  
    
    
}



//倒计时按钮的代理方法 点击倒计时按钮处理相应的事件
- (void)btnClick:(UIButton *)sender{
    
//    NSLog(@"%@", sender.identifyKey);
    
    //判断输入框内容是否为空 提示用户输入相应的内容
    if (kStringIsEmpty(tf1.text)) {
        
        LRToast(@"请输入您的手机号");
        
    }else{
        if (![NSString isValidPhone:tf1.text]) {
            LRToast(@"无效的手机号!");
            return;
        }
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setValue:tf1.text forKey:@"send"];
        
        [dic setValue:@"2" forKey:@"type"];
        
        [HttpRequest postWithURLString:NetRequestUrl(sendValidate) parameters:dic
                          isShowToastd:(BOOL)YES
                             isShowHud:(BOOL)YES
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
                                   
                                   if (codeStr.intValue==1) {
                                       
//                                       [sender fire];
                                       [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:NAVIGATIONBAR_COLOR countColor:[UIColor grayColor]];
                                       
                                   }
//                                   else{
//                                       NSString *msgStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
//                                       LRToast(msgStr);
//                                   }
                                   
                               } failure:^(NSError *error) {
                                   //打印网络请求错误
                                   NSLog(@"%@",error);
                                   
                               } RefreshAction:^{
                                   //执行无网络刷新回调方法
                                   
                               }];

        
    }
    
    
    
}

//确认按钮的点击方法
-(void)okBtnClick{
    
    
    
    //判断输入框内容是否为空 提示用户输入相应的内容
    if (kStringIsEmpty(tf1.text)||kStringIsEmpty(tf2.text)) {
        
        LRToast(@"请输入完整注册信息");
        
    }else{
        
        //判断输入密码是否符合要求
        if (tf3.text.checkPassWord) {
        
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setValue:tf1.text forKey:@"mobile"];
        
        [dic setValue:tf2.text forKey:@"mobile_code"];

        [dic setValue:tf3.text forKey:@"password"];
 
        [HttpRequest postWithURLString:NetRequestUrl(forGetPassword) parameters:dic
                          isShowToastd:(BOOL)NO
                             isShowHud:(BOOL)YES
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                   
                                   if (codeStr.intValue==1) {
                                       
                                       RegisterSuccessfulPopoversView *rspv=[[RegisterSuccessfulPopoversView alloc]init];
                                       [rspv drawView:@"密码修改成功!"];
                                       [self.view addSubview:rspv];
                                       rspv.alertViewDidCloseBlock = ^{
                                           [self.navigationController popViewControllerAnimated:YES];
                                       };
                                       
                                   }
                                   
                               } failure:^(NSError *error) {
                                   //打印网络请求错误
                                   NSLog(@"%@",error);
                                   
                               } RefreshAction:^{
                                   //执行无网络刷新回调方法
                                   
                               }];
            
        }else{
            LRToast(@"请输入6-20位的纯数字/字母/半角符号的组合");
        }
   
        
        
    }
    
    
    
}

-(void)loginBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

