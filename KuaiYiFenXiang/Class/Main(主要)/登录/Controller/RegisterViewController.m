//
//  PhoneVerificationViewController.m
//  NewProject
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "RegisterViewController.h"
#import "AgreementViewController.h"

#import "RegisterSecondViewController.h"
#import "NSString+STRegex.h"

@interface RegisterViewController ()<UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) UITextField *tf1;

@end

@implementation RegisterViewController{
    

    YYFImgTextFiled *tf1;
    YYFImgTextFiled *tf2;
    
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
    
    self.navigationItem.title=@"注册";
    
    UIImageView *headimageview=[[UIImageView alloc]init];
    [headimageview setImage:[UIImage imageNamed:@"reg_title"]];
    [self.view addSubview:headimageview];
    headimageview.sd_layout
    .topSpaceToView(self.view, 40)
    .centerXEqualToView(self.view)
    .widthIs(SCREEN_WIDTH-120)
    .heightIs(26);
    
    tf1=[[YYFImgTextFiled alloc]init];
    self.tf1 = tf1;
    tf1.delegate= self;
    tf2=[[YYFImgTextFiled alloc]init];
    [self.view addSubview:tf1];
    [self.view addSubview:tf2];

    //通过循环创建多个文本输入框
    for (int i=0; i<4; i++) {
        
        
        //这里用for循环来设置多个相同的控件 之前用switch会造成多个对象相同
        if (i==0) {
            
            tf1.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(headimageview, 25+40*i+i*30)
            .widthIs(SCREEN_WIDTH-56)
            .heightIs(40);
            [tf1 creattextfiled:@"reg_phone" andlabletext:@"" andplaceholderstr:@"请输入手机号码"];
            


        }else if (i==1)
        {
            
            tf2.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(headimageview, 25+40*i+i*30)
            .widthIs(SCREEN_WIDTH-56)
            .heightIs(40);
            [tf2 creattextfiled:@"reg_phone" andlabletext:@"" andplaceholderstr:@"推荐人手机号码(可不填)"];
            
        }else{
            
            
            
        }
        
    
        
    }
    
    
//    //在相应的文本输入框添加倒计时按钮
//    tf2.clearButtonMode = UITextFieldViewModeNever;
//    WLCaptcheButton *btn = [[WLCaptcheButton alloc]init];
//    btn.identifyKey = @"grayK";
//    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn.backgroundColor = NAVIGATIONBAR_COLOR;
//    btn.disabledBackgroundColor = [UIColor grayColor];
//    btn.disabledTitleColor = [UIColor whiteColor];
//    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [tf2 addSubview:btn];
//    btn.sd_layout
//    .centerYEqualToView(tf2)
//    .rightSpaceToView(tf2, 10)
//    .widthIs(100)
//    .heightIs(tf2.height-10);

    
    
    //设置确认按钮
    YYFButton *okBtn=[[YYFButton alloc]init];
    [okBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    okBtn.sd_layout
    .topSpaceToView(tf2, 40)
    .centerXEqualToView(self.view)
    .widthIs(290)
    .heightIs(44);
    
    UILabel *noticeLabel = [UILabel new];
    noticeLabel.font = Font(12);
    noticeLabel.textColor = HexColor(999999);
    [self.view addSubview:noticeLabel];
    
    noticeLabel.sd_layout
    .topSpaceToView(okBtn, 10)
    .centerXEqualToView(self.view)
    .autoHeightRatio(0)
    ;
    [noticeLabel setSingleLineAutoResizeWithMaxWidth:ScreenW];
    noticeLabel.isAttributedContent = YES;
    NSString *noticeStr = @"完成注册，领取3元现金红包";
    NSMutableAttributedString *str = [NSString RichtextString:noticeStr andstartstrlocation:5 andendstrlocation:8 andchangcoclor:HexColor(d40000) andchangefont:Font(12)];
    noticeLabel.attributedText = str;
    
    //红包图标
    UIImageView *redPacketImg = [[UIImageView alloc]initWithImage:UIImageNamed(@"discount_RedPacket")];
    [redPacketImg sizeToFit];
    [self.view addSubview:redPacketImg];
    
    redPacketImg.sd_layout
    .centerYEqualToView(noticeLabel)
    .rightSpaceToView(noticeLabel, 10)
    .widthIs(11)
    .heightIs(15)
    ;
    
//    //添加用户协议标签
//    UIButton *customerserviceBtn=[[UIButton alloc]init];
//    [customerserviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:@"注册遇到问题?联系客服"];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(7,attributedString.length-7)];
//    [customerserviceBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
//    customerserviceBtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [customerserviceBtn addTarget:self action:@selector(customerserviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:customerserviceBtn];
//    customerserviceBtn.sd_layout
//    .topSpaceToView(okBtn, 10)
//    .centerXEqualToView(self.view)
//    .widthIs(SCREEN_WIDTH)
//    .heightIs(30);
    
    
//    [self setpopview];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == 11 && range.length == 0) {
        return NO;
    }
    return YES;
}

-(void)setpopview{
    
    popview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
    [popview setBackgroundColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.8]];
    [self.view addSubview:popview];
    
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [popview addSubview:_webView];
    _webView.sd_layout
    .bottomSpaceToView(popview, 44)
    .leftEqualToView(popview)
    .rightEqualToView(popview)
    .heightIs(SCREEN_HEIGHT/2);
    NSString *html = [NSString stringWithFormat:@"%@%@",DefaultDomainName,NetRequestUrl(useragreement)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
    
    
    UIButton *agreebutton=[[UIButton alloc]init];
    [agreebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreebutton.layer setMasksToBounds:YES];
    //        [self.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    //边框宽度
    [agreebutton.layer setBorderWidth:1.0];
    agreebutton.layer.borderColor=HexColor(d40000).CGColor;
    agreebutton.titleLabel.font=[UIFont systemFontOfSize:20];
    agreebutton.backgroundColor=  HexColor(d40000);//hwcolor(18, 36, 46);
    [agreebutton setTitle:@"同意" forState:UIControlStateNormal];
    [agreebutton addTarget:self action:@selector(agreebuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [popview addSubview:agreebutton];
    agreebutton.sd_layout
    .bottomEqualToView(popview)
    .leftEqualToView(popview)
    .widthIs(SCREEN_WIDTH/2)
    .heightIs(44);
    
    
    UIButton *unagreebutton=[[UIButton alloc]init];
    [unagreebutton setTitleColor:HexColor(999999) forState:UIControlStateNormal];
    [unagreebutton.layer setMasksToBounds:YES];
    //        [self.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    //边框宽度
    [unagreebutton.layer setBorderWidth:1.0];
    unagreebutton.layer.borderColor=HexColor(999999).CGColor;
    unagreebutton.titleLabel.font=[UIFont systemFontOfSize:20];
    unagreebutton.backgroundColor=  HexColor(ffffff);//hwcolor(18, 36, 46);
    [unagreebutton setTitle:@"不同意" forState:UIControlStateNormal];
    [unagreebutton addTarget:self action:@selector(unagreebuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [popview addSubview:unagreebutton];
    unagreebutton.sd_layout
    .bottomEqualToView(popview)
    .rightEqualToView(popview)
    .widthIs(SCREEN_WIDTH/2)
    .heightIs(44);
    
    
    UILabel *titlelabel=[[UILabel alloc]init];
    [titlelabel setFont:PFR18Font];
    [titlelabel setTextColor:HexColor(333333)];
    [titlelabel setText:@"用户注册协议"];
    [titlelabel setBackgroundColor:[UIColor whiteColor]];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    [popview addSubview:titlelabel];
    titlelabel.sd_layout
    .bottomSpaceToView(_webView, 1)
    .leftEqualToView(popview)
    .rightEqualToView(popview)
    .heightIs(44);
    
    
    [self setInfoViewFrame:YES];

}

//网页视图即将加载弹出loding
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    kShowHUDAndActivity;
    
    
}
//在网页视图完成加载后隐藏loding
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    kHiddenHUDAndAvtivity;
    
}

////倒计时按钮的代理方法 点击倒计时按钮处理相应的事件
//- (void)btnClick:(WLCaptcheButton *)sender{
//
//    NSLog(@"%@", sender.identifyKey);
//
//
//    //判断输入框内容是否为空 提示用户输入相应的内容
//    if (kStringIsEmpty(tf1.text)) {
//
//        LRToast(@"请输入您的手机号");
//
//    }else{
//
//        // 设置请求参数可变数组
//        NSMutableDictionary  *dic = [NSMutableDictionary new];
//
//        [dic setValue:tf1.text forKey:@"send"];
//
//        [dic setValue:@"1" forKey:@"type"];
//
//        [HttpRequest postWithURLString:NetRequestUrl(sendValidate) parameters:dic
//                               isShowToastd:(BOOL)YES
//                                  isShowHud:(BOOL)NO
//                           isShowBlankPages:(BOOL)NO
//                                    success:^(id responseObject)  {
//
//                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
//
//                                        if (codeStr.intValue==1) {
//
//                                            [sender fire];
//
//                                        }
//
//                                    } failure:^(NSError *error) {
//                                        //打印网络请求错误
//                                        NSLog(@"%@",error);
//
//                                    } RefreshAction:^{
//                                        //执行无网络刷新回调方法
//
//                                    }];
//
//    }
//
//
//
//}

//确认按钮的点击方法
-(void)okBtnClick{
    
    //判断输入框内容是否为空 提示用户输入相应的内容
    
    if (kStringIsEmpty(tf1.text)) {
        LRToast(@"请输入手机号");
        return;
    }else{
        
        if ([tf1.text isEqualToString:tf2.text]) {
            LRToast(@"推荐人手机号码不能与注册手机号相同")
            return;
        }
        
        if ([NSString isValidPhone:tf1.text])
        {
            //如果填了推荐人，需要再做一下检测
            if (!kStringIsEmpty(tf2.text)) {
                
                if (![NSString isValidPhone:tf2.text]) {
                    LRToast(@"推荐人手机号有误");
                    return;
                }
            }
            
            RegisterSecondViewController *rsvc=[[RegisterSecondViewController alloc]init];
            rsvc.userphonenumstring=tf1.text;
            rsvc.refereesstring=tf2.text;
            [self.navigationController pushViewController:rsvc animated:YES];
        
        }else{
                
            LRToast(@"请输入正确手机号");
                
        }
        
    }
    
}

-(void)loginBtnClick{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//点击跳转到用户协议页面
-(void)customerserviceBtnClick{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-998-9798"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}


-(void)agreebuttonClick
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setInfoViewFrame:NO];
}

-(void)unagreebuttonClick
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setInfoViewFrame:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setInfoViewFrame:(BOOL)isDown{
    if(isDown == NO)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [popview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
                                                  [popview setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
        
    }else
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [popview setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
                                                  [popview setFrame:CGRectMake(0, 0 ,SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
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
