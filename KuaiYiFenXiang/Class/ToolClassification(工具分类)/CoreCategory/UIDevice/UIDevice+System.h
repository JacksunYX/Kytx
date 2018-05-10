//
//  UIDevice+System.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (System)

+ (NSString *)devicePlatform;
+ (NSString *)devicePlatformString;
+ (NSString *)deviceModel;

+ (BOOL)isiPad;
+ (BOOL)isiPhone;
+ (BOOL)isSimulator;
+ (BOOL)isRetina;
+ (BOOL)isRetinaHD;

+ (NSUInteger)cpuFrequency;
+ (NSUInteger)cpuNumber;
- (NSArray *)cpuUsage;                 //cpu利用率
+ (NSUInteger)busFrequency;
+ (NSUInteger)ramSize;
+ (NSUInteger)totalMemory;
+ (NSUInteger)userMemory;
+ (NSNumber *)totalDiskSpace;
+ (NSNumber *)freeDiskSpace;

- (long long)freeDiskSpaceBytes;   //获取手机硬盘空闲空间,返回的是字节数
- (long long)totalDiskSpaceBytes;  //获取手机硬盘总空间,返回的是字节数

- (NSUInteger)totalMemoryBytes;    //获取手机内存总量,返回的是字节数
- (NSUInteger)freeMemoryBytes;     //获取手机可用内存,返回的是字节数

+ (NSInteger)iOSVersion;
+ (NSString*)systemMachine;
+ (NSString*)systemVersion;

+(NSString *)appVersion;


@end
