//
//  CashOutDetailViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "CashOutDetailViewController.h"
#import "KYHeader.h"
#import "CashTableViewCell.h"
#import "CashModel.h"

@interface CashOutDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sectionYearArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, strong) UILabel *totalLabel;

@end

@implementation CashOutDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现记录";
    self.view.backgroundColor = kDefaultBGColor;
    
    [self navi];
    [self configUI];
    [self loadData];
}

- (void)navi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
//    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    dict[@"type"] = @"3";
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(cashdetail) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        NSArray *arr = [CashModel mj_objectArrayWithKeyValuesArray:res[@"result"][@"data"]];
        if (arr == nil || arr.count == 0) {
            [self showEmpty];
            return ;
        }
        self.dataArray = [arr mutableCopy];
        
        self.totalLabel.text = [NSString stringWithFormat:@"%.2f", [res[@"result"][@"total_money"] floatValue]];
        [arr enumerateObjectsUsingBlock:^(CashModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            if (idx == 0) {
                [self.sectionYearArray addObject:[NSString stringWithFormat:@"%@年%@月", @(model.year).description, @(model.month).description]];
                model.showTitle = YES;
            } else {
                CashModel *temp = arr[idx-1];
                if ((temp.year == model.year) && (temp.month == model.month)) {
                } else {
                    [self.sectionYearArray addObject:[NSString stringWithFormat:@"%@年%@月", @(model.year).description, @(model.month).description]];
                }
                
                if (temp.month != model.month) {
                    model.showTitle = YES;
                } else if ((temp.day != model.day) && (temp.month == model.month)) {
                    model.showTitle = YES;
                }
            }
        }];
        
        for (NSString *monthStr in self.sectionYearArray) {
            NSMutableArray *temparr = [NSMutableArray array];
            for (CashModel *model in self.dataArray) {
                NSString *str = [NSString stringWithFormat:@"%ld年%ld月", model.year, model.month];
                if ([str isEqualToString:monthStr]) {
                    [temparr addObject:model];
                }
            }
            self.dataDict[monthStr] = temparr;
            
            [self.statusArray addObject:@"1"];
        }
        [self.table reloadData];
        
        
    } failure:nil RefreshAction:nil];
}

- (void)showEmpty {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无提现记录"]];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150+ScaleHeight(492/2.0));
    }];
}

- (void)configUI {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"累计提现记录"]];
    
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(ScaleHeight(492/2.0));
    }];
    
    UILabel *label = [UILabel new];
    self.totalLabel = label;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"";
    label.textColor = [UIColor colorWithHexString:@"ff9000"];
    label.font = kFont(24);
    [imageview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview);
        make.top.equalTo(imageview).offset(ScaleWidth(150));
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, ScaleHeight(492/2.0), SCREEN_WIDTH, SCREEN_HEIGHT-ScaleHeight(492/2.0)) style:UITableViewStylePlain];
    
//    table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    table.separatorColor = [UIColor colorWithHexString:@"cccccc"];
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = kDefaultBGColor;
    [table registerClass:[CashTableViewCell class] forCellReuseIdentifier:@"cell"];
    [table registerClass:[CashTableViewCell class] forCellReuseIdentifier:@"cell2"];
    table.tableFooterView = [UIView new];
    self.table = table;
    
    [self.view addSubview:table];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionYearArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *new = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [new setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    new.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    new.tag = 1000+section;
    [new addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 44)];
    red.backgroundColor = kColord40;
    [new addSubview:red];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
    label.textColor= kColor333;
    label.font = kFont(15);
    label.text = self.sectionYearArray[section];
    
    [new addSubview:label];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上箭头"]];
    [new addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(new);
        make.right.equalTo(new).offset(-15);
    }];
    
    if ([self.statusArray[section] isEqualToString:@"1"]) {
        imageview.transform = CGAffineTransformIdentity;
    } else {
        
        imageview.transform = CGAffineTransformRotate(imageview.transform, M_PI);
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [new addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(new);
        make.height.mas_equalTo(0.5);
    }];
    
    return new;
    
}

- (void)click:(UIButton *)sender {
    UIImageView *image;
    for (UIView *sub in sender.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            image = (UIImageView *)sub;
        }
    }
    
    NSString *str = self.statusArray[sender.tag - 1000];
    if ([str isEqualToString:@"1"]) {
        self.statusArray[sender.tag - 1000] = @"0";
        //        image.transform = CGAffineTransformRotate(image.transform, M_PI_2);
    } else {
        self.statusArray[sender.tag - 1000] = @"1";
        //        image.transform = CGAffineTransformIdentity;
    }
    
    [self.table reloadSection:sender.tag - 1000 withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.statusArray[section] isEqualToString:@"0"]) {
        return 0;
    }
    NSString *month = self.sectionYearArray[section];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (CashModel *model in self.dataArray) {
        NSString *temp = [NSString stringWithFormat:@"%ld年%ld月", (long)model.year, model.month];
        if ([temp isEqualToString:month]) {
            [arr addObject:model];
        }
    }
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataDict[self.sectionYearArray[indexPath.section]];
    
    CashModel *model = arr[indexPath.row];
    CashTableViewCell *cell;
    if (model.showTitle) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *month = self.sectionYearArray[indexPath.section];
    NSArray *arr = self.dataDict[month];
    
    CashModel *model = arr[indexPath.row];
    if (model.showTitle) {
        return 105;
    }
    return 65;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)sectionYearArray {
    if (!_sectionYearArray) {
        _sectionYearArray = [NSMutableArray array];
    }
    return _sectionYearArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (NSMutableArray *)statusArray {
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
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
