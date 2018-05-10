//
//  NSString+Richtext.m
//  NewProject
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "NSString+Richtext.h"

@implementation NSString (Richtext)

+(NSMutableAttributedString*)RichtextString:(NSString*)changestr andstartstrlocation:(NSInteger)startstrlocation andendstrlocation:(NSInteger)endstrlocation andchangcoclor:(UIColor *)changecolor andchangefont:(UIFont *)changefont{
    
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:changestr];
//    // 需要改变的第一个文字的位置
//    NSUInteger firstLoc = [[noteStr string] rangeOfString:startstr].location + 1;
//    // 需要改变的最后一个文字的位置
//    NSUInteger secondLoc = [[noteStr string] rangeOfString:endstr].location;
    // 需要改变的区间
    NSRange range = NSMakeRange(startstrlocation, endstrlocation);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:changecolor range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:changefont range:range];

    return noteStr;
    
}


@end
