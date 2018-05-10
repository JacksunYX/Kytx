//
//  NSString+Path.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

+ (NSString *)documentPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)tmpPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

+ (NSString *)cachePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
}

+ (NSString *)pathWithFileName:(NSString *)fileName {
    return [self pathWithFileName:fileName ofType:nil];
}

+ (NSString *)pathWithFileName:(NSString *)fileName ofType:(NSString *)type {
    return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}

@end
