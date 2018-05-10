//
//  AgreementViewController.m
//  cidehui
//
//  Created by apple on 11/03/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MessageDetailsViewController.h"

@interface MessageDetailsViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation MessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建网页视图控制器
    self.title=@"消息详情";
    NSLog(@"%@",self.messageid);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSString *html = [NSString stringWithFormat:@"%@%@/message_id/%@/user_id/%@/token/%@",DefaultDomainName,NetRequestUrl(message_detail),self.messageid,[USER_DEFAULT objectForKey:@"user_id"],[USER_DEFAULT objectForKey:@"token"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
    
}
//网页视图即将加载弹出loding
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
