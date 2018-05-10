//
//  AddressHelper.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressHelper : NSObject

/**
 获取地域数组
 */
-(void)getArearList;

/**
 获取地址数组
 */
-(void)getAdressList;

/**
 删除沙盒里的文件
 */
+(void)deleteAreaFile:(NSString *)fileName;



@end
