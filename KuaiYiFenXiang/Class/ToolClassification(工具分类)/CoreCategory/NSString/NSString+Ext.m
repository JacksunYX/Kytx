//
//  NSString+Ext.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "NSString+Ext.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "NSData+Ext.h"

@implementation NSString (Ext)

- (NSString *)trimLeft {
  NSUInteger len = 0;
  NSString *resultString = @"";
  while (len < self.length) {
    if ([self characterAtIndex:len] == ' ') {
      if (len + 1 < self.length) {
        resultString = [self substringFromIndex:len + 1];
      }
    } else {
      return resultString;
    }
    len++;
  }
  return self;
}

- (NSString *)trimRight {
  NSString *tempString = [self trimLeft];
  NSUInteger count = 0;
  while (count < tempString.length) {
    if ([tempString characterAtIndex:count] == ' ') {
      return [tempString substringToIndex:count];
    }
    count++;
  }
  return tempString;
}

- (NSString *)trim {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// _min _min_min
- (NSString *)insertAbbr:(NSString *)abbrStr
{
    NSRange ran = [self rangeOfString:@"." options:NSBackwardsSearch];
    if (ran.location != NSNotFound) {
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:self];
        [tmpString insertString:abbrStr atIndex:ran.location];
        
        return tmpString;
    }
    
    return self;
}

- (NSString *)trimAll {
  NSString *tempString = self.trim;
  return [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)trimLetters {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
}

- (NSString *)trimCharacter:(unichar)character {
  NSString *str = [NSString stringWithFormat:@"%c", character];
  return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

- (NSString *)trimWhitespace {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
  return [self componentsSeparatedByString:@"\n"].count + 1;
}

- (BOOL)isEmpty {
  return self == nil || self.length == 0;
}

- (BOOL)isTrimEmpty {
    
//    return self == nil ? YES : self.trim.length == 0);
  return self == nil || self.trim.length == 0;
}

- (NSString *)nullString
{
    if ([self isEmpty] || [self isTrimEmpty]) {
        return @"";
    }
    return self;
}


- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    //  [\u4e00-\u9fa5A-Za-z0-9_]{4,20}
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
{
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)addPrefix:(NSString *)prefix {
  if (prefix == nil || prefix.length == 0) {
    return self;
  }
  
  return [NSString stringWithFormat:@"%@%@", prefix, self];
}

- (NSString *)addSubfix:(NSString *)subfix {
  if (subfix == nil || subfix.length == 0) {
    return self;
  }
  
  return [NSString stringWithFormat:@"%@%@", self, subfix];
}

@end
