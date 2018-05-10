//
//  UIView+Extension.m
//  yyf微博项目－16-2-6
//
//  Created by 杨毅飞 on 16/2/12.
//  Copyright © 2016年 杨毅飞. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


-(void)setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
-(void)setY:(CGFloat)y{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;

}


-(CGFloat)x{
    return self.frame.origin.x;
}
-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)centerx{
    return self.center.x;
}
-(void)setCenterx:(CGFloat)centerx{
    CGPoint center=self.center;
    center.x=centerx;
    self.center=center;
    
}

-(CGFloat)centery{
    return self.center.y;
}
-(void)setCentery:(CGFloat)centery{
    CGPoint center=self.center;
    center.y=centery;
    self.center=center;
    
}

-(void)setWidth:(CGFloat)width{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;

}
-(void)setHeight:(CGFloat)height{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;

}


-(CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat)height{
    return self.frame.size.height;
}


-(void)setSize:(CGSize)size{
    CGRect frame=self.frame;
    frame.size=size;
    self.frame=frame;

}
-(CGSize)size{
    return self.frame.size;
}


-(void)setOrigin:(CGPoint)origin{
    CGRect frame=self.frame;
    frame.origin=origin;
    self.frame=frame;
 
}
-(CGPoint)origin{
    return self.frame.origin;
}




@end
