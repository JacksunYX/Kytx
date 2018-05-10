//
//  GroupPayModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupPayModel : NSObject

@property (nonatomic,copy) NSString *title;     //标题
@property (nonatomic,copy) NSString *subTitle;  //子标题
@property (nonatomic,copy) NSString *imgStr;    //图标
@property (nonatomic,copy) NSString *money;     //右边的金额，也可能是其他的

@end
