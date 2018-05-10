//
//  GetLocation.h
//  GlobalAuto
//
//  Created by Longxia on 16/7/8.
//  Copyright © 2016年 jmhqmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetLocation : NSObject

/**
 创建user单例
 */

@property(nonatomic,copy)void(^block)(NSDictionary *dict);

+(GetLocation *)getLocationManager;

- (void)getMyLocation;  //在此获得

@end
