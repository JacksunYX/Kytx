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

@interface WalletViewController ()
@property(nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, strong) NSString *money;
@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"我的钱包";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱包"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(460));
    }];
    
    
    UILabel *label = [UILabel new];
    
    label.font = kFont(25);
    label.textColor = kWhiteColor;
//    label.text = @"5000.00"; 
    self.moneyLabel = label;
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScaleWidth(130));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"查看明细>" forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(13);
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(d:) forControlEvents:UIControlEventTouchUpInside];
    [btn _addTarget:self action:@selector(d:)];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(label.mas_bottom).offset(40);
    }];
    
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
    [btn1 addTarget:self action:@selector(a:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn2 addTarget:self action:@selector(b:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SCREEN_WIDTH/3.0);
        make.width.mas_equalTo(SCREEN_WIDTH/3.0);
        make.top.equalTo(btn1);
        make.height.mas_equalTo(ScaleHeight(60));
    }];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn3 addTarget:self action:@selector(c:) forControlEvents:UIControlEventTouchUpInside];
    
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
            self.moneyLabel.text = res[@"result"][@"money"];
            self.money = res[@"result"][@"money"];
        }
    } failure:nil RefreshAction:nil];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor, NSFontAttributeName :kBoldFont(16)} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor, NSFontAttributeName :kBoldFont(16)} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = item1;
    
}

- (void)right:(UIBarButtonItem *)sender {
    // 提现记录
    CashOutDetailViewController *vc = [CashOutDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)a:(UIButton *)sender {
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

- (void)b:(UIButton *)sender {
    CashInViewController *vc = [CashInViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)c:(UIButton *)sender {
    RecordViewController *vc = [RecordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)d:(UIButton *)sender {
    MoneyLeftViewController *vc = [MoneyLeftViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
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
