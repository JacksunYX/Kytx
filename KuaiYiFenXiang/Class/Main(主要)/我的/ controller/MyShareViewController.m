//
//  MyShareViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MyShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "ShareRegistViewController.h"
#import "ShareMessagerViewController.h"

#import "UIImage+Avatar.h"

@interface MyShareViewController ()
{
    BOOL showQRCodeImg; //是否是分享的二维码
    UIImageView *qrCodeImageView;
}
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *picker;
@property (nonatomic, copy) NSString *shareStr;
@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    
    NSString *str = IPHONE_X ? @"我的分享X" : @"我的分享";
    UIImage *aimage = [UIImage imageNamed:str];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:aimage];
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"我的分享";
    [self configNavi];
    
    UILabel *label = [UILabel new];
    
    label.text = [NSString stringWithFormat:@"您的好友（%@）向您推荐了快益分享商城，自购省钱，分享赚钱，抢先下载体验吧！", self.user_name];
    label.font = kFont(13);
    label.textColor = kWhiteColor;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        if (IPHONE_X) {
            make.top.equalTo(self.view).offset(380+NAVI_HEIGHT-50);
            
        } else {
            make.top.equalTo(self.view).offset(ScaleHeight(345));
        }
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn setTitle:@"我要推广" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-60);
        make.height.mas_equalTo(ScaleHeight(40));
        if (IPHONE_X) {
//            make.top.equalTo(self.view).offset(435+NAVI_HEIGHT-50);
            make.top.equalTo(label.mas_bottom).offset(20);
        }else {
//            make.top.equalTo(self.view).offset(435);
            make.top.equalTo(label.mas_bottom).offset(ScaleHeight(10));
        }
        
    }];
    
//    UIImageView *imageview1 = [KYHeader generateQRCodeWithArray:@[@"http://www.baidu.com"]];
    //二维码
    self.shareStr = [DefaultDomainName stringByAppendingString:[NSString stringWithFormat:@"/Mobile/GoodDetail/share_registration?tel=%@&username=%@", self.mobile, self.user_name]];
    qrCodeImageView = [KYHeader generateQRCodeWithArray:@[self.shareStr]];
//    qrCodeImageView.image = [KYHeader generateQRCodeWithStr:self.shareStr];
    [self.view addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 120));
        if (IPHONE_X) {
            make.top.equalTo(self.view).offset(130+NAVI_HEIGHT-50);
        } else {
            make.top.equalTo(self.view).offset(125);
        }
    }];
    
    //添加一个logo的水印
    qrCodeImageView.image = [UIImage imagewithBgImage:qrCodeImageView.image addLogoImage:UIImageNamed(@"qrCodeLogo") ofTheSize:qrCodeImageView.frame.size];
    
    qrCodeImageView.userInteractionEnabled = YES;
    qrCodeImageView.tag = 10086;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [self showShareViewWithQRCode:YES];
    }];
    tap.numberOfTapsRequired = 1;
    [qrCodeImageView addGestureRecognizer:tap];
}

-(void)clickToShare:(UIButton *)sender
{
    [self showShareViewWithQRCode:NO];
}

//是否只分享二维码图片
- (void)showShareViewWithQRCode:(BOOL)onlyQRCodeImg
{
    showQRCodeImg = onlyQRCodeImg;
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cover addGestureRecognizer:tap];
    
    self.picker = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 156+BOTTOM_MARGIN)];
    
    self.picker.backgroundColor = kWhiteColor;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.tag = 10001;
    [btn1 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.picker);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
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
    btn3.hidden = YES;
    
    btn3.tag = 10003;
    [btn3 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2);
        make.left.equalTo(btn2.mas_right);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
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
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT-156-BOTTOM_MARGIN, SCREEN_WIDTH, 156+BOTTOM_MARGIN);
    } completion:nil];
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
    
    
//    NSURL *shareUrl2 = [NSURL URLWithString:[@"itms-apps://itunes.apple.com/us/app/快益分享商城/id1245685766?l=zh&ls=1&mt=8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *descriptionText;
    NSURL *shareUrl;
    NSArray* imageArray;
    NSString *title;
    UIImage *qrImg = qrCodeImageView.image;
    UIImage *logoImg;
    
    if (showQRCodeImg) {
        logoImg = UIImageNamed(@"qrCodeLogo");
        
        imageArray = @[qrImg];
        shareUrl = nil;
        title = [NSString stringWithFormat:@"%@推荐这个实用APP给你~", self.user_name];
    }else{
        logoImg = UIImageNamed(@"login_logo");
        descriptionText = [NSString stringWithFormat:@"商品有品质，价格更实惠，消费高补贴，推荐赚收益"];
        imageArray = @[logoImg];
        shareUrl = [NSURL URLWithString:[self.shareStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        title = [NSString stringWithFormat:@"您的好友邀你一起来快益分享购物"];
    }
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:descriptionText
                                         images:imageArray
                                            url:shareUrl
                                          title:title
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

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"会员" style:UIBarButtonItemStylePlain target:self action:@selector(messager:)];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor} forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ShareRegistViewController *vc = [ShareRegistViewController new];
//    vc.mobile = self.mobile;
//    vc.user_name = self.user_name;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)messager:(UIBarButtonItem *)sender {
    ShareMessagerViewController *vc = [ShareMessagerViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
