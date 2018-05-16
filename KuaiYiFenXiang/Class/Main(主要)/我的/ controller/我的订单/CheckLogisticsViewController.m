//
//  CheckLogisticsViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/16.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "CheckLogisticsViewController.h"
#import "CheckLogicCell.h"

@interface CheckLogisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datasource;

@end

@implementation CheckLogisticsViewController

#pragma mark --- 懒加载 ---
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[CheckLogicCell class] forCellReuseIdentifier:CheckLogicCellID];
        [self.view addSubview:_tableView];
        
        _tableView.sd_layout
        .leftEqualToView(self.view)
        .topEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
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
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.navigationItem.title = @"查看物流";
    self.tableView.backgroundColor = BACKVIEWCOLOR;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}





#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.datasource.count;
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckLogicCell *cell = (CheckLogicCell *)[tableView dequeueReusableCellWithIdentifier:CheckLogicCellID forIndexPath:indexPath];
    cell.accessoryType = 1;
    kArrayIsEmpty(self.datasource)?:[cell setModel:self.datasource[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
