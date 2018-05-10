//
//  CheckLogisticsPopView.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckLogisticsPopView : UIView

@property(nonatomic,copy)NSString *logisticsTypeString;
@property(nonatomic,copy)NSString *logisticsNoString;
-(void)loadTradeLogisticsData:(NSString *)logisticsnsmeString andlogisticsnoString:(NSString *)logisticsnsnoString;
@end
