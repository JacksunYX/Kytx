//
//  MoneyDetailViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MoneyDetailViewController.h"
//#import "MoneyModel.h"
#import "MoneyModel.h"
#import "KYHeader.h"
//#import "PointTableViewCell.h"
#import "MoneyTableViewCell.h"

@interface MoneyDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sectionYearArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong) NSString *request_url;

@end

@implementation MoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kDefaultBGColor;
    
    if (self.type == 2 || self.type == 1) {
        self.request_url = NetRequestUrl(moneydetail);
        self.title = @"激励明细";
    } else if (self.type == 3) {
        self.request_url = NetRequestUrl(frozendetail);
        self.title = @"冻结明细";
    } else if (self.type == 4) {
        self.request_url = NetRequestUrl(billdetail);
        self.title = @"账户明细";
    }else if (self.type == 5){
        self.request_url = NetRequestUrl(consume_money);
        self.title = @"消费余额";
    }
    [self configNavi];
    [self configUI];
    [self loadData];
    
}

- (void)configNavi {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [HttpRequest postWithTokenURLString:self.request_url parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            NSArray *arr = [MoneyModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
            if (arr.count == 0) {
                UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"激励"]];
                [self.view addSubview:imageview];
                [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(170, 130));
                    make.center.equalTo(self.view);
                }];
                
                UILabel *notice = [UILabel new];
                notice.textAlignment = NSTextAlignmentCenter;
                
                [self.view addSubview:notice];
                [notice mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(imageview.mas_bottom).offset(10);
                    make.centerX.equalTo(imageview);
                }];
                notice.text = @"暂无明细";
                
                return ;
            }
            self.dataArray = [arr mutableCopy];
            
            [arr enumerateObjectsUsingBlock:^(MoneyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                if (idx == 0) {
                    [self.sectionYearArray addObject:[NSString stringWithFormat:@"%@年%@月", @(model.year).description, @(model.month).description]];
                    model.showTitle = YES;
                } else {
                    MoneyModel *temp = arr[idx-1];
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
                for (MoneyModel *model in self.dataArray) {
                    NSString *str = [NSString stringWithFormat:@"%ld年%ld月", model.year, model.month];
                    if ([str isEqualToString:monthStr]) {
                        [temparr addObject:model];
                    }
                }
                self.dataDict[monthStr] = temparr;
                
                [self.statusArray addObject:@"1"];
            }
            [self.table reloadData];
        }
        
        
    } failure:nil RefreshAction:nil];
}

- (void)configUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NAVI_HEIGHT) style:UITableViewStylePlain];
    
    table.separatorInset = UIEdgeInsetsMake(0, 15, 0, -15);
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = kDefaultBGColor;
    [table registerClass:[MoneyTableViewCell class] forCellReuseIdentifier:@"cell"];
    [table registerClass:[MoneyTableViewCell class] forCellReuseIdentifier:@"cell2"];
    table.tableFooterView = [UIView new];
    self.table = table;
    
    UIView *aview = [UIView new];
    aview.backgroundColor = kDefaultBGColor;
    aview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    
    UILabel *label = [UILabel new];
    label.font = kFont(12);
    label.textColor = kColor999;
    label.backgroundColor = kDefaultBGColor;
//    [label addSubview:aview];
    label.frame = CGRectMake(70, 0, SCREEN_WIDTH-70, 30);
    [aview addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"感叹号"]];
    [aview addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.center.equalTo(aview);
    }];
    
    if (self.type == 2 || self.type == 1) {
        
        label.text = @"积分激励需要扣除10%财务管理费用及平台维护费用";
        table.tableHeaderView = aview;
    } else if (self.type == 3) {
        label.text = @"冻结说明：提现款没到银行卡前，处于冻结状态";
        table.tableHeaderView = aview;
    } else {
       
    }
    
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
    for (MoneyModel *model in self.dataArray) {
        NSString *temp = [NSString stringWithFormat:@"%ld年%ld月", (long)model.year, model.month];
        if ([temp isEqualToString:month]) {
            [arr addObject:model];
        }
    }
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataDict[self.sectionYearArray[indexPath.section]];
    
    MoneyModel *model = arr[indexPath.row];
    MoneyTableViewCell *cell;
    if (model.showTitle) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
    if (self.type == 3) {
        cell.celltype = 2;
    } else if (self.type == 4) {
        cell.celltype = 3;
    }else if (self.type == 5) {
        cell.celltype = 4;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *month = self.sectionYearArray[indexPath.section];
    NSArray *arr = self.dataDict[month];
    
    MoneyModel *model = arr[indexPath.row];
    if (model.showTitle) {
        if (self.type == 3) {
            return 105;
        } else {
            return 125;
            
        }
    }
    
    if (self.type == 3) {
        return 65;
    } else {
        return 85;
        
    }
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
