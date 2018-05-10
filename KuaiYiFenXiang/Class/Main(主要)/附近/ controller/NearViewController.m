//
//  NearViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "NearViewController.h"
#import "KYHeader.h"
#import "VIPViewController.h"

@interface NearViewController ()
@property (nonatomic, strong) UIButton *btn;

@end

@implementation NearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"VIP福利专区";
    
    
    UIImageView *image = [[UIImageView alloc] init];
    if (IPHONE_X) {
        image.image = [UIImage imageNamed:@"vip_x"];
    } else {
        image.image = [UIImage imageNamed:@"vip"];
    }
    [self.view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (IPHONE_X) {
            make.height.mas_equalTo(2436/3.0);
        } else {
            make.height.mas_equalTo(1334/2.0);
        }
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.view);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn = btn;
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (IPHONE_X) {
            make.bottom.equalTo(self.view).offset(-280/3.0);
            make.size.mas_equalTo(CGSizeMake(220, 35));
        } else {
            make.bottom.equalTo(self.view).offset(-ScaleHeight(65));
            make.size.mas_equalTo(CGSizeMake(ScaleWidth(225), ScaleHeight(35)));
        }
    }];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.userInteractionEnabled = NO;
    
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)next:(UIButton *)sender {
    VIPViewController *vc = [VIPViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if ([KYHeader checkLogin]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [HttpRequest postWithTokenURLString:NetRequestUrl(character) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                if ([res[@"role"]integerValue] == 1 || [res[@"role"]integerValue] == 2) {
                    self.btn.userInteractionEnabled = YES;
                    self.btn.backgroundColor = [UIColor clearColor];
                } else {
                    self.btn.backgroundColor = [UIColor blackColor];
                    self.btn.userInteractionEnabled = NO;
                }
            }
        } failure:nil RefreshAction:nil];
    }
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
