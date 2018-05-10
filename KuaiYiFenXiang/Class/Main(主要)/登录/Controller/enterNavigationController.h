//
//  enterNavigationController.h
//  CiDeHui
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYDHLBaseViewController.h"

typedef void(^BackHandle)();    //回调函数

@interface enterNavigationController : YYDHLBaseViewController

@property(nonatomic,assign)BOOL normalBack; //常规返回

@property (nonatomic,copy) BackHandle backHandleBlock;
@end
