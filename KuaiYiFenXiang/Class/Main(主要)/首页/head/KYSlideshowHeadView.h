//
//  KYSlideshowHeadView.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  类型自定义
 */
typedef void (^KYSlideshowHeadViewBlock) (NSInteger index);


@interface KYSlideshowHeadView : UICollectionReusableView
/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property(nonatomic, copy) KYSlideshowHeadViewBlock kyslideshowheadviewBlock;

@property (strong , nonatomic)NSMutableArray *imageURLStringsGroup;

@end
