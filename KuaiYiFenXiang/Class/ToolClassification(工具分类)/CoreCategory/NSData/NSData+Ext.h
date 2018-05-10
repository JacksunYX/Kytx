//
//  NSData+Ext.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSData (Ext)

/*!
 *  将二进制转换成字符串
 *
 *  @return 字符串
 */
- (NSString *)toString;

+ (NSString *)toString:(NSData *)data;



@end
