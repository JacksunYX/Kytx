//
//  NewAddressViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYAddressModel.h"
#import "AreaModel.h"

@interface NewAddressViewController : UIViewController

@property (nonatomic, strong) KYAddressModel *model;

@property (nonatomic, assign) BOOL is_default;
@property (nonatomic, copy) void(^refreshHandler)();

@property (nonatomic, strong) NSArray<AreaModel *> *provinceArray;
@property (nonatomic, strong) NSArray<AreaModel *> *cityArray;
@property (nonatomic, strong) NSArray<AreaModel *> *districtArray;
@property (nonatomic, strong) NSArray<AreaModel *> *townArray;

- (void)editMode;

@end
