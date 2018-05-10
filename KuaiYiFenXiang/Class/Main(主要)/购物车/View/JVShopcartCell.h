//
//  JVShopcartCell.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JVShopcartProductModel.h"


typedef void(^ShopcartCellBlock)(BOOL isSelected);
typedef void(^ShopcartCellEditBlock)(NSInteger count);
//新增点击中部才跳转商品详情
typedef void(^ShopcartCellDidClick)();

/**
 *  类型自定义
 */
typedef void (^ReturnValueBlock) (UITableViewCell *deletecell);


typedef void (^RefreshBlock) (UITableViewCell *deletecell);


@interface JVShopcartCell : UITableViewCell


@property (nonatomic, copy) ShopcartCellBlock shopcartCellBlock;
@property (nonatomic, copy) ShopcartCellEditBlock shopcartCellEditBlock;
//新增点击中部才跳转商品详情
@property (nonatomic, copy) ShopcartCellDidClick shopcartCellDidClickBlock;
/**
 *  声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的
 */
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;


@property(nonatomic, copy) RefreshBlock refreshBlock;

@property (nonatomic, strong) JVShopcartProductModel *JVShopcartProductModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

+(CGFloat)cellHight:(JVShopcartProductModel *)jvspModel;


@end

