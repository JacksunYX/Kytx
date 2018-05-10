//
//  UILabel+Category.m
//  CiDeHui
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel_Category


+ (UILabel *)setupLabelWithFount:(UIFont *)fount WithText:(NSString *)text WithX:(CGFloat )x WithY:(CGFloat )y {
    
    //准备工作
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = text;
    //textLabel.backgroundColor = [UIColor redColor];
    textLabel.numberOfLines = 0;//根据最大行数需求来设置
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-40, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    textLabel.frame = CGRectMake(x, y, expectSize.width, expectSize.height);
    //textLabel.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    return textLabel;
    
}



@end
