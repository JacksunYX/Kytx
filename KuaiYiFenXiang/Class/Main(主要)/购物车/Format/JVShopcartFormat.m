//
//  JVShopcartFormat.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartFormat.h"
#import "JVShopcartBrandModel.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>

@interface JVShopcartFormat ()

@property (nonatomic, strong) NSMutableArray *shopcartListArray;    /**< 购物车数据源 */

@end

@implementation JVShopcartFormat

//这是请求购物车数据源的方法，大家一般都是对AFNetworking进行二次封装来请求数据。
- (void)requestShopcartProductList {
    //    //在这里请求数据 当然我直接用本地数据模拟的
    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopcart" ofType:@"plist"];
    //    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    //    self.shopcartListArray = [JVShopcartBrandModel mj_objectArrayWithKeyValuesArray:dataArray];
    //
    //    //成功之后回调
    //    [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:self.shopcartListArray];
    ////    [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:nil];
    
    [self requestcarlistdata];
    
}

//这是用户选中了某个产品或某个row的处理方法，因为这会改变底部结算视图所以一定会回调上文协议中的第二个方法， 下同。
- (void)selectProductAtIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    JVShopcartProductModel *productModel = brandModel.products[indexPath.row];
    productModel.isSelected = isSelected;
    
    BOOL isBrandSelected = YES;
    
    for (JVShopcartProductModel *aProductModel in brandModel.products) {
        if (aProductModel.isSelected == NO) {
            isBrandSelected = NO;
        }
    }
    
    brandModel.isSelected = isBrandSelected;
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

//这是用户选中了某个品牌或某个section的处理方法
- (void)selectBrandAtSection:(NSInteger)section isSelected:(BOOL)isSelected {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[section];
    brandModel.isSelected = isSelected;
    
    for (JVShopcartProductModel *aProductModel in brandModel.products) {
        aProductModel.isSelected = brandModel.isSelected;
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

//这是用户改变了商品数量的处理方法
- (void)changeCountAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    JVShopcartProductModel *productModel = brandModel.products[indexPath.row];
    if (count <= 0) {
        count = 1;
    } else if (count > productModel.productStocks) {
        count = productModel.productStocks;
    }
    
    //根据请求结果决定是否改变数据
    productModel.productQty = count;
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

//这是用户删除操作的处理方法
- (void)deleteProductAtIndexPath:(NSIndexPath *)indexPath {
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    JVShopcartProductModel *productModel = brandModel.products[indexPath.row];
    
    NSLog(@"删除-----%@-----%@",brandModel,productModel);
    
    //根据请求结果决定是否删除
    [brandModel.products removeObject:productModel];
    if (brandModel.products.count == 0) {
        [self.shopcartListArray removeObject:brandModel];
    } else {
        if (!brandModel.isSelected) {
            BOOL isBrandSelected = YES;
            for (JVShopcartProductModel *aProductModel in brandModel.products) {
                if (!aProductModel.isSelected) {
                    isBrandSelected = NO;
                    break;
                }
            }
            
            if (isBrandSelected) {
                brandModel.isSelected = YES;
            }
        }
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
    if (self.shopcartListArray.count == 0) {
        [self.delegate shopcartFormatHasDeleteAllProducts];
    }
}

- (void)beginToDeleteSelectedProducts {
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (JVShopcartProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                [selectedArray addObject:productModel];
            }
        }
    }
    
    [self.delegate shopcartFormatWillDeleteSelectedProducts:selectedArray];
}

- (void)deleteSelectedProducts:(NSArray *)selectedArray {
    //网络请求
    //根据请求结果决定是否批量删除
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        [brandModel.products removeObjectsInArray:selectedArray];
        
        if (brandModel.products.count == 0) {
            [emptyArray addObject:brandModel];
        }
    }
    
    if (emptyArray.count) {
        [self.shopcartListArray removeObjectsInArray:emptyArray];
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
    if (self.shopcartListArray.count == 0) {
        [self.delegate shopcartFormatHasDeleteAllProducts];
    }
}

//这是用户收藏操作的处理方法，这里没有回调任何方法，也可以根据需求添加回调方法。
- (void)starProductAtIndexPath:(NSIndexPath *)indexPath {
    //这里写收藏的网络请求
    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    JVShopcartProductModel *productModel = brandModel.products[indexPath.row];
    
    NSLog(@"收藏------%@------%@",brandModel,productModel);
    
}

- (void)starSelectedProducts{
    
    //这里写批量收藏的网络请求
    NSLog(@"批量收藏");
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (JVShopcartProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                [selectedArray addObject:productModel];
            }
        }
    }
    
    [self.delegate shopcartFormatWillCollectSelectedProducts:selectedArray];
    
}

//这是用户全选操作的处理方法
- (void)selectAllProductWithStatus:(BOOL)isSelected {
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        brandModel.isSelected = isSelected;
        for (JVShopcartProductModel *productModel in brandModel.products) {
            productModel.isSelected = isSelected;
        }
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

//这是用户结算操作的处理方法
- (void)settleSelectedProducts {
    NSMutableArray *settleArray = [[NSMutableArray alloc] init];
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
        for (JVShopcartProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                [selectedArray addObject:productModel];
            }
        }
        
        brandModel.selectedArray = selectedArray;
        
        if (selectedArray.count) {
            [settleArray addObject:brandModel];
        }
    }
    
    [self.delegate shopcartFormatSettleForSelectedProducts:settleArray];
}

#pragma mark private methods

- (float)accountTotalPrice {
    float totalPrice = 0.f;
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (JVShopcartProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                totalPrice += productModel.productPrice * productModel.productQty;
            }
        }
    }
    
    return totalPrice;
}

- (NSInteger)accountTotalCount {
    NSInteger totalCount = 0;
    
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (JVShopcartProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                totalCount += productModel.productQty;
            }
        }
    }
    
    return totalCount;
}

- (BOOL)isAllSelected {
    if (self.shopcartListArray.count == 0) return NO;
    
    BOOL isAllSelected = YES;
    
    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.isSelected == NO) {
            isAllSelected = NO;
        }
    }
    
    return isAllSelected;
}


- (void)requestcarlistdata{
    
    
    self.shopcartListArray = [NSMutableArray new];
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(cList) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSMutableArray *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        
                                        if (!kArrayIsEmpty(result)) {
                                            
                                            for (NSDictionary *dic in result) {
                                                
                                                NSString *business_idstring=[dic objectForKey:@"business_id"];
                                                NSString *shop_namestring=[dic objectForKey:@"shop_name"];
                                                
                                                NSMutableArray *products=[NSMutableArray new];
                                                
                                                NSMutableArray *goodsarray=[dic objectForKey:@"goods"];
                                                for (NSDictionary *goodsdic in goodsarray) {
                                                    
                                                    NSDictionary *productdic=@{
                                                                               @"specWidth":@(18),//NSInteger 宽
                                                                               @"specHeight":@(18),//NSInteger 高
                                                                               @"specLength":@(18),//NSInteger 长
                                                                               @"cart_id":[goodsdic objectForKey:@"id"],//NSString  品牌图片
                                                                               @"spec_key_name":kStringIsEmpty([goodsdic objectForKey:@"spec_key_name"])?@"":[goodsdic objectForKey:@"spec_key_name"],//NSString  产品属性
                                                                               @"productStyle":@"产品类型",//NSString  产品类型
                                                                               @"brandPicUri":[goodsdic objectForKey:@"original_img"],//NSString  品牌图片
                                                                               @"productId":[goodsdic objectForKey:@"goods_id"],//NSString。品牌ID
                                                                               @"productType":@"产品类型",//NSString。产品类型
                                                                               @"brandName":[goodsdic objectForKey:@"shop_name"],//NSString。品牌名称
                                                                               @"brandId":[goodsdic objectForKey:@"business_id"],//NSString。品牌ID
                                                                               @"productStocks":[goodsdic objectForKey:@"store_count"],//NSInteger 产品库存
                                                                               @"productNum":[goodsdic objectForKey:@"goods_num"],//NSString。产品个数
                                                                               @"cartId":[goodsdic objectForKey:@"id"],//NSString。购物车ID
                                                                               @"productQty":[goodsdic objectForKey:@"goods_num"],//NSInteger     产品当前个数
                                                                               @"originPrice":[goodsdic objectForKey:@"market_price"],//NSInteger。商品原价
                                                                               @"productPrice":[goodsdic objectForKey:@"member_goods_price"],//NSInteger。商品价格
                                                                               @"productName":[goodsdic objectForKey:@"goods_name"],//NSString。商品名称
                                                                               @"productPicUri":[goodsdic objectForKey:@"original_img"],//NSString。商品图片
                                                                               @"isSelected":@NO,//BOOL。是否是选中状态
                                                                               @"activitysmallimageurlString":@"",//NSString。活动小图标
                                                                               @"activitysmalltextString":@"",//NSString  活动内容
                                                                               };
                                                    
                                                    [products addObject:productdic];
                                                    
                                                }
                                                
                                                NSDictionary *shoppingcardic=@{
                                                                               @"brandName":shop_namestring,//NSInteger 宽
                                                                               @"brandId":business_idstring,//NSInteger 高
                                                                               @"products":products,//NSInteger 长
                                                                               };
                                                [self.shopcartListArray addObject:[JVShopcartBrandModel mj_objectWithKeyValues:shoppingcardic]];
                                                
                                            }
                                            
                                            [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:self.shopcartListArray];
                                            
                                            
                                        }else{
                                            [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:nil];
                                        }
                                        
                                    }else{
                                        
                                        [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:nil];
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}


@end

