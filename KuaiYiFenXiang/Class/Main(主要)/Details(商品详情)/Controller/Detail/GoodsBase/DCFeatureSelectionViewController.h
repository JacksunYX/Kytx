//
//  DCFeatureSelectionViewController.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DCFeatureSelectionViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *RootAttributeArray;
@property (nonatomic, strong) NSMutableArray *Spec_goods_priceArray;
@property (nonatomic, strong) NSDictionary *goods_infodictionary;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;
/* 上一次选择的属性 */
@property (strong , nonatomic)NSArray *lastSeleArray;
/* 上一次选择的数量 */
@property (assign , nonatomic)NSInteger lastNum;

/** 选择的属性和数量 */
@property (nonatomic , copy) void(^userChooseBlock)(NSMutableArray *seleArray,NSInteger num,NSInteger tag,NSMutableDictionary *addCartDic);

@end
