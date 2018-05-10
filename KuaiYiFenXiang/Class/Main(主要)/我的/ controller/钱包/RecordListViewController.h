//
//  RecordListViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface RecordListViewController : UIViewController
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, copy) void(^pushHander)(RecordModel *model);
- (void)filterArray;

@end
