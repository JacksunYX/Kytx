//
//  MoneLeftyViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MoneyLeftViewController.h"
#import "KYHeader.h"
#import "MoneyDetailViewController.h"

@interface MoneyLeftViewController ()
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *doneLabel;
@property (nonatomic, strong) UILabel *frezenLabel;
@property (nonatomic, strong) UILabel *billLabel;

@end

@implementation MoneyLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"可用余额";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱包明细"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(1304/2.0));
    }];
    [self configNavi];
    
    [self configUI];
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(moneyleft) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            self.moneyLabel.text = [res[@"result"][@"money"][@"gold"] stringByAppendingString:@""];
            
            self.todayLabel.text = [res[@"result"][@"today_gold"] stringByAppendingString:@"元 >"];
            self.doneLabel.text = [res[@"result"][@"total_gold"] stringByAppendingString:@"元 >"];
            self.frezenLabel.text = [res[@"result"][@"freeze"] stringByAppendingString:@"元 >"];
//            self.billLabel.text = [res[@"result"][@"bill"] stringByAppendingString:@"元>"];
//            self.billLabel.backgroundColor = kColord40;
            
        }
    } failure:nil RefreshAction:nil];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)configUI {
    UILabel *alabel = [UILabel new];
    
    alabel.font = kFont(20);
    alabel.textColor = [UIColor colorWithHexString:@"ff9914"];
//    alabel.text = @"5000.00";
    self.moneyLabel = alabel;
    
    [self.view addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(215);
    }];
    
    UIImageView *orange = [[UIImageView alloc] initWithImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"ff9914"]]];
    orange.layer.cornerRadius = 3;
    orange.layer.masksToBounds = YES;
    [self.view addSubview:orange];
    [orange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScaleHeight(360));
        
        make.left.equalTo(self.view).offset(ScaleWidth(60));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *olabel = [UILabel new];
    olabel.font = kFont(15);
    olabel.textColor = kColor333;
    olabel.text = @"今日激励";
    [self.view addSubview:olabel];
    [olabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orange);
        make.left.equalTo(orange.mas_right).offset(15);
    }];
    
    UILabel *newPointLabel = [UILabel new];
    
    newPointLabel.font = kFont(15);
    newPointLabel.textAlignment = NSTextAlignmentRight;
    newPointLabel.textColor = kColor333;
    newPointLabel.text = @"102.89元>";
    newPointLabel.tag = 10001;
    
    self.todayLabel = newPointLabel;
    [self.view addSubview:newPointLabel];
    [newPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orange);
        make.right.equalTo(self.view).offset(-60);
        make.width.mas_equalTo(120);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [newPointLabel addGestureRecognizer:tap];
    newPointLabel.userInteractionEnabled = YES;
    
    UIImageView *red = [[UIImageView alloc] initWithImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]]];
    red.layer.cornerRadius = 3;
    red.layer.masksToBounds = YES;
    [self.view addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(ScaleWidth(420));
        make.top.equalTo(orange.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(ScaleWidth(60));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *rlabel = [UILabel new];
    rlabel.font = kFont(15);
    rlabel.textColor = kColor333;
    rlabel.text = @"已激励金额";
    [self.view addSubview:rlabel];
    [rlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(red);
        make.left.equalTo(red.mas_right).offset(15);
    }];
    
    UILabel *allPointLabel = [UILabel new];
    
    allPointLabel.font = kFont(15);
    allPointLabel.textColor = kColor333;
    allPointLabel.text = @"4569.55元>";
    allPointLabel.textAlignment = NSTextAlignmentRight;
    allPointLabel.tag = 10002;
    self.doneLabel = allPointLabel;
    
    [self.view addSubview:allPointLabel];
    [allPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(red);
        make.right.equalTo(self.view).offset(-60);
        make.width.mas_equalTo(120);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [allPointLabel addGestureRecognizer:tap1];
    allPointLabel.userInteractionEnabled = YES;
    
    
    UIImageView *blue = [[UIImageView alloc] initWithImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"4db6ff"]]];
    blue.layer.cornerRadius = 3;
    blue.layer.masksToBounds = YES;
    [self.view addSubview:blue];
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(ScaleWidth(470));
        make.top.equalTo(red.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(ScaleWidth(60));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *bluelabel = [UILabel new];
    bluelabel.font = kFont(15);
    bluelabel.textColor = kColor333;
    bluelabel.text = @"冻结金额";
    [self.view addSubview:bluelabel];
    [bluelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(blue);
        make.left.equalTo(blue.mas_right).offset(15);
    }];
    
    UILabel *frozen = [UILabel new];
    
    frozen.font = kFont(15);
    frozen.textColor = kColor333;
    frozen.text = @"369.55元>";
    frozen.tag = 10003;
    frozen.textAlignment = NSTextAlignmentRight;
    self.frezenLabel = frozen;
    
    [self.view addSubview:frozen];
    [frozen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(blue);
        make.right.equalTo(self.view).offset(-60);
        make.width.mas_equalTo(120);
    }];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [frozen addGestureRecognizer:tap3];
    frozen.userInteractionEnabled = YES;
    
    
    UIImageView *green = [[UIImageView alloc] initWithImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"20b939"]]];
    green.layer.cornerRadius = 3;
    green.layer.masksToBounds = YES;
    [self.view addSubview:green];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(ScaleWidth(520));
        make.top.equalTo(blue.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(ScaleWidth(60));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *glabel = [UILabel new];
    glabel.font = kFont(15);
    glabel.textColor = kColor333;
    glabel.text = @"账户明细";
    [self.view addSubview:glabel];
    [glabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(green);
        make.left.equalTo(green.mas_right).offset(15);
    }];
    
    UILabel *detail = [UILabel new];
    
    detail.font = kFont(15);
    detail.textColor = kColor333;
    detail.text = @">";
    detail.tag = 10004;
    detail.textAlignment = NSTextAlignmentRight;
    self.billLabel = detail;
    
    [self.view addSubview:detail];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(green);
        make.right.equalTo(self.view).offset(-60);
        make.width.mas_equalTo(120);
    }];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [detail addGestureRecognizer:tap4];
    detail.userInteractionEnabled = YES;
    
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    UIView *superview = tap.view;
    MoneyDetailViewController *vc = [MoneyDetailViewController new];
    vc.type = superview.tag - 10000;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
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
