//
//  GoodsUnifiedModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsUnifiedModel : NSObject



@property (nonatomic, copy ) NSString *cellidStr;

/** 图片URL */
@property (nonatomic, copy ) NSString *imageurlString;
/** 商品标题 */
@property (nonatomic, copy ) NSString *maintitleString;
/** 商品原价 */
@property (nonatomic, copy ) NSString *originalpriceString;
/** 商品现价 */
@property (nonatomic, copy ) NSString *presentpriceString;
/** 商品积分 */
@property (nonatomic, copy ) NSString *integralString;
/** 商品排行榜 */
@property (nonatomic, copy ) NSString *listString;
/** 商品购买按钮　 */
@property (nonatomic, copy ) NSString *buybuttontextString;
/** 商品规格　 */
@property (nonatomic, copy ) NSString *productspecificationsString;
/** 已售　 */
@property (nonatomic, copy ) NSString *soldString;


@end
