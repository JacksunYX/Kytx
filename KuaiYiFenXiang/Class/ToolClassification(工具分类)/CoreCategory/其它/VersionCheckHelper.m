//
//  VersionCheckHelper.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "VersionCheckHelper.h"

@implementation VersionCheckHelper

//检查版本
+(void)questToCheckVersion:(success)successBlock
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSString *version = [UIDevice appVersion];
    param[@"vesion"] = version;
    param[@"type"] = @"ios";
    NSString *appid = @"1245685766";
    NSString *openUrlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
    NSURL *openUrl = [NSURL URLWithString:openUrlStr];
    
    [HttpRequest postWithURLString:NetRequestUrl(checkVersion) parameters:param isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
        NSInteger code = [response[@"code"] integerValue];
        
        NSString *versionNum = response[@"result"][@"vesion_number"];
        
        successBlock(code,openUrl,versionNum);
        if (code == 1) {
            NSLog(@"当前是最新版本");
        }else if(code == 2){    //可以更新，也可以正常使用
            NSLog(@"不更新也能正常使用");
        }else if(code == 3){    //无法使用，必须更新
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"当前版本过低，必须要进行更新才能正常使用~" cancelButtonTitle:@"立即更新"];
            [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                NSLog(@"点击了第%ld按钮",buttonIndex);
                if (buttonIndex == 0) {
                    //此处跳转到appstore进行更新
                    [[UIApplication sharedApplication] openURL:openUrl];
                }
            }];
            
        }else{
            NSLog(@"版本检查，后台返回错误：%@",response[@"msg"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"网络出错了~");
    } RefreshAction:^{
        
    }];
}

@end
