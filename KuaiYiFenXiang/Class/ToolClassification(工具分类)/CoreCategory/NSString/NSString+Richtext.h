//
//  NSString+Richtext.h
//  NewProject
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Richtext)

+(NSMutableAttributedString*)RichtextString:(NSString*)changestr andstartstrlocation:(NSInteger)startstrlocation andendstrlocation:(NSInteger)endstrlocation andchangcoclor:(UIColor *)changecolor andchangefont:(UIFont *)changefont;

@end
