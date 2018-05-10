//
//  DCTopLineFootView.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  类型自定义
 */
typedef void (^DCTopLineFootViewBlock) (NSInteger selectIndex);

typedef void (^DCTopLineFootViewMoreBlock) ();

@interface DCTopLineFootView : UICollectionReusableView

/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property(nonatomic, copy) DCTopLineFootViewBlock dctoplinefootviewblock;

@property(nonatomic, copy) DCTopLineFootViewMoreBlock dctoplinefootviewmoreblock;

@property (strong , nonatomic)NSMutableArray *noticeList;

- (void)setUpUI;


@end
