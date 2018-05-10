//
//  YYFCollectionReusableView.h
//  NewProject
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YCRVReturnValueBlock) (NSString *btntitleStr);

@interface YYFCollectionReusableView : UICollectionReusableView

/** 筛选点击回调 */
@property (nonatomic, copy) YCRVReturnValueBlock returnValueBlock;

@end
