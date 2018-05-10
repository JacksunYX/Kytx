//
//  KYLadHeader.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#ifndef KYLadHeader_h
#define KYLadHeader_h
#define IPHONE_X (([[UIScreen mainScreen] bounds].size.height == 812) && ([[UIScreen mainScreen] bounds].size.width == 375))
#define HEIGHT_Adaptation (IPHONE_X ? ([UIScreen mainScreen].bounds.size.height)/812 : ([UIScreen mainScreen].bounds.size.height)/667)
#define NAVI_HEIGHT (IPHONE_X ? 88 : 64)
#define BOTTOM_MARGIN (IPHONE_X ? 34 : 0)

#define TAB_HEIGHT (IPHONE_X ? 83 : 49)
#define ScaleWidth(width) width * WIDTH_SCALE
#define ScaleHeight(height) height * HEIGHT_SCALE
#define WIDTH_SCALE ([UIScreen mainScreen].bounds.size.width)/375.0

#define HEIGHT_SCALE (IPHONE_X ? ([UIScreen mainScreen].bounds.size.height)/812 : ([UIScreen mainScreen].bounds.size.height)/667)
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "ShootVideoViewController.h"

#endif /* KYLadHeader_h */
