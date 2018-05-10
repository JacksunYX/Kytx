//
//  AppDelegate+Guaid.m
//  KSGuaidViewDemo
//
//  Created by Mr.kong on 2017/5/31.
//  Copyright © 2017年 Bilibili. All rights reserved.
//

#import "AppDelegate+Guaid.h"
#import "KSGuaidViewController.h"

#import <objc/runtime.h>

const char* kGuaidWindowKey = "kGuaidWindowKey";
NSString * const kLastVersionKey = @"kLastVersionKey";

@interface AppDelegate (Guaid) <KSGuaidViewDelegate>

@end

@implementation AppDelegate (Guaid)

+ (void)load{

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString* lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kLastVersionKey];
        NSString* curtVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        
        if ([curtVersion compare:lastVersion] == NSOrderedDescending) {
            Method originMethod = class_getInstanceMethod(self.class, @selector(application:didFinishLaunchingWithOptions:));
            Method customMethod = class_getInstanceMethod(self.class, @selector(guaid_application:didFinishLaunchingWithOptions:));
            
            method_exchangeImplementations(originMethod, customMethod);

        }
    });
}

- (BOOL)guaid_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.guaidWindow = [[UIWindow alloc] init];
    self.guaidWindow.frame = self.guaidWindow.screen.bounds;
    self.guaidWindow.backgroundColor = [UIColor clearColor];
    self.guaidWindow.windowLevel = UIWindowLevelStatusBar + 1;
    [self.guaidWindow makeKeyAndVisible];
    //删除沙盒文件
    [AddressHelper deleteAreaFile:@"area.plist"];
    
    KSGuaidViewController* vc = [[KSGuaidViewController alloc] init];
    vc.delegate = self;
    
    self.guaidWindow.rootViewController = vc;
    
    return [self guaid_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (UIWindow *)guaidWindow{
    return  objc_getAssociatedObject(self, kGuaidWindowKey);
}

- (void)setGuaidWindow:(UIWindow *)guaidWindow{
    objc_setAssociatedObject(self, kGuaidWindowKey, guaidWindow, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark --- KSGuaidViewDelegate ---
-(void)haveClickCenterBtn
{
    NSLog(@"点击了立即体验");
    NSString* curtVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:curtVersion forKey:kLastVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.guaidWindow resignKeyWindow];
    
    self.guaidWindow.hidden = YES;
    self.guaidWindow = nil;
}

@end
