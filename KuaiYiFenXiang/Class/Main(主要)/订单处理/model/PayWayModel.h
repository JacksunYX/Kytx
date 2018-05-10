//
//  PayWayModel.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayWayModel : NSObject

@property (nonatomic, copy) NSString *cellid;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) NSString *payimageUrlString;
@property (nonatomic, copy) NSString *paytextString;
@property (nonatomic, copy) NSString *paysmallimageUrlString;

@end
