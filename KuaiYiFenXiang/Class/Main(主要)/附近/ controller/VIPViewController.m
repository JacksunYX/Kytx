//
//  VIPViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/24.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "VIPViewController.h"
#import "VIPTableViewCell.h"
#import "VIPDetailModel.h"
#import "VIPDetailViewController.h"

@interface VIPViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *address;

@end

@implementation VIPViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor333}];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"VIP礼包专区";
    self.view.backgroundColor = kWhiteColor;
    
    [self configTable];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(vipGoods) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            self.dataArray = [VIPDetailModel mj_objectArrayWithKeyValuesArray:res[@"result"][@"goodsInfo"]];
//            self.address = res[@"result"][@"address"];
            VIPDetailModel *t = self.dataArray.firstObject;
            NSLog(@"%@", t.business_info);
            [self.table reloadData];
        }
    } failure:nil RefreshAction:nil]; 
}

- (void)configTable {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    
    table.estimatedSectionHeaderHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedRowHeight = 0;
    table.tableFooterView = [UIView new];
    table.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self.view addSubview:table];
    
    table.dataSource = self;
    
    table.delegate = self;
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.sectionHeaderHeight = 0;
    table.sectionFooterHeight = 10;
    
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScaleWidth(550/2.0))];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VIP礼包"]];
    imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, ScaleHeight(533/2.0));
    [aview addSubview:imageview];
    table.tableHeaderView = aview;
    
    self.table = table;
    [table registerClass:[VIPTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VIPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.section];
    
    MCWeakSelf
    cell.clickHandler = ^(VIPDetailModel *model) {
        VIPDetailViewController *vc = [VIPDetailViewController new];
        vc.model = model;
//        vc.address = weakSelf.address;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
