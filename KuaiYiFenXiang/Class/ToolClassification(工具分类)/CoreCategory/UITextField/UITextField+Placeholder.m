//
//  UITextField+Placeholder.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
  [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
  [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

@end
