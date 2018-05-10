//
//  GoodsDetailsViewController.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  GeneralGoodsModel;
@interface GoodsDetailsViewController : UIViewController
@property (strong , nonatomic)GeneralGoodsModel *GeneralGoodsModel;
@property (strong , nonatomic)NSString *goods_id;
@end
