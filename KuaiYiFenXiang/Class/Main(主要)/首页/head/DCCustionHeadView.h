//
//  DCCustionHeadView.h
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  类型自定义
 */
typedef void (^DCCustionHeadViewBlock) (NSString *strValue);

@interface DCCustionHeadView : UICollectionReusableView

- (void)setUpUI;

/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property(nonatomic, copy) DCCustionHeadViewBlock dccustionheadviewblock;
/** 筛选点击回调 */
@property (nonatomic, copy) dispatch_block_t filtrateClickBlock;

@property (nonatomic, copy) NSString *headImageUrl;

@end
