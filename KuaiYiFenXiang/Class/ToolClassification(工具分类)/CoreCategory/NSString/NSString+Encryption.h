//
//  NSString+MD5Addition.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Encryption)

/**
 *  md5 Encryption
 *
 *  @return return the result of Encryption
 */

- (NSString *)md5;
- (NSString *)SHA1;
- (NSString *)SHA256;
- (NSString *)SHA512;



@end
