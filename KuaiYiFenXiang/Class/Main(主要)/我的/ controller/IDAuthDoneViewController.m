//
//  IDAuthDoneViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "IDAuthDoneViewController.h"
#import "KYHeader.h"

@interface IDAuthDoneViewController ()

@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong) UILabel *trueLabel;
@property (nonatomic, strong) UILabel *idLabel;

@end

@implementation IDAuthDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = kDefaultBGColor;
    [self configNavi];
    [self configUI];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(approve) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            NSDictionary *dict = res[@"result"];
            self.nameLabel.text = res[@"nickname"];
            
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:dict[@"image"]]]];
            self.trueLabel.text = dict[@"relname"];
            
            NSString *idstr = dict[@"user_card"];
//            NSString *idstr = @"420102199312240810";
            if (idstr.length) {
                NSString *sub = [idstr substringWithRange:NSMakeRange(1, idstr.length - 2)];
                NSString *temp = @"";
                
                for (int i=0; i < idstr.length - 2; i++) {
                    temp = [temp stringByAppendingString:@"*"];
                }
                self.idLabel.text = [idstr stringByReplacingOccurrencesOfString:sub withString:temp];
            } else {
                self.idLabel.text = @"";
            }
        }
    } failure:^(NSError *err) {
        [self.navigationController popViewControllerAnimated:YES];
    } RefreshAction:nil];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
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

- (void)configUI {
    UIImageView *bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"实名认证_bg"]];
    [self.view addSubview:bgimageView];
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(456/2.0));
    }];
    
    UIView *aview = [UIView new];
    
    aview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(bgimageView.mas_bottom);
        make.height.mas_equalTo(ScaleHeight(100));
    }];
    
    UIView *line = [UIView new];
    [aview addSubview:line];
    line.backgroundColor = kColor999;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(aview);
        make.height.equalTo(@0.5);
    }];
    
    UIView *f1 = [self viewWithName:@"真实姓名" desc:@"文戬"];
    [self.view addSubview:f1];
    [f1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aview.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    UIView *f2 = [self viewWithName:@"身份证号" desc:@"4****************0"];
    [self.view addSubview:f2];
    [f2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(f1.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    
    UIView *f3 = [self viewWithName:@"证件审核" desc:@"已通过"];
    [self.view addSubview:f3];
    [f3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(f2.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    UIView *bgView = [[UIView alloc] init];
    
    bgView.layer.cornerRadius = 5;
    bgView.layer.shadowOffset = CGSizeMake(0, 3);
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowRadius = 3;
    bgView.layer.shadowOpacity = 0.2;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgimageView.mas_bottom);
        make.height.mas_equalTo(180);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UILabel *shimingLabel = [UILabel new];
    shimingLabel.text = @"您已通过实名认证";
    shimingLabel.font = [UIFont systemFontOfSize:15];
    shimingLabel.textColor = kColor333;
    
    [bgView addSubview:shimingLabel];
    [shimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-40);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"实名认证头像"]];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(bgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    icon.layer.borderWidth = 5;
    icon.layer.borderColor = kWhiteColor.CGColor;
    icon.layer.cornerRadius = 25;
    icon.layer.shadowOffset = CGSizeMake(0, 3);
    icon.layer.shadowColor = [UIColor blackColor].CGColor;
    icon.layer.shadowRadius = 3;
    icon.layer.shadowOpacity = 0.2;
    icon.layer.masksToBounds = YES;
    self.icon = icon;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"文戬";
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = kColor333;
    
    [bgView addSubview: nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(icon.mas_bottom).offset(16);
    }];
    
    UIView *wrap = [UIView new];
    wrap.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:wrap];
    [wrap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
//        make.top.equalTo(nameLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已实名_icon"]];
    [wrap addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wrap);
        make.centerY.equalTo(wrap);
        make.size.mas_equalTo(CGSizeMake(57/2, 25));
    }];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = @"已实名";
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [UIColor colorWithHexString:@"d40000"];
    [wrap addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(wrap);
        make.left.equalTo(imageView.mas_right).offset(5);
    }];
    
}

- (UIView *)viewWithName:(NSString *)name desc:(NSString *)desc {
    UIView *view = [UIView new];
    view.backgroundColor = kWhiteColor;
    
    UILabel *a = [UILabel new];
    a.text = name;
    a.textColor = kColor666;
    a.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:a];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
    }];
    
    UILabel *b = [UILabel new];
    b.text = desc;
    b.textColor = kColor666;
    b.font = [UIFont systemFontOfSize:15];
    if ([name isEqualToString:@"真实姓名"]) {
        self.trueLabel = b;
    } else if ([name isEqualToString:@"身份证号"]) {
        self.idLabel = b;
    }
    
    [view addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-15);
        make.centerY.equalTo(view);
    }];
    
    UIView *line = [UIView new];
    [view addSubview:line];
    line.backgroundColor = kColor999;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@0.5);
    }];
    return view;
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
