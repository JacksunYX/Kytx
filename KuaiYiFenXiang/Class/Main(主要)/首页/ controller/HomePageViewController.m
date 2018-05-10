
//
//  HomePageViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "HomePageViewController.h"

#import "WebShareRegisterViewController.h"

/* controller */
#import "DCCommodityViewController.h"

#import "QualityZoneViewController.h"

#import "LoveToGoShoppingViewController.h"

#import "TheAnnouncementDetailsViewController.h"

#import "DCGoodDetailViewController.h"

#import "StoreDisplayViewController.h"
//搜索商品结果
#import "SearchResultsViewController.h"

//消息页面
#import "MessageViewController.h"

#import "MessageSubpageViewController.h"

/* head */
#import "KYSlideshowHeadView.h"

#import "ClassificationTitleHeadView.h"

/* foot */
#import "DCTopLineFootView.h"
/* cell */
#import "KYGoodsGridCell.h"

#import "DCGoodsHandheldCell.h"

#import "DCGoodsYouLikeCell.h"
//新增
#import "TodayOnSaleCell.h"

// Models
#import "KYGridItem.h"

#import "DCRecommendItem.h"

#import "DCGoodsHandheldModel.h"

#import "ClassificationTitleHeadModel.h"

#import "SubclassModuleViewController.h"

#import "NewproductrecommendationModel.h"

#import "UserPayViewController.h"

#import "AdvertiseSonViewController.h"  //新的广告页界面
#import "HomePageSecondeVC.h"           //新写的首页版块跳转页面

//全局开关
#define openTodaySale (kArrayIsEmpty(self.todayOnSale))

static int pageNum=0;

@interface HomePageViewController ()<PYSearchViewControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,TodayOnSaleClickDelegate>{
    
    
}

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 轮播图下5个可选分类属性 */
@property (strong , nonatomic)NSMutableArray<KYGridItem *> *gridItem;
/* 推荐商品属性 */
@property (strong , nonatomic)NSMutableArray<NewproductrecommendationModel *> *youLikeItem;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;


@property(nonatomic,strong) NSArray *btnImageAttay;
@property(nonatomic,strong) NSArray *btnTextAttay;

@property(nonatomic,strong) NSMutableArray *bannerimagearray;
@property(nonatomic,strong) NSMutableArray *banneridarray;

@property(nonatomic,strong) NSArray *advertiseArr;  //滚动广告数组

@property(nonatomic,strong) NSMutableArray *noticearray;
@property(nonatomic,strong) NSMutableArray *noticeidarray;

@property(nonatomic,strong) NSMutableArray *pinleizhuanquDataarray;

@property(nonatomic,strong) NSMutableArray *zuiaiguangjieDataarray;

@property(nonatomic,strong) NSMutableArray *newsadvertisingdataarray;
@property(nonatomic,strong) NSMutableArray *newsadvertisingarray;
@property(nonatomic,strong) NSMutableArray *newsadvertisingidarray;

//新增
@property(nonatomic,strong) NSMutableArray *todayOnSale;    //今日特价数据数组
@property(nonatomic,strong) TodayOnSaleModel *onsaleModel;  //今日特价模型

@end


/* head */
static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const KYSlideshowHeadViewID = @"KYSlideshowHeadView";

static NSString *const ClassificationTitleHeadViewID = @"ClassificationTitleHeadView";

/* foot */
static NSString *const DCTopLineFootViewID = @"DCTopLineFootView";
/* cell */
static NSString *const UICollectionViewCellID = @"UICollectionViewCell";

static NSString *const KYGoodsGridCellID = @"KYGoodsGridCell";

static NSString *const DCGoodsHandheldCellID = @"DCGoodsHandheldCell";

static NSString *const DCGoodsYouLikeCellID = @"DCGoodsYouLikeCell";

static NSString *const TodayOnSaleCellID = @"TodayOnSaleCellID";


@implementation HomePageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    pageNum=0;
    [self setUpSuspendView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [_backTopButton removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"首页";
    
    //    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemBottomWithTarget:self Action:@selector(scanClick) image:@"scan" hightimage:@"scan" andTitle:@"扫一扫"];
    //
    //    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemBottomWithTarget:self Action:@selector(messageClick) image:@"message" hightimage:@"message"  andTitle:@"消息"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scanClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"firstmessage"] style:UIBarButtonItemStylePlain target:self action:@selector(messageClick)];
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.btnImageAttay = @[@"moneyimage",@"moneyimage",@"moneyimage"];
    self.btnTextAttay = @[@"每日激励",@"甄选优品",@"品质保证"];
    
    self.bannerimagearray=[NSMutableArray new];
    self.banneridarray=[NSMutableArray new];
    
    self.noticearray=[NSMutableArray new];
    self.noticeidarray=[NSMutableArray new];
    
    self.pinleizhuanquDataarray=[NSMutableArray new];
    self.zuiaiguangjieDataarray=[NSMutableArray new];
    
    self.newsadvertisingdataarray=[NSMutableArray new];
    self.newsadvertisingarray=[NSMutableArray new];
    self.newsadvertisingidarray=[NSMutableArray new];
    
    self.youLikeItem = [NSMutableArray new];
    
    self.todayOnSale = [NSMutableArray new];
    
    //    [self loadNoticeData];
    
    //    [self setUpGoodsData];
    
    //    [self getNewAdvertise];
    
    //    [self newproductrecommendationData];
    
    self.collectionView.backgroundColor = BACKVIEWCOLOR;
    
    [self.collectionView.mj_header beginRefreshing];
    
    //这里需要记录一下，同一版本只显示一次弹窗
    
    
    //首先检测版本
    MCWeakSelf;
    [VersionCheckHelper questToCheckVersion:^(NSInteger backCode,NSURL *openUrl,NSString *versionNum) {
        if (backCode == 1) {
//            [weakSelf.collectionView.mj_header beginRefreshing];
        }
        if (backCode == 2) {
            //是否有最新版本弹框的标记
            NSString *version = [NSString stringWithFormat:@"Version_%@",versionNum];
            NSString *updateMark = [USER_DEFAULT objectForKey:version];
            
            //如果存在，说明已经展示过弹窗了，直接返回
            if (!kStringIsEmpty(updateMark)) {
                return;
            }
            //没有则标记
            [USER_DEFAULT setObject:@"YES" forKey:version];
            [USER_DEFAULT synchronize];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"有新的版本可以更新~" cancelButtonTitle:@"暂时不用" otherButtonTitle:@"立即更新"];
            [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 0:
//                        [weakSelf.collectionView.mj_header beginRefreshing];
                        break;
                    case 1:
                        //此处跳转到appstore进行更新
                        [[UIApplication sharedApplication] openURL:openUrl];
                        break;
                        
                    default:
                        break;
                }
            }];
            
        }
        //需要强制更新，这里不需要刷新界面了
        if (backCode == 3) {
            weakSelf.collectionView.mj_header = nil;
            weakSelf.collectionView.mj_footer = nil;
        }
        
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationsearchbar resignFirstResponder];
}

//单独请求滚动公告的请求
-(void)loadNoticeData{
    
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [HttpRequest postWithURLString:NetRequestUrl(usernotice) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSMutableArray *result=[responseObject objectForKey:@"result"];
                               
                               if (codeStr.intValue==1) {
                                   
                                   for (NSDictionary *dic in result) {
                                       
                                       [self.noticearray addObject:[dic objectForKey:@"title"]];
                                       [self.noticeidarray addObject:[dic objectForKey:@"article_id"]];
                                       
                                   }
                                   
                               }
                               
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
    
    
}

#pragma mark - 加载数据
- (void)setUpGoodsData
{
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [HttpRequest postWithURLString:NetRequestUrl(banner) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               //                               [NSThread sleepForTimeInterval:3];
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSDictionary *result = [responseObject objectForKey:@"result"];
                               //轮播
                               NSMutableArray  *bannerarray=[result objectForKey:@"banner"];
                               //公告
                               NSMutableArray *notice = [result objectForKey:@"notice"];
                               //品质专区
                               NSArray  *qualityarray = [result objectForKey:@"quality"];
                               //爱逛街
                               NSArray  *lovearray = [result objectForKey:@"love"];
                               //广告
                               self.advertiseArr = [HomePageAdvertiseModel mj_objectArrayWithKeyValuesArray:result[@"advertise"]];
                               
                               for (HomePageAdvertiseModel *model in self.advertiseArr) {
                                   if (!kStringIsEmpty(model.image)) {
                                       [self.bannerimagearray addObject:[NSString stringWithFormat:@"%@%@",DefaultDomainName,model.image]];
                                   }
                               }
                               
                               if (codeStr.intValue==1) {
                                   
                                   self.onsaleModel = [TodayOnSaleModel mj_objectWithKeyValues:result[@"shop"]];
                                   
                                   for (NSDictionary *dic in bannerarray) {
                                       NSString *position_name=[dic objectForKey:@"position_name"];
                                       //                                       if ([position_name isEqualToString:@"2.0轮播"]) {
                                       //                                           [self.bannerimagearray addObject:[NSString stringWithFormat:@"%@%@",DefaultDomainName,[dic objectForKey:@"ad_code"]]];
                                       //                                           [self.banneridarray addObject:dic];
                                       //                                       }
                                       if ([position_name isEqualToString:@"2.0中间图"]) {
                                           [self.newsadvertisingarray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"ad_code"]]];
                                           [self.newsadvertisingidarray addObject:[dic objectForKey:@"ad_id"]];
                                       }
                                   }
                                   
                                   for (NSDictionary *dic in notice) {
                                       
                                       [self.noticearray addObject:[dic objectForKey:@"title"]];
                                       [self.noticeidarray addObject:[dic objectForKey:@"article_id"]];
                                       
                                   }
                                   
                                   if (!kArrayIsEmpty(qualityarray)) {
                                       for (NSDictionary *dic in qualityarray) {
                                           
                                           //初始化模型
                                           DCGoodsHandheldModel *model=[DCGoodsHandheldModel mj_objectWithKeyValues:dic];
                                           //把模型添加到相应的数据源数组中
                                           model.idstring=[dic objectForKey:
                                                           @"id"];
                                           [self.zuiaiguangjieDataarray addObject:model];
                                           
                                       }
                                   }
                                   
                                   if (!kArrayIsEmpty(lovearray)) {
                                       for (NSDictionary *dic in lovearray) {
                                           
                                           //初始化模型
                                           DCGoodsHandheldModel *model=[DCGoodsHandheldModel mj_objectWithKeyValues:dic];
                                           model.idstring=[dic objectForKey:
                                                           @"id"];
                                           //把模型添加到相应的数据源数组中
                                           [self.pinleizhuanquDataarray addObject:model];
                                           
                                       }
                                   }
                                   
                                   for (int i=0; i<3; i++) {
                                       
                                       NSString *ad_titlenamestring=[NSString new];
                                       NSString * IsRoundedcornersp=[NSString new];
                                       if (i == 0) {
                                           ad_titlenamestring=@"品.类.专.区";
                                           IsRoundedcornersp=@"0";
                                       }else if (i == 1){
                                           ad_titlenamestring=@"最.爱.逛.街";
                                           IsRoundedcornersp=@"0";
                                       }else if (i == 2){
                                           ad_titlenamestring=@"新.品.推.荐";
                                           IsRoundedcornersp=@"0";
                                       }
                                       
                                       IsRoundedcornersp=@"3";  //新首页新增
                                       
                                       NSDictionary *dic = @{
                                                             @"IsRoundedcorners":                                           IsRoundedcornersp,
                                                             @"ad_id":@"",
                                                             @"ad_code":@"",
                                                             @"ad_titlename":ad_titlenamestring,
                                                             @"ad_subtitlename":i==2?@"每日甄选选优质新品满足您的挑剔":@"为追求高品质的你量身定制",
                                                             };
                                       
                                       //初始化模型
                                       ClassificationTitleHeadModel *model=[ClassificationTitleHeadModel mj_objectWithKeyValues:dic];
                                       //把模型添加到相应的数据源数组中
                                       [self.newsadvertisingdataarray addObject:model];
                                       
                                   }
                                   //添加一组测试数据
                                   if (self.onsaleModel) {
                                       [self addtodayOnsaleData];
                                   }
                                   
                                   _gridItem = [KYGridItem mj_objectArrayWithFilename:@"GoodsGrid.plist"];
                                   
                               }
                               
                               [self.collectionView.mj_header endRefreshing];
                               
                               [self.collectionView reloadData];
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
                               [self.collectionView.mj_header endRefreshing];
                               
                               [self.collectionView reloadData];
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
}

//单独获取轮播图的请求
-(void)getNewAdvertise
{
    [HttpRequest postWithURLString:NetRequestUrl(newAdvertise) parameters:nil isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            self.advertiseArr = [HomePageAdvertiseModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            
            for (HomePageAdvertiseModel *model in self.advertiseArr) {
                if (!kStringIsEmpty(model.image)) {
                    [self.bannerimagearray addObject:[NSString stringWithFormat:@"%@%@",DefaultDomainName,model.image]];
                }
            }
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        LRToast(@"轮播广告请求出错，请检查网络")
    } RefreshAction:nil];
}

//添加今日特价数据
-(void)addtodayOnsaleData
{
    NSDictionary *dic = @{
                          
                          @"IsRoundedcorners":@"4",
                          @"ad_titlename"   :@"今·日·特·价",
                          @"ad_subtitlename":@"品质单品  天天特价",
                          
                          };
    
    //初始化模型
    ClassificationTitleHeadModel *model=[ClassificationTitleHeadModel mj_objectWithKeyValues:dic];
    //把模型添加到相应的数据源数组中
    [self.newsadvertisingdataarray insertObject:model atIndex:0];
    
}

#pragma mark - 加载数据
- (void)newproductrecommendationData
{
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"1" forKey:@"type"];
    
    [dic setObject:@(pageNum) forKey:@"page"];
    
    [HttpRequest postWithURLString:NetRequestUrl(goods) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSMutableArray *result=[responseObject objectForKey:@"result"];
                               
                               
                               if (codeStr.intValue==1) {
                                   
                                   if (kArrayIsEmpty(result)) {
                                       
                                       [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       
                                       for (NSDictionary *dic in result) {
                                           
                                           //初始化模型
                                           NewproductrecommendationModel *model=[NewproductrecommendationModel mj_objectWithKeyValues:dic];
                                           //把模型添加到相应的数据源数组中
                                           [self.youLikeItem addObject:model];
                                           
                                       }
                                       [self.collectionView.mj_footer endRefreshing];
                                       
                                   }
                                   
                               }
                               
                               [self.collectionView reloadData];
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
                               [self.collectionView.mj_footer endRefreshing];
                               
                               [self.collectionView reloadData];
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - NAVIGATION_TAB_HEIGHT);
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //注册
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:UICollectionViewCellID];
        [_collectionView registerClass:[KYGoodsGridCell class] forCellWithReuseIdentifier:KYGoodsGridCellID];
        [_collectionView registerClass:[DCGoodsYouLikeCell class] forCellWithReuseIdentifier:DCGoodsYouLikeCellID];
        //新增
        [_collectionView registerClass:[TodayOnSaleCell class] forCellWithReuseIdentifier:TodayOnSaleCellID];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        [_collectionView registerClass:[KYSlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KYSlideshowHeadViewID];
        [_collectionView registerClass:[ClassificationTitleHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ClassificationTitleHeadViewID];
        
        [_collectionView registerClass:[DCTopLineFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID];
        
        [self.view addSubview:_collectionView];
        
        //进行刷新时开始刷新状态请求数据
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            pageNum=0;
            
            //在请求数据的时间初始化当前的数据源数组防止数据重复
            [self.bannerimagearray removeAllObjects];
            [self.banneridarray removeAllObjects];
            
            [self.noticearray removeAllObjects];
            [self.noticeidarray removeAllObjects];
            
            [self.pinleizhuanquDataarray removeAllObjects];
            [self.zuiaiguangjieDataarray removeAllObjects];
            
            [self.newsadvertisingdataarray removeAllObjects];
            [self.newsadvertisingarray removeAllObjects];
            [self.newsadvertisingidarray removeAllObjects];
            
            [self.todayOnSale removeAllObjects];
            
            [self.youLikeItem removeAllObjects];
            
            //            [self loadNoticeData];
            // 进入刷新状态后会自动调用这个block
            [self setUpGoodsData];
            
            //            [self getNewAdvertise];
            
            [self newproductrecommendationData];
            
        }];
        
        // 上拉加载
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            
            //上拉加载把page数加一
            pageNum++;
            
            // 进入刷新状态后会自动调用这个block
            [self newproductrecommendationData];
            
        }];
        
        // 马上进入刷新状态
        //        [self.collectionView.mj_header beginRefreshing];
        
    }
    return _collectionView;
}


#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[HttpRequest getCurrentVC].view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 60 - BOTTOM_MARGIN - 40, 40, 40);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
}
#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    if (self.collectionView.contentOffset.y > ScreenH) {
        [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }else{
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.collectionView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }];
    }
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.onsaleModel) {
        return 6;
    }
    
    return 5;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger sectionN = 0;
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    
    if (section==0) {
        return 1;
    }else if (section == 1)
    {
        return _gridItem.count;
    }
    /* else if(section==2||section==3){
     return 8;
     }
     */
    //    if (openTodaySale) {
    
    if (section == sectionN){
        return self.pinleizhuanquDataarray.count;
    }
    else if (section == sectionN + 1){
        return self.zuiaiguangjieDataarray.count;
    }
    else if (section == sectionN + 2) { //新品推荐
        return _youLikeItem.count;
    }
    
    //    }else{
    //
    //        if (section == 3){
    //            return 6;
    //        }
    //        else if (section == 4){
    //            return 4;
    //        }
    //        else if (section == 5) { //新品推荐
    //            return _youLikeItem.count;
    //        }
    //        return 1;   //新增今日推荐
    //
    //    }
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    NSInteger sectionN = 0;
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    
    if(indexPath.section==0){
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
        //每日激励、甄选优品、品质保证
        for (int i=0; i<3; i++) {
            UIButton *headBtn = [[UIButton alloc] init];
            headBtn.backgroundColor=[UIColor whiteColor];
            NSString *imgstr=[NSString stringWithFormat:@"%@",self.btnImageAttay[i]];
            NSString *textstr=[NSString stringWithFormat:@"%@",self.btnTextAttay[i]];
            [headBtn setImage:[UIImage imageNamed:imgstr] forState:UIControlStateNormal];
            [headBtn setImage:[UIImage imageNamed:imgstr] forState:UIControlStateSelected];
            [headBtn setTitle:textstr forState:UIControlStateNormal];
            [headBtn setTitleColor:hwcolor(212, 0, 0) forState:UIControlStateNormal];
            headBtn.titleLabel.font=PFR12Font;
            [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [headBtn setSelected:NO];
            headBtn.tag=i+100;
            [cell.contentView addSubview:headBtn];
            headBtn.sd_layout
            .leftSpaceToView(cell.contentView, (SCREEN_WIDTH/3)*i)
            .centerYEqualToView(cell.contentView )
            .widthIs(SCREEN_WIDTH/3)
            .heightIs(30);
            
            [headBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        }
        gridcell = cell;
        
        
    }else if(indexPath.section == 1){
        //轮播图下方分类
        KYGoodsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KYGoodsGridCellID forIndexPath:indexPath];
        kArrayIsEmpty(self.gridItem) ? : [cell setGridItem:self.gridItem[indexPath.row]];
        cell.backgroundColor= [UIColor whiteColor];
        gridcell = cell;
    }
    else if(indexPath.section == sectionN){
        //爱生活
        NSString *CellIdentifier = [NSString stringWithFormat:@"%@%ld%ld",DCGoodsHandheldCellID,indexPath.section,indexPath.row];
        [_collectionView registerClass:[DCGoodsHandheldCell class] forCellWithReuseIdentifier:CellIdentifier];
        DCGoodsHandheldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        kArrayIsEmpty(self.pinleizhuanquDataarray) ? : [cell setDCGoodsHandheldModel:self.pinleizhuanquDataarray[indexPath.row]];
        gridcell = cell;
        
    }else if(indexPath.section == sectionN + 1){
        //爱逛街
        NSString *CellIdentifier = [NSString stringWithFormat:@"%@%ld%ld",DCGoodsHandheldCellID,indexPath.section,indexPath.row];
        [_collectionView registerClass:[DCGoodsHandheldCell class] forCellWithReuseIdentifier:CellIdentifier];
        DCGoodsHandheldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        kArrayIsEmpty(self.zuiaiguangjieDataarray) ? : [cell setDCGoodsHandheldModel:self.zuiaiguangjieDataarray[indexPath.row]];
        gridcell = cell;
        
    }else if(indexPath.section == sectionN + 2){
        //精选单品
        DCGoodsYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsYouLikeCellID forIndexPath:indexPath];
        cell.lookSameBlock = ^{
            NSLog(@"点击了第%zd商品的找相似",indexPath.row);
        };
        kArrayIsEmpty(self.youLikeItem) ? : [cell setYouLikeItem:self.youLikeItem[indexPath.row]];
        gridcell = cell;
        
    }else{
        //今日推荐
        TodayOnSaleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TodayOnSaleCellID forIndexPath:indexPath];
        if (self.onsaleModel) {
            cell.tag = indexPath.row;
            [cell setModel:self.onsaleModel];
            cell.delegate = self;
        }
        gridcell = cell;
    }
    
    return gridcell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if (indexPath.section==1) {
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
            reusableview = headerView;
            
        }else if (indexPath.section==0){
            //轮播图作为collectionView分区0的头部展示
            KYSlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KYSlideshowHeadViewID forIndexPath:indexPath];
            
            if (kArrayIsEmpty(self.bannerimagearray)) {
                
                headerView.imageURLStringsGroup = nil;
                
            }else{
                headerView.imageURLStringsGroup = [self.bannerimagearray mutableCopy];
                //            }
                headerView.kyslideshowheadviewBlock = ^(NSInteger index) {
                    
                    //                BannerDetailsTableViewController *bdtvc=[[BannerDetailsTableViewController alloc]init];
                    //                bdtvc.categorynameNumString = @"bannerdetails";
                    //                [self.navigationController pushViewController:bdtvc animated:YES];
                    //                SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
                    
                    //                DCCalssSubItem * model = _mainItem[indexPath.section].goods[indexPath.row];
                    //                smvc.categorynameNumString = @"LevelThreeClassification";
                    //                smvc.categoryzoneid=self.banneridarray[index];
                    //                smvc.titlestring=@"推荐";
                    //                KYWebViewController *vc = [KYWebViewController new];
                    //                NSDictionary *dict = self.banneridarray[index];
                    //                vc.bgcolor = dict[@"bgcolor"];
                    //                vc.name = dict[@"ad_name"];
                    //                NSString *url =  kStringIsEmpty(dict[@"son_code"]) ? dict[@"ad_code"] : dict[@"son_code"];
                    //
                    //                url = [@"/Mobile/GoodDetail/activity?ad_code=" stringByAppendingString:url];
                    //                url = [url stringByAppendingString:[NSString stringWithFormat:@"&cat_id=%@", dict[@"ad_son_id"]]];
                    //                url = [url stringByAppendingString:[NSString stringWithFormat:@"&bgcolor=%@", dict[@"bgcolor"]]];
                    //                vc.web_url = url;
                    
                    
                    
                    //跳转到新的界面
                    AdvertiseSonViewController *asVC = [AdvertiseSonViewController new];
                    asVC.model = self.advertiseArr[index];
                    [self.navigationController pushViewController:asVC animated:YES];
                };
                
            }
            
            reusableview = headerView;
            
        }else{
            
            ClassificationTitleHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ClassificationTitleHeadViewID forIndexPath:indexPath];
            //暂时替换成本地图片
            NSInteger index = indexPath.section - 2;
            ClassificationTitleHeadModel *model = kArrayIsEmpty(self.newsadvertisingdataarray) ? nil: self.newsadvertisingdataarray[index];
            
            if (self.onsaleModel) {
                switch (index) {
                    case 1:
                        model.ad_code = @"lovelife";
                        break;
                    case 2:
                        model.ad_code = @"loveshopping";
                        break;
                    case 3:
                        model.ad_code = @"handpickproducet";
                        break;
                        
                    default:
                        break;
                }
            }else{
                switch (index) {
                    case 0:
                        model.ad_code = @"lovelife";
                        break;
                    case 1:
                        model.ad_code = @"loveshopping";
                        break;
                    case 2:
                        model.ad_code = @"handpickproducet";
                        break;
                        
                    default:
                        break;
                }
            }
            
            kArrayIsEmpty(self.newsadvertisingdataarray) ? : [headerView setClassificationTitleHeadModel:self.newsadvertisingdataarray[index]];
            reusableview = headerView;
            
        }
        
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        DCTopLineFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID forIndexPath:indexPath];
        kArrayIsEmpty(self.noticearray) ? : [footview setNoticeList:[self.noticearray mutableCopy]];
        [footview setUpUI];
        //分区1的尾部，滚动公告控件
        @weakify(self)
        footview.dctoplinefootviewblock = ^(NSInteger selectIndex) {
            TheAnnouncementDetailsViewController *tadvc = [[TheAnnouncementDetailsViewController alloc]init];
            tadvc.TheAnnouncementDetailsid = weak_self.noticeidarray[selectIndex];
            [weak_self.navigationController pushViewController:tadvc animated:YES];
        };
        
        footview.dctoplinefootviewmoreblock = ^{
            MessageSubpageViewController *msvc=[[MessageSubpageViewController alloc]init];
            msvc.selectIndex = 1;
            [weak_self.navigationController pushViewController:msvc animated:YES];
        };
        reusableview = footview;
        
    }
    
    return reusableview;
}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sectionN = 0;
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    
    if(indexPath.section == 0){
        return CGSizeMake(SCREEN_WIDTH , 30);
    }else if (indexPath.section == 1){
        return CGSizeMake(SCREEN_WIDTH/5 , SCREEN_WIDTH/5 + 10);
    }else if (indexPath.section == sectionN||indexPath.section == sectionN + 1){
        return [self layoutAttributesForItemAtIndexPath:indexPath].size;
    }else if (indexPath.section == sectionN + 2){
        return DCGoodsYouLikeCellSize;
    }else{
        return [self layoutAttributesForItemAtIndexPath:indexPath].size;
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger sectionN = 0;
    BOOL haveTodaySection = kArrayIsEmpty(self.todayOnSale);
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    
    if (haveTodaySection&&indexPath.section == 2) {
        //        CGFloat wid = (SCREEN_WIDTH - 5)/2;
        //        CGFloat hei = wid * (165.0/188);
        //        if (indexPath.row == 0) {
        //            layoutAttributes.size = CGSizeMake(wid, hei);
        //        }else{
        //            CGFloat hei2 = (hei - 5)/2;
        //            layoutAttributes.size = CGSizeMake(wid, hei2);
        //        }
        layoutAttributes.size = CGSizeMake(ScreenW, TodayOnSaleCellHeight);
    }
    if(indexPath.section == sectionN){
        //        if (indexPath.row == 7 || indexPath.row == 6 || indexPath.row == 5 || indexPath.row == 4){
        //            layoutAttributes.size = CGSizeMake(SCREEN_WIDTH * 0.25 - 1, SCREEN_WIDTH * 0.25 * 1.15);
        //        }else{
        //            layoutAttributes.size = CGSizeMake(SCREEN_WIDTH * 0.5 - 1, SCREEN_WIDTH * 0.5 * 0.47);
        //        }
        //新排版
        if (indexPath.row == 0 || indexPath.row ==1) {
            CGFloat wid = (SCREEN_WIDTH - 1)/2;
            CGFloat hei = wid * (90.0/188);
            layoutAttributes.size = CGSizeMake(wid, hei);
        }else{
            CGFloat wid = (SCREEN_WIDTH - 3)/4;
            CGFloat hei = wid * (110.0/95);
            layoutAttributes.size = CGSizeMake(wid, hei);
        }
    }
    
    if(indexPath.section == sectionN + 1){
        //        if (indexPath.row == 0){
        //            layoutAttributes.size = CGSizeMake(SCREEN_WIDTH / 3 * 2 - 1, SCREEN_WIDTH / 3);
        //        }else{
        //            layoutAttributes.size = CGSizeMake(SCREEN_WIDTH / 3 - 1, SCREEN_WIDTH / 3);
        //        }
        //新排版
        CGFloat wid = (SCREEN_WIDTH - 1)/2;
        CGFloat hei = wid * (130.0/188);
        layoutAttributes.size = CGSizeMake(wid, hei);
    }
    
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (kArrayIsEmpty(self.bannerimagearray)) {
            return CGSizeMake(SCREEN_WIDTH, 0.01);
        }
        return CGSizeMake(SCREEN_WIDTH, kScaelW(175)); //图片滚动的宽高
    }else if(section==1){
        return CGSizeZero;
    }else{
        if (self.onsaleModel&&section == 2) {
            return CGSizeMake(SCREEN_WIDTH, 80);
        }
        
        return CGSizeMake(SCREEN_WIDTH, /*210*/120);  //推荐适合的宽高
    }
    
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (section == 1&&self.noticearray.count>0) {
        return CGSizeMake(SCREEN_WIDTH, 54);  //Top头条的宽高
    }
    
    return CGSizeZero;
}



/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    NSInteger sectionN = 0;
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    
    return (section == sectionN + 2) ? 10 : (section == sectionN||section == sectionN + 1) ? 1 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    NSInteger sectionN = 0;
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    return (section == sectionN + 2) ? 10 : (section == sectionN||section == sectionN + 1) ? 1 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sectionN = 0;
    if (self.onsaleModel) {
        sectionN = 3;
    }else{
        sectionN = 2;
    }
    if (indexPath.section == 1) {//10
        NSLog(@"点击了第%zd",indexPath.row);
        if (indexPath.row==4) {
            DCCommodityViewController *dcvc=[[DCCommodityViewController alloc]init];
            [self.navigationController pushViewController:dcvc animated:YES];
        }else{
            SubclassModuleViewController *smvc=[[SubclassModuleViewController alloc]init];
            smvc.categorynameNumString=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [self.navigationController pushViewController:smvc animated:YES];
        }
    }else if (indexPath.section == sectionN + 2){
        NSLog(@"点击了推荐的第%zd个商品",indexPath.row);
        NewproductrecommendationModel *model=self.youLikeItem[indexPath.row];
        DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
        dcgdvc.goods_id=model.goods_id;
        [self.navigationController pushViewController:dcgdvc animated:YES];
    }else if (indexPath.section == sectionN){
        //        QualityZoneViewController *qzvc=[[QualityZoneViewController alloc]init];
        //        DCGoodsHandheldModel *model=self.pinleizhuanquDataarray[indexPath.row];
        //        qzvc.two_idstring = model.idstring;
        //        qzvc.titlestring = model.name;
        //        if (kStringIsEmpty(qzvc.two_idstring) || kStringIsEmpty(qzvc.titlestring)){
        //            LRToast(@"数据尚未加载完毕，请稍后再试");
        //            return;
        //        }
        //        [self.navigationController pushViewController:qzvc animated:YES];
        
        HomePageSecondeVC *secondeVC = [HomePageSecondeVC new];
        DCGoodsHandheldModel *model = self.pinleizhuanquDataarray[indexPath.row];
        secondeVC.a_id = model.idstring;
        secondeVC.titleStr = model.name;
        [self.navigationController pushViewController:secondeVC animated:YES];
        
    }else if (indexPath.section == sectionN + 1){
        //        LoveToGoShoppingViewController *ltgsvc=[[LoveToGoShoppingViewController alloc]init];
        //        DCGoodsHandheldModel *model=self.zuiaiguangjieDataarray[indexPath.row];
        //        ltgsvc.two_idstring = model.idstring;
        //        ltgsvc.titlestring = model.name;
        //        [self.navigationController  pushViewController:ltgsvc animated:YES];
        HomePageSecondeVC *secondeVC = [HomePageSecondeVC new];
        DCGoodsHandheldModel *model = self.zuiaiguangjieDataarray[indexPath.row];
        secondeVC.a_id = model.idstring;
        secondeVC.titleStr = model.name;
        [self.navigationController pushViewController:secondeVC animated:YES];
    }else{
        NSLog(@"今日特价");
        
    }
    
    
}

//二维码扫描
-(void)scanClick{
    
    if ([KYHeader checkLogin]) {
        
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
        SubLBXScanViewController *vc = [[SubLBXScanViewController alloc]init];
        vc.navigationItem.title = @"扫一扫";
        vc.style = style;
        vc.isQQSimulator = YES;
        
        YYFNavigationController *nav = [[YYFNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        MCWeakSelf
        vc.scanResult = ^(NSString *strScanned){
            NSLog(@"扫码结果-----%@",strScanned);
            if ([strScanned containsString:@"http"]) {
                if ([strScanned containsString:@"kuaiyishare"]) {
                    WebShareRegisterViewController *vc = [WebShareRegisterViewController new];
                    vc.url = strScanned;
                    vc.url = [vc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                
                
            }else {
                
                //获取扫码结果数组传递参数
                NSArray *strScannedArray = [strScanned componentsSeparatedByString:@","];
                NSLog(@"strScannedArray-----%@",strScannedArray);
                if ([strScannedArray.firstObject isEqualToString:@"usercash"]) {
                    UserPayViewController *upvc=[[UserPayViewController alloc]init];
                    upvc.user_name=[USER_DEFAULT objectForKey:@"nickname"];
                    upvc.shop_name=strScannedArray[1];
                    upvc.business_id=strScannedArray[2];
                    upvc.ratio=[strScannedArray[3] integerValue];
                    upvc.mutiply=[strScannedArray[4] integerValue];
                    [weakSelf.navigationController pushViewController:upvc animated:YES];
                    
                }
            }
            
        };
        
    }
    
}

//消息
-(void)messageClick{
    
    MessageViewController *mvc=[[MessageViewController alloc]init];
    
    [self.navigationController pushViewController:mvc animated:YES];
    
}

//轮播图下的分类点击跳转事件
-(void)headBtnClick:(UIButton *)btn{
    
}

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- TodayOnSaleClickDelegate ---
-(void)clickonRow:(NSInteger)row OnIndex:(NSInteger)index
{
    //暂时用不到第一个值，因为默认只显示一个cell
    //    NSLog(@"点击了第%ld行的%ld",row,index);
    NSString *idStr = [NSString stringWithFormat:@"goods_id_%ld",index + 1];
    NSDictionary *modelDic = [self.onsaleModel mj_keyValues];
    //    NSLog(@"点击的item的id为：%@",modelDic[idStr]);
    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
    dcgdvc.goods_id = modelDic[idStr];
    [self.navigationController pushViewController:dcgdvc animated:YES];
    
}










@end

