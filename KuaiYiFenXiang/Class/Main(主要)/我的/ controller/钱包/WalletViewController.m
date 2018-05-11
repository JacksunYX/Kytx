//
//  WalletViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "WalletViewController.h"
#import "CashInViewController.h"
#import "KYHeader.h"
#import "CashOutDetailViewController.h"
#import "BankCardViewController.h"
#import "CashOutViewController.h"
#import "MoneyLeftViewController.h"
#import "RecordViewController.h"
#import "MoneyDetailViewController.h"

@interface WalletViewController ()


@property(nonatomic, strong)UILabel *moneyLabel;
@property(nonatomic, strong)UILabel *consumeLabel;
@property (nonatomic, strong) NSString *totalMoney;    //总余额(包含余额和消费余额)
@property (nonatomic, strong) NSString *money;         //可提现余额
@property (nonatomic, strong) NSString *consume_money; //消费余额(只能在商城使用)

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"钱包";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱包"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(460));
    }];
    
    UILabel *topLabel = [UILabel new];
    topLabel.font = kFont(15);
    topLabel.textColor = kWhiteColor;
    topLabel.text = @"可用余额";
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20 + NAVI_HEIGHT);
        make.left.equalTo(self.view).offset(15);
    }];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.font = kFont(36);
    self.moneyLabel.textColor = kWhiteColor;
    [self.view addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.mas_bottom).offset(30);
        make.left.equalTo(topLabel);
    }];
    
    UIButton *checkBalance = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBalance setTitle:@"查看明细>" forState:UIControlStateNormal];
    checkBalance.titleLabel.font = kFont(12);
    [checkBalance setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [checkBalance _addTarget:self action:@selector(balanceDetail:)];
    
    [self.view addSubview:checkBalance];
    [checkBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.moneyLabel);
    }];
    
    
    
    //提现、充值、记录
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
//        if (IPHONE_X) {
            make.top.equalTo(self.view).offset(ScaleHeight(270));
//        } else {
//            make.top.equalTo(self.view).offset(ScaleHeight(230));
//        }
        
        make.height.mas_equalTo(ScaleHeight(60));
    }];
    [btn1 addTarget:self action:@selector(withdrawDeposit:) forControlEvents:UIControlEventTouchUpInside];
    
    //消费余额
    self.consumeLabel = [UILabel new];
    self.consumeLabel.font = kFont(15);
    self.consumeLabel.textColor = kWhiteColor;
    [self.view addSubview:self.consumeLabel];
    [self.consumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel);
//        make.top.equalTo(self.moneyLabel.mas_bottom).offset(66);
        make.bottom.equalTo(btn1.mas_top).offset(-30);
    }];
    
    UIButton *checkConsumeBalance = [UIButton buttonWithType:UIButtonTypeCustom];
    checkConsumeBalance.tag = 10005;
    [checkConsumeBalance setTitle:@"查看明细>" forState:UIControlStateNormal];
    checkConsumeBalance.titleLabel.font = kFont(12);
    [checkConsumeBalance setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [checkConsumeBalance _addTarget:self action:@selector(balanceDetail:)];
    
    [self.view addSubview:checkConsumeBalance];
    [checkConsumeBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.consumeLabel);
    }];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn2 addTarget:self action:@selector(recharge:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SCREEN_WIDTH/3.0);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
        make.top.equalTo(btn1);
        make.height.mas_equalTo(ScaleHeight(60));
    }];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn3 addTarget:self action:@selector(rechargeRecord:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
        make.top.equalTo(btn1);
        make.height.mas_equalTo(ScaleHeight(60));
    }];
    
    
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(mywallet) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            self.totalMoney = [NSString stringWithFormat:@"%@",res[@"result"][@"total"]];
            self.money = [NSString stringWithFormat:@"%@",res[@"result"][@"money"]];
            self.consume_money = [NSString stringWithFormat:@"%@",res[@"result"][@"consume_money"]];
            self.moneyLabel.text = [@"￥ " stringByAppendingString:self.money];
            self.consumeLabel.text = [@"消费余额：" stringByAppendingString:self.consume_money];
        }
    } failure:nil RefreshAction:nil];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}


//提现
- (void)withdrawDeposit:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(bankinfo) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 3) {
            // 未绑定
            BankCardViewController *vc = [BankCardViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([res[@"code"] integerValue] == 1) {
            // 已绑定
            CashOutViewController *vc = [CashOutViewController new];
            vc.bank_id = res[@"result"][@"card"];
            vc.bank_name = res[@"result"][@"bank_name"];
            vc.bank_number = res[@"result"][@"number"];
            vc.money = self.money;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    } failure:nil RefreshAction:nil];
}

//大额充值
- (void)recharge:(UIButton *)sender {
    CashInViewController *vc = [CashInViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//充值记录
- (void)rechargeRecord:(UIButton *)sender {
    RecordViewController *vc = [RecordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//查看明细
- (void)balanceDetail:(UIButton *)sender {
    if (sender.tag == 10005) {
        MoneyDetailViewController *vc = [MoneyDetailViewController new];
        vc.type = sender.tag - 10000;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MoneyLeftViewController *vc = [MoneyLeftViewController new];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
    [self configNavi];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
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
