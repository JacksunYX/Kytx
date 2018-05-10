//
//  NSMutableDictionary+Ext.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSMutableDictionary+Ext.h"

@implementation NSMutableDictionary (Ext)

- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for(id key in keys)
    {
        id oneValue = [self objectForKey:key];
        id oneCopy = nil;
        
        oneCopy = [oneValue copy];
        
        
        [ret setValue:oneCopy
               forKey:key];
        
    }
    return ret;
}

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (aKey == nil) {
    return;
  }
  
  if (anObject == nil) {
    return;
  }
  
  if ([anObject isKindOfClass:[NSString class]]) {
    NSString *obj = (NSString *)anObject;
    if (obj.length == 0) {
      return;
    }
  }
  
  [self setObject:anObject forKey:aKey];
}

- (void)setInt:(int)intValue forKey:(id<NSCopying>)aKey {
  [self setSafeObject:@(intValue) forKey:aKey];
}

- (void)setDouble:(double)doubleValue forKey:(id<NSCopying>)aKey {
  [self setSafeObject:@(doubleValue) forKey:aKey];
}

- (void)setFloat:(float)floatValue forKey:(id<NSCopying>)aKey {
  [self setSafeObject:@(floatValue) forKey:aKey];
}

@end
