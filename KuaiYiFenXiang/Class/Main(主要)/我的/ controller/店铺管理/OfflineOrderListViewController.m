//
//  OfflineOrderListViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OfflineOrderListViewController.h"
#import "OfflineOrderListTableViewCell.h"
#import "OfflineOrderListModel.h"
#import "GoPayViewController.h"

@interface OfflineOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView  *table;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger page;


@end

@implementation OfflineOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 0) {
        self.view.backgroundColor = [UIColor redColor];
    } else {
        self.view.backgroundColor = [UIColor greenColor];
    }
    [self configUI];
    [self loadDataWithpage:0];
}

- (void)loadDataWithpage:(NSInteger)page {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(self.type).description;
    dict[@"page"] = @(page).description;
    if (page == 0) {
        self.page = 0;
    }
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopOrder) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {

        HiddenHudOnly;
        if ([res[@"code"] integerValue] == 1) {
            NSArray *arr = res[@"result"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                [temp addObject:[self validDict:dict]];
            }
            if (page == 0) {
                self.dataArray = [OfflineOrderListModel mj_objectArrayWithKeyValuesArray:temp];
                [self.table.mj_footer endRefreshing];
            } else {
                if (temp.count == 0) {
                    self.page--;
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.dataArray = [self.dataArray arrayByAddingObjectsFromArray:[OfflineOrderListModel mj_objectArrayWithKeyValuesArray:temp]];
                    [self.table.mj_footer endRefreshing];
                }
            }
            [self.table.mj_header endRefreshing];
            [self.table reloadData];
        } else {
            if ([self.table.mj_header isRefreshing]) {
                [self.table.mj_header endRefreshing];
            }
            
            if ([self.table.mj_footer isRefreshing]) {
                [self.table.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:nil RefreshAction:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)configUI {
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    
    _table.tableFooterView = [UIView new];
    _table.backgroundColor = kDefaultBGColor;
    
    [self.view addSubview:_table];
    
    _table.dataSource = self;
    
    _table.delegate = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _table.sectionHeaderHeight = 0;
    _table.sectionFooterHeight = 10;
    _table.estimatedRowHeight = 0;
    _table.estimatedSectionFooterHeight = 0;
    _table.estimatedSectionHeaderHeight = 0;
    _table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    MCWeakSelf
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithpage:0];
    }];
    
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadDataWithpage:++weakSelf.page];
    }];
    [_table.mj_footer setAutomaticallyHidden:YES];
    [_table registerClass:[OfflineOrderListTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfflineOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.type = self.type;
    cell.model = self.dataArray[indexPath.section];
    
    MCWeakSelf
    cell.clickHandler = ^(NSString *order_sn) {
        [weakSelf deleteOrder:order_sn];
    };
    
    cell.clickPay = ^(NSString *order_sn, NSString *price) {
        [weakSelf pay:order_sn price:price];
    };
    return cell;
}

- (void)pay:(NSString *)order_sn price:(NSString *)price{
    GoPayViewController *vc = [GoPayViewController new];
    vc.type = @"5";
    vc.tn = order_sn;
    vc.price = price;
    MCWeakSelf
    vc.handler = ^{
        [weakSelf loadDataWithpage:0];
        [weakSelf.table scrollToTop];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)deleteOrder:(NSString *)order_sn {
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(deleteOfflineOrder) parameters:[@{@"order_sn":order_sn} mutableCopy] isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            [self loadDataWithpage:0];
        }
    } failure:nil RefreshAction:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 215;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
