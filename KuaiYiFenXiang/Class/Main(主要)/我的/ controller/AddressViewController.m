//
//  AddressViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "AddressViewController.h"
#import "NewAddressViewController.h"
#import "KYHeader.h"
#import "KYAddressTableViewCell.h"
#import "AreaModel.h"
#import "KYAddressModel.h"

@interface AddressViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic,strong)NSMutableArray *deleteArr;  //用来保存删除的addressid的数组
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBGColor;
    if (self.titleType == 1) {
        self.title = @"选择收货地址";
    }else{
        self.title = @"管理收货地址";
    }
    
    [self configUI];
    [self loadData];
}

- (void)configUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-44-BOTTOM_MARGIN) style:UITableViewStyleGrouped];
//        if (@available(iOS 11.0, *)) {
//            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            // Fallback on earlier versions
//        }
    
    table.tableFooterView = [UIView new];
//    table.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    table.backgroundColor = BACKVIEWCOLOR;
    
    [self.view addSubview:table];
    
    table.dataSource = self;
    
    table.delegate = self;
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.showsVerticalScrollIndicator = NO;
    
    table.sectionHeaderHeight = 10;
    table.sectionFooterHeight = 0;
    table.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0 );
    
    self.table = table;
    [table registerClass:[KYAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    exitBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    
    //    exitBtn.backgroundColor = [UIColor colorWithHexString:@"d40000"];
    [exitBtn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [self.view addSubview: exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44+BOTTOM_MARGIN);
    }];
    [exitBtn addTarget:self action:@selector(signout:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BACK"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back:(UIBarButtonItem *)sender {
//    if (self.didSelectedAddressHander&&!kArrayIsEmpty(self.dataArray)) {
//        self.didSelectedAddressHander(self.dataArray.firstObject);
//    }
    
//    if (self.deleteAddressBlock) {
//        self.deleteAddressBlock(model.address_id);
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"area.plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:docPath];
    if (!arr || arr.count == 0) {
        [HttpRequest postWithURLString:NetRequestUrl(arealist) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                NSArray *temp = res[@"result"];
                [temp writeToFile:docPath atomically:YES];
                [self loadData];
            }
        } failure:nil RefreshAction:nil];
    } else {
        self.areaArray = [AreaModel mj_objectArrayWithKeyValuesArray:arr];
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(getaddress) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                self.dataArray = [KYAddressModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
                if (kArrayIsEmpty(self.dataArray)) {
                    [self showEmptyView];
                }else{
                    [self hideEmptyView];
                }
            }else{
                
            }
            
            [self.table reloadData];
        } failure:^(NSError *error) {
            
        } RefreshAction:^{
            
        }];
    }
    
    
    
}

//显示空视图
-(void)showEmptyView
{
    if (!self.emptyView) {
        UIView *aview = [UIView new];
        aview.backgroundColor = BACKVIEWCOLOR;
        self.emptyView = aview;
        
        [self.view addSubview:aview];
        [aview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.table);
            make.size.mas_equalTo(CGSizeMake(348/2.0, 200));
        }];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无收货地址_bg"]];
        [aview addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(aview);
            make.top.equalTo(aview);
            make.width.equalTo(@131);
            make.height.equalTo(@130);
        }];
        
        UILabel *label = [UILabel new];
        label.textColor = kColor333;
        label.font = kFont(15);
        label.text = @"暂无收货地址，请添加";
        label.textAlignment = NSTextAlignmentCenter;
        [aview addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(aview);
            make.top.equalTo(imageview.mas_bottom);
        }];
        
    }
}

//隐藏空视图
-(void)hideEmptyView
{
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KYAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.area = self.areaArray;
    cell.model = self.dataArray[indexPath.section];
    __weak AddressViewController *weakself = self;
    //点击编辑
    cell.didClickEditHandler = ^(KYAddressModel *model) {
        NewAddressViewController *vc = [NewAddressViewController new];
        
        NSMutableArray *province = [NSMutableArray array];
        NSMutableArray *city = [NSMutableArray array];
        NSMutableArray *district = [NSMutableArray array];
        NSMutableArray *town = [NSMutableArray array];
        
        for (AreaModel *temp in self.areaArray) {
            switch (temp.level.integerValue) {
                case 1:
                    [province addObject:temp];
                    break;
                case 2:
                    [city addObject:temp];
                    break;
                case 3:
                    [district addObject:temp];
                    break;
                case 4:
                    [town addObject:temp];
                    break;
                default:
                    break;
            }
        }
        
        vc.provinceArray = province;
        vc.cityArray = city;
        vc.districtArray = district;
        vc.townArray = town;
        vc.model = model;
        vc.is_default = model.is_default;
        [vc editMode];
        vc.refreshHandler = ^{
            [weakself loadData];
            if (self.editeAddressBlock) {
                self.editeAddressBlock(model.address_id);
            }
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    //点击删除
    cell.didClickDeleteHandler = ^(KYAddressModel *model) {
        [weakself deladdress:model];
    };
    //点击设置为默认
//    __weak typeof(self) weakself = self;
    cell.didClickDefaultHandler = ^(KYAddressModel *model) {
        [weakself setDefault:model];
    };
    
    return cell;
}

- (void)deladdress:(KYAddressModel *)model {
    
    [LBXAlertAction showAlertWithTitle:@"确定要删除此地址？" msg:@"" chooseBlock:^(NSInteger buttonIdx) {
        if (buttonIdx==0) {
            return ;
        }else{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"address_id"] = model.address_id;
            
            [HttpRequest postWithTokenURLString:NetRequestUrl(deladdress) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
                if ([res[@"code"] integerValue] == 1) {
                    NSLog(@"删除成功");
                    //把这个id保存在删除数组中
                    [self.deleteArr addObject:model.address_id];
                    [self loadData];
                    if (self.deleteAddressBlock) {
                        self.deleteAddressBlock(model.address_id);
                    }
                }
            } failure:nil RefreshAction:nil];
        }
    } buttonsStatement:@"取消",@"确定",nil];
    
}

- (void)setDefault:(KYAddressModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"address_id"] = model.address_id;
    dict[@"consignee"] = model.consignee;
    dict[@"mobile"] = model.mobile;
    dict[@"province"] = model.province;
    dict[@"city"] = model.city;
    dict[@"district"] = model.district;
    dict[@"twon"] = model.twon;
    dict[@"address"] = model.address;
    dict[@"is_default"] = @"1";
    dict[@"type"] = @"2";
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(addaddress) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            [self loadData];
        }
    } failure:nil RefreshAction:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedAddressHander) {
        self.didSelectedAddressHander(self.dataArray[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 新建地址
- (void)signout:(UIButton *)sender {
    [self createAddress];
}
- (void)configUI1 {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无收货地址_bg"]];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
    }];

    UILabel *label = [UILabel new];
    label.text = @"暂无收货地址，请添加";
    label.textColor = kColor333;
    label.font = [UIFont systemFontOfSize:15];

    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageview.mas_bottom).offset(25);
        make.centerX.equalTo(imageview);
    }];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(createAddress)];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} forState:UIControlStateHighlighted];

    self.navigationItem.rightBarButtonItem = item;
}

- (void)createAddress {
    NewAddressViewController *vc = [NewAddressViewController new];
    __weak typeof(self) weakself = self;
    NSMutableArray *province = [NSMutableArray array];
    NSMutableArray *city = [NSMutableArray array];
    NSMutableArray *district = [NSMutableArray array];
    NSMutableArray *town = [NSMutableArray array];
    
    for (AreaModel *temp in self.areaArray) {
        switch (temp.level.integerValue) {
            case 1:
                [province addObject:temp];
                break;
            case 2:
                [city addObject:temp];
                break;
            case 3:
                [district addObject:temp];
                break;
            case 4:
                [town addObject:temp];
                break;
            default:
                break;
        }
    }
    
    vc.provinceArray = province;
    vc.cityArray = city;
    vc.districtArray = district;
    vc.townArray = town;
    vc.refreshHandler = ^{
        [weakself loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}

-(NSArray *)areaArray {
    if (!_areaArray) {
        _areaArray = [NSArray array];
    }
    return _areaArray;
}

-(NSMutableArray *)deleteArr
{
    if (!_deleteArr) {
        _deleteArr = [NSMutableArray new];
    }
    return _deleteArr;
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
