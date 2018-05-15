
//
//  MyViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MyViewController.h"
#import "KYMyOrderTableViewCell.h"
#import "KYHeader.h"
#import "KYHelpViewController.h"
#import "SecurityViewController.h"
#import "MessageNotiViewController.h"
#import "AddressViewController.h"
#import "KYWebViewController.h"
#import "StoreManagementViewController.h"
#import "MyOrderViewController.h"
#import "WalletViewController.h"
#import "PointViewController.h"
#import "BankCardViewController.h"
#import "ContactViewController.h"
#import "MessageViewController.h"
#import "MyOrderListViewController.h"
#import "FocusOnStoreViewController.h"
#import "CollectionGoodsViewController.h"
#import "MyShareViewController.h"
#import "MyDiscountCouponViewController.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)UITableView *table;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *iconArray;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSMutableArray *dotArray;

@end

@implementation MyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationItem.title=@"我的";
    self.title = @"";
    self.tabBarItem.title = @"我的";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}


- (void)loadData {
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.isLogin) {
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(usermyinfo) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            if ([self.table.mj_header isRefreshing]) {
                [self.table.mj_header endRefreshing];
            }
            if ([res[@"code"] integerValue] == 1) {
                
                self.loginLabel.hidden = YES;
                self.nameLabel.hidden = NO;
                //                self.shareImageView.hidden = NO;
                self.moneyLabel.hidden = NO;
                
                NSDictionary *dict = res[@"result"];
                dict = [self validDict:dict];
                if (![dict[@"head_pic"] isEqualToString:@""]) {
                    
                    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:dict[@"head_pic"]]]];
                } else {
                    self.iconImageView.image = [UIImage imageNamed:@"我的-头像"];
                }
                self.mobile = dict[@"mobile"];
                self.nameLabel.text = dict[@"nickname"];
                
                self.moneyLabel.text = [@"当天剩余最大支付额度：" stringByAppendingString:[NSString stringWithFormat:@"%.2f", [dict[@"surplus_money"] floatValue]]];
                NSInteger role = [dict[@"role"] integerValue];
//                UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                NSString *openStore;
                if (role != 1 && role != 2) {
                    if (role == 3) {
                        openStore = @"我要开店";
                    } else {
                        openStore = @"店铺管理";
                    }
                } else {
                    openStore = @"我要开店";
                }
                [self.titleArray replaceObjectAtIndex:1 withObject:@[openStore,@"我的分享"]];
                self.role = role;
                if (role == 1 || role == 2) {
                    self.shareImageView.hidden = YES;
                } else {
                    self.shareImageView.hidden = NO;
                }
                //是否显示为总监
                if ([dict[@"extend_status"] integerValue] == 1) {
                    self.shareImageView.image = UIImageNamed(@"chiefInspector");
                }else{
                    self.shareImageView.image = UIImageNamed(@"我的——VIP");
                }
                [self.table reloadData];
            }
        } failure:nil RefreshAction:nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [HttpRequest postWithTokenURLString:NetRequestUrl(nummenu) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            NSDictionary *temp = res[@"result"];
            if ([res[@"code"] integerValue] == 1) {
                [self.dotArray removeAllObjects];
                [self.dotArray addObject:[NSString stringWithFormat:@"%@", @([temp[@"obligation"] integerValue]).description]];
                [self.dotArray addObject:[NSString stringWithFormat:@"%@", @([temp[@"Overhang"] integerValue]).description]];
                [self.dotArray addObject:[NSString stringWithFormat:@"%@", @([temp[@"receiving"] integerValue]).description]];
                [self.dotArray addObject:[NSString stringWithFormat:@"%@", @([temp[@"stocks"] integerValue]).description]];
                [self.dotArray addObject:[NSString stringWithFormat:@"%@", @([temp[@"refund"] integerValue]).description]];
                
                [self.table reloadData];
            }
        } failure:nil RefreshAction:nil];
        
    } else {
        if ([self.table.mj_header isRefreshing]) {
            [self.table.mj_header endRefreshing];
        }
        self.loginLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.shareImageView.hidden = YES;
        self.moneyLabel.hidden = YES;
        self.iconImageView.image = [UIImage imageNamed:@"我的-头像"];
        kHiddenHUD;
        [self.titleArray replaceObjectAtIndex:1 withObject:@[@"我要开店",@"我的分享"]];
        [self.dotArray removeAllObjects];
        [self.dotArray addObjectsFromArray:@[@"",@"",@"",@"",@""]];
        [self.table reloadData];
    }
}


- (void)configUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, -(NAVI_HEIGHT-44), SCREEN_WIDTH, SCREEN_HEIGHT-TAB_HEIGHT+(NAVI_HEIGHT-44)) style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self.view addSubview:table];
    table.estimatedRowHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    MCWeakSelf
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    table.dataSource = self;
    
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    table.sectionHeaderHeight = 10;
    table.sectionFooterHeight = 0;
    
    table.delegate = self;
    
    table.tableHeaderView = [self createHederView];
    
    table.showsVerticalScrollIndicator = NO;
    
    self.table = table;
    
}

- (UIView *)createHederView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScaleHeight(240))];
    view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    UIImageView *bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-我的"]];
    
    bgimage.userInteractionEnabled = YES;
    
    [view addSubview:bgimage];
    [bgimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(view);
        make.height.mas_equalTo(ScaleHeight(170));
    }];
    
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.top.equalTo(bgimage).offset(40);
        make.right.equalTo(bgimage).offset(-15);
    }];
    
    UIView *littleBg = [[UIView alloc] init];
    
    littleBg.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:littleBg];
    [littleBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(bgimage.mas_bottom);
        make.height.mas_equalTo(ScaleHeight(60));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的"]];
    
    //    self.iconImageView = imageView;
    imageView.userInteractionEnabled = YES;
    
    [littleBg addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(littleBg);
        //        make.height.mas_equalTo(ScaleWidth(40.5));
        //        make.width.mas_equalTo(ScaleWidth(276));
    }];
    
    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    abtn.backgroundColor = [UIColor clearColor];
    [abtn addTarget:self action:@selector(account:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleBg addSubview:abtn];
    [abtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(littleBg);
        make.left.equalTo(littleBg);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
    }];
    
    //分割线1
    UIView *line1 = [UIView new];
    line1.backgroundColor = kWhite(0.8);
    [littleBg addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(littleBg.mas_top).offset(10);
        make.bottom.equalTo(littleBg.mas_bottom).offset(- 10);
        make.left.equalTo(abtn.mas_right);
        make.width.mas_equalTo(0.5);
    }];
    
    UIButton *bbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    bbtn.backgroundColor = [UIColor clearColor];
    [bbtn addTarget:self action:@selector(card:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleBg addSubview:bbtn];
    [bbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(littleBg);
        make.left.equalTo(abtn.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
    }];
    
    //分割线2
    UIView *line2 = [UIView new];
    line2.backgroundColor = kWhite(0.8);
    [littleBg addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(littleBg.mas_top).offset(10);
        make.bottom.equalTo(littleBg.mas_bottom).offset(- 10);
        make.left.equalTo(bbtn.mas_right);
        make.width.mas_equalTo(0.5);
    }];
    
    UIButton *cbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cbtn.backgroundColor = [UIColor clearColor];
    [cbtn addTarget:self action:@selector(point:) forControlEvents:UIControlEventTouchUpInside];
    
    [littleBg addSubview:cbtn];
    [cbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(littleBg);
        make.left.equalTo(bbtn.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    loginBtn.backgroundColor = kColord40;
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [bgimage addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgimage).offset(ScaleWidth(15));
        make.centerY.equalTo(bgimage);
        make.height.mas_equalTo(ScaleHeight(56));
        make.right.equalTo(bgimage);
    }];
    
    UIImageView *imageview111 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头白"]];
    [bgimage addSubview:imageview111];
    [imageview111 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgimage).offset(-15);
        make.centerY.equalTo(bgimage);
        make.size.mas_equalTo(CGSizeMake(8.5, 13));
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-头像"]];
    //    iconImageView.layer.cornerRadius = ScaleWidth(28);
    self.iconImageView = iconImageView;
    iconImageView.layer.cornerRadius = ScaleWidth(28);
    iconImageView.layer.masksToBounds = YES;
    [loginBtn addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginBtn);
        make.centerY.equalTo(loginBtn);
        make.size.mas_equalTo(CGSizeMake(ScaleWidth(56), ScaleWidth(56)));
    }];
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = @"登录/注册";
    self.loginLabel = descLabel;
    descLabel.textColor = [UIColor whiteColor];
    descLabel.font = [UIFont systemFontOfSize:ScaleWidth(15)];
    [loginBtn addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(ScaleWidth(15));
        make.centerY.equalTo(loginBtn);
        make.height.equalTo(loginBtn);
        make.right.equalTo(loginBtn);
    }];
    
    // 收藏商品
    UIButton *collection = [UIButton buttonWithType:UIButtonTypeCustom];
    [collection setTitle:@"收藏商品" forState:UIControlStateNormal];
    collection.backgroundColor = [UIColor clearColor];
    collection.titleLabel.font = [UIFont systemFontOfSize:ScaleWidth(12)];
    [bgimage addSubview:collection];
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgimage).offset(ScaleWidth(70));
        make.bottom.equalTo(bgimage).offset(-ScaleHeight(15));
    }];
    [collection addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    
    // 关注店铺
    UIButton *focusStore = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusStore setTitle:@"关注店铺" forState:UIControlStateNormal];
    focusStore.backgroundColor = [UIColor clearColor];
    focusStore.titleLabel.font = [UIFont systemFontOfSize:ScaleWidth(12)];
    [bgimage addSubview:focusStore];
    [focusStore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgimage).offset(-ScaleWidth(70));
        make.bottom.equalTo(bgimage).offset(-ScaleHeight(15));
    }];
    
    [focusStore addTarget:self action:@selector(focusStore:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = kWhiteColor;
    _nameLabel.font = kFont(13);
    _nameLabel.hidden = YES;
    
    [bgimage addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.bottom.equalTo(iconImageView.mas_centerY).offset(-5);
    }];
    
    _shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的——VIP"]];
    _shareImageView.backgroundColor = [UIColor clearColor];
    _shareImageView.hidden = YES;
    
    [bgimage addSubview:_shareImageView];
    [_shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.bottom.equalTo(iconImageView.mas_centerY).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = kFont(13);
    _moneyLabel.hidden = YES;
    _moneyLabel.textColor = kWhiteColor;
    
    [bgimage addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.top.equalTo(iconImageView.mas_centerY).offset(5);
    }];
    
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 3;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KYMyOrderTableViewCell *cell = [[KYMyOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noneed"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak MyViewController *weakself = self;
        cell.checkAllOrderHandler = ^{
            if ([KYHeader checkNormalBackLogin]) {
                MyOrderViewController *vc = [MyOrderViewController new];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        };
        
        cell.clickHandler = ^(NSInteger type) {
            if ([KYHeader checkNormalBackLogin]) {
                MyOrderViewController *vc = [MyOrderViewController new];
                vc.index = type+1;
                if (vc.index == 5) {
                    MyOrderListViewController *molvc=[[MyOrderListViewController alloc]init];
                    molvc.index=5;
                    [self.navigationController pushViewController:molvc animated:YES];
                    return ;
                }
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        };
        
        if (self.dotArray.count == 5) {
            [cell dot1WithText:self.dotArray[0]];
            [cell dot2WithText:self.dotArray[1]];
            [cell dot3WithText:self.dotArray[2]];
            [cell dot4WithText:self.dotArray[3]];
            [cell dot5WithText:self.dotArray[4]];
        }
        
        
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = kFont(14);
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return 44;
    }
    
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                
                if ([KYHeader checkNormalBackLogin]) {
                    [self store];
                }
                break;
            }
            case 1: {
                
                if ([KYHeader checkNormalBackLogin]) {
                    [self share];
                }
                break;
            }
                
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                // 收货地址
                if ([KYHeader checkNormalBackLogin]) {
                    [self address];
                }
                break;
                
            }
            case 1:
                // 帮助中心
                [self help];
                break;
            case 2: {
                
                // 安全设置
                if ([KYHeader checkNormalBackLogin]) {
                    [self security];
                }
                break;
            }
                
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                [self tapCall];
                break;
            case 1:
                [self companyInfo];
                break;
            case 2:
                [self infomation];
                break;
                
            default:
                break;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collection:(UIButton *)sender {
    
    if ([KYHeader checkNormalBackLogin]) {
        CollectionGoodsViewController *cgvc = [CollectionGoodsViewController new];
        [self.navigationController pushViewController:cgvc animated:YES];
    }
}

- (void)focusStore:(UIButton *)sender {
    if ([KYHeader checkNormalBackLogin]) {
        FocusOnStoreViewController *fovc = [FocusOnStoreViewController new];
        [self.navigationController pushViewController:fovc animated:YES];
    }
}

- (void)share {
    
    MyShareViewController *vc = [MyShareViewController new];
    vc.user_name = self.nameLabel.text;
    vc.mobile = self.mobile;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 消息
- (void)messageClick:(UIButton *)sender {
    
    if ([KYHeader checkNormalBackLogin]) {
        MessageViewController *vc = [MessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
//        MyDiscountCouponViewController *dcVC = [MyDiscountCouponViewController new];
//        [self.navigationController pushViewController:dcVC animated:YES];
    }
    
}

#pragma mark - 我的店铺
- (void)store {
    
    StoreManagementViewController *vc = [StoreManagementViewController new];
    if (self.role == 1 || self.role == 2) {
        // 申请VIP
        self.tabBarController.selectedIndex = 1;
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 公司介绍
- (void)companyInfo {
    KYWebViewController *vc = [[KYWebViewController alloc] init];
    vc.name = @"公司介绍";
    vc.web_url = companyInfo_url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 钱包
- (void)account:(UIButton *)sender {

    if ([KYHeader checkNormalBackLogin]) {
        WalletViewController *vc = [WalletViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 银行卡
- (void)card:(UIButton *)sender {
    
    if ([KYHeader checkNormalBackLogin]) {
        BankCardViewController *vc = [BankCardViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 积分
- (void)point:(UIButton *)sender {

    if ([KYHeader checkNormalBackLogin]) {
        PointViewController *vc = [PointViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 登录注册
- (void)login:(UIButton *)sender {
    if ([KYHeader checkNormalBackLogin]) {
        [self security];
    }
}

#pragma mark - 打电话
-(void)tapCall
{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-998-9798"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

#pragma mark - 收货地址
- (void)address {

    AddressViewController *vc = [AddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 帮助中心
- (void)help {
    KYHelpViewController *vc = [[KYHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 安全设置
- (void)security {
    
    SecurityViewController *vc = [[SecurityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 联系我们
- (void)infomation {
    ContactViewController *vc = [ContactViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - 懒加载
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
        _titleArray = [@[
                        @[@"我的订单"],
                        @[@"我要开店", @"我的分享"],
                        @[@"收货地址", @"帮助中心", @"安全设置"],
                        @[@"官方客服", @"公司介绍", @"联系我们"]
                        ] mutableCopy];
    }
    return _titleArray;
}

- (NSArray *)iconArray {
    if (!_iconArray) {
        _iconArray = @[@[@"我的订单_icon"],@[@"我要开店_icon", @"我的分享_icon"], @[@"收货地址_icon", @"帮助中心_icon", @"安全设置_icon"], @[@"官方客服_icon", @"公司介绍_icon", @"联系我们_icon"]];
    }
    return _iconArray;
}

- (NSMutableArray *)dotArray {
    if (!_dotArray) {
        _dotArray = [NSMutableArray array];
    }
    return _dotArray;
}

@end

