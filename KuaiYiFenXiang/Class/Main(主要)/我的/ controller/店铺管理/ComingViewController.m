//
//  ComingViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ComingViewController.h"
#import "UserRegisterViewController.h"
#import "ShopRegisterViewController.h"

@interface ComingViewController ()

@end

@implementation ComingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = @"立即入驻";
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人店"]];
    imageview1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        UserRegisterViewController *vc = [UserRegisterViewController new];
        vc.type1 = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [imageview1 addGestureRecognizer:tap1];
    [self.view addSubview:imageview1];
    [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScaleHeight(60));
        make.size.mas_equalTo(CGSizeMake(467/2.0, 265/2.0));
    }];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"企业店"]];
    imageview2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        ShopRegisterViewController *vc = [ShopRegisterViewController new];
        vc.type1 = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [imageview2 addGestureRecognizer:tap2];

    [self.view addSubview:imageview2];
    [imageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageview1.mas_bottom).offset(ScaleHeight(60));
        make.size.mas_equalTo(CGSizeMake(539/2.0, 265/2.0));
    }];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"底纹"]];
    
    [self.view addSubview:imageview3];
    [imageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleHeight(388/2.0));
    }];
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
