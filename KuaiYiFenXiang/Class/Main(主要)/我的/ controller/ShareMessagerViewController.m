//
//  ShareMessagerViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShareMessagerViewController.h"
#import "KYHeader.h"
//#import "CashTableViewCell.h"
//#import "CashModel.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "EarnPointViewController.h"
@interface ShareMessagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sectionYearArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation ShareMessagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的会员";
    self.view.backgroundColor = kDefaultBGColor;
    
    [self configNavi];
    [self configUI];
    [self loadData];
    
}

- (void)configNavi {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"赚积分" style:UIBarButtonItemStylePlain target:self action:@selector(rightclick:)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor999} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor999} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightclick:(UIBarButtonItem *)sender {
    EarnPointViewController *vc = [EarnPointViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    dict[@"type"] = @"3";
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(contacts) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        NSArray *arr = [ContactModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
        if (arr == nil || arr.count == 0) {
            [self showEmpty];
            return ;
        }
        self.dataArray = [arr mutableCopy];
        
        //1.先筛选出月份分区
        [arr enumerateObjectsUsingBlock:^(ContactModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            if (idx == 0) {
                [self.sectionYearArray addObject:[NSString stringWithFormat:@"%@年%@月", @(model.year).description, @(model.month).description]];
                model.showTitle = YES;
            } else {
                ContactModel *temp = arr[idx-1];
                //年月都相同
                if ((temp.year == model.year) && (temp.month == model.month)) {
                    if ((temp.day != model.day) && (temp.month == model.month)) {
                        model.showTitle = YES;
                    }
                    
                } else {    //年月有不同
                    
                    [self.sectionYearArray addObject:[NSString stringWithFormat:@"%@年%@月", @(model.year).description, @(model.month).description]];
                    
                    //年份不同月份相同，这个比较特殊,比如相邻的是2018/4/25和2017/4/25
                    if ((temp.year != model.year)&&(temp.month == model.month)) {
                        
                        model.showTitle = YES;
                        
                    }else{ //年份不同月份也不同，或年份相同月份不同
                        
                        if (temp.month != model.month) {
                            model.showTitle = YES;
                        } else if ((temp.day != model.day) && (temp.month == model.month)) {
                            model.showTitle = YES;
                        }
                        
                    }
                    
                }
                
            }
        }];
        
        //2.再筛选出同月的日期分区
        for (NSString *monthStr in self.sectionYearArray) {
            NSMutableArray *temparr = [NSMutableArray array];
            for (ContactModel *model in self.dataArray) {
                NSString *str = [NSString stringWithFormat:@"%ld年%ld月", model.year, model.month];
                //同一个年月
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
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myMemberNoRecord"]];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(150);
    }];
    UILabel *noticeLabel = [UILabel new];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        
        make.top.equalTo(imageview.mas_bottom).offset(10);
    }];
    noticeLabel.text = @"暂无记录";
}

- (void)configUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NAVI_HEIGHT) style:UITableViewStylePlain];
    
//    table.separatorInset = UIEdgeInsetsMake(0, 15, 0, -15);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = kDefaultBGColor;
    [table registerClass:[ContactTableViewCell class] forCellReuseIdentifier:@"cell"];
    [table registerClass:[ContactTableViewCell class] forCellReuseIdentifier:@"cell2"];
    table.tableFooterView = [UIView new];
    self.table = table;
    
    [self.view addSubview:table];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionYearArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //整部分的点击bei'jing
    UIButton *new = [UIButton buttonWithType:UIButtonTypeCustom];
    [new setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    new.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    new.tag = 1000+section;
    [new addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    //左边红线
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 44)];
    red.backgroundColor = kColord40;
    [new addSubview:red];
    
    //月份
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
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
    //分区状态为0是表示收起
    if ([self.statusArray[section] isEqualToString:@"0"]) {
        return 0;
    }
    NSString *month = self.sectionYearArray[section];
    //对应的分区有多少条数据
    NSMutableArray *arr = [NSMutableArray array];
    for (ContactModel *model in self.dataArray) {
        NSString *temp = [NSString stringWithFormat:@"%ld年%ld月", (long)model.year, model.month];
        if ([temp isEqualToString:month]) {
            [arr addObject:model];
        }
    }
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataDict[self.sectionYearArray[indexPath.section]];
    
    ContactModel *model = arr[indexPath.row];
    ContactTableViewCell *cell;
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
    
    ContactModel *model = arr[indexPath.row];
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
