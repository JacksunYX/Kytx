//
//  WebViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYWebViewController.h"
#import <WebKit/WebKit.h>
#import "KYHeader.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface KYWebViewController ()<UIWebViewDelegate>

@property(nonatomic, strong)WKWebView *webView;

@end

@implementation KYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kDefaultBGColor;
//    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT)];
////    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DefaultDomainName, self.web_url]]];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    _webView.navigationDelegate = self;
//    _webView.UIDelegate = self;
//    [_webView loadRequest:request];
//    _webView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_webView];
    UIWebView *a = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT)];
    a.delegate = self;
    if (self.bgcolor) {
        a.backgroundColor = [UIColor colorWithHexString:self.bgcolor];
    }
    self.title = self.name;
    NSString *str = [DefaultDomainName stringByAppendingString:self.web_url];
    NSLog(@"url地址：%@",str);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [self.view addSubview:a];
    [a loadRequest:request];
    if ([self.name isEqualToString:@"大额充值规则"]) {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"电话"] style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
        [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateHighlighted];
        self.navigationItem.rightBarButtonItem = item1;
    }

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
    
    [self.webView.scrollView.mj_header endRefreshing];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    //点击进入店铺
    context[@"new_tj"]=^(NSString *s_id){
        NSLog(@"new_tj");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",s_id);
            //H5详情页
            DCGoodDetailViewController *DCGoodDetailVc = [[DCGoodDetailViewController alloc] init];
            DCGoodDetailVc.goods_id=s_id;
            [self.navigationController pushViewController:DCGoodDetailVc animated:YES];
        });    };
    
}


- (void)right:(UIButton *)sender {
    [self tapCall];
}

#pragma mark - 打电话
-(void)tapCall
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:@"400-988-9798" ]]];
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
