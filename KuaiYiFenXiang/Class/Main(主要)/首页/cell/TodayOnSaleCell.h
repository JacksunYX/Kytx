//
//  TodayOnSaleCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//
//首页今日特卖的自定义cell

#import <UIKit/UIKit.h>

#import "TodayOnSaleModel.h"    //新增今日特价模块model

#define TodayOnSaleCellHeight (165 * ScreenH/667)

@protocol TodayOnSaleClickDelegate <NSObject>
@optional
-(void)clickonRow:(NSInteger)row OnIndex:(NSInteger)index;

@end

@interface TodayOnSaleCell : UICollectionViewCell

@property (nonatomic,weak) id<TodayOnSaleClickDelegate> delegate;

//设置数据
-(void)setupViewWithDataArr:(NSArray *)dataArr;

@property (nonatomic,strong) TodayOnSaleModel *model;

@end
