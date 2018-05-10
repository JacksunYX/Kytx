//
//  KYHeader.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYHeader.h"

@implementation KYHeader

//颜色转换成image
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(BOOL)checkLogin
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isLogin) {
        return YES;
    } else {
        
        [[HttpRequest getCurrentVC] presentViewController:[[YYFNavigationController alloc] initWithRootViewController:[[enterNavigationController alloc]init]] animated:YES completion:nil];
        return NO;
    }
}


//新增一个跳转登录正常返回的
+(BOOL)checkNormalBackLogin
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isLogin) {
        return YES;
    } else {
        
        enterNavigationController *loginVC = [[enterNavigationController alloc]init];
        loginVC.normalBack = YES;
        [[HttpRequest getCurrentVC] presentViewController:[[YYFNavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
        return NO;
    }
}


+ (UIImageView *)generateQRCodeWithArray:(NSArray <NSString *>*)array {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = array.firstObject;
//    = [NSString stringWithFormat:@"%@,%@,%@", @"share", self.user_name, self.mobile];
    for (int i = 1; i < array.count; i++) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@",%@", array[i]]];
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    UIImage *newimage = [self createNonInterpolatedUIImageFormCIImage:image withSize:200];
    
    return [[UIImageView alloc] initWithImage:newimage];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
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

//新增，根据文字生成二维码图片
+ (UIImage *)generateQRCodeWithStr:(NSString *)urlStr
{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = urlStr;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 返回二维码
    return [UIImage imageWithCIImage:image];
}



@end
