//
//  SubclassModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "StoreDisplayViewController.h"

#import "GoodsUnifiedModel.h"


#import "DCCustionHeadView.h"

#import "HighIntegralCollectionViewCell.h"

#import "UserPayViewController.h"

#import "DCShareToViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

static int pageNum=0;

@interface StoreDisplayViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate,PYSearchViewControllerDelegate>{
    
    NSString *typestring;
    
    NSString *searchTextString;
    
    NSString *ratio;
    
    NSString *multiple;
    
    UIImageView *emptyImageView;
    
    UILabel *emptyLabel;
}
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *picker;
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSMutableArray<GoodsUnifiedModel *> *dataSource;

/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;
@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const DCCustionHeadViewID = @"DCCustionHeadView";

static NSString *const HighIntegralCollectionViewCellID = @"HighIntegralCollectionViewCell";

static NSString *const UICollectionViewCellID = @"UICollectionViewCell";

@implementation StoreDisplayViewController


static int scrollTop = 0;
static int scrollBottom = 0;
static int pointY = 0;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    pageNum=0;
    
    self.fd_interactivePopDisabled = YES;
    
    [self requestShopData];
    
    [self setUpSuspendView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [_backTopButton removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置navigationBar的中间为searchBar
    YYFSearchBar *navigationsearchbar=[[YYFSearchBar alloc] init];
    navigationsearchbar.delegate=self;
    self.navigationItem.titleView = navigationsearchbar;
    
    _dataSource = [NSMutableArray new];
    
    typestring = @"2";
    
    [self setUpGoodsData];
    
    self.navigationsearchbar = navigationsearchbar;
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"白色箭头" hightimage:@"白色箭头" andTitle:@""];
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(shareClick) image:@"shareWhite" hightimage:@"shareWhite"  andTitle:@""];
}

#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[HttpRequest getCurrentVC].view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH-100, 40, 40);
}

//添加线下支付入口按钮
-(void)addOfflinePayEnterButton
{
    UIButton *offlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [offlineBtn addTarget:self action:@selector(goToOfflinePay) forControlEvents:UIControlEventTouchUpInside];
    [offlineBtn setImage:[UIImage imageNamed:@"offlinePayBtn"] forState:UIControlStateNormal];
    offlineBtn.frame = CGRectMake(ScreenW - 45, ScreenH - 250, 45, 50);
    [self.view addSubview:offlineBtn];
}
//线下支付
-(void)goToOfflinePay
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.isLogin) {
        NSLog(@"进入线下支付");
        UserPayViewController *upvc = [[UserPayViewController alloc]init];
        upvc.user_name = [USER_DEFAULT objectForKey:@"nickname"];
        upvc.shop_name = self.TheStoreModel.name;
        upvc.business_id = self.business_idstring;
        upvc.ratio = self.TheStoreModel.ratio;
        upvc.mutiply = self.TheStoreModel.multiple;
        [self.navigationController pushViewController:upvc animated:YES];
    }else{
        NSLog(@"进入登录界面");
        enterNavigationController *loginVC = [enterNavigationController new];
        loginVC.normalBack = YES;
        YYFNavigationController *loginNvi = [[YYFNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:loginNvi animated:YES completion:nil];
    }
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
//    _collectionView.frame = CGRectMake(0, -NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT  - BOTTOM_MARGIN);
    
    [self.collectionView scrollToTopAnimated:YES];
    
    //    if (self.collectionView.contentOffset.y > ScreenH) {
    //        [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    //    }
    //    else{
    
    //        [UIView animateWithDuration:0.5 animations:^{
    //            self.collectionView.frame = CGRectMake(0, -NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT  - BOTTOM_MARGIN);
    //        } completion:^(BOOL finished) {
//    self.collectionView.contentOffset = CGPointMake(0, 0);
    //        }];
    //    }
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
    //    NSLog(@"%lf",scrollView.contentOffset.y);
//    pointY = 175 - NAVI_HEIGHT;
    if (scrollView.contentOffset.y >= pointY) {
        scrollTop ++;
        NSLog(@"上拉到需要将头部固定的偏移量了");
        if (scrollTop == 1) {
            pointY = 175;
            _collectionView.contentOffset = CGPointMake(0, 175);
        }
        scrollBottom = 0;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN);
        
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"BACK" hightimage:@"BACK" andTitle:@""];
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(shareClick) image:@"shareimage" hightimage:@"shareimage"  andTitle:@""];
        
    }else{
        if (scrollTop == 0&&scrollBottom == 0) {
            return;
        }
        scrollBottom ++;
        NSLog(@"下拉到需要将头部移动的偏移量了");
        if (scrollBottom == 1) {
            pointY = 175 - NAVI_HEIGHT;
            _collectionView.contentOffset = CGPointMake(0, 175 - NAVI_HEIGHT);
        }
        scrollTop = 0;
        _collectionView.frame = CGRectMake(0, -NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT  - BOTTOM_MARGIN);
        
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"白色箭头" hightimage:@"白色箭头" andTitle:@""];
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(shareClick) image:@"shareWhite" hightimage:@"shareWhite"  andTitle:@""];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewTo
{
    
}

#pragma mark - 加载数据
- (void)setUpGoodsData
{
    
    
    
    
    //    _dataSource=[NSMutableArray new];
    //
    //
    //
    //        //通过循环模拟数据的请求
    //        for (int i=0; i<8; i++) {
    //
    //
    //            //        integralString
    //
    //
    //            NSDictionary *dic = @{
    //                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
    //                                  @"cellidStr":[NSString stringWithFormat:@"%d",i],
    //
    //                                  @"imageurlString":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
    //
    //                                  @"maintitleString":@"Apple iPhone SE 玫瑰金16G 4G手机（全网通）",
    //
    //                                  @"originalpriceString":@"¥ 6299",
    //
    //                                  @"presentpriceString":@"¥ 3299",
    //
    //                                  @"integralString":@"26.00",
    //
    //                                  };
    //
    //
    //            //初始化模型
    //            GoodsUnifiedModel *model=[GoodsUnifiedModel mj_objectWithKeyValues:dic];
    //            //把模型添加到相应的数据源数组中
    //            [_dataSource addObject:model];
    //
    //        }
    //
    //    [self.collectionView reloadData];
    
    
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    kStringIsEmpty(self.business_idstring)?:[dic setObject:self.business_idstring forKey:@"business_id"];
    
    [dic setObject:kStringIsEmpty(searchTextString)?@"":searchTextString forKey:@"goods_name"];
    
    [dic setObject:@(pageNum) forKey:@"page"];
    
    [dic setObject:typestring forKey:@"type"];
    
    [HttpRequest postWithURLString:NetRequestUrl(search) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSMutableArray *result=[responseObject objectForKey:@"result"];
                               
                               [self hiddenEmptyView];
                               
                               if (codeStr.intValue==1) {
                                   
                                   //空数组
                                   if (kArrayIsEmpty(result)) {
                                       
                                       //下拉刷新无数据时
                                       if (_dataSource.count == 0 && pageNum == 0) {
                                           [self showEmptyView];
                                           [self.collectionView.mj_header endRefreshing];
                                           self.collectionView.mj_footer = nil;
                                       }else{
                                           
                                           [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                           
                                       }
                                       
                                   }else{   //数组有值时
                                       
                                       for (NSDictionary * dic in result) {
                                           
                                           //初始化模型
                                           GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
                                           //把模型添加到相应的数据源数组中
                                           [_dataSource addObject:model];
                                           
                                       }
                                       [self.collectionView.mj_header endRefreshing];
                                       [self.collectionView.mj_footer endRefreshing];
                                       
                                   }
                                   
                               }
                               
                               
                               [self.collectionView reloadData];
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
                               [self.collectionView.mj_header endRefreshing];
                               
                               [self.collectionView.mj_footer endRefreshing];
                               
                               [self.collectionView reloadData];
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
    
    
}

//获取店铺信息
-(void)requestShopData
{
    if (!kStringIsEmpty(self.business_idstring)) {
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        dict1[@"business_id"] = self.business_idstring;
        [HttpRequest postWithTokenURLString:NetRequestUrl(shophead) parameters:dict1 isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                NSDictionary *result = res[@"result"];
                TheStoreModel *model = [TheStoreModel new];
                model.name = result[@"name"];
                model.logo = result[@"logo"];
                model.type = result[@"type"];
                model.ratio = [result[@"ratio"] integerValue];
                model.multiple = [result[@"multiple"] integerValue];
                model.business_id = self.business_idstring;
                model.sign = [result[@"sign"] integerValue];
                self.TheStoreModel = model;
                [self.collectionView reloadData];
            }
        } failure:nil RefreshAction:nil];
    }
}

//显示空提示
-(void)showEmptyView
{
    emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无商品"]];
    [self.collectionView addSubview:emptyImageView];
    emptyImageView.sd_layout
    .centerXEqualToView(_collectionView)
    .centerYIs(_collectionView.height*0.6)
    .widthIs(SCREEN_WIDTH/3)
    .heightIs(SCREEN_WIDTH/4);
    
    emptyLabel = [[UILabel alloc]init];
    [emptyLabel setFont:PFR15Font];
    [emptyLabel setTextColor:[UIColor grayColor]];
    [emptyLabel setText:@"店主还未上传商品噢"];
    [emptyLabel setTextAlignment:NSTextAlignmentCenter];
    [self.collectionView addSubview:emptyLabel];
    emptyLabel.sd_layout
    .centerXEqualToView(_collectionView)
    .topSpaceToView(emptyImageView, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(30);
}

//隐藏空提示
-(void)hiddenEmptyView
{
    if (emptyImageView) {
        [emptyImageView removeFromSuperview];
    }
    if (emptyLabel) {
        [emptyLabel removeFromSuperview];
    }
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        layout.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setScrollEnabled:YES];
        _collectionView.frame = CGRectMake(0, -NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT  - BOTTOM_MARGIN);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        [_collectionView setBackgroundColor:BACKVIEWCOLOR];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        [_collectionView registerClass:[DCCustionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID];
        
        [_collectionView registerClass:[HighIntegralCollectionViewCell class] forCellWithReuseIdentifier:HighIntegralCollectionViewCellID];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:UICollectionViewCellID];
        
        [self.view addSubview:_collectionView];
        pointY = 175 - NAVI_HEIGHT;
        
        //进行刷新时开始刷新状态请求数据
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            pageNum=0;
            
            //在请求数据的时间初始化当前的数据源数组防止数据重复
            [self.dataSource removeAllObjects];
            
            // 进入刷新状态后会自动调用这个block
            [self setUpGoodsData];
            
        }];
        
        // 上拉加载
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            
            //上拉加载把page数加一
            pageNum++;
            
            // 进入刷新状态后会自动调用这个block
            [self setUpGoodsData];
            
        }];
        
        [self addOfflinePayEnterButton];
        
    }
    return _collectionView;
}




#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return _dataSource.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    if (indexPath.section==0) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *cellimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
        [cellimageview setImage:[UIImage imageNamed:@"我的店铺bg"]];
        [cellimageview setUserInteractionEnabled:YES];
        [cell.contentView addSubview:cellimageview];
        
        UIImageView *storeimageview=[[UIImageView alloc]init];
        kStringIsEmpty(self.TheStoreModel.logo)?[storeimageview setImage:UIImageNamed(@"店铺logo")]:[storeimageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,self.TheStoreModel.logo]] placeholderImage:nil];
        [cellimageview addSubview:storeimageview];
        storeimageview.sd_layout
        .bottomSpaceToView(cellimageview, 33)
        .leftSpaceToView(cellimageview, 15)
        .widthIs(70)
        .heightIs(70);
        
        UILabel *storenameLabel=[[UILabel alloc]init];
        [storenameLabel setTextColor:[UIColor whiteColor]];
        [storenameLabel setFont:PFR15Font];
        [storenameLabel setText:self.TheStoreModel.name];
        [cellimageview addSubview:storenameLabel];
        storenameLabel.sd_layout
        .topSpaceToView(storeimageview, -storeimageview.height/1.3)
        .leftSpaceToView(storeimageview, 8)
        .autoHeightRatio(0);
        [storenameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        UIImageView *storeTagLabel=[[UIImageView alloc] init];
        if ([self.TheStoreModel.type isEqualToString:@"offline"]) {
            storeTagLabel.image = [UIImage imageNamed:@"个人店商家"];
        } else {
            storeTagLabel.image = [UIImage imageNamed:@"企业店商家"];
        }
        
        [cellimageview  addSubview:storeTagLabel];
        storeTagLabel.sd_layout
        .topSpaceToView(storenameLabel, 0)
        .leftEqualToView(storenameLabel)
        .widthIs(94/2.0)
        .heightIs(37/2.0);
        
        UIButton * collectionStoreButton = [[UIButton alloc] init];
        [collectionStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [collectionStoreButton.layer setMasksToBounds:YES];
        [collectionStoreButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        //边框宽度
        [collectionStoreButton.layer setBorderWidth:1.0];
        collectionStoreButton.layer.borderColor=[UIColor redColor].CGColor;
        collectionStoreButton.titleLabel.font = PFR10Font;
        collectionStoreButton.backgroundColor =  [UIColor redColor];//hwcolor(18, 36, 46);
        NSString *collectStr;
        //代表未登录
        if (self.TheStoreModel.sign == 0) {
            collectStr = @"收藏店铺";
        }else{
            if (self.TheStoreModel.sign == 1) {    //未收藏
                collectStr = @"收藏店铺";
            }else{
                collectStr = @"已收藏";
            }
        }
        [collectionStoreButton setTitle:collectStr forState:UIControlStateNormal];
//        [collectionStoreButton setBackgroundImage:[UIImage imageNamed:@"收藏店铺"] forState:UIControlStateNormal];
        [cellimageview addSubview:collectionStoreButton];
        [collectionStoreButton addTarget:self action:@selector(collectionStoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        collectionStoreButton.sd_layout
        .rightSpaceToView(cellimageview, 15)
        .centerYEqualToView(storeimageview)
        .widthIs(60)
        .heightIs(20);
        
        gridcell = cell;
        
    }else{
        
        HighIntegralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HighIntegralCollectionViewCellID forIndexPath:indexPath];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
        gridcell = cell;
        
    }
    
    return gridcell;
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
            reusableview = headerView;
        }else{
            DCCustionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID forIndexPath:indexPath];
            headerView.dccustionheadviewblock = ^(NSString *strValue) {
                NSLog(@"strValue-----%@",strValue);
                if (strValue.integerValue == 1) {
                    typestring = @"2";
                }else if (strValue.integerValue == 2){
                    typestring = @"1";
                }else{
                    typestring = strValue;
                }
                
                [self.collectionView.mj_header beginRefreshing];
            };
            reusableview = headerView;
        }
        
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        
    }
    
    return reusableview;
}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return CGSizeMake(SCREEN_WIDTH,175);
    }else{
        return OtherCollectionViewCellSize;
    }
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGSizeZero;
    }else{
        return CGSizeMake(SCREEN_WIDTH, 45); //图片滚动的宽高
    }
}


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4 ;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4 ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {return;}
    NSLog(@"点击了推荐的第%zd个商品",indexPath.row);
    GeneralGoodsModel *model=self.dataSource[indexPath.row];
    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
    dcgdvc.goods_id=model.goods_id;
    [self.navigationController pushViewController:dcgdvc animated:YES];
}


-(void)shareClick{
    
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
    NSString *business_id = self.business_idstring;

    NSString *shopShareUrlStr = JoinShareWebUrlStr(ShopShareUrl, business_id, user_id, token);
    
    //分享的店铺图标
    NSArray* imageArray;
    if (!kStringIsEmpty(self.TheStoreModel.logo)) {
        imageArray = @[[NSString stringWithFormat:@"%@%@",DefaultDomainName,self.TheStoreModel.logo]];
    }else{
        imageArray = @[[UIImage imageNamed:@"店铺logo"]];
    }
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"我很喜欢这家店铺的东西，价格也挺便宜，你也来看看吧！"]
                                         images:imageArray
                                            url:[NSURL URLWithString:[shopShareUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                          title:GetSaveString(self.TheStoreModel.name)
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

-(void)collectionStoreButtonClick{
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    if (![KYHeader checkNormalBackLogin]) {
        return;
    }
    
    
    kStringIsEmpty(self.business_idstring)?[dic setObject:self.TheStoreModel.business_id forKey:@"shop_id"]:[dic setObject:self.business_idstring forKey:@"shop_id"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(collect_shop) parameters:dic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSMutableArray *result=[responseObject objectForKey:@"result"];
                                    
                                    if (kArrayIsEmpty(result)) {
                                        
                                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                        
                                    }else{
                                        
                                        
                                        
                                    }
                                    if (codeStr.intValue == 1) {
                                        if ([responseObject[@"msg"] isEqualToString:@"关注店铺成功"]) {
                                            self.TheStoreModel.sign = 2;
                                        }else if ([responseObject[@"msg"] isEqualToString:@"解除关注店铺成功"]){
                                            self.TheStoreModel.sign = 1;
                                        }
                                        [self.collectionView reloadData];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                    [self.collectionView reloadData];
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self initAndJumpSearchViewController];
    
}

-(void)initAndJumpSearchViewController{
    
    // 1. Create an Array of popular search   设置建议用户的搜索标签
    NSArray *hotSeaches = @[
                            @"纸巾",
                            @"零食",
                            @"吹风机",
                            @"电饭锅",
                            @"电风扇",
                            @"家用摄像头",
                            @"抱枕靠垫",
                            @"床品四件套",
                            @"遮阳帽",
                            @"休闲鞋",
                            ];
    __weak typeof(self) weakSelf = self;
    // 2. Create a search view controller  创建搜索控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索商品", @"搜索商品") andsearchHeadViewHidden:(NSString *)@"YES" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText,NSString *searchtypes,NSString * VagueOrSpecific) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"搜索词条:%@",searchText);
        searchTextString = searchText;
        strongSelf.navigationsearchbar.text = searchText;
        [strongSelf.collectionView.mj_header beginRefreshing];
        [searchViewController.navigationController popViewControllerAnimated:NO];
        
        //        // Called when search begain.
        //        // eg：Push to a temp view controller
        //
        //        //开始搜索之后的回调方法 实际开发过程中将搜索的关键词传递到下一个页面进行搜索 然后设置页面
        //        NSLog(@"开始搜索-%@-----%@-----%@-----%@-----%@",searchViewController,searchBar,searchText,searchtypes,VagueOrSpecific);
        //
        //        SearchResultsViewController *sfprvc=[[SearchResultsViewController alloc]init];
        //        sfprvc.searchtypes=searchtypes;
        //        sfprvc.goodsname=searchText;
        //        //        sfprvc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemBottomWithTarget:self Action:@selector(backClick) image:@"BACK" hightimage:@"BACK" andTitle:@""];
        //        if (kStringIsEmpty(searchText)) {
        //            LRToast(@"请输入要搜索的内容");
        //        }else{
        //            [searchViewController.navigationController  pushViewController:sfprvc animated:YES];
        //        }
        //
        //        //        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //        //
        //        //            if ([VagueOrSpecific isEqualToString:@"isSearchButtonClick"]) {
        //        //
        //        //            SearchResultsViewController    *sfprvc=[[SearchResultsViewController alloc]init];
        //        //            sfprvc.searchtypes=searchtypes;
        //        //            sfprvc.goodsname=searchText;
        //        //            [self.navigationController  pushViewController:sfprvc animated:YES];
        //        //
        //        //            }else if ([VagueOrSpecific isEqualToString:@"isSearchCellClick"]){
        //        //
        //        //                if ([searchtypes isEqualToString:@"商品"]) {
        //        //
        //        //                    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
        //        //
        //        //                    //    Apple iPhone SE 玫瑰金 16G 4G 手机（全网通）-----2588-----采用IOS 10 系统，配置A9芯片，更高速-----(
        //        //                    //                                                                                "http://gfs14.gomein.net.cn/T12TCTByWQ1RCvBVdK_800.jpg",
        //        //                    //                                                                                "http://gfs14.gomein.net.cn/T1PwKTB5_g1RCvBVdK_800.jpg",
        //        //                    //                                                                                "http://gfs13.gomein.net.cn/T1ES_TBTAg1RCvBVdK_800.jpg"
        //        //                    //                                                                                )-----http://gfs17.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_360.jpg
        //        //
        //        //                    dcgdvc.goodTitle = @"Apple iPhone SE 玫瑰金 16G 4G 手机（全网通）";
        //        //                    dcgdvc.goodPrice = @"2588";
        //        //                    dcgdvc.goodSubtitle = @"采用IOS 10 系统，配置A9芯片，更高速";
        //        //                    dcgdvc.shufflingArray = @[@"http://gfs14.gomein.net.cn/T12TCTByWQ1RCvBVdK_800.jpg",
        //        //                                              @"http://gfs14.gomein.net.cn/T1PwKTB5_g1RCvBVdK_800.jpg",
        //        //                                              @"http://gfs13.gomein.net.cn/T1ES_TBTAg1RCvBVdK_800.jpg"];
        //        //                    dcgdvc.goodImageView = @"http://gfs17.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_360.jpg";
        //        //                    [self.navigationController pushViewController:dcgdvc animated:YES];
        //        //
        //        //
        //        //                }else if ([searchtypes isEqualToString:@"店铺"]){
        //        //
        //        //                    StoreDisplayViewController *sdvc=[[StoreDisplayViewController alloc]init];
        //        //                    [self.navigationController pushViewController:sdvc animated:YES];
        //        //
        //        //                }else{
        //        //
        //        //
        //        //                }
        //        //
        //        //            }
        //        //
        //        //        }];
        //
        
        
    }];
    
    
    //设置搜索视图的样式属性
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoriesCount = 10;
    
    // 4. Set delegate  设置搜索控制器的代理
    searchViewController.delegate = self;
    
    // 5. Present a navigation controller  点击搜索框之后跳转到搜索页面
    //    YYFNavigationController *nav = [[YYFNavigationController alloc] initWithRootViewController:searchViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:searchViewController animated:NO];
    
}



#pragma mark - PYSearchViewControllerDelegate  设置搜索历史记录
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText searchType:(NSString *)searchType
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            //            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
            //                NSString *searchSuggestion = [NSString stringWithFormat:@"%@ Search suggestion %d",searchType,i];
            //                [searchSuggestionsM addObject:searchSuggestion];
            //            }
            //            // Refresh and display the search suggustions
            //            searchViewController.searchSuggestions = searchSuggestionsM;
            
            // 设置请求参数可变数组
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:searchText forKey:@"name"];
            
            //            if ([searchType isEqualToString:@"商品"]) {
            [dic setObject:@"1" forKey:@"type"];
            //            } else if ([searchType isEqualToString:@"店铺"]){
            //                [dic setObject:@"2" forKey:@"type"];
            //            }
            
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            
            [HttpRequest postWithURLString:NetRequestUrl(likeGoods) parameters:dic
                              isShowToastd:(BOOL)NO
                                 isShowHud:(BOOL)NO
                          isShowBlankPages:(BOOL)NO
                                   success:^(id responseObject)  {
                                       
                                       NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                       NSMutableArray *result=[responseObject objectForKey:@"result"];
                                       
                                       if (codeStr.intValue==1) {
                                           
                                           if (!kArrayIsEmpty(result)) {
                                               
                                               for (NSDictionary * dic in result) {
                                                   
                                                   [searchSuggestionsM addObject:[dic objectForKey:@"name"]];
                                                   
                                               }
                                               
                                           }
                                           
                                           searchViewController.searchSuggestions = searchSuggestionsM;
                                           
                                       }
                                       
                                       
                                   } failure:^(NSError *error) {
                                       //打印网络请求错误
                                       NSLog(@"%@",error);
                                       
                                   } RefreshAction:^{
                                       //执行无网络刷新回调方法
                                       
                                   }];
            
        });
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

