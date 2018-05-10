//
//  WebShareRegisterViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "WebShareRegisterViewController.h"

@interface WebShareRegisterViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;

@end

@implementation WebShareRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *a = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
    a.delegate = self;
    a.backgroundColor = kDefaultBGColor;
    self.webview = a;
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"快益商城注册";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.view addSubview:a];
    [a loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor333}];
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
