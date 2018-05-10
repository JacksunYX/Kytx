//
//  UIImage+Circle.h
//  NewProject
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DirectionStyle){
    DirectionStyleToUnder = 0,  //向下
    DirectionStyleToUn = 1      //向上
};


@interface UIImage (Circle)


- (UIImage *)LW_gradientColorWithRed:(CGFloat)red
                               green:(CGFloat)green
                                blue:(CGFloat)blue
                          startAlpha:(CGFloat)startAlpha
                            endAlpha:(CGFloat)endAlpha
                           direction:(DirectionStyle)direction
                               frame:(CGRect)frame;

@end
