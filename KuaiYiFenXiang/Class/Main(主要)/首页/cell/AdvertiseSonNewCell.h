//
//  AdvertiseSonNewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/26.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//
//包含2个商品的自定义tableViewcell

#import <UIKit/UIKit.h>

#define AdvertiseSonNewCellID   @"AdvertiseSonNewCellID"

@protocol TwoSonCellDelegate <NSObject>
@optional
-(void)clickHandleGoodsData:(GeneralGoodsModel *)model;

@end

@interface AdvertiseSonNewCell : UITableViewCell

@property(nonatomic,weak) id<TwoSonCellDelegate> delegate;

//加载数据
-(void)setDataLeft:(GeneralGoodsModel *)leftModel right:(GeneralGoodsModel *)rightModel;



@end
