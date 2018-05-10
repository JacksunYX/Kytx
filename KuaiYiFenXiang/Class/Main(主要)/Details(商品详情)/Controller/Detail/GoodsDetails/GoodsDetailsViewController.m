//
//  DCGoodBaseViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "GoodsDetailsViewController.h"

// Controllers
//#import "DCFootprintGoodsViewController.h"
#import "DCShareToViewController.h"
#import "DCToolsViewController.h"
#import "DCFeatureSelectionViewController.h"
#import "DCFillinOrderViewController.h"
#import "MakeSureTheOrderViewController.h"
#import "StoreDisplayViewController.h"
#import "DCGoodDetailViewController.h"
// Models

// Views
#import "DCLIRLButton.h"

#import "DCShowTypeOneCell.h"
#import "DCShowTypeTwoCell.h"
#import "DCShowTypeThreeCell.h"
#import "DCShowTypeFourCell.h"
// Vendors
#import "AddressPickerView.h"
#import <WebKit/WebKit.h>
#import "MJRefresh.h"
#import "MJExtension.h"
// Categories
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
// Others
#import <JavaScriptCore/JavaScriptCore.h>

@interface GoodsDetailsViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
/* 选择地址弹框 */
@property (strong , nonatomic)AddressPickerView *adPickerView;
/* 已选组Cell */
@property (weak ,nonatomic)DCShowTypeOneCell *cell;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;
/* 通知 */
@property (weak ,nonatomic) id dcObj;


@end





@implementation GoodsDetailsViewController


- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        _webView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        ;
        //进行刷新时开始刷新状态请求数据
        self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self setUpGoodsWKWebView];
            
        }];
        
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    [self setUpSuspendView];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [_backTopButton removeFromSuperview];
}

#pragma mark - LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpInit];

    [self setUpGoodsWKWebView];

    [self acceptanceNote];
}

#pragma mark - initialize

- (void)setUpInit
{
    
    self.view.backgroundColor = DCBGColor;
    
}

#pragma mark - 接受通知
- (void)acceptanceNote
{
    __weak typeof(self)weakSelf = self;
    //客服电话通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:@"callphone" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //        NSString *phonenumstring=[NSString stringWithFormat:@"tel:%@",note.userInfo[@"customerServiceTelephone"]];
        //        NSURL *phoneURL = [NSURL URLWithString:phonenumstring];
        //        [_webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:note.userInfo[@"customerServiceTelephone"] ]]];
    }];
    
    //分享通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:@"shareAlterView" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf selfAlterViewback];
        [weakSelf setUpAlterViewControllerWith:[DCShareToViewController new] WithDistance:300 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
    }];
    //加入购物车或点击直接购买通知
    _dcObj = [[NSNotificationCenter defaultCenter] addObserverForName:@"ClikAddOrBuy" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([KYHeader checkLogin]) {
            
            DCFeatureSelectionViewController *dcFeaVc = [DCFeatureSelectionViewController new];
            __weak typeof(self)weakSelf = self;
            
            dcFeaVc.userChooseBlock = ^(NSMutableArray *seleArray, NSInteger num, NSInteger tag,NSMutableDictionary *addCartDic) { //第一次更新选择的属性
                NSString *result = [NSString stringWithFormat:@"%@ %zd件",[seleArray componentsJoinedByString:@"，"],num];
                weakSelf.cell.contentLabel.text = result;
                NSLog(@"tag-----%ld",(long)tag);
                NSLog(@"addCartDic-----%@",addCartDic);
                if (tag==0) { //加入购物车
                    [weakSelf addShoppingCar:addCartDic];
                }else if (tag==1){//立即购买
                    [weakSelf buynow:addCartDic];
                }
                
            };
            
            if ([weakSelf.cell.leftTitleLable.text isEqual:@"已选"]) {
                
                if ([note.userInfo[@"buttonTag"] isEqualToString:@"3"]) { //加入购物车
                    
                }else if ([note.userInfo[@"buttonTag"] isEqualToString:@"4"]){//立即购买
                    DCFillinOrderViewController *dcFillVc = [DCFillinOrderViewController new];
                    [weakSelf.navigationController pushViewController:dcFillVc animated:YES];
                }
                
            }else{
                dcFeaVc.RootAttributeArray = note.userInfo[@"RootAttributeArray"];
                dcFeaVc.Spec_goods_priceArray=note.userInfo[@"Spec_goods_priceArray"];
                dcFeaVc.goods_infodictionary=note.userInfo[@"goods_infodictionary"];
                [self setUpAlterViewControllerWith:dcFeaVc WithDistance:ScreenH * 0.6 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:YES WithFlipEnable:YES];
            }
            
        }
        
    }];
}

#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
//    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 100, 40, 40);
    _backTopButton.sd_layout
    .rightSpaceToView(self.view, 50)
    .topSpaceToView(self.webView, -80)
    .widthIs(40)
    .heightIs(40)
    ;
}


#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    if (self.webView.scrollView.contentOffset.y > ScreenH) {
        [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }else{
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.webView.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }];
    }
}


#pragma mark - 记载图文详情
- (void)setUpGoodsWKWebView
{
    
    NSString *webUrlStr;
    if (kStringIsEmpty(self.goods_id)) {
        webUrlStr = [NSString stringWithFormat:@"%@%@/goods_id/%@/user_id/%@/token/%@",DefaultDomainName,NetRequestUrl(index),self.GeneralGoodsModel.goods_id,[USER_DEFAULT objectForKey:@"user_id"],[USER_DEFAULT objectForKey:@"token"]];
    }else{
        webUrlStr = [NSString stringWithFormat:@"%@%@/goods_id/%@/user_id/%@/token/%@",DefaultDomainName,NetRequestUrl(index),self.goods_id,[USER_DEFAULT objectForKey:@"user_id"],[USER_DEFAULT objectForKey:@"token"]];
    }
    
    //加载请求的时候忽略缓存
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webUrlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    [self.webView loadRequest:request];
    NSLog(@"加载的网页地址是:%@",webUrlStr);
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
}



#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance WithDirection:(XWDrawerAnimatorDirection)vcDirection WithParallaxEnable:(BOOL)parallaxEnable WithFlipEnable:(BOOL)flipEnable
{
    XWDrawerAnimatorDirection direction = vcDirection;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = parallaxEnable;
    animator.flipEnable = flipEnable;
    [self xw_presentViewController:vc withAnimator:animator];
    __weak typeof(self)weakSelf = self;
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf selfAlterViewback];
    }];
}

//网页视图即将加载弹出loding
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    //    kShowHUDAndActivity;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //    kHiddenHUDAndAvtivity;
    
    [self.webView.scrollView.mj_header endRefreshing];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //服务打开
    context[@"toshare2"]=^(){
        NSLog(@"toshare");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"closebottomview" object:nil userInfo:nil];
        });
    };
    //服务打开
    context[@"fwqx2"]=^(){
        NSLog(@"fwqx");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"openbottomview" object:nil userInfo:nil];
        });
    };
    //服务打开
    context[@"toshare11"]=^(){
        NSLog(@"toshare1");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"closebottomview" object:nil userInfo:nil];
        });    };
    //服务打开
    context[@"ggqx1"]=^(){
        NSLog(@"ggqx");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"openbottomview" object:nil userInfo:nil];
        });    };
    //点击进入店铺
    context[@"Indp"]=^(NSString *business_id){
        NSLog(@"Indp");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",business_id);
            StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
            sdvc.business_idstring=business_id;
            [self.navigationController pushViewController:sdvc animated:YES];
        });    };
    //
    context[@"new_tj"]=^(NSString *s_id){
        NSLog(@"new_tj");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",s_id);
            //H5详情页
            DCGoodDetailViewController *DCGoodDetailVc = [[DCGoodDetailViewController alloc] init];
            DCGoodDetailVc.goods_id=s_id;
            [self.navigationController pushViewController:DCGoodDetailVc animated:YES];
        });    };
    AppDelegate *de = [UIApplication sharedApplication].delegate;
    //点击收藏
    context[@"login"] = ^{
        NSLog(@"点击了收藏");
        
        if (!de.isLogin) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //进入登录界面
                enterNavigationController *loginVC = [enterNavigationController new];
                //回调刷新一下界面
                MCWeakSelf;
                loginVC.backHandleBlock = ^{
                    [weakSelf.webView.scrollView.mj_header beginRefreshing];
                };
                loginVC.normalBack = YES;
                YYFNavigationController *loginNvi = [[YYFNavigationController alloc]initWithRootViewController:loginVC];
                [self presentViewController:loginNvi animated:YES completion:nil];
            });
        }
    };
    
    
    
}

-(void)islogin
{
    
}


-(void)addShoppingCar:(NSMutableDictionary *)addCarDic{
    
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(addCart) parameters:addCarDic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        self.tabBarController.tabBar.items[3].badgeValue = @(self.tabBarController.tabBar.items[3].badgeValue.integerValue + [addCarDic[@"goods_num"] integerValue]).description;
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
}

-(void)buynow:(NSMutableDictionary *)addCarDic{
    
    addCarDic[@"type"] = @"1";
    [HttpRequest postWithTokenURLString:NetRequestUrl(buyNow) parameters:addCarDic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        
                                        MakeSureTheOrderViewController *mstovc = [MakeSureTheOrderViewController new];
                                        mstovc.resultdic=[result mutableCopy];
                                        mstovc.baseDic = [addCarDic mutableCopy];
                                        mstovc.type = 2; mstovc.DecideWhichControllerComesIn=@"GoodsDetailsViewController";
                                        [self.navigationController pushViewController:mstovc animated:YES];
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
}

#pragma 退出界面
- (void)selfAlterViewback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];
}

@end

