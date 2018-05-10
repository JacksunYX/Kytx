//
//  KYHeader.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//
////腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

#define IPHONE_X (([[UIScreen mainScreen] bounds].size.height == 812) && ([[UIScreen mainScreen] bounds].size.width == 375))
#define HEIGHT_Adaptation (IPHONE_X ? ([UIScreen mainScreen].bounds.size.height)/812 : ([UIScreen mainScreen].bounds.size.height)/667)
#define NAVI_HEIGHT (IPHONE_X ? 88 : 64)
#define BOTTOM_MARGIN (IPHONE_X ? 34 : 0)
#define StatusBarHeight (20)

#define TAB_HEIGHT (IPHONE_X ? 83 : 49)
#define ScaleWidth(width) width * WIDTH_SCALE
#define ScaleHeight(height) height * HEIGHT_SCALE
#define WIDTH_SCALE ([UIScreen mainScreen].bounds.size.width)/375.0

#define HEIGHT_SCALE (IPHONE_X ? ([UIScreen mainScreen].bounds.size.height)/812 : ([UIScreen mainScreen].bounds.size.height)/667)

#define kDefaultBGColor [UIColor colorWithHexString:@"efefef"]
#define kColor333 [UIColor colorWithHexString:@"333333"]
#define kColor666 [UIColor colorWithHexString:@"666666"]
#define kColor999 [UIColor colorWithHexString:@"999999"]
#define kColord40 [UIColor colorWithHexString:@"d40000"]
#define kWhite(x) [UIColor colorWithWhite:x alpha:1]
#define kWhiteColor [UIColor whiteColor]
#define kFont(x) [UIFont systemFontOfSize:(x)]
#define kBoldFont(x) [UIFont boldSystemFontOfSize:x]
#define MCWeakSelf __weak typeof(self) weakSelf = self;

#define companyInfo_url @"/Mobile/GoodDetail/introduce"
#define helpInfo_url @"/Mobile/GoodDetail/help_center"
#define bankrule_url @"/Mobile/GoodDetail/binding_rules"
#define pointrule_url @"/Mobile/GoodDetail/love_rule"
#define cashoutrule_url @"/Mobile/GoodDetail/cash_rule"
#define cashiinrule_url @"/Mobile/GoodDetail/recharge_rule"
#define sharemember_url @"/Mobile/GoodDetail/loveenvoy"
#define sharemessager_url @"/Mobile/GoodDetail/transmitenvoy"
#define riskcontrol_url @"/Mobile/GoodDetail/control"


#import "UIColor+Hex.h"
#import "UIAlertView+Category.h"
#import "Masonry.h"
#import "ShootVideoViewController.h"
#import "HMSegmentedControl.h"
#import "MJRefresh.h"
#import "SDImageCache.h"
#import "GetLocation.h"
#import "AppDelegate.h"
#import "CommonMacroDefinitions .h"
#import "MJExtension.h"
#import "YYFTabBarViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIButton+pressMode.h"
#import "DCPaymentView.h"
#import "KYWebViewController.h"
#import "YYFNavigationController.h"
#import "enterNavigationController.h"
#import "TZImagePickerController.h"
#import "JTSImageViewController.h"
@interface KYHeader : NSObject

/**
 生成二维码

 @param array 数组第一个元素传类型，后面传值
 @return 二维码图片
 */
+ (UIImageView *)generateQRCodeWithArray:(NSArray <NSString *>*)array;
+ (UIImage *)generateQRCodeWithStr:(NSString *)urlStr;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (BOOL)checkLogin;
//新增一个跳转登录正常返回的
+(BOOL)checkNormalBackLogin;


@end
