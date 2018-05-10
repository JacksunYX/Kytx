//
//  DCGoodDetailViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodDetailViewController.h"

// Controllers
#import "DCGoodBaseViewController.h"
#import "DCGoodParticularsViewController.h"
#import "DCGoodCommentViewController.h"
#import "ShoppingCarViewController.h"
#import "DCToolsViewController.h"
#import "StoreDisplayViewController.h"
#import "DCShareToViewController.h"

#import "GoodsDetailsViewController.h"

// Models

// Views

// Vendors
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
// Categories
#import "UIBarButtonItem+DCBarButtonItem.h"
// Others
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
@interface DCGoodDetailViewController ()<UIScrollViewDelegate>{
    
    TheStoreModel *model;
    NSString *mobilestring;

}
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *picker;
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UIView *bgView;
/** 记录上一次选中的Button */
@property (nonatomic , weak) UIButton *selectBtn;
/* 标题按钮地下的指示器 */
@property (weak ,nonatomic) UIView *indicatorView;
/* 通知 */
@property (weak ,nonatomic) id dcObserve;

@property (strong ,nonatomic) UIView *bottombuttonbgview;

@property (nonatomic, strong) NSMutableArray *RootAttributeArray;
@property (nonatomic, strong) NSMutableArray *Spec_goods_priceArray;
@property (nonatomic, strong) NSDictionary *goods_infodictionary;

@end

@implementation DCGoodDetailViewController

#pragma mark - LazyLoad
- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.pagingEnabled = YES;
        _scrollerView.delegate = self;
        [self.view addSubview:_scrollerView];
        _scrollerView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, 50)
        ;
        [_scrollerView updateLayout];
    }
    return _scrollerView;
}

#pragma mark - LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpChildViewControllers];
    
    [self setUpInit];
    
    [self setUpNav];

    [self setUpTopButtonView];

    [self addChildViewController];

    [self setUpBottomButton];

    [self acceptanceNote];

    [self RequestCommodityDetailsData];
    
}
- (void)RequestCommodityDetailsData{
    
    _RootAttributeArray=[NSMutableArray new];
    
    _Spec_goods_priceArray=[NSMutableArray new];
    
    _goods_infodictionary=[NSDictionary new];


    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    kStringIsEmpty(self.goods_id)?[dic setObject:self.GeneralGoodsModel.goods_id forKey:@"id"]:[dic setObject:self.goods_id forKey:@"id"];
    
    [HttpRequest postWithURLString:NetRequestUrl(goodsSpec) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)YES
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSDictionary *result=[responseObject objectForKey:@"result"];
                               
                                if (codeStr.intValue==1) {
                                   
                                   NSDictionary *goods_infodic=[result objectForKey:@"goods_info"];
                                    _goods_infodictionary=goods_infodic;
                                    
                                   model = [TheStoreModel mj_objectWithKeyValues:goods_infodic];
                                   model.name=[goods_infodic objectForKey:@"shop_name"];
                                   
                                   mobilestring=[goods_infodic objectForKey:@"mobile"];
                                   
                                   //商品属性数组
                                   NSMutableArray *filter_specarray=[result objectForKey:@"filter_spec"];
                                    if (!kArrayIsEmpty(filter_specarray)) {
                                        
                                   for (NSDictionary *dic in filter_specarray) {

                                       NSString *namestring=[dic objectForKey:@"name"];
                                       NSDictionary *attr=@{
                                                            @"attrname":namestring,
                                                            };
                                       
                                       NSMutableArray *list=[NSMutableArray new];
                                       NSMutableArray *resultarray=[dic objectForKey:@"result"];
                                      
//                                       for (NSDictionary *dic in resultarray) {
//                                           NSDictionary *itemdic=@{
//                                                                  @"infoname":[dic objectForKey:@"item"],
//                                                                  @"infoid":[dic objectForKey:@"item_id"],
//                                                                   };
//                                           [list addObject:itemdic];
//                                       }
                                       
                                       for (NSString *infonamestring in resultarray) {
                                           NSDictionary *itemdic=@{
                                                                   @"infoname":infonamestring,
//                                                                   @"infoid":[dic objectForKey:@"item_id"],
                                                                   };
                                           [list addObject:itemdic];
                                       }
                                       
                                       NSDictionary *rootitemdic=@{
                                                                   @"attr":attr,
                                                                   @"list":list
                                                                   };
                                       
                                       [_RootAttributeArray addObject:rootitemdic];
                                   
                                   }
                                    
//                                    NSLog(@"RootAttributeArray-----%@",_RootAttributeArray);
                                        
                                    }
                                    
                                    NSMutableArray *spec_goods_pricearray=[result objectForKey:@"spec_goods_price"];

                                    if (!kArrayIsEmpty(spec_goods_pricearray))
                                    {
                                        for (NSDictionary *dic in spec_goods_pricearray) {
                                            NSDictionary *spedic=@{
                                                                   [dic objectForKey:@"key_name"]:dic,
                                                                   };
                                            [_Spec_goods_priceArray addObject:spedic];
                                        }
                                    }

                                }
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];

}
#pragma mark - initialize
- (void)setUpInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollerView.backgroundColor = [UIColor whiteColor];
    self.scrollerView.contentSize = CGSizeMake(self.view.dc_width * self.childViewControllers.count, 0);
    
}


#pragma mark - 接受通知
- (void)acceptanceNote
{
    //滚动到详情
    __weak typeof(self)weakSlef = self;
    _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:@"scrollToDetailsPage" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSlef topBottonClick:weakSlef.bgView.subviews[1]]; //跳转详情
    }];
    
    _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:@"scrollToCommentsPage" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSlef topBottonClick:weakSlef.bgView.subviews[2]]; //跳转到评论界面
    }];
    
    _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:@"closebottomview" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _bottombuttonbgview.hidden=YES; //隐藏bottomview
    }];

    _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:@"openbottomview" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        _bottombuttonbgview.hidden=NO;//显示bottomview
    }];

}

#pragma mark - 头部View
- (void)setUpTopButtonView
{
//    NSArray *titles = @[@"商品",@"详情",@"评价"];
    NSArray *titles = @[@"商品",@"详情"];

    CGFloat margin = 5;
    _bgView = [[UIView alloc] init];
    _bgView.dc_centerX = ScreenW * 0.5;
    _bgView.dc_height = 44;
    _bgView.dc_width = (_bgView.dc_height + margin) * titles.count;
    _bgView.dc_y = 0;
    self.navigationItem.titleView = _bgView;
    
    CGFloat buttonW = _bgView.dc_height;
    CGFloat buttonH = _bgView.dc_height;
    CGFloat buttonY = _bgView.dc_y;
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = PFR15Font;
        [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = i * (buttonW + margin);
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [_bgView addSubview:button];
        
    }
    
    UIButton *firstButton = _bgView.subviews[0];
    [self topBottonClick:firstButton]; //默认选择第一个
    
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    indicatorView.dc_height = 2;
    indicatorView.dc_y = _bgView.dc_height - indicatorView.dc_height;
    
    [firstButton.titleLabel sizeToFit];
    indicatorView.dc_width = firstButton.titleLabel.dc_width;
    indicatorView.dc_centerX = firstButton.dc_centerX;
    
    [_bgView addSubview:indicatorView];

}

#pragma mark - 添加子控制器View
-(void)addChildViewController
{
    NSInteger index = _scrollerView.contentOffset.x / _scrollerView.dc_width;
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview) return; //判断添加就不用再添加了
    childVc.view.frame = CGRectMake(index * _scrollerView.dc_width, 0, _scrollerView.dc_width, _scrollerView.dc_height);
    [_scrollerView addSubview:childVc.view];
    
}

#pragma mark - 添加子控制器
-(void)setUpChildViewControllers
{
//    //原生详情页
//    __weak typeof(self)weakSelf = self;
//    DCGoodBaseViewController *goodBaseVc = [[DCGoodBaseViewController alloc] init];
//    goodBaseVc.goodTitle = _goodTitle;
//    goodBaseVc.goodPrice = _goodPrice;
//    goodBaseVc.goodSubtitle = _goodSubtitle;
//    goodBaseVc.shufflingArray = _shufflingArray;
//    goodBaseVc.goodImageView = _goodImageView;
//    goodBaseVc.changeTitleBlock = ^(BOOL isChange) {
//        if (isChange) {
//            weakSelf.title = @"图文详情";
//            weakSelf.navigationItem.titleView = nil;
//                self.scrollerView.contentSize = CGSizeMake(self.view.dc_width, 0);
//        }else{
//            weakSelf.title = nil;
//            weakSelf.navigationItem.titleView = weakSelf.bgView;
//            self.scrollerView.contentSize = CGSizeMake(self.view.dc_width * self.childViewControllers.count, 0);
//        }
//    };
//    [self addChildViewController:goodBaseVc];
    
    
    //H5详情页
    GoodsDetailsViewController *goodsDetailsVc = [[GoodsDetailsViewController alloc] init];
    kStringIsEmpty(self.goods_id)?[goodsDetailsVc  setGeneralGoodsModel:self.GeneralGoodsModel]:[goodsDetailsVc setGoods_id:self.goods_id];
    [self addChildViewController:goodsDetailsVc];

    
    //详情页
    DCGoodParticularsViewController *goodParticularsVc = [[DCGoodParticularsViewController alloc] init];
    kStringIsEmpty(self.goods_id)?[goodParticularsVc  setGeneralGoodsModel:self.GeneralGoodsModel]:[goodParticularsVc setGoods_id:self.goods_id];
    [self addChildViewController:goodParticularsVc];
    
    
    //评论页
//    DCGoodCommentViewController *goodCommentVc = [[DCGoodCommentViewController alloc] init];
//    goodParticularsVc.GeneralGoodsModel=self.GeneralGoodsModel;
//    [self addChildViewController:goodCommentVc];
    
}

#pragma mark - 底部按钮(收藏 购物车 加入购物车 立即购买)
- (void)setUpBottomButton
{
    //创建底部的按钮背景方便隐藏
    _bottombuttonbgview=[[UIView alloc]init];
    [_bottombuttonbgview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottombuttonbgview];
    _bottombuttonbgview.sd_layout
    .leftEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .widthIs(SCREEN_WIDTH)
    .heightIs(50);
    
    [self setUpLeftTwoButton];//收藏 购物车
    
    [self setUpRightTwoButton];//加入购物车 立即购买
}
#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    NSArray *imagesNor = @[/*@"kefu",*/@"dianpu",@"gouwuche"];
    NSArray *imagesSel = @[/*@"kefu",*/@"dianpu",@"gouwuche"];
    CGFloat buttonW = (ScreenW * 0.3)/imagesNor.count;
    CGFloat buttonH = 50;
    CGFloat buttonY = 0;
    
    for (NSInteger i = 0; i < imagesNor.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:BACKVIEWCOLOR];
        [button setImage:[UIImage imageNamed:imagesNor[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imagesSel[i]] forState:UIControlStateSelected];
        button.tag = i + 1;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = (buttonW * i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [_bottombuttonbgview addSubview:button];
    }
}
#pragma mark - 加入购物车 立即购买
- (void)setUpRightTwoButton
{
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    CGFloat buttonW = ScreenW * 0.7 * 0.5;
    CGFloat buttonH = 50;
    CGFloat buttonY = 0;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = PFR16Font;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = i + 3;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = (i == 0) ? RGB(249, 125, 10) : [UIColor redColor];
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = ScreenW * 0.3 + (buttonW * i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [_bottombuttonbgview addSubview:button];
    }
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildViewController];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.dc_width;
    UIButton *button = _bgView.subviews[index];
    
    [self topBottonClick:button];
    
    [self addChildViewController];
}

#pragma mark - 导航栏设置
- (void)setUpNav
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"shareimage"] WithHighlighted:[UIImage imageNamed:@"shareimage"] Target:self action:@selector(toolItemClick)];
}


#pragma mark - 点击事件
#pragma mark - 头部按钮点击
- (void)topBottonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _selectBtn = button;
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.dc_width = button.titleLabel.dc_width;
        weakSelf.indicatorView.dc_centerX = button.dc_centerX;
    }];
    
    CGPoint offset = _scrollerView.contentOffset;
    offset.x = _scrollerView.dc_width * button.tag;
    [_scrollerView setContentOffset:offset animated:YES];
}

#pragma mark - 点击工具条
- (void)toolItemClick
{
//    [self setUpAlterViewControllerWith:[DCToolsViewController new] WithDistance:150 WithDirection:XWDrawerAnimatorDirectionTop WithParallaxEnable:NO WithFlipEnable:NO];
    
//    [self setUpAlterViewControllerWith:[DCShareToViewController new] WithDistance:300 WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
    [self show:nil];
}

- (void)show:(UIButton *)sender {
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cover addGestureRecognizer:tap];
    
    self.picker = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 156+BOTTOM_MARGIN)];
    
    self.picker.backgroundColor = kWhiteColor;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.tag = 10001;
    [btn1 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.picker);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"朋友圈"]];
    
    [btn1 addSubview:imageview1];
    [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(btn1).offset(35);
        make.centerX.equalTo(btn1);
    }];
    
    UILabel *label1 = [UILabel new];
    
    label1.textColor = kColor333;
    label1.text =@"朋友圈";
    label1.font = kFont(12);
    
    [btn1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview1);
        make.top.mas_equalTo(imageview1.mas_bottom).offset(6);
    }];
    
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2.tag = 10002;
    [btn2 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1);
        make.left.equalTo(btn1.mas_right);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"微信"]];
    
    [btn2 addSubview:imageview2];
    [imageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(btn2).offset(35);
        make.centerX.equalTo(btn2);
    }];
    
    UILabel *label2 = [UILabel new];
    
    label2.textColor = kColor333;
    label2.text =@"微信好友";
    label2.font = kFont(12);
    
    [btn2 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview2);
        make.top.mas_equalTo(imageview2.mas_bottom).offset(6);
    }];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.hidden = YES;
    
    btn3.tag = 10003;
    [btn3 addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.picker addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2);
        make.left.equalTo(btn2.mas_right);
        make.height.mas_equalTo(110);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QQ"]];
    
    [btn3 addSubview:imageview3];
    [imageview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.equalTo(btn3).offset(35);
        make.centerX.equalTo(btn3);
    }];
    
    UILabel *label3 = [UILabel new];
    
    label3.textColor = kColor333;
    label3.text =@"QQ好友";
    label3.font = kFont(12);
    
    [btn3 addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview3);
        make.top.mas_equalTo(imageview3.mas_bottom).offset(6);
    }];
    
    UIView *line = [UIView new];
    
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self.picker addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.picker);
        make.height.mas_equalTo(1);
        make.top.equalTo(btn1.mas_bottom);
    }];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setTitle:@"取消" forState:UIControlStateNormal];
    btn4.titleLabel.font = kFont(15);
    [btn4 setTitleColor:kColor333 forState:UIControlStateNormal];
    [self.picker addSubview:btn4];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.picker);
        make.top.equalTo(line.mas_bottom);
    }];
    [btn4 addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    [[UIApplication sharedApplication].keyWindow addSubview:self.picker];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cover.alpha = 0.4;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT-156-BOTTOM_MARGIN, SCREEN_WIDTH, 156+BOTTOM_MARGIN);
    } completion:nil];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        
        
    }];
    [self.view endEditing:YES];
}



- (void)share:(UIButton *)sender {
    NSString *user_id = GetSaveString([USER_DEFAULT objectForKey:@"user_id"]);
    NSString *token = GetSaveString([USER_DEFAULT objectForKey:@"token"]);
    NSString *good_id = model.goods_id;
    NSString *business_id = model.business_id;
//    if (kStringIsEmpty(self.goods_id)) {
//        good_id = self.GeneralGoodsModel.goods_id;
//    }else{
//        good_id = self.goods_id;
//    }
    NSString *goodShareUrlStr = JoinShareWebUrlStr(GoodShareUrl, good_id, business_id, user_id, token);
    
//    [@"itms-apps://itunes.apple.com/us/app/快益分享商城/id1245685766?l=zh&ls=1&mt=8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    
    NSArray* imageArray;
    if (!kStringIsEmpty(model.original_img)) {
        imageArray = @[[NSString stringWithFormat:@"%@%@",DefaultDomainName,model.original_img]];
    }else{
        imageArray = @[[UIImage imageNamed:@"login_logo"]];
    }
    
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@""
                                         images:imageArray
                                            url:[NSURL URLWithString:goodShareUrlStr]
                                          title:GetSaveString(model.goods_name)
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //进行分享
        SSDKPlatformType type = SSDKPlatformTypeAny;
        if (sender.tag == 10001) {
            type = SSDKPlatformSubTypeWechatTimeline;
        } else if (sender.tag == 10002) {
            type = SSDKPlatformSubTypeWechatSession;
        } else if (sender.tag == 10003) {
            type = SSDKPlatformSubTypeQQFriend;
        }
        [ShareSDK share:type //传入分享的平台类型
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
             [self tap:nil];
             switch (state) {
                     
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     break;
                 }
                 default:
                     break;
             }
         }];
    }
    
}


- (void)bottomButtonClick:(UIButton *)button
{
    if (button.tag == 0) {
        NSLog(@"客服");
        //异步发通知
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",mobilestring],@"customerServiceTelephone", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"callphone" object:nil userInfo:dict];
        });
    }else if(button.tag == 1){
        NSLog(@"店铺");
        StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
        sdvc.business_idstring = _goods_infodictionary[@"business_id"];
        sdvc.TheStoreModel=model;
        
        [self.navigationController pushViewController:sdvc animated:YES];
    }else if(button.tag == 2){
        NSLog(@"购物车");
        ShoppingCarViewController *shopCarVc = [[ShoppingCarViewController alloc] init];
        shopCarVc.SuperiorControllerString=@"DCGoodDetailViewController";
        [self.navigationController pushViewController:shopCarVc animated:YES];
    }else  if (button.tag == 3 || button.tag == 4) { //父控制器的加入购物车和立即购买
        //异步发通知
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",button.tag],@"buttonTag",_RootAttributeArray,@"RootAttributeArray",_Spec_goods_priceArray,@"Spec_goods_priceArray",_goods_infodictionary,@"goods_infodictionary" ,nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClikAddOrBuy" object:nil userInfo:dict];
        });
    }
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

#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 消失
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObserve];
     NSLog(@"烫烫烫烫烫烫烫烫烫烫烫烫烫烫==================");
}


@end
