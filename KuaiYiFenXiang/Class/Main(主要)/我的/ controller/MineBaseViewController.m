//
//  MineBaseViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MineBaseViewController.h"
#import "KYHeader.h"
#import "PayChangeViewController.h"

@interface MineBaseViewController ()

@end

@implementation MineBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayDone:) name:@"AliPayResult" object:nil];
}

- (void)AlipayDone:(NSNotification *)resp {
    
        
        NSString  * resultStatus = [(NSDictionary *)resp.object objectForKey:@"resultStatus"];
        switch(resultStatus.integerValue){
            case 9000:{
//                LRToast(@"支付成功!");
                [self requestResponse:(NSDictionary *)resp.object];
            }
                break;
            default:{
//                LRToast(@"支付失败，请重新支付!");
            }
                break;
        }
        
        
    
    
}

-(void)requestResponse:(NSDictionary *)respdic{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[respdic[@"result"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString *tn = dict[@"alipay_trade_app_pay_response"][@"out_trade_no"];
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:tn forKey:@"order_shop"];
    [requestdic setObject:[respdic objectForKey:@"resultStatus"] forKey:@"trade_status"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(response) parameters:requestdic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    
                                    if (codeStr.intValue==1) {
                                        [self paydone];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}
- (void)paydone {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = SCREEN_WIDTH;
    CGFloat screenHeight = SCREEN_HEIGHT;
    
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (screenHeight * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newImage = [self compressOriginalImage:newImage toMaxDataSizeKBytes:500];
   
    
    return newImage;
}

- (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
            }else{
                lastData = dataKBytes;
                }
        }
    
    UIImage *newimage = [UIImage imageWithData:data];
    return newimage;
}

- (void)doAPPayAnmount:(CGFloat)price
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
    order.biz_content.subject = self.info ? self.info : @"快益分享商城订单";
    order.biz_content.out_trade_no = self.tn; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", price]; //商品价格
    
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
        }];
    }
}

-(void)doBalancePay:(NSString *)orderstring andorder_amount:(NSString *)order_amount andtypestring:(NSString *)typestring{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            DCPaymentView *payAlert = [[DCPaymentView alloc]init];
            payAlert.title = @"请输入支付密码";
            //    payAlert.detail = @"提现";
            //    payAlert.amount= 10;
            [payAlert show];
            payAlert.completeHandle = ^(NSString *inputPwd) {
                NSLog(@"密码是%@",inputPwd);
                
                NSMutableDictionary *requestdic=[NSMutableDictionary new];
                [requestdic setObject:orderstring forKey:@"order_sn"];
                [requestdic setObject:order_amount forKey:@"order_amount"];
                [requestdic setObject:typestring forKey:@"type"];
                [requestdic setObject:inputPwd forKey:@"pass"];
                
                [HttpRequest postWithTokenURLString:NetRequestUrl(moneyPay) parameters:requestdic
                                       isShowToastd:(BOOL)YES
                                          isShowHud:(BOOL)YES
                                   isShowBlankPages:(BOOL)NO
                                            success:^(id responseObject)  {
                                                
                                                NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                                //                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                                
                                                if (codeStr.intValue==1) {
//                                                    LRToast(responseObject[@"支付成功~"]);
                                                    [self paydone];
                                                    
                                                }
                                                
                                            } failure:^(NSError *error) {
                                                //打印网络请求错误
                                                NSLog(@"%@",error);
                                                
                                            } RefreshAction:^{
                                                //执行无网络刷新回调方法
                                                
                                            }];
                
            };
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:nil RefreshAction:nil];
    
    
}

- (NSDictionary *)validDict:(NSDictionary *)dict {
    NSMutableDictionary *temp = [dict mutableCopy];
    for (id obj in temp.allKeys) {
        if ([temp[obj] isKindOfClass:[NSNull class]]) {
//            [dict setValue:@"" forKey:obj];
            temp[obj] = @"";
        }
    }
    
    return temp;
}

-(void)doUPPay{
    
    //当获得的tn不为空时，调用支付接口
    //if (tn != nil && tn.length > 0)
    //{
    [[UPPaymentControl defaultControl]
     startPay:self.tn
     fromScheme:@"UPPay"
     mode:@"01"
     viewController:self];
    //}
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
