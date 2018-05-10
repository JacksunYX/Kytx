//
//  SubclassModuleViewController.h
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "YYDHLBaseViewController.h"

@protocol SubClassVCRefreshDelegate <NSObject>
@optional
-(void)subVCDataHaveRefresh;
@end

@interface SubclassModuleViewController : YYDHLBaseViewController

@property (nonatomic,weak) id<SubClassVCRefreshDelegate> delegate;

@property(nonatomic,copy)NSString *titlestring;
@property(nonatomic,copy)NSString *titleid;
@property(nonatomic,copy)NSString *categoryzoneid;
@property(nonatomic,copy)NSString *currentIndexId;
@property(nonatomic,copy)NSString *categorynameNumString;

//快递编号(用来查询物流公司)
@property(nonatomic,copy)NSString *logisticsTypeString;
//快递单号(查询物流)
@property(nonatomic,copy)NSString *logisticsNoString;
//物流电话
@property(nonatomic,copy)NSString *logisticsPhone;


@property(nonatomic,copy)NSString *a_id;   //分类父id
//物流信息数组
@property (strong , nonatomic)NSMutableArray *TradeLogisticsDataSource;

//新增











@end
