//
//  YYFImgTextFiled.m
//  cidehui
//
//  Created by apple on 23/02/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YYFImgTextFiled.h"

static NSString * const SJPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@interface YYFImgTextFiled ()


@end

@implementation YYFImgTextFiled{
    
    UIImageView *textfiledimage;
    UILabel *textLabel;
}

-(instancetype)init{
    
    
    if (self=[super init]) {
        
        //        self.size=CGSizeMake(SCREEN_WIDTH/1.2, 30);
        
        //设置文本输入框的右边的删除全部的按钮
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        

    }
    
    
    return self;
    
}

//通过实例方法设置文本输入框的属性
-(void)creattextfiled:(NSString *)imagestr andlabletext:(NSString *)labletext andplaceholderstr:(NSString *)placeholderstr{
    
    
    if ([placeholderstr containsString:@"密码"]) {
        self.secureTextEntry = YES;
    }
    
    //设置文本输入框的默认文字
    self.placeholder=placeholderstr;
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];

    
    //设置文本输入框的图片
    textfiledimage=[[UIImageView alloc]init];
    [textfiledimage setImage:[UIImage imageNamed:imagestr]];
    [self addSubview:textfiledimage];
    textfiledimage.sd_layout
    .leftSpaceToView(self, 10)
    .centerYEqualToView(self)
    .widthIs(18)
    .heightIs(20);
    
    //设置文本输入框左边提示文字
    textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textColor=[UIColor grayColor];
    textLabel.text = labletext;
    textLabel.numberOfLines = 0;//根据最大行数需求来设置
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    [self addSubview:textLabel];
    textLabel.sd_layout
    .leftSpaceToView(textfiledimage, 5)
    .centerYEqualToView(self)
    .widthIs(expectSize.width)
    .heightIs(expectSize.height);
    
    
//    //不要设置边框样式否则其他设置无效
//    self.layer.borderColor=[[UIColor grayColor] CGColor];
//
//    self.layer.borderWidth=0.5;

    
    //设置文本输入框的下划线
    UILabel *linelable=[[UILabel alloc]init];
    linelable.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:linelable];
    linelable.sd_layout
    .centerXEqualToView(self)
    .bottomSpaceToView(self, 1)
    .widthIs(self.width)
    .heightIs(1);

    
    
    

}



// Placeholder position   文本输入框的默认显示文字的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, textfiledimage.SG_width+textLabel.SG_width+15, 0,0);
    return UIEdgeInsetsInsetRect(rect, insets);
}

// Text position   设置文本输入框的输入文字的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, textfiledimage.SG_width+textLabel.SG_width+15, 0,0);
    return UIEdgeInsetsInsetRect(rect, insets);
}

// Clear button   设置文本输入框的右边清除按钮的位置
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    
    return CGRectOffset(rect, 0, 0);
}





- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置placeholder开始颜色（方式一）
    //    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
    //    placeholderLabel.textColor = [UIColor redColor];
    // 设置placeholder开始颜色（方式二）
    [self setValue:[UIColor grayColor] forKeyPath:SJPlacerholderColorKeyPath];
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor lightGrayColor] forKeyPath:SJPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:SJPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

@end







