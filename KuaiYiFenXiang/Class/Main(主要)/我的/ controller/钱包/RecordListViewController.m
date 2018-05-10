//
//  RecordListViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "RecordListViewController.h"
#import "KYHeader.h"
#import "RecordTableViewCell.h"
#import "RecordModel.h"
#import "RecordDetailViewController.h"

@interface RecordListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionYearArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBGColor;
    
    [self configUI];
    
}

- (void)configUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NAVI_HEIGHT - 45) style:UITableViewStylePlain];
    
    table.separatorInset = UIEdgeInsetsMake(0, 15, 0, -15);
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = kDefaultBGColor;
    [table registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"cell"];
    [table registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"cell2"];
    table.tableFooterView = [UIView new];
    self.table = table;
    
    [self.view addSubview:table];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordModel *model = self.dataArray[indexPath.row];
    
    RecordTableViewCell *cell;
    
    if (model.showTitle) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.pushHander) {
        RecordModel *model = self.dataArray[indexPath.row];
        self.pushHander(model);
    }
    
}

- (void)filterArray {
    [self.dataArray enumerateObjectsUsingBlock:^(RecordModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (idx == 0) {
//            [self.sectionYearArray addObject:[NSString stringWithFormat:@"%@年%@月", @(model.year).description, @(model.month).description]];
            model.showTitle = YES;
        } else {
            RecordModel *temp = self.dataArray[idx-1];
            
            if (temp.month != model.month) {
                model.showTitle = YES;
            } else if ((temp.day != model.day) && (temp.month == model.month)) {
                model.showTitle = YES;
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordModel *model = self.dataArray[indexPath.row];
    if (model.showTitle) {
        return 110;
    }
    return 70;
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

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }

    return _dataArray;
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
