//
//  PointRankViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "PointRankViewController.h"
#import "KYHeader.h"
#import "PointRankTableViewCell.h"

@interface PointRankViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *iconimageview;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *allArray;
@property (nonatomic, strong) UITableView *table;

@end

@implementation PointRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"积分排行榜";
    
    [self configUI];
    [self configNavi];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @"2";
    [HttpRequest postWithTokenURLString:NetRequestUrl(pointbang) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            NSDictionary *dict = res[@"result"];
            
            NSDictionary *person = dict[@"person"];
            if (![person[@"head_pic"] isEqualToString:@""]) {
                
                NSString *str = [defaultUrl stringByAppendingString:person[@"head_pic"]];
                [self.iconimageview sd_setImageWithURL:[NSURL URLWithString:str]];
            }
            self.nameLabel.text = person[@"nickname"];
            self.pointLabel.text = [person[@"user_love"] stringByAppendingString:@"个"];
            self.rankLabel.text = [person[@"num"] description];
            self.allArray = dict[@"list"];
            self.dataArray = [self.allArray subarrayWithRange:NSMakeRange(0, 6)];
            [self.table reloadData];
        }
    } failure:nil RefreshAction:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}


//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:YES];
//    
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    
//}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积分排行榜"]];
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleHeight(1239/2.0));
    }];
    
    UIImageView *iconimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-头像"]];
    
    iconimageview.layer.cornerRadius = 25;
    self.iconimageview = iconimageview;
    iconimageview.layer.masksToBounds = YES;
    
    [self.view addSubview:iconimageview];
    [iconimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (SCREEN_HEIGHT == 667) {
            make.top.equalTo(self.view).offset(NAVI_HEIGHT + ScaleWidth(20));
        } else {
            make.top.equalTo(self.view).offset(NAVI_HEIGHT + ScaleWidth(40));
        }
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    _nameLabel = [self labelWithText:@"用户"];
    
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconimageview);
        make.top.equalTo(iconimageview.mas_bottom).offset(10);
    }];
    
    UILabel *name = [self labelWithText:@"名次"];
    
    [self.view addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.centerY.equalTo(_nameLabel);
    }];
    
    UILabel *rank = [self labelWithText:@"积分"];
    [self.view addSubview:rank];
    [rank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(name);
        make.right.equalTo(self.view).offset(-45);
    }];
    
    _rankLabel = [self labelWithText:@"3"];
    [self.view addSubview:_rankLabel];
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(name);
        make.bottom.equalTo(rank.mas_top).offset(-20);
    }];
    
    _pointLabel = [self labelWithText:@"9999个"];
    
    [self.view addSubview:_pointLabel];
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rank);
        make.bottom.equalTo(_rankLabel);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconimageview.mas_bottom).offset(ScaleHeight(100));
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(SCREEN_WIDTH - ScaleWidth(70));
    }];
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _table.separatorColor = kDefaultBGColor;
    
//    _table.backgroundColor = [UIColor redColor];
    [_table registerClass:[PointRankTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.height.mas_equalTo(ScaleHeight(360));
        make.width.equalTo(line);
        make.centerX.equalTo(line);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = kFont(15);
    [btn setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn setTitleColor:kColord40 forState:UIControlStateNormal];
    _table.tableFooterView = btn;
}

- (void)show:(UIButton *)sender {
    
    self.dataArray = self.allArray;
    [self.table reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    self.table.tableFooterView = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PointRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.type = indexPath.row;
    NSDictionary *dict = self.dataArray[indexPath.row];
//    [cell.iconImageview sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:dict[@"head_pic"]]]];
    NSInteger count = indexPath.row + 1;
    cell.iconLabel.text = @(count).description;
    cell.nameLabel.text = dict[@"nickname"];
//    cell.nameLabel.text = @"有个用户";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pointLabel.text = [dict[@"user_love"] description];
//    cell.backgroundColor = kColord40;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView {
    return 70;
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = kFont(17);
    label.textColor = kWhiteColor;
    return label;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
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
