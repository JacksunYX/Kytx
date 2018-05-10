//
//  DCGoodsCountDownCell.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRecommendItem.h"

@interface DCGoodsCountDownCell : UICollectionViewCell

/* 推荐商品数据 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *countDownItem;

@end
