//
//  YYFSearchBar.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "YYFSearchBar.h"

@implementation YYFSearchBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.size = CGSizeMake(280, 30);
        
        self.clearButtonMode = UITextFieldViewModeAlways;

        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:3.0f];
        
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"搜索商品和店铺";
        
        [self  setBackgroundColor:hwcolor(235, 235, 235)];
        
        // 提前在Xcode上设置图片中间拉伸
//        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 通过init初始化的控件大多都没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.size = CGSizeMake(30, 30);
        
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    
        
    }
    return self;
}


+(instancetype)searchBar
{
    return [[self alloc] init];
}







@end
