//
//  UIDevice+System.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "UIDevice+System.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <mach/processor_info.h>
#include <sys/stat.h>
#import "sys/utsname.h"

@implementation UIDevice (System)

+ (NSString *)devicePlatform {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = (char *)malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *platform = [NSString stringWithUTF8String:machine];
  free(machine);
  
  return platform;
}

+ (NSString *)devicePlatformString {
  NSString *platform = [self devicePlatform];
  // iPhone
  if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
  if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
  if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
  if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
  if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
  if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
  if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
  if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
  if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
  if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
  if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
  if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
  if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
  if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
  // iPod
  if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
  // iPad
  if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
  if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
  if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
  if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
  if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
  if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
  if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
  if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
  if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
  if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
  if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
  if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
  if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
  if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
  if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (China)";
  if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
  if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
  // iPad mini
  if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2 (WiFi)";
  if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2 (Cellular)";
  if ([platform isEqualToString:@"iPad4,6"])      return @"iPad mini 2 (China)";
  if ([platform isEqualToString:@"iPad4,7"])      return @"iPad mini 3 (WiFi)";
  if ([platform isEqualToString:@"iPad4,8"])      return @"iPad mini 3 (Cellular)";
  if ([platform isEqualToString:@"iPad4,9"])      return @"iPad mini 3 (China)";
  // Simulator
  if ([platform isEqualToString:@"i386"])         return @"Simulator";
  if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
  return platform;
}

+ (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}

+ (BOOL)isiPad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isiPhone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isSimulator {
  return [[self devicePlatform] isEqualToString:@"i386"]
  || [[self devicePlatform] isEqualToString:@"x86_64"];
}

+ (BOOL)isRetina {
  return [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
  && ([UIScreen mainScreen].scale == 2.0 || [UIScreen mainScreen].scale == 3.0);
}

+ (BOOL)isRetinaHD {
  return [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
  && ([UIScreen mainScreen].scale == 3.0);
}

+ (NSUInteger)cpuFrequency {
  return [self _getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger)cpuNumber {
    return [self _getSysInfo:HW_NCPU];
}

- (NSArray *)cpuUsage
{
    NSMutableArray *usage = [NSMutableArray array];
    //    float usage = 0;
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if(_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if(err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        for(unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if(_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            //            NSLog(@"Core : %u, Usage: %.2f%%", i, _inUse / _total * 100.f);
            float u = _inUse / _total * 100.f;
            [usage addObject:[NSNumber numberWithFloat:u]];
        }
        
        [_cpuUsageLock unlock];
        
        if(_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        
        _prevCPUInfo = _cpuInfo;
        _numPrevCPUInfo = _numCPUInfo;
        
        _cpuInfo = nil;
        _numCPUInfo = 0U;
    } else {
        NSLog(@"Error!");
    }
    return usage;
}

+ (NSUInteger)busFrequency {
  return [self _getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger)ramSize {
  return [self _getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)totalMemory {
  return [self _getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)userMemory {
  return [self _getSysInfo:HW_USERMEM];
}

+ (NSNumber *)totalDiskSpace {
  NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
  return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *)freeDiskSpace {
  NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
  return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (long long)freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

- (long long)totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

- (NSUInteger)totalMemoryBytes
{
    return [self _getSysInfo:HW_PHYSMEM];
}

- (NSUInteger)freeMemoryBytes
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    //    natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t   mem_free = vm_stat.free_count * pagesize;
    //    natural_t   mem_total = mem_used + mem_free;
    
    return mem_free;
}

+ (NSInteger)iOSVersion {
    return [[[UIDevice currentDevice] systemVersion] integerValue];
}

+ (NSString *)systemMachine
{
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice]systemVersion];
}

#pragma mark - Private
//COMPLIER ACCORDING TO FILE  设置为这个选项时，static_cast<int>报错
- (NSUInteger) _getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier/*static_cast<int>(typeSpecifier)*/};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSUInteger)_getSysInfo:(uint)typeSpecifier {
  size_t size = sizeof(int);
  int results;
  int mib[2] = {CTL_HW, typeSpecifier/*static_cast<int>(typeSpecifier)*/};
  sysctl(mib, 2, &results, &size, NULL, 0);
  return (NSUInteger) results;
}

+ (NSString *)_generateUUID {
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  CFStringRef string = CFUUIDCreateString(NULL, theUUID);
  CFRelease(theUUID);
  return (__bridge_transfer NSString *)string;
}

+(NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"app当前版本：%@",app_Version);
    return app_Version;
}












@end
