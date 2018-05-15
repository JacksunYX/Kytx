//
//  DiscountCouponChildVC.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "DiscountCouponChildVC.h"
#import "DiscountCouponCell.h"

@interface DiscountCouponChildVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datasource;
@end

@implementation DiscountCouponChildVC

#pragma mark --- 懒加载 ---
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        _tableView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        //注册
        [_tableView registerClass:[DiscountCouponCell class] forCellReuseIdentifier:DiscountCouponCellID];
        
        MCWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.tableView.mj_header endRefreshing];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }
    return _tableView;
}

-(NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray new];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BACKVIEWCOLOR;
    
    [self productDemoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//获取当前界面的优惠券列表
-(void)requestToGetCurrentDiscountConpons
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [HttpRequest postWithTokenURLString:NetRequestUrl(discountList) parameters:dic isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
    } failure:nil RefreshAction:nil];
    
}

//生成模拟数据
-(void)productDemoData
{
    NSArray *statusArr = @[
                           @"0",
                           @"1",
                           @"1",
                           @"2",
                           @"2"
                           ];
    NSArray *limitMoneyArr = @[
                               @"5",
                               @"10",
                               @"15",
                               @"5",
                               @"20",
                               ];
    NSArray *startTimeArr = @[
                              @"2018-05-07",
                              @"2018-05-10",
                              @"2018-05-15",
                              @"2018-05-20",
                              @"2018-06-01",
                              ];
    NSArray *endTimeArr = @[
                            @"2018-06-07",
                            @"2018-06-10",
                            @"2018-06-15",
                            @"2018-06-20",
                            @"2018-07-01",
                            ];
    
    NSArray *usableArr = @[
                           @"20",
                           @"30",
                           @"15",
                           @"50",
                           @"88",
                           ];
    
    for (int i = 0; i < statusArr.count; i ++) {
        DiscountCouponModel *model = [DiscountCouponModel new];
        model.status = statusArr[i];
        model.limit = limitMoneyArr[i];
        model.startTime = startTimeArr[i];
        model.endTime = endTimeArr[i];
        model.usable = usableArr[i];
        [self.datasource addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark ----- UITableViewDataSource -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscountCouponCell *cell = (DiscountCouponCell *)[tableView dequeueReusableCellWithIdentifier:DiscountCouponCellID forIndexPath:indexPath];
    
    DiscountCouponModel *model = self.datasource[indexPath.section];
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}










@end
