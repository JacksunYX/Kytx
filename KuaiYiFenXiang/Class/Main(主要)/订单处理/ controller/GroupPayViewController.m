//
//  GroupPayViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "GroupPayViewController.h"

#import "GroupPayBtn.h"

#import "MyOrderViewController.h"

@interface GroupPayViewController ()
{
    NSString *aliPayNum;   //实际需要用第三方支付的金额
}
@end

@implementation GroupPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"组合支付";
    self.view.backgroundColor = kWhiteColor;
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)setUI
{
    NSArray *imgArr = @[@"yue",@"zhifubao"];
    NSArray *titleArr = @[@"余额",@"支付宝"];
    NSArray *subTitleArr = @[[NSString stringWithFormat:@"可用余额%@元",self.money],@""];
    aliPayNum = [NSString stringWithFormat:@"%.2f",self.payTotal.floatValue - self.total.floatValue];
    aliPayNum = @"0.01";
    NSArray *moneyArr = @[self.total,aliPayNum];
    NSMutableArray *payModelArr = [NSMutableArray new];
    for (int i = 0; i < imgArr.count; i ++) {
        GroupPayModel *payModel = [GroupPayModel new];
        payModel.imgStr = imgArr[i];
        payModel.title = titleArr[i];
        payModel.subTitle = subTitleArr[i];
        payModel.money = moneyArr[i];
        [payModelArr addObject:payModel];
    }
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = BACKVIEWCOLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    ;
    
    //组合按钮
    CGFloat y = 0;  //y轴偏移量
    CGFloat btnH = 70;
    CGFloat lineH = 10; //分割线的高度
    for (int i = 0; i < payModelArr.count; i ++) {
        GroupPayModel *payModel = payModelArr[i];
        GroupPayBtn *btn = [GroupPayBtn new];
        [scrollView addSubview:btn];
        btn.sd_layout
        .topSpaceToView(scrollView, y)
        .leftEqualToView(scrollView)
        .rightEqualToView(scrollView)
        .heightIs(btnH)
        ;
        [btn updateLayout];
        [btn setModel:payModel];
        
        btn.ClickBlock = ^(GroupPayModel *model) {
            NSLog(@"点击了%@",model.title);
        };
        
        y = CGRectGetMaxY(btn.frame) + lineH;
    }
    
    //支付按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:[NSString stringWithFormat:@"余额+支付宝支付￥%@元",self.payTotal] forState:UIControlStateNormal];
    payBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    
    [payBtn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [scrollView addSubview: payBtn];
    payBtn.sd_layout
    .topSpaceToView(scrollView, y + 50)
    .centerXEqualToView(scrollView)
    .widthIs(280)
    .heightIs(40)
    ;
    payBtn.sd_cornerRadius = @(3);
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    //添加‘+’号
    for (int i = 0; i < payModelArr.count; i ++) {
        //如果只有一条，不需要添加
        if (i != payModelArr.count - 1) {
            
            UIImageView *addImg = [UIImageView new];
            [scrollView addSubview:addImg];
            [addImg setImage:UIImageNamed(@"groupPay_add")];
            addImg.sd_layout
            .centerXEqualToView(scrollView)
            .widthIs(25)
            .heightIs(25)
            .centerYIs(btnH * (i + 1) + 5)
            ;
        }
        
    }
    
}

-(void)pay
{
//    LRToast(@"功能正在测试阶段~");
    [self doAPPay];
}

//支付宝支付
- (void)doAPPay
{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017051007191557";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = AlipayPublicKey;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"body";
    order.biz_content.subject = self.order_name;
    order.biz_content.out_trade_no = self.order_shop; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = aliPayNum; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                LRToast(@"支付取消");
                GCDAfter1s(^{
                    MyOrderViewController *vc = [MyOrderViewController new];
                    vc.index = 1;
                    [self.navigationController pushViewController:vc animated:YES];
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                });
            }
        }];
    }
}

/*
 *支付宝支付结果回调
 */
-(void)alipayResponse:(NSNotification *)resp{
    NSLog(@"resp-----%@",resp);
    NSString  * resultStatus = [(NSDictionary *)resp.object objectForKey:@"resultStatus"];
    switch(resultStatus.integerValue){
        case 9000:{
            // 移除当前对象监听的事件
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            LRToast(@"支付成功");
            [self requestResponse:(NSDictionary *)resp.object andorderstring:self.order_shop];
        }
            break;
            
        default:{
            LRToast(@"支付失败");
            GCDAfter1s(^{
                MyOrderViewController *vc = [MyOrderViewController new];
                vc.index = 1;
                [self.navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            });
            
        }
            break;
    }
    
}

-(void)requestResponse:(NSDictionary *)respdic andorderstring:(NSString *)orderstring{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:orderstring forKey:@"order_shop"];
    [requestdic setObject:[respdic objectForKey:@"resultStatus"] forKey:@"trade_status"];
    requestdic[@"type"] = @"1";
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(response) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result = [responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        
                                        GCDAfter1s(^{
                                            MyOrderViewController *vc = [MyOrderViewController new];
                                            vc.index = 2;
                                            [self.navigationController pushViewController:vc animated:YES];
                                        });
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}






@end
