//
//  PublishShopViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "PublishShopViewController.h"

@interface PublishShopViewController ()

@end

@implementation PublishShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"发布商品";
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发布商品-1"]];
    
    [self.view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(15);
        make.height.mas_equalTo(ScaleHeight(300));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn setTitle:@"联系客服：400-998-9798" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-50);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
}

- (void)click {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:@"4009889798" ]]];
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
