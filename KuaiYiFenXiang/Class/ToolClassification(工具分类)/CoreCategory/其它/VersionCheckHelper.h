//
//  VersionCheckHelper.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(NSInteger backCode,NSURL *openUrl,NSString *versionNum);

@interface VersionCheckHelper : NSObject

/**
 检测版本
 */
+(void)questToCheckVersion:(success)successBlock ;



@end
