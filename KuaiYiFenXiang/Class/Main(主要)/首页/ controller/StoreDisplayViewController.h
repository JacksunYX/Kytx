//
//  StoreDisplayViewController.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/16.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "YYDHLBaseViewController.h"
#import "TheStoreModel.h"
@interface StoreDisplayViewController : YYDHLBaseSearchBarViewController
@property (nonatomic,copy)NSString *business_idstring;
@property (nonatomic,strong)TheStoreModel *TheStoreModel;
@end
