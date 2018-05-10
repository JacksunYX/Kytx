//
//  DCGoodsYouLikeCell.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewproductrecommendationModel.h"

@class NewproductrecommendationModel;

@interface DCGoodsYouLikeCell : UICollectionViewCell

/* 推荐数据 */
@property (strong , nonatomic)NewproductrecommendationModel *youLikeItem;
/* 相同 */
@property (strong , nonatomic)UIButton *sameButton;
/** 找相似点击回调 */
@property (nonatomic, copy) dispatch_block_t lookSameBlock;

@end
