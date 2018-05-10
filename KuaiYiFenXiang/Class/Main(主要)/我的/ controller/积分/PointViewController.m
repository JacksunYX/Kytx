//
//  PointViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "PointViewController.h"
#import "KYHeader.h"
#import "PointDetailViewController.h"

@interface PointViewController ()

@property (nonatomic, strong) UILabel *addPointLabel;
@property (nonatomic, strong) UILabel *allPointLabel;
@property (nonatomic, strong) UILabel *payPointLbael;
@property (nonatomic, strong) UILabel *shopPointLabel;
@property (nonatomic, strong) UILabel *encurPointLabel;


@end

@implementation PointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"我的积分";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积分"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(552));
    }];
    
    
    [self configUI];
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(mypoint) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            self.addPointLabel.text = [[NSString stringWithFormat:@"%.4f", [res[@"result"][@"today_love"] floatValue]] stringByAppendingString:@"个>"];
            self.allPointLabel.text = [[NSString stringWithFormat:@"%.4f", [res[@"result"][@"total_love"] floatValue]] stringByAppendingString:@"个>"];
            self.payPointLbael.text = [NSString stringWithFormat:@"%.4f", [res[@"result"][@"love_list"][@"two_love"] floatValue]];
            self.shopPointLabel.text = [NSString stringWithFormat:@"%.4f", [res[@"result"][@"love_list"][@"three_love"] floatValue]];
            self.encurPointLabel.text = [NSString stringWithFormat:@"%.4f", [res[@"result"][@"love_list"][@"one_love"] floatValue]];
        }
    } failure:nil RefreshAction:nil];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : kWhiteColor} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : kWhiteColor} forState:UIControlStateHighlighted];
    
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)configUI {
    UILabel *alabel = [UILabel new];
    
    alabel.font = kFont(18);
    alabel.textColor = kWhiteColor;
    alabel.text = @"商品积分";
//    alabel.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScaleWidth(230));
    }];
    
    UILabel *blabel = [UILabel new];
    
    blabel.font = kFont(18);
    blabel.textColor = kWhiteColor;
    blabel.text = @"消费积分";
//    blabel.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH/4 - ScaleWidth(7));
        make.top.equalTo(self.view).offset(ScaleWidth(270));
    }];
    
    UILabel *clabel = [UILabel new];
    
    clabel.font = kFont(18);
    clabel.textColor = kWhiteColor;
    clabel.text = @"激励积分";
//    clabel.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:clabel];
    [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(SCREEN_WIDTH/4 + ScaleWidth(7));
        make.top.equalTo(self.view).offset(ScaleWidth(270));
    }];
    
    UILabel *dlabel = [UILabel new];
    
    dlabel.font = kFont(18);
    dlabel.textColor = kWhiteColor;
    dlabel.text = @"0.0000";
    self.shopPointLabel = dlabel;
    //    alabel.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:dlabel];
    [dlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(alabel.mas_bottom).offset(ScaleWidth(10));
    }];
    
    UILabel *elabel = [UILabel new];
    
    elabel.font = kFont(18);
    elabel.textColor = kWhiteColor;
    elabel.text = @"0.0000";
    //    blabel.backgroundColor = [UIColor yellowColor];
    self.payPointLbael = elabel;
    
    [self.view addSubview:elabel];
    [elabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH/4 - ScaleWidth(7));
        make.top.equalTo(blabel.mas_bottom).offset(ScaleWidth(10));
    }];
    
    UILabel *flabel = [UILabel new];
    
    flabel.font = kFont(18);
    flabel.textColor = kWhiteColor;
    flabel.text = @"0.0000";
    self.encurPointLabel = flabel;
    //    clabel.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:flabel];
    [flabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(SCREEN_WIDTH/4 + ScaleWidth(7));
        make.top.equalTo(clabel.mas_bottom).offset(ScaleWidth(10));
    }];
    
//    UIImageView *wave1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"橙"]];
//    wave1.contentMode = UIViewContentModeScaleAspectFill;
//    wave1.layer.masksToBounds = YES;
//    [self.view addSubview:wave1];
//    [wave1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.view).offset(ScaleWidth(230));
//        make.width.mas_equalTo(ScaleWidth(90));
//        make.bottom.equalTo(self.view.mas_centerY);
//    }];
    
    
    UIImageView *orange = [[UIImageView alloc] initWithImage:[KYHeader imageWithColor:[UIColor orangeColor]]];
    orange.layer.cornerRadius = 3;
    orange.layer.masksToBounds = YES;
    [self.view addSubview:orange];
    [orange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScaleWidth(450));
        
        make.left.equalTo(self.view).offset(ScaleWidth(60));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *olabel = [UILabel new];
    olabel.font = kFont(15);
    olabel.textColor = kColor333;
    olabel.text = @"今日新增";
    [self.view addSubview:olabel];
    [olabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orange);
        make.left.equalTo(orange.mas_right).offset(15);
    }];
    
    UILabel *newPointLabel = [UILabel new];
    newPointLabel.font = kFont(15);
    newPointLabel.textColor = kColor333;
    newPointLabel.text = @"102.89元>";
    self.addPointLabel = newPointLabel;
    [self.view addSubview:newPointLabel];
    [newPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orange);
        make.right.equalTo(self.view).offset(-60);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [newPointLabel addGestureRecognizer:tap];
    newPointLabel.userInteractionEnabled = YES;
    
    UIImageView *red = [[UIImageView alloc] initWithImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]]];
    red.layer.cornerRadius = 3;
    red.layer.masksToBounds = YES;
    [self.view addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(ScaleWidth(500));
        
        make.left.equalTo(self.view).offset(ScaleWidth(60));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *rlabel = [UILabel new];
    rlabel.font = kFont(15);
    rlabel.textColor = kColor333;
    rlabel.text = @"累计获得积分";
    [self.view addSubview:rlabel];
    [rlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(red);
        make.left.equalTo(red.mas_right).offset(15);
    }];
    
    UILabel *allPointLabel = [UILabel new];
    allPointLabel.font = kFont(15);
    allPointLabel.textColor = kColor333;
    allPointLabel.text = @"4569.元>";
    self.allPointLabel = allPointLabel;
    [self.view addSubview:allPointLabel];
    [allPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(red);
        make.right.equalTo(self.view).offset(-60);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [allPointLabel addGestureRecognizer:tap1];
    allPointLabel.userInteractionEnabled = YES;
    
//    UIView *temp = [UIView new];
//    temp.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:temp];
//    temp.layer.masksToBounds = YES;
//    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.width.mas_equalTo(ScaleWidth(86));
//        make.height.mas_equalTo(ScaleWidth(180));
//        make.top.equalTo(self.view).offset(ScaleWidth(150));
//    }];
//
//    UIImageView *timageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"橙"]];
//    timageview.contentMode = UIViewContentModeScaleAspectFill;
//    [temp addSubview:timageview];
//    [timageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(temp);
//        make.top.equalTo(temp).offset(50);
//        make.size.mas_equalTo(CGSizeMake(ScaleWidth(358/2.0), ScaleWidth(461)));
//    }];
    
}

- (void)tap:(UITapGestureRecognizer *)tap {
    PointDetailViewController *vc = [PointDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)right:(UIButton *)btn {
    KYWebViewController *vc = [KYWebViewController new];
    vc.name = @"积分规则";
    vc.web_url = pointrule_url;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self configNavi];
    
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
