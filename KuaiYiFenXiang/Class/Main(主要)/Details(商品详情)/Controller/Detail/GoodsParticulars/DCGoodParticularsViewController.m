//
//  DCGoodParticularsViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodParticularsViewController.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCGoodParticularsViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation DCGoodParticularsViewController

#pragma mark - LazyLoad


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _webView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    
    NSString *webUrlStr;
    if (kStringIsEmpty(self.goods_id)) {
        webUrlStr = [NSString stringWithFormat:@"%@%@/goods_id/%@/user_id/%@/token/%@",DefaultDomainName,NetRequestUrl(details),self.GeneralGoodsModel.goods_id,[USER_DEFAULT objectForKey:@"user_id"],[USER_DEFAULT objectForKey:@"token"]];
    }else{
        webUrlStr = [NSString stringWithFormat:@"%@%@/goods_id/%@/user_id/%@/token/%@",DefaultDomainName,NetRequestUrl(details),self.goods_id,[USER_DEFAULT objectForKey:@"user_id"],[USER_DEFAULT objectForKey:@"token"]];
    }
    //加载请求的时候忽略缓存
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    [self.webView loadRequest:request];
    NSLog(@"加载的网页地址是:%@",webUrlStr);
    
}
//网页视图即将加载弹出loding
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    //    kShowHUDAndActivity;
    
    
}
//在网页视图完成加载后隐藏loding
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //    kHiddenHUDAndAvtivity;
    
}

@end

