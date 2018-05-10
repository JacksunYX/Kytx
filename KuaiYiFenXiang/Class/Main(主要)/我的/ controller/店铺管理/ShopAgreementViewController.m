//
//  ShopAgreementViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/28.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShopAgreementViewController.h"
#import <WebKit/WebKit.h>
#import "KYHeader.h"
@interface ShopAgreementViewController ()<UIWebViewDelegate>
@end

@implementation ShopAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.title = @"商家注册协议";
    
    UIWebView *a = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-44-BOTTOM_MARGIN)];
    a.delegate = self;

    NSString *html = [NSString stringWithFormat:@"%@%@",DefaultDomainName,NetRequestUrl(useragreement)];
    [a loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
    [self.view addSubview:a];
    
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44-BOTTOM_MARGIN);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"同意" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44+BOTTOM_MARGIN);
    }];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)click:(UIButton *)sender {
    [USER_DEFAULT setBool:YES forKey:@"showcategory"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    kShowHUDAndActivity;
    
    
}
//在网页视图完成加载后隐藏loding
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    kHiddenHUDAndAvtivity;
    
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
