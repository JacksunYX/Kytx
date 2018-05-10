//
//  GeneralGoodsModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralGoodsModel : NSObject

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *original_img;
@property (nonatomic, copy) NSString *market_price;
@property (nonatomic, copy) NSString *shop_price;
@property (nonatomic, copy) NSString *loves;
/** 商品排行榜 */
@property (nonatomic, copy ) NSString *listString;
/** 商品购买按钮　 */
@property (nonatomic, copy ) NSString *buybuttontextString;

@end
