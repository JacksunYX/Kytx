//
//  ShareRegistViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShareRegistViewController.h"
#import "AgreementViewController.h"

@interface ShareRegistViewController ()
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *picker;

@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;

@property (nonatomic, strong) UIButton *ri;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) UIButton *submitbtn;
@end

@implementation ShareRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"快益分享商城邀请好友注册";
    self.view.backgroundColor = kDefaultBGColor;
    self.time = 60;
    [self configNavi];
    NSString *str = IPHONE_X ? @"分享注册X" : @"分享注册";
    UIImage *aimage = [UIImage imageNamed:str];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:aimage];
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *imageview1 = [KYHeader generateQRCodeWithArray:@[@"download", @"http://www.baidu.com"]];
    
    [self.view addSubview:imageview1];
    [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.left.equalTo(self.view).offset(ScaleWidth(28));
        make.top.equalTo(self.view).offset(NAVI_HEIGHT + ScaleHeight(44));
    }];
    
    UILabel *label1 = [UILabel new];
    
    label1.text = @"iOS下载";
    label1.textColor = kWhiteColor;
    label1.font = kFont(12);
    
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview1);
        make.top.equalTo(imageview1.mas_bottom).offset(8);
    }];
    
    UIImageView *imageview2 = [KYHeader generateQRCodeWithArray:@[@"download", @"http://www.baidu.com"]];
    
    [self.view addSubview:imageview2];
    [imageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.right.equalTo(self.view).offset(ScaleWidth(-28));
        make.top.equalTo(self.view).offset(NAVI_HEIGHT + ScaleHeight(44));
    }];
    
    UILabel *label2 = [UILabel new];
    
    label2.text = @"安卓下载";
    label2.textColor = kWhiteColor;
    label2.font = kFont(12);
    
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview2);
        make.top.equalTo(imageview1.mas_bottom).offset(8);
    }];
    
    UILabel *label3 = [UILabel new];
    
    label3.text = [self.user_name stringByAppendingString:@"为您推荐【快益分享商城】移动商城"];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = kColor666;
    label3.font = kFont(17);
    label3.numberOfLines = 2;
    
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        if (IPHONE_X) {
            make.top.equalTo(self.view).offset(320);
        }else {
            make.top.equalTo(self.view).offset(ScaleHeight(265));
        }
    }];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"手机号"]];
    
    [self.view addSubview:imageview3];
    [imageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.top.equalTo(label3.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];
    
    _tf1 = [[UITextField alloc] init];
    
    _tf1.placeholder = @"请输入手机号码";
    _tf1.keyboardType = UIKeyboardTypePhonePad;
    _tf1.textColor = kColor666;
    
    [self.view addSubview:_tf1];
    [_tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview3.mas_right).offset(10);
        make.centerY.equalTo(imageview3);
        make.height.mas_equalTo(imageview3);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIView *line1 = [UIView new];
    
    line1.backgroundColor = [UIColor colorWithHexString:@"666666"];
    
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tf1);
        make.left.equalTo(imageview3);
        make.height.mas_equalTo(1);
        make.top.equalTo(_tf1.mas_bottom).offset(10);
    }];
    
    UIImageView *imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"验证码"]];
    
    [self.view addSubview:imageview4];
    [imageview4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.top.equalTo(line1.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];
    
    _tf2 = [[UITextField alloc] init];
    
    _tf2.placeholder = @"验证码";
    _tf2.keyboardType = UIKeyboardTypeNumberPad;
    _tf2.textColor = kColor666;
    
    [self.view addSubview:_tf2];
    [_tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview4.mas_right).offset(10);
        make.centerY.equalTo(imageview4);
        make.height.mas_equalTo(imageview4);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIButton *ri = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ri setTitle:@" 获取验证码 " forState:UIControlStateNormal];
    [ri setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [ri addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    ri.titleLabel.font = kFont(13);
    [ri setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    ri.layer.cornerRadius = 3;
    ri.layer.masksToBounds = YES;
    [_tf2 addSubview:ri];
    [ri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tf2);
        make.right.equalTo(_tf2);
        make.height.mas_equalTo(30);
    }];
    self.ri = ri;
    
    
    UIView *line2 = [UIView new];
    
    line2.backgroundColor = [UIColor colorWithHexString:@"666666"];
    
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tf2);
        make.left.equalTo(imageview4);
        make.height.mas_equalTo(1);
        make.top.equalTo(_tf2.mas_bottom).offset(10);
    }];
    
    UIImageView *imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"手机号"]];
    
    [self.view addSubview:imageview5];
    [imageview5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.top.equalTo(line2.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];
    
    _tf3 = [[UITextField alloc] init];
    
    _tf3.userInteractionEnabled = NO;
    _tf3.text = self.mobile;
    _tf3.keyboardType = UIKeyboardTypePhonePad;
    _tf3.textColor = kColor666;
    
    [self.view addSubview:_tf3];
    [_tf3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview5.mas_right).offset(10);
        make.centerY.equalTo(imageview5);
        make.height.mas_equalTo(imageview5);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIView *line3 = [UIView new];
    
    line3.backgroundColor = [UIColor colorWithHexString:@"666666"];
    
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tf3);
        make.height.mas_equalTo(1);
        make.left.equalTo(imageview5);
        make.top.equalTo(_tf3.mas_bottom).offset(10);
    }];
    
    UIImageView *imageview6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码"]];
    
    [self.view addSubview:imageview6];
    [imageview6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.top.equalTo(line3.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(30);
    }];
    
    _tf4 = [[UITextField alloc] init];
    
    _tf4.placeholder = @"请输入密码";
    _tf4.keyboardType = UIKeyboardTypeDefault;
    _tf4.textColor = kColor666;
    
    [self.view addSubview:_tf4];
    [_tf4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview6.mas_right).offset(10);
        make.centerY.equalTo(imageview6);
        make.height.mas_equalTo(imageview6);
        make.right.equalTo(self.view).offset(-30);
    }];
    
    UIView *line4 = [UIView new];
    
    line4.backgroundColor = [UIColor colorWithHexString:@"666666"];
    
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tf4);
        make.left.equalTo(imageview6);
        make.height.mas_equalTo(1);
        make.top.equalTo(_tf4.mas_bottom).offset(10);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.selected = YES;
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(line4.mas_bottom).offset(15);
    }];
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *simageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中"]];
    [btn1 addSubview:simageview];
    [simageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.left.equalTo(btn1);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UILabel *desclabel = [UILabel new];
    
    desclabel.text = @"登录代表已阅读并同意";
    desclabel.textColor = kColor666;
    desclabel.font = kFont(12);
    
    [btn1 addSubview:desclabel];
    [desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(simageview.mas_right).offset(18);
        make.centerY.equalTo(simageview);
        make.right.equalTo(btn1);
    }];
    
    
    UIButton *agreementlableBtn=[[UIButton alloc]init];
    [agreementlableBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:@"《用户注册协议》"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(0,attributedString.length)];
    [agreementlableBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    agreementlableBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [agreementlableBtn addTarget:self action:@selector(agreementlableClick) forControlEvents:UIControlEventTouchUpInside];
    agreementlableBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:agreementlableBtn];
    [agreementlableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desclabel.mas_right);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(btn1);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString* attributedString1 = [[NSMutableAttributedString alloc]initWithString:@"《风控协议》"];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:NSMakeRange(0,attributedString1.length)];
    [btn setAttributedTitle:attributedString1 forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(agreementlableClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreementlableBtn);
        make.left.equalTo(agreementlableBtn.mas_right);
    }];
    
    _submitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_submitbtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_submitbtn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [_submitbtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _submitbtn.layer.cornerRadius = 5;
    _submitbtn.layer.masksToBounds = YES;
    _submitbtn.titleLabel.font = kFont(17);
    [_submitbtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitbtn];
    [_submitbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(290);
        make.height.mas_equalTo(44);
        make.top.equalTo(btn1.mas_bottom).offset(25);
    }];
}

- (void)submit:(UIButton *)sender {
    UIImage *image = [sender backgroundImageForState:UIControlStateNormal];
    if ([image isEqual:[KYHeader imageWithColor:kColord40]]) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setValue:self.tf1.text forKey:@"username"];
        
        [dic setValue:self.tf2.text forKey:@"mobile_code"];
        
        [dic setValue:self.tf3.text forKey:@"parent"];
        
        [dic setValue:self.tf4.text  forKey:@"password"];
        
        [HttpRequest postWithURLString:NetRequestUrl(reg) parameters:dic
                          isShowToastd:(BOOL)NO
                             isShowHud:(BOOL)YES
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                   
                                   if (codeStr.intValue==1) {
                                       
                                       RegisterSuccessfulPopoversView *rspv=[[RegisterSuccessfulPopoversView alloc]init];
                                       [rspv drawView:@"恭喜您,注册成功!"];
                                       [self.view addSubview:rspv];
                                       rspv.alertViewDidCloseBlock = ^{
                                           //如果用户已经输入完全就跳转到主视图页面
                                           UIWindow *window=[UIApplication sharedApplication].keyWindow;
                                           window.rootViewController=[[YYFTabBarViewController alloc]init];
                                       };
                                       
                                   }
                                   
                               } failure:^(NSError *error) {
                                   //打印网络请求错误
                                   NSLog(@"%@",error);
                                   
                               } RefreshAction:^{
                                   //执行无网络刷新回调方法
                                   
                               }];
        
    }else{
        LRToast(@"请先阅读并同意用户注册协议与风控协议!");
    }
}

- (void)click:(UIButton *)sender {
    UIImageView *imageview;
    for (UIView *sub in sender.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            imageview = sub;
        }
    }
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        imageview.image = [UIImage imageNamed:@"选中"];
        [self.submitbtn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
        [self.submitbtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    } else {
        imageview.image = [UIImage imageNamed:@"未选中"];
        [self.submitbtn setBackgroundImage:[KYHeader imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [self.submitbtn setTitleColor:kColor333 forState:UIControlStateNormal];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(sharetap:)];
    self.navigationItem.rightBarButtonItem = item2;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sharetap:(UIBarButtonItem *)sender {
    [self show:nil];
}

- (void)show:(UIButton *)sender {
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cover addGestureRecognizer:tap];
    
    self.picker = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 156)];
    
    self.picker.backgroundColor = kWhiteColor;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.tag = 10001;
    [btn1 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.picker);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈"]];
    
    [btn1 addSubview:imageview1];
    [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(btn1).offset(35);
        make.centerX.equalTo(btn1);
    }];
    
    UILabel *label1 = [UILabel new];
    
    label1.textColor = kColor333;
    label1.text =@"朋友圈";
    label1.font = kFont(12);
    
    [btn1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview1);
        make.top.mas_equalTo(imageview1.mas_bottom).offset(6);
    }];
    
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2.tag = 10002;
    [btn2 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1);
        make.left.equalTo(btn1.mas_right);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"微信"]];
    
    [btn2 addSubview:imageview2];
    [imageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(btn2).offset(35);
        make.centerX.equalTo(btn2);
    }];
    
    UILabel *label2 = [UILabel new];
    
    label2.textColor = kColor333;
    label2.text =@"微信好友";
    label2.font = kFont(12);
    
    [btn2 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview2);
        make.top.mas_equalTo(imageview2.mas_bottom).offset(6);
    }];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn3.tag = 10003;
    [btn3 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2);
        make.left.equalTo(btn2.mas_right);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QQ"]];
    
    [btn3 addSubview:imageview3];
    [imageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(btn3).offset(35);
        make.centerX.equalTo(btn3);
    }];
    
    UILabel *label3 = [UILabel new];
    
    label3.textColor = kColor333;
    label3.text =@"QQ好友";
    label3.font = kFont(12);
    
    [btn3 addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview3);
        make.top.mas_equalTo(imageview3.mas_bottom).offset(6);
    }];
    
    UIView *line = [UIView new];
    
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self.picker addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.picker);
        make.height.mas_equalTo(1);
        make.top.equalTo(btn1.mas_bottom);
    }];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"取消" forState:UIControlStateNormal];
    btn4.titleLabel.font = kFont(15);
    [btn4 setTitleColor:kColor333 forState:UIControlStateNormal];
    [self.picker addSubview:btn4];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.picker);
        make.top.equalTo(line.mas_bottom);
    }];
    [btn4 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    [[UIApplication sharedApplication].keyWindow addSubview:self.picker];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cover.alpha = 0.4;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT-156, SCREEN_WIDTH, 156);
    } completion:nil];
    
    
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

- (void)tap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        
        
    }];
    [self.view endEditing:YES];
}



- (void)share:(UIButton *)sender {
    
    NSArray* imageArray = @[[UIImage imageNamed:@"login_logo"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"你的好友（%@）向您推荐了一款购物应用【快益分享商城】，优惠多多，现在注册，5倍收益，赶紧下载体验吧！", self.user_name]
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:[NSString stringWithFormat:@"%@推荐这个使用APP给你~", self.user_name]
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //进行分享
        SSDKPlatformType type = SSDKPlatformTypeAny;
        if (sender.tag == 10001) {
            type = SSDKPlatformSubTypeWechatTimeline;
        } else if (sender.tag == 10002) {
            type = SSDKPlatformSubTypeWechatSession;
        } else if (sender.tag == 10003) {
            type = SSDKPlatformSubTypeQQFriend;
        }
        [ShareSDK share:type //传入分享的平台类型
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
             [self tap:nil];
             switch (state) {
                     
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
    }
    
}

- (void)getCode:(UIButton *)sender {
    
    if ([self.tf1.text isEqualToString:@""] || self.tf1.text == nil) {
        LRToast(@"请输入手机号");
        return;
    }
    
    [HttpRequest postWithURLString:NetRequestUrl(sendValidate) parameters:[@{@"type" : @"1", @"send" : self.tf1.text} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        //        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            self.timer = timer;
            [self.ri setBackgroundImage:[KYHeader imageWithColor:kColor666] forState:UIControlStateNormal];
            self.ri.userInteractionEnabled = NO;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [timer fire];
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

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
