//
//  HttpRequest.m
//  CiDeHui
//
//  Created by 杨毅飞 on 16/11/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

//判断是否有网加入的
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>
#import "enterNavigationController.h"


@implementation HttpRequest



#pragma mark -- GET请求 --
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    
    /**
     *  请求队列的最大并发数
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    //    manager.requestSerializer.timeoutInterval = 5;
    [manager GET:baseURLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //直接吧返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",resultdic);
        
        NSString *msg = resultdic[@"msg"];
        if ([resultdic[@"code"] integerValue] == 2&&![msg isEqualToString:@"请取设置支付密码"]&&![msg isEqualToString:@"查询失败"]&&!kStringIsEmpty(msg)) {
            LRToast(resultdic[@"msg"]);
        }
        
        if (success) {
            success(resultdic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             isShowToastd:(BOOL)isshowtoastd
                isShowHud:(BOOL)isshowhud
         isShowBlankPages:(BOOL)isshowblankpages
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
            RefreshAction:(void (^)())RefreshAction{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置请求超时时长
    manager.requestSerializer.timeoutInterval = 10;
    
    //设置请求头中请求数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    
    
    //判断显示loding
    if (isshowhud==YES) {
        
        //        if (![MBProgressHUD allHUDsForView:kWindow].count)
        
        //            kShowHUDAndActivity;
        ShowHudOnly;
        
    }
    
    //请求之前先隐藏空白页和无网络页面 不然会出现页面重叠
    [[self getCurrentVC].view hideBlankPageView];
    [[self getCurrentVC].view hideErrorPageView];
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
//        NSString *msg = resultdic[@"msg"];
//        if ([resultdic[@"code"] integerValue] == 2&&![msg isEqualToString:@"请取设置支付密码"]&&![msg isEqualToString:@"查询失败"]&&!kStringIsEmpty(msg)&&![msg isEqualToString:@"请更新版本后使用"]) {
//            LRToast(resultdic[@"msg"]);
//        }
        
        //取出返回数据
        if (success) {
            
            //隐藏loding
            //            kHiddenHUDAndAvtivity;
            HiddenHudOnly;
            
            //判断是否显示请求成功提示框 如果数据为空就显示空白页
            if (isshowblankpages==YES) {
                
                id data=[resultdic objectForKey:@"result"];
                //判断当前是否有数据如果数据为空则显示空白页
                if ([data isKindOfClass:[NSNull class]]||data==nil||data==NULL){
                    //获取当前页面控制器添加空白页
                    [[self getCurrentVC].view showBlankPageView];
                    
                }
                
            }
            
            if (isshowtoastd==YES) {
                
                //显示提示用户信息
                NSString *msg= [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"msg"]];
                
                if ([msg isEqualToString:@"成功"]||kStringIsEmpty(msg)) {
                    
                } else {
                    LRToast(msg);
                }
                
            }
            
            NSLog(@"resultdic-----%@",resultdic);
            
            //成功返回服务器数据
            success(resultdic);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //隐藏loding
//        kHiddenHUDAndAvtivity;
        HiddenHudOnly;
        
        //判断如果失败隐藏空白页显示无网络页面
        if (isshowblankpages==YES) {
            
            //如果请求错误就隐藏空白页视图显示无网络刷新视图
            [[self getCurrentVC].view hideBlankPageView];
            [[self getCurrentVC].view showErrorPageView];
            [[self getCurrentVC].view configReloadAction:^{
                
                //点击无网络刷新按钮执行方法 通过回调执行相应的方法
                RefreshAction();
                
            }];
            
        }
        
        if (failure) {
            //失败返回错误原因
            failure(error);
            
        }
        
    }];
    
}




#pragma mark -- 请求带token参数的POST请求 --
+ (void)postWithTokenURLString:(NSString *)URLString
                    parameters:(id)parameters
                  isShowToastd:(BOOL)isshowtoastd
                     isShowHud:(BOOL)isshowhud
              isShowBlankPages:(BOOL)isshowblankpages
                       success:(void (^)(id res))success
                       failure:(void (^)(NSError *))failure
                 RefreshAction:(void (^)())RefreshAction{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置请求超时时长
    manager.requestSerializer.timeoutInterval = 10;
    
    //设置请求头中请求数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"image/jpeg", @"image/png",@"application/octet-stream",nil];
    
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    NSString *token = [USER_DEFAULT objectForKey:@"token"];
    NSString *user_id = [USER_DEFAULT objectForKey:@"user_id"];
    
    //    if (!token || !user_id || [token isEqualToString:@""] || [user_id isEqualToString:@""]) {
    //        // 需要登录
    //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[YYFNavigationController alloc] initWithRootViewController:[[enterNavigationController alloc]init]] animated:YES completion:nil];
    //    }
    
    [parameters setValue:token forKey:@"token"];
    
    [parameters setValue:user_id forKey:@"user_id"];
    
    //判断显示loding
    if (isshowhud==YES) {
        
        //             dispatch_async(dispatch_get_main_queue(), ^{
        
        //                if (![MBProgressHUD allHUDsForView:kWindow].count)
        
        //                kShowHUDAndActivity;
        //            kShowNetworkActivityIndicator();
        ShowHudOnly;
        //             });
        
    }
    
    //请求之前先隐藏空白页和无网络页面 不然会出现页面重叠
    [[self getCurrentVC].view hideBlankPageView];
    [[self getCurrentVC].view hideErrorPageView];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
//        NSString *msg = resultdic[@"msg"];
//        if ([resultdic[@"code"] integerValue] == 2&&![msg isEqualToString:@"请取设置支付密码"]&&![msg isEqualToString:@"查询失败"]&&!kStringIsEmpty(msg)) {
//            LRToast(resultdic[@"msg"]);
//        }
        
        NSLog(@"resultdic-----%@",resultdic);
        
        //取出返回数据
        if (success) {
            
            //                dispatch_async(dispatch_get_main_queue(), ^{
            
            //隐藏loding
            //                kHiddenHUDAndAvtivity;
            //                HideNetworkActivityIndicator();
            HiddenHudOnly;
            //                });
            
            //判断是否显示请求成功提示框 如果数据为空就显示空白页
            if (isshowblankpages==YES) {
                
                id data=[resultdic objectForKey:@"result"];
                //判断当前是否有数据如果数据为空则显示空白页
                if ([data isKindOfClass:[NSNull class]]||data==nil||data==NULL){
                    //获取当前页面控制器添加空白页
                    [[self getCurrentVC].view showBlankPageView];
                }
                
            }
            
            
            if (isshowtoastd==YES) {
                
                //显示提示用户信息
                NSString *msg= [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"msg"]];
                
                if ([msg isEqualToString:@"成功"]||kStringIsEmpty(msg)) {
                    
                } else {
                    LRToast(msg);
                }
                
            }
            // 判断登录
            if ([resultdic[@"code"] integerValue] == 10) {
//                enterNavigationController *loginVC = [[enterNavigationController alloc]init];
//                loginVC.normalBack = YES;
//                [[self getCurrentVC] presentViewController:[[YYFNavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
                LRToast(resultdic[@"msg"]);
                
                [USER_DEFAULT setObject:@"" forKey:@"token"];
                [USER_DEFAULT setObject:@"" forKey:@"user_id"];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.isLogin = NO;
                
                GCDAfter1s(^{
                    [[self getCurrentVC] presentViewController:[[YYFNavigationController alloc] initWithRootViewController:[[enterNavigationController alloc]init]] animated:YES completion:nil];
                });
                
            } else {
                
                //成功返回服务器数据
                success(resultdic);
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"error:%@",error);
            //隐藏loding
//            kHiddenHUDAndAvtivity;
        HiddenHudOnly;
        LRToast(@"网络故障，请重试");
            
//        });
        //判断如果失败隐藏空白页显示无网络页面
        if (isshowblankpages==YES) {
            
            //如果请求错误就隐藏空白页视图显示无网络刷新视图
            [[self getCurrentVC].view hideBlankPageView];
            [[self getCurrentVC].view showErrorPageView];
            [[self getCurrentVC].view configReloadAction:^{
                
                //点击无网络刷新按钮执行方法 通过回调执行相应的方法
                RefreshAction();
                
            }];
            
        }
        if (failure) {
            
            //失败返回错误原因
            failure(error);
            
        }
        
    }];
    
}




//获取用户的token信息进行相应的请求
+(void)gettoken:(void (^)(id))successtoken{
    
    //获取当前前一次保存Token时间与当前时间差值  如果相差时间少于一个小时就不进行请求 如果超过一个小时或者Token为空也要进行请求就请求Token
    NSDate *senddate = [NSDate date];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:[senddate timeIntervalSince1970]];
    NSTimeInterval time = [nowDate timeIntervalSinceDate:[USER_DEFAULT  objectForKey:@"oldDate"]];
    NSInteger timeint = round(time);
    NSLog(@"timeint-----%ld",(long)timeint);
    
    if (kStringIsEmpty([USER_DEFAULT  objectForKey:@"ios_token"])||timeint>3600) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //设置请求超时时长
        manager.requestSerializer.timeoutInterval = 10;
        
        //设置请求头中请求数据类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
        
        manager.operationQueue.maxConcurrentOperationCount = 1;
        
        //之前直接用初始化方法来拼接请求地址 现在直接拼接
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,NetRequestUrl(getiostoken)];
        
        [dic setValue:tokenappid forKey:@"appid"];
        
        [dic setValue:tokenappsecret forKey:@"appsecret"];
        
        NSLog(@"%@",dic);
        
        [manager POST:baseURLString parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            //把网络请求返回数据转换成json数据
            NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSString *msg = resultdic[@"msg"];
            if ([resultdic[@"code"] integerValue] == 2&&![msg isEqualToString:@"请取设置支付密码"]&&![msg isEqualToString:@"查询失败"]&&!kStringIsEmpty(msg)) {
                LRToast(resultdic[@"msg"]);
            }
            
            NSLog(@"%@",resultdic);
            
            NSString *staStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"status"]]; ;
            
            NSDictionary *datadic=[resultdic objectForKey:@"data"];
            
            //获取token并存储
            if (staStr.intValue==200) {
                
                //用户的user_id
                [USER_DEFAULT setObject:[datadic objectForKey:@"ios_token"] forKey:@"ios_token"];
                
                NSDate *senddate = [NSDate date];
                
                NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:[senddate timeIntervalSince1970]];
                
                [USER_DEFAULT setObject:oldDate forKey:@"oldDate"];
                
                //立即存储 如果不存储系统会在一段时间内自动存储
                [USER_DEFAULT synchronize];
                
                successtoken([datadic objectForKey:@"ios_token"]);
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
        }];
        
    }else{
        
        successtoken([USER_DEFAULT objectForKey:@"ios_token"]);
        
    }
    
}




#pragma mark -- POST/GET网络请求 --
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    switch (type) {
        case HttpRequestTypeGet:
        {
            
            [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
            
        case HttpRequestTypePost:
        {
            [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
}




#pragma mark -- 上传图片 -- 如果要上传多张图片只需要些for循环遍历数组图片上传 上传图片时把图片转换成字符串传递
+ (void)uploadFileImage:(NSString *)URLString
             parameters:(id)parameters
            uploadImage:(UIImage *)uploadimage
                success:(void (^)())success
                failure:(void (^)(NSError *))failure {
    
    //    //在token获取成功之后进行相应的请求
    //    [self gettoken:^(id tokenStr) {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    
    [parameters setValue:@"1" forKey:@"client_id"];
    
    [parameters setValue:[HttpRequest  getapi_tokenwithurlstring:URLString] forKey:@"api_token"];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    NSURLSessionDataTask *task = [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(uploadimage,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"member_pic"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        
        if (success) {
            success(resultdic);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    //    }];
    
}




#pragma mark -- 上传多张图片 -- 如果要上传多张图片只需要些for循环遍历数组图片上传 上传图片时把图片转换成字符串传递
+ (void)uploadFileImages:(NSString *)URLString
              parameters:(id)parameters
             uploadImage:(NSMutableArray *)uploadimages
                 success:(void (^)())success
                 failure:(void (^)(NSError *))failure {
    
    //    //在token获取成功之后进行相应的请求
    //    [self gettoken:^(id tokenStr) {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    
    [parameters setValue:@"1" forKey:@"client_id"];
    
    [parameters setValue:[HttpRequest  getapi_tokenwithurlstring:URLString] forKey:@"api_token"];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    NSURLSessionDataTask *task = [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        //通过循环取出图片上传
        for (int i = 0; i < uploadimages.count; i ++) {
            
            UIImage *uploadimage = uploadimages[i];
            
            NSData *imageData =UIImageJPEGRepresentation(uploadimage,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            NSLog(@"fileName---------%@",fileName);
            
            NSString *picname=[NSString stringWithFormat:@"dt_pic%d",i];
            
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:picname
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        
        if (success) {
            success(resultdic);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    //    }];
    
}





+(void)uploadFileVideo:(NSString *)URLString
            parameters:(id)parameters
       uploadVideoData:(NSData *)uploadVideoData
               success:(void (^)())success
               failure:(void (^)(NSError *))failure {
    
    //    //在token获取成功之后进行相应的请求
    //    [self gettoken:^(id tokenStr) {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",@"text/plain",
                                                         nil];
    
    
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    
    [parameters setValue:@"1" forKey:@"client_id"];
    
    [parameters setValue:[HttpRequest  getapi_tokenwithurlstring:URLString] forKey:@"api_token"];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    if (![MBProgressHUD allHUDsForView:kWindow].count)
        
        kShowHUDAndActivity;
    
    NSURLSessionDataTask *task = [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:uploadVideoData
                                    name:@"video"
                                fileName:fileName
                                mimeType:@"video/mpeg4"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"uploadProgress.fractionCompleted---%f",uploadProgress.fractionCompleted);
        
        if (uploadProgress.fractionCompleted==1.0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 在主线程中更新 UI
                kHiddenHUDAndAvtivity;
            });
            
        }
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        
        //显示提示用户信息
        NSString *msg= [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"mess"]];
        
        LRToast(msg);
        
        if (success) {
            success(resultdic);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    //    }];
    
}







//获取App的请求参数
+ (NSString *)getapi_tokenwithurlstring:(NSString *)urlstring{
    
    NSDate *senddate = [NSDate date];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *date = [dateformatter stringFromDate:senddate];
    
    NSString  *splicingstring=[NSString stringWithFormat:@"%@%@%@",urlstring,date,tokenappsecret];
    
    return splicingstring.md5;
    
}





//这里的判断只是为了判断当前是否有网
+(BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
    
}


//这个判断是判断当前的网络状态 通过不同的网络状态提示用户
+(void)networkStatusChangeAFN
{
    
    //1.获得一个网络状态监听管理者
    AFNetworkReachabilityManager *manager =  [AFNetworkReachabilityManager sharedManager];
    
    //2.监听状态的改变(当网络状态改变的时候就会调用该block)
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        /*
         AFNetworkReachabilityStatusUnknown          = -1,  未知
         AFNetworkReachabilityStatusNotReachable     = 0,   没有网络
         AFNetworkReachabilityStatusReachableViaWWAN = 1,    3G|4G
         AFNetworkReachabilityStatusReachableViaWiFi = 2,   WIFI
         */
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
                
            default:
                break;
        }
    }];
    
    //3.手动开启 开始监听
    [manager startMonitoring];
    
}




//获取当前页面的控制器 进行相应的跳转以及视图的添加
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



//先进性相应的字典元素首字母排序 然后进行哈西加密
+(NSString *)ParameterFormattingSplicing:(NSMutableDictionary *)requestparameterdic  WithKey:(NSString *)keyStr{
    
    //进行字典中字符串的拼接
    //    首先我们定义一个数组，存储字典中的所有key值:
    NSArray *keyArray = [requestparameterdic allKeys];
    
    //    接下来我们定义一个排序数组，存储排序好之后的key值
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //    sortedArrayUsingComparator方法是苹果为我们提供的一个数组排序方法，利用block语法来完成排序功能。
    //
    //    而这时，我们排序好的key值，已经按顺序存储在sortArray数组中，这时我们再创建一个数组，来按升序存储key对应的Value，通过遍历sortArray的方法。
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[requestparameterdic objectForKey:sortString]];
    }
    
    //    现在我们有两个数组，分别对应升序排序的key和value，所以再创建一个keyValue的数组来存储每一个key和value的格式。
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],[valueArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //        NSString *keyValueStr = [NSString stringWithFormat:@"%@",valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    //    最后的一步，就是用“,”把每个字符串拼接起来，很简单。
    NSString *sign = [[signArray componentsJoinedByString:@""] lowercaseString];
    
    //把拼接过的字符串进行加密
    const char *cKey  = [keyStr cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [sign cStringUsingEncoding:NSUTF8StringEncoding];
    const unsigned int blockSize = 64;
    char ipad[blockSize];
    char opad[blockSize];
    char keypad[blockSize];
    
    unsigned int keyLen = (unsigned int)strlen(cKey);
    CC_MD5_CTX ctxt;
    if (keyLen > blockSize) {
        CC_MD5_Init(&ctxt);
        CC_MD5_Update(&ctxt, cKey, keyLen);
        CC_MD5_Final((unsigned char *)keypad, &ctxt);
        keyLen = CC_MD5_DIGEST_LENGTH;
    }
    else {
        memcpy(keypad, cKey, keyLen);
    }
    
    memset(ipad, 0x36, blockSize);
    memset(opad, 0x5c, blockSize);
    
    int i;
    for (i = 0; i < keyLen; i++) {
        ipad[i] ^= keypad[i];
        opad[i] ^= keypad[i];
    }
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, ipad, blockSize);
    CC_MD5_Update(&ctxt, cData, (unsigned int)strlen(cData));
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md5, &ctxt);
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, opad, blockSize);
    CC_MD5_Update(&ctxt, md5, CC_MD5_DIGEST_LENGTH);
    CC_MD5_Final(md5, &ctxt);
    
    const unsigned int hex_len = CC_MD5_DIGEST_LENGTH*2+2;
    char hex[hex_len];
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        snprintf(&hex[i*2], hex_len-i*2, "%02x", md5[i]);
    }
    
    NSData *HMAC = [[NSData alloc] initWithBytes:hex length:strlen(hex)];
    NSString *hash = [[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding];
    
    return hash;
    
}








@end
