//
//  JVShopcartTableViewProxy.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class JVShopcartProductModel;
typedef void(^ShopcartProxyProductSelectBlock)(BOOL isSelected, NSIndexPath *indexPath);
typedef void(^ShopcartProxyBrandSelectBlock)(BOOL isSelected, NSInteger section);
typedef void(^ShopcartProxyChangeCountBlock)(NSInteger count, NSIndexPath *indexPath);
typedef void(^ShopcartProxyDeleteBlock)(NSIndexPath *indexPath,JVShopcartProductModel *model);
typedef void(^ShopcartProxyStarBlock)(NSIndexPath *indexPath,JVShopcartProductModel *model);
typedef void(^ShopcartProxyTopRefresh)();
typedef void(^ShopcartProxyBottomRefresh)(BOOL finishLoad);

//滚动式滚动时回调
typedef void(^ScrollViewDidScrolled)(UIScrollView *scrollView);

@interface JVShopcartTableViewProxy : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) ShopcartProxyProductSelectBlock shopcartProxyProductSelectBlock;
@property (nonatomic, copy) ShopcartProxyBrandSelectBlock shopcartProxyBrandSelectBlock;
@property (nonatomic, copy) ShopcartProxyChangeCountBlock shopcartProxyChangeCountBlock;
@property (nonatomic, copy) ShopcartProxyDeleteBlock shopcartProxyDeleteBlock;
@property (nonatomic, copy) ShopcartProxyStarBlock shopcartProxyStarBlock;

@property (nonatomic, copy) ShopcartProxyTopRefresh shopcartProxyTopRefreshBlock;
@property (nonatomic, copy) ShopcartProxyBottomRefresh shopcartProxyBottomRefreshBlock;

@property (nonatomic, copy) void(^didSelectedJVShopcartTableViewProxy)(NSString *goodidstring);

@property (nonatomic, copy) void(^didSelectedBlankPageButton)(NSString *buttonText);

@property (nonatomic, copy) void(^didSelectedRowBlock)(JVShopcartProductModel *model);

@property (nonatomic,copy) ScrollViewDidScrolled scrollViewDidScrolledBlock;

@end

