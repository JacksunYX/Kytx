//
//  NSData+Ext.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSData+Ext.h"

@implementation NSData (Ext)

- (NSString *)toString {
  return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

+ (NSString *)toString:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
