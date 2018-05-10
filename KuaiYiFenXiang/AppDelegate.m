//
//  AppDelegate.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

//Kuaiyi2017@163.com   Kytx@2018

//不同的开发者账号对应的 Bundle ID

//杨逸飞  com.yihehengrui.kuaiyifenxiang.KuaiYiFenXiang

//易和恒瑞  com.yihehengrui.kuaiyifenxiang

#import "AppDelegate.h"
#import "KYHeader.h"
#import "enterNavigationController.h"

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//百度移动统计
#import "BaiduMobStat.h"

static NSString * const kUserHasOnboardedKey = @"firstLaunch";

@interface AppDelegate ()<JPUSHRegisterDelegate>{
    
    NSDictionary *_resultDic;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置启动页面停留时间
    //    [NSThread sleepForTimeInterval:3];
    
    //解决键盘输入掩盖问题
    [IQKeyboardManager sharedManager].enable = YES;
    
    //初始化极光推送
    [self shareInit];
    [self pushInit:launchOptions];
    
    //添加百度移动统计
    [self addBaiduMobStat];
    
    //    UIWebView页面信息的离线缓存
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    //1. 创建窗口
    self.window=[[UIWindow alloc]init];
    self.window.frame=[UIScreen mainScreen].bounds;
    self.window.backgroundColor = kDefaultBGColor;
    
    
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    NSString*tokenStr = [USER_DEFAULT objectForKey:@"token"];
    
    if (!kStringIsEmpty(tokenStr)) {
        self.isLogin = YES;
        
    }
    if(!userHasOnboarded){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
        
        NSLog(@"第一次启动APP");
        
        //判断是不是最新版本 如果需要引导页就设置 如果不需要就到登录页
        //            [self setupEnterRootViewController];
        
        [self setupNormalRootViewController];
        
    }else{
        
        [self setupNormalRootViewController];
        
        NSLog(@"不是第一次启动APP");
        
        //判断是否免登陆
        //                if (kStringIsEmpty(tokenStr)) {
        //
        //                    [self setupEnterRootViewController];
        //
        //                }
        //                else if(!kStringIsEmpty(tokenStr))
        //                {
        //                    [self setupNormalRootViewController];
        //                }
        
        
    }
    
    return YES;
    
}


- (void)pushInit:(NSDictionary *)launchOptions {
    //清除角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = [defaultUrl containsString:@"testweb"] ? NO : YES;
    [JPUSHService setupWithOption:launchOptions appKey:@"a851919ff251a6b61142cba5"
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)shareInit {
    /**初始化ShareSDK应用
     
     @param activePlatforms
     
     使用的分享平台集合
     
     @param importHandler (onImport)
     
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     
     @param configurationHandler (onConfiguration)
     
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     
     */
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeQQFriend),
                                        @(SSDKPlatformSubTypeWechatTimeline)]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformSubTypeWechatSession:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformSubTypeQQFriend:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 
             case SSDKPlatformSubTypeWechatTimeline:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb930cd6005d32fbd"
                                       appSecret:@"9350670526b3acac96c6904565eff2d4"];
                 break;
             case SSDKPlatformSubTypeQQFriend:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            _resultDic=resultDic;
            [self sendAlipayResult:resultDic];
        }];
    } else {
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            if([code isEqualToString:@"success"]) {
                
                //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
                if(data != nil){
                    //数据从NSDictionary转换为NSString
                    NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                       options:0
                                                                         error:nil];
                    NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                    
                    //                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                    //                if([self verify:sign]) {
                    //                    //验签成功
                    //                }
                    //                else {
                    //                    //验签失败
                    //                }
                    
                }
                
                //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
            }
        }];
    }
    
    return YES;
}

//百度移动统计
-(void)addBaiduMobStat
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    [statTracker startWithAppId:@"ec4d61b730"];
}

- (void)setupEnterRootViewController {
    
    YYFNavigationController *nav = [[YYFNavigationController alloc] initWithRootViewController:[[enterNavigationController alloc]init]];
    self.window.rootViewController = nav;
    
}

- (void)setupNormalRootViewController {
    
    self.window.rootViewController = [[YYFTabBarViewController alloc]init];
    
}

////支付宝支付回调的代理方法判断是否成功进行相应操作
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            _resultDic=resultDic;
//            [self sendAlipayResult:resultDic];
//        }];
//        return _resultDic;
//    }else{
//        return YES;
//    }
//
//}

#pragma mark -支付宝通知
-(void)sendAlipayResult:(NSDictionary *)resultDic{
    // 支付成功
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResult" object:resultDic userInfo:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [VersionCheckHelper questToCheckVersion:^(NSInteger backCode,NSURL *openUrl,NSString *versionNum) {
        
    }];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
