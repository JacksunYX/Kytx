//
//  StoreDisplayHeadView.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/16.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreDisplayHeadView : UICollectionReusableView

- (void)setUpUI;

/** 筛选点击回调 */
@property (nonatomic, copy) dispatch_block_t filtrateClickBlock;

@property (nonatomic, copy) NSString *headImageUrl;


@end
