//
//  WLCaptcheButton.h
//  WLButtonCountingDownDemo
//
//  Created by wayne on 16/1/14.
//  Copyright © 2016年 ZHWAYNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLCaptcheButton : UIButton

@property (nonatomic, copy) IBInspectable NSString *identifyKey;
@property (nonatomic, strong) IBInspectable UIColor *disabledBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *disabledTitleColor;
@property (nonatomic, strong) UILabel *overlayLabel;
/**
 开始倒计时操作 当后台判定请求成功后!
 */
- (void)fire;

@end
