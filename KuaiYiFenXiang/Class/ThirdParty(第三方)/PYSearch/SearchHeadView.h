//
//  SearchHeadView.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/15.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  类型自定义
 */
typedef void (^SearchHeadClickBlock) (NSString *strValue);

@interface SearchHeadView : UIView

/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property(nonatomic, copy) SearchHeadClickBlock searchheadClickBlock;


@end
