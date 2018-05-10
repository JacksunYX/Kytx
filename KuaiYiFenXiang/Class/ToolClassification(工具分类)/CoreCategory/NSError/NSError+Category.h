//
//  NSError+Category.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

/**
 * 加密算法错误Error Domin
 */
extern NSString * const kCommonCryptoErrorDomain;

@interface NSError (Category)

/**
 * 根据加密算法状态，生成错误对象
 */
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;

@end
