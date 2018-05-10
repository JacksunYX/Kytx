//
//  JVShopcartFooterView.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsUnifiedModel;

@protocol RefreshFootViewDelegate <NSObject>
@optional

/**
 已经加载完首部数据
 */
-(void)haveloadHeadData;

/**
 已经加载完底部数据
 */
-(void)haveLoadFootData:(BOOL)finishLoad;

@end

@interface JVShopcartFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^didSelectedJVShopcartFooterView)(NSString *goodidstring);

@property (strong , nonatomic)NSMutableArray<GoodsUnifiedModel *> *dataSource;

@property (nonatomic,weak) id<RefreshFootViewDelegate> delegate;

@end
