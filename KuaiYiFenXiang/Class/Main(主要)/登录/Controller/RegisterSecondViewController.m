//
//  PhoneVerificationViewController.m
//  NewProject
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "RegisterSecondViewController.h"
#import "AgreementViewController.h"
#import "UITextField+Category.h" //设置长度限制
#import "UIButton+countDown.h"

#import "GetDiscountView.h" //注册红包弹框

@interface RegisterSecondViewController ()<UITextFieldDelegate>



@end

@implementation RegisterSecondViewController{
    
    YYFImgTextFiled *tf1;
    YYFImgTextFiled *tf2;
    YYFImgTextFiled *tf3;
    
    NSString *code_id;
    
    UIView *popview;
    
    UIButton *passwordvisibleBtn;
    
    UIButton *agreementlableBtn;
    
    UIButton *selectBtn;
    
    UIButton *backBtn;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"注册";
    
    //设置左边按钮
    backBtn = [UIButton new];
    [backBtn setImage:UIImageNamed(@"BACK") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"BACK" hightimage:@"BACK" andTitle:@""];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    scrollView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    
    UIImageView *headimageview=[[UIImageView alloc]init];
    [headimageview setImage:[UIImage imageNamed:@"reg_title2"]];
    [scrollView addSubview:headimageview];
    headimageview.sd_layout
    .topSpaceToView(scrollView, 40)
    .centerXEqualToView(scrollView)
    .widthIs(SCREEN_WIDTH - 120)
    .heightIs(26);
    
    tf1=[[YYFImgTextFiled alloc]init];
    tf1.delegate = self;
    [scrollView addSubview:tf1];
    tf1.sd_layout
    .centerXEqualToView(scrollView)
    .topSpaceToView(headimageview, 29)
    .widthIs(SCREEN_WIDTH - 56)
    .heightIs(40);
    [tf1 creattextfiled:@"login_mm" andlabletext:@"" andplaceholderstr:@"请设置登录密码"];
    
    
    passwordvisibleBtn = [[UIButton alloc] init];
    [passwordvisibleBtn setImage:[UIImage imageNamed:@"reg_mmkj01"] forState:UIControlStateNormal];
    [passwordvisibleBtn setImage:[UIImage imageNamed:@"reg_mmkj02"] forState:UIControlStateSelected];
    [passwordvisibleBtn setTitle:@"密码可见" forState:UIControlStateNormal];
    [passwordvisibleBtn setTitleColor:HexColor(999999) forState:UIControlStateNormal];
    passwordvisibleBtn.titleLabel.font=PFR12Font;
    [passwordvisibleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:15.0];
    [passwordvisibleBtn addTarget:self action:@selector(passwordvisibleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [passwordvisibleBtn setSelected:NO];
    [scrollView addSubview:passwordvisibleBtn];
    passwordvisibleBtn.sd_layout
    .leftSpaceToView(tf1, -tf1.width-5)
    .topSpaceToView(tf1, 16)
    .widthIs(80)
    .heightIs(10);
    
    
    
    UILabel *tishiLabel=[[UILabel alloc]init];
    [tishiLabel setTextColor:HexColor(999999)];
    [tishiLabel setFont:PFR12Font];
    [tishiLabel setTextAlignment:NSTextAlignmentLeft];
    NSString *contentStr = @"*    请输入6-20位纯数字/字母/半角符号组合";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    tishiLabel.attributedText = str;
    [scrollView addSubview:tishiLabel];
    tishiLabel.sd_layout
    .topSpaceToView(passwordvisibleBtn, 15)
    .leftEqualToView(tf1)
    .autoHeightRatio(0);
    [tishiLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    
    tf2=[[YYFImgTextFiled alloc]init];
    tf2.delegate = self;
    [scrollView addSubview:tf2];
    tf2.sd_layout
    .centerXEqualToView(scrollView)
    .topSpaceToView(tishiLabel, 29)
    .widthIs(SCREEN_WIDTH-56)
    .heightIs(40);
    [tf2 creattextfiled:@"login_mm" andlabletext:@"" andplaceholderstr:@"再次确认密码"];
    
    tf3=[[YYFImgTextFiled alloc]init];
    tf3.delegate = self;
    [scrollView addSubview:tf3];
    tf3.sd_layout
    .centerXEqualToView(scrollView)
    .topSpaceToView(tf2, 29)
    .widthIs(SCREEN_WIDTH-56)
    .heightIs(40);
    [tf3 creattextfiled:@"reg_yzm" andlabletext:@"" andplaceholderstr:@"输入短信验证码"];
    
    //在相应的文本输入框添加倒计时按钮
    tf3.clearButtonMode = UITextFieldViewModeNever;
    //    WLCaptcheButton *btn = [[WLCaptcheButton alloc]init];
    //    btn.identifyKey = @"grayK";
    //    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = NAVIGATIONBAR_COLOR;
    
    btn.titleLabel.font = PFR13Font;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tf3 addSubview:btn];
    btn.sd_layout
    .centerYEqualToView(tf3)
    .rightSpaceToView(tf3, 0)
    .widthIs(100)
    .heightIs(tf3.height-10);
    //长度限制和键盘
    [tf3 limitTextLength:6];
    tf3.keyboardType = UIKeyboardTypeNumberPad;
    
    //设置确认按钮
    YYFButton *okBtn=[[YYFButton alloc]init];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [scrollView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    okBtn.sd_layout
    .topSpaceToView(tf3, 40)
    .centerXEqualToView(scrollView)
    .widthIs(290)
    .heightIs(44);
    
    
    //添加用户协议标签
    agreementlableBtn=[[UIButton alloc]init];
    [agreementlableBtn setTitleColor:HexColor(999999) forState:UIControlStateNormal];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:@"我已阅读并同意《用户注册协议》"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:HexColor(999999) range:NSMakeRange(7,attributedString.length-7)];
    [agreementlableBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    agreementlableBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [agreementlableBtn addTarget:self action:@selector(agreementlableClick) forControlEvents:UIControlEventTouchUpInside];
    agreementlableBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:agreementlableBtn];
    [agreementlableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(ScaleWidth(45));
        make.top.equalTo(okBtn).offset(50);
        make.height.mas_equalTo(30);
        //        make.width.mas_equalTo(SCREEN_WIDTH - 100);
    }];
    
    UIButton *newbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString* attributedString1 = [[NSMutableAttributedString alloc]initWithString:@"《风控协议》"];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:HexColor(999999) range:NSMakeRange(0,attributedString1.length)];
    [newbtn setAttributedTitle:attributedString1 forState:UIControlStateNormal];
    newbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [newbtn addTarget:self action:@selector(agreementlableClick2) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:newbtn];
    [newbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreementlableBtn);
        make.left.equalTo(agreementlableBtn.mas_right);
    }];
    
    
    selectBtn=[[UIButton alloc]init];
    [selectBtn setImage:[UIImage imageNamed:@"reg_mmkj01"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"reg_mmkj02"] forState:UIControlStateSelected];
    [selectBtn setSelected:YES];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectBtn];
    selectBtn.sd_layout
    .centerYEqualToView(agreementlableBtn)
    .rightSpaceToView(agreementlableBtn, 10)
    .widthIs(20)
    .heightIs(20);
    
    
    //添加用户协议标签
    UIButton *customerserviceBtn=[[UIButton alloc]init];
    [customerserviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString* attributedString2 = [[NSMutableAttributedString alloc]initWithString:@"注册遇到问题?联系客服"];
    [attributedString2 addAttribute:NSUnderlineStyleAttributeName
                              value:@(NSUnderlineStyleSingle)
                              range:(NSRange){7,[attributedString2 length]-7}];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(7,attributedString2.length-7)];
    [customerserviceBtn setAttributedTitle:attributedString2 forState:UIControlStateNormal];
    customerserviceBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [customerserviceBtn addTarget:self action:@selector(customerserviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:customerserviceBtn];
    customerserviceBtn.sd_layout
    .topSpaceToView(agreementlableBtn, 10)
    .centerXEqualToView(scrollView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(30);
    
    [scrollView setupAutoContentSizeWithBottomView:customerserviceBtn bottomMargin:50];
    
    self.fd_interactivePopDisabled = YES;
    
}

//弹出红包领取框
-(void)showGetDiscountViewWithUser_id:(NSString *)user_id
{
    GetDiscountView *discountView = [GetDiscountView new];
    [self.view addSubview:discountView];
    backBtn.enabled = NO;
    MCWeakSelf;
    discountView.getDiscountBlock = ^{
        [weakSelf getDiscountWithUserId:user_id];
    };
    
    discountView.closeBlock = ^{
        LRToast(@"您可以到消息中的优惠活动查看后重新领取~");
        GCDAfter1s(^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    };
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.isSelected;
    
    
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

//倒计时按钮的代理方法 点击倒计时按钮处理相应的事件
- (void)btnClick:(UIButton *)sender{
    
    //    NSLog(@"%@", sender.identifyKey);
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:self.userphonenumstring forKey:@"send"];
    
    [dic setValue:@"1" forKey:@"type"];
    
    [HttpRequest postWithURLString:NetRequestUrl(sendValidate) parameters:dic
                      isShowToastd:(BOOL)YES
                         isShowHud:(BOOL)YES
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               
                               if (codeStr.intValue==1) {
                                   
                                   //                                        [sender fire];
                                   [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:NAVIGATIONBAR_COLOR countColor:[UIColor grayColor]];
                                   
                               }
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tf3) {
        return [self validateNumber:string];
    }
    if (range.location == 20 && range.length == 0) {
        return NO;
    }
    return YES;
}

-(void)passwordvisibleBtn:(UIButton *)agbtn{
    
    agbtn.selected=!agbtn.selected;
    
    tf1.secureTextEntry = !agbtn.selected;
    
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


//确认按钮的点击方法
-(void)okBtnClick{
    
    if (tf1.text.length < 6||tf1.text.length > 20) {
        LRToast(@"密码应在6-20位之间");
        
        return;
    }
    
    if (tf1.text.checkPassWord&&tf2.text.checkPassWord) {
        
        //判断输入框内容是否为空 提示用户输入相应的内容
        if (kStringIsEmpty(tf1.text)||kStringIsEmpty(tf2.text)||kStringIsEmpty(tf3.text)){
            
            LRToast(@"请输入完整注册信息");
            
        }else{
            
            if ([tf1.text isEqualToString:tf2.text]) {
                
                if (selectBtn.isSelected==YES) {
                    
                    // 设置请求参数可变数组
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    
                    [dic setValue:self.userphonenumstring forKey:@"username"];
                    
                    [dic setValue:tf3.text forKey:@"mobile_code"];
                    
                    [dic setValue:self.refereesstring forKey:@"parent"];
                    
                    [dic setValue:tf1.text  forKey:@"password"];
                    
                    [HttpRequest postWithURLString:NetRequestUrl(reg) parameters:dic
                                      isShowToastd:(BOOL)YES
                                         isShowHud:(BOOL)YES
                                  isShowBlankPages:(BOOL)NO
                                           success:^(id responseObject)  {
                                               
                                               NSString *codeStr = responseObject[@"code"];
                                               
                                               if (codeStr.intValue == 1) {
                                                   NSString *user_id = responseObject[@"result"][@"user_id"];
                                                   GCDAfter1s(^{
                                                       [self showGetDiscountViewWithUser_id:user_id];
                                                   });
                                                   
                                                   //                                                   RegisterSuccessfulPopoversView *rspv=[[RegisterSuccessfulPopoversView alloc]init];
                                                   //                                                   [rspv drawView:@"恭喜您,注册成功!"];
                                                   //                                                   [self.view addSubview:rspv];
                                                   //                                                   rspv.alertViewDidCloseBlock = ^{
                                                   //                                               //如果用户已经输入完全就跳转到主视图页面
                                                   //                                               UIWindow *window=[UIApplication sharedApplication].keyWindow;
                                                   //                                               window.rootViewController=[[YYFTabBarViewController alloc]init];
                                                   
                                                   //                                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                                   //
                                                   //                                                   };
                                                   
                                               }
                                               
                                           } failure:^(NSError *error) {
                                               //打印网络请求错误
                                               NSLog(@"%@",error);
                                               
                                           } RefreshAction:^{
                                               //执行无网络刷新回调方法
                                               
                                           }];
                    
                }else{
                    LRToast(@"请仔细阅读并且同意用户协议");
                }
                
            }else{
                
                LRToast(@"请输入相同登录密码");
                
            }
            
        }
    }else{
        LRToast(@"请输入6-20位纯数字/字母/半角符号组合");
        return;
    }
    
    
    
}

-(void)getDiscountWithUserId:(NSString *)user_id
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"user_id"] = user_id;
    [HttpRequest postWithURLString:NetRequestUrl(favourable) parameters:dic isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            GCDAfter1s(^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
}

//点击跳转到用户协议页面
-(void)customerserviceBtnClick{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-998-9798"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
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
