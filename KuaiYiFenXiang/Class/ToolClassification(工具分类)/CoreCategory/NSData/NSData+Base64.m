//
//  NSData+Base64.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSData+Base64.h"

@implementation NSData (Base64)

- (NSString *)base64Encoding
{
    NSString *result = nil;
    result = [self base64EncodedStringWithOptions:0];
    return result;
}

+ (NSString *)base64Encoding:(NSData*)data
{
    NSString *result = nil;
    result = [data base64EncodedStringWithOptions:0];
    return result;
}

@end
