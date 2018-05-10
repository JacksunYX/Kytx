//
//  NSData+Base64.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

- (NSString *)base64Encoding;
+ (NSString *)base64Encoding:(NSData*)data;

@end
