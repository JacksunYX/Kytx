//
//  DCEmptyCartView.h
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCEmptyCartView : UITableViewHeaderFooterView

/** 抢购点击回调 */
@property (nonatomic, copy) dispatch_block_t collectionButtonClickBlock;

/** 抢购点击回调 */
@property (nonatomic, copy) dispatch_block_t browseButtonClickBlock;

@end
