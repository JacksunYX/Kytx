//
//  NSString+Base64.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

- (NSString *)base64Encoding {
    return [NSString base64Encoding:self];
}

+ (NSString *)base64Encoding:(NSString *)text {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = nil; 
    
    result = [data base64EncodedStringWithOptions:0];
    
    return result;
}
- (NSString *)base64EncodingWithOtherString{
    
    NSString *string =  [NSString base64Encoding:self];
    return [string stringByAppendingString:@""];
}
@end
