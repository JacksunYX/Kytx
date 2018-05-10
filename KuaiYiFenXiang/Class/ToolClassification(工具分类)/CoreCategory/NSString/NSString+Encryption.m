//
//  NSString+Encryption.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonDigest.h>
//#import "GTMBase64.h"

//密匙 key
#define gkey            @"Kyle_Chu"
//偏移量
#define gIv             @"jukai"
@implementation NSString(Encryption)

/** md5 Encryption
 *
 *
 *  @return return code of 32 bit
 */
- (NSString *)md5 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA1 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
    CC_SHA1([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for ( i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA256 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH], i;
    CC_SHA256([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA512 {
    if (self == nil || [self length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_SHA512_DIGEST_LENGTH], i;
    CC_SHA512([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

//3des加密



@end
