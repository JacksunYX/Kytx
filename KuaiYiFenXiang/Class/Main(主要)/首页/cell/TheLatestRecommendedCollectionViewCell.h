//
//  TheLatestRecommendedCollectionViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/12.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsUnifiedModel.h"

@interface TheLatestRecommendedCollectionViewCell : UICollectionViewCell

@property (strong , nonatomic)GoodsUnifiedModel *GoodsUnifiedModel;

@property (strong , nonatomic)GeneralGoodsModel *GeneralGoodsModel;

@end
