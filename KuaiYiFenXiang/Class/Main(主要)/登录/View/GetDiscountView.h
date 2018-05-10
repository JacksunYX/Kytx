//
//  GetDiscountView.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickToGetDiscount)();
typedef void(^ClickToClose)();

@interface GetDiscountView : UIView

@property (nonatomic,copy) ClickToGetDiscount getDiscountBlock;
@property (nonatomic,copy) ClickToClose closeBlock;

@end
