//
//  CheckLogicCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/16.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//
//查看物流cell

#import <UIKit/UIKit.h>

@interface CheckLogicModel : NSObject

@property (nonatomic,copy) NSString *goodImg;       //商品图片
@property (nonatomic,copy) NSString *good_name;     //商品名称
@property (nonatomic,copy) NSString *good_price;    //现价
@property (nonatomic,copy) NSString *originalPrice; //原价

@end

#define CheckLogicCellID @"CheckLogicCellID"

@interface CheckLogicCell : UITableViewCell

@property (nonatomic,strong) CheckLogicModel *model;

@end
