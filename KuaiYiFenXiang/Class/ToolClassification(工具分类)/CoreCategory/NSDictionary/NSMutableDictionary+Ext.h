//
//  NSMutableDictionary+Ext.h
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Ext)

- (NSMutableDictionary *)mutableDeepCopy;

/**
 * 调用此方法来防止无效值时崩溃的问题
 */
- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setInt:(int)intValue forKey:(id<NSCopying>)aKey;
- (void)setDouble:(double)doubleValue forKey:(id<NSCopying>)aKey;
- (void)setFloat:(float)floatValue forKey:(id<NSCopying>)aKey;

@end
