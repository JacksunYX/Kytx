//
//  ShareSDKHelper.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShareSDKHelper.h"

@implementation ShareSDKHelper

/**
 普通分享
 
 @param model 分享参数模型
 @param type 分享平台
 @param success 成功回调
 @param failure 失败回调
 */
+(void)normalShareWithModel:(ShareModel *)model  shareType:(SSDKPlatformType)type  success:(ShareSuccessHandle)success failure:(ShareFailureHandle)failure
{
    
    NSArray* imageArray;
    if (!kArrayIsEmpty(model.shareImgs)) {
        imageArray = model.shareImgs;
    }else{
        imageArray = @[[UIImage imageNamed:model.shareLogo]];
    }
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:GetSaveString(model.shareDescription)
                                         images:imageArray
                                            url:[NSURL URLWithString:[model.shareUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                          title:GetSaveString(model.shareTitle)
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //传入分享的平台类型
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             switch (state) {
                     
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     //回调
                     if (success) {
                         success();
                     }
                     
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
                     //回调
                     if (failure) {
                         failure();
                     }
                     break;
                 }
                 default:
                     break;
             }
         }];
    }else{
        LRToast(@"分享参数缺失~");
    }
    
}

/**
 微信分享
 
 @param model 分享参数模型
 @param type 分享平台
 @param success 成功回调
 @param failure 失败回调
 */
+(void)shareWechatWithModel:(ShareModel *)model shareType:(SSDKPlatformType)type success:(ShareSuccessHandle)success failure:(ShareFailureHandle)failure
{
    NSArray* imageArray;
    if (!kArrayIsEmpty(model.shareImgs)) {
        imageArray = model.shareImgs;
    }else{
        imageArray = @[[UIImage imageNamed:model.shareLogo]];
    }
    if (kArrayIsEmpty(imageArray)) {
        LRToast(@"分享参数缺失~");
    }else{
        //构建微信分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupWeChatParamsByText:GetSaveString(model.shareDescription) title:GetSaveString(model.shareTitle) url:[NSURL URLWithString:[model.shareUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] thumbImage:imageArray[0] image:imageArray[0] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                    
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    //回调
                    if (success) {
                        success();
                    }
                    
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
                    //回调
                    if (failure) {
                        failure();
                    }
                    break;
                }
                default:
                    break;
            }
        }];
    }
}








@end


@implementation ShareModel

@end



