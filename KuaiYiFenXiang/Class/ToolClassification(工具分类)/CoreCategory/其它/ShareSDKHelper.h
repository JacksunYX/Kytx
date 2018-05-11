//
//  ShareSDKHelper.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface ShareModel : NSObject

@property (nonatomic ,strong) NSArray *shareImgs;   //分享图片数组
@property (nonatomic ,copy) NSString *shareUrlStr;  //分享链接

@property (nonatomic ,copy) NSString *shareTitle;       //分享标题
@property (nonatomic ,copy) NSString *shareDescription; //分享描述
@property (nonatomic ,copy) NSString *shareLogo;    //分享相关logo

@end

typedef void(^ShareSuccessHandle)();  //分享成功回调
typedef void(^ShareFailureHandle)();  //分享成功回调

@interface ShareSDKHelper : NSObject


/**
 普通分享

 @param model 分享参数模型
 @param type 分享平台
 @param success 成功回调
 @param failure 失败回调
 */
+(void)normalShareWithModel:(ShareModel *)model shareType:(SSDKPlatformType)type success:(ShareSuccessHandle)success failure:(ShareFailureHandle)failure;



/**
 微信分享

 @param model 分享参数模型
 @param type 分享平台
 @param success 成功回调
 @param failure 失败回调
 */
+(void)shareWechatWithModel:(ShareModel *)model shareType:(SSDKPlatformType)type success:(ShareSuccessHandle)success failure:(ShareFailureHandle)failure;










@end






