//
//  SubclassModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "SubclassModuleViewController.h"

#import "GoodsUnifiedModel.h"
#import "LogisticsTimelineModel.h"

#import "DCCustionHeadView.h"

#import "GoodsIsEmptyHeadView.h"

#import "NinePiecesOfNineCollectionViewCell.h"

#import "HighIntegralCollectionViewCell.h"

#import "SellLikeHotCakesCollectionViewCell.h"

#import "TheLatestRecommendedCollectionViewCell.h"

#import "ShoppingCarLatestRecommendedCollectionViewCell.h"

#import "SpecialClearanceCollectionViewCell.h"

#import "LogisticsTimelineCollectionViewCell.h"

static int pageNum=0;

@interface SubclassModuleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    NSString * classificationtypestring;
    
    NSString *typestring;
    
    NinePiecesOfNineCollectionViewCell *nponcvcell;
    
    NSString *logisticName;
}



@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSMutableArray<GoodsUnifiedModel *> *dataSource;

//@property (strong , nonatomic)NSMutableArray *TradeLogisticsDataSource;

/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;

@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const DCCustionHeadViewID = @"DCCustionHeadView";
static NSString *const TradeLogisticsHeadViewID = @"TradeLogisticsHeadView";

static NSString *const NinePiecesOfNineCollectionViewCellID = @"NinePiecesOfNineCollectionViewCell";

static NSString *const HighIntegralCollectionViewCellID = @"HighIntegralCollectionViewCell";

static NSString *const SellLikeHotCakesCollectionViewCellID = @"SellLikeHotCakesCollectionViewCell";

static NSString *const TheLatestRecommendedCollectionViewCellID = @"TheLatestRecommendedCollectionViewCell";

static NSString *const ShoppingCarLatestRecommendedCollectionViewCellID = @"ShoppingCarLatestRecommendedCollectionViewCell";

static NSString *const SpecialClearanceCollectionViewCellID = @"SpecialClearanceCollectionViewCell";

static NSString *const LogisticsTimelineCollectionViewCellID = @"LogisticsTimelineCollectionViewCell";

static NSString *const UICollectionViewCellID = @"UICollectionViewCell";

static NSString *const GoodsIsEmptyHeadViewID = @"GoodsIsEmptyHeadView";

@implementation SubclassModuleViewController


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
    
    NSLog(@"categorynameNumString-----%@-----titleid-----%@",self.categorynameNumString,self.titleid);
    
    if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]){
        self.navigationItem.title=@"交易物流";
        classificationtypestring=@"1";
    }else if ([self.categorynameNumString isEqualToString:@"0"]) {
        self.navigationItem.title=@"9.9";
        classificationtypestring=@"3";
    }else if([self.categorynameNumString isEqualToString:@"1"]){
        self.navigationItem.title=@"高积分";
        classificationtypestring=@"2";
    }else if([self.categorynameNumString isEqualToString:@"2"]){
        self.navigationItem.title=@"热销榜";
        classificationtypestring=@"4";
    }else if([self.categorynameNumString isEqualToString:@"3"]){
        self.navigationItem.title=@"新品推荐";
        classificationtypestring=@"1";
    }else if(!kStringIsEmpty(self.titlestring)){
        self.navigationItem.title=self.titlestring;
    }else if([self.categorynameNumString isEqualToString:@"4"]){
        
    }
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataSource = [NSMutableArray new];
    
    //    _TradeLogisticsDataSource=[NSMutableArray new];
    
    typestring = @"2";
    
    [self setUpGoodsData];
    
    if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        //        [self loadTradeLogisticsData];
    }
    
}

//进行数据的请求
-(void)loadTradeLogisticsData{
    
    self.TradeLogisticsDataSource=[NSMutableArray new];
    
    NSString *expressqueryUrl=[NSString stringWithFormat:@"https://way.jd.com/fegine/exp?type=%@&no=%@&appkey=d08ce5d77a6d395a23de6745d9b7407e",self.logisticsTypeString,self.logisticsNoString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 5;
    
    if (![MBProgressHUD allHUDsForView:kWindow].count)kShowHUDAndActivity;
    
    [manager GET:expressqueryUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        kHiddenHUDAndAvtivity;
        
        //直接吧返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"expressqueryUrl-----%@-----resultdic-----%@",expressqueryUrl,resultdic);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"code"]]; ;
        NSDictionary *resultdic1=[resultdic objectForKey:@"result"];
        NSString *status = [NSString stringWithFormat:@"%@",[resultdic1 objectForKey:@"status"]]; ;
        NSDictionary *resultdic2=[resultdic1 objectForKey:@"result"];
        //        NSMutableArray *listarray=kDictIsEmpty(resultdic2)?[NSMutableArray new]:[resultdic2 objectForKey:@"list"];
        if (codeStr.intValue==10000&&status.intValue==0) {
            
            NSMutableArray *listarray=[resultdic2 objectForKey:@"list"];
            
            for (NSDictionary *dic in listarray) {
                
                //初始化模型
                LogisticsTimelineModel *model=[LogisticsTimelineModel mj_objectWithKeyValues:dic];
                //把模型添加到相应的数据源数组中
                [self.TradeLogisticsDataSource addObject:model];
                
            }
            
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        kHiddenHUDAndAvtivity;
        
    }];
    
    
}

#pragma mark - 加载数据
- (void)setUpGoodsData
{
    
    
    
    if ([self.categorynameNumString isEqualToString:@"shoppingcarlatestrecommended"]) {
        
        //通过循环模拟数据的请求
        for (int i=0; i<16; i++) {
            
            
            //        integralString
            
            
            NSDictionary *dic = @{
                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                  @"cellidStr":[NSString stringWithFormat:@"%d",i],
                                  
                                  @"imageurlString":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
                                  
                                  @"maintitleString":@"Apple iPhone SE 玫瑰金16G 4G手机（全网通）",
                                  
                                  @"originalpriceString":@"¥ 6299",
                                  
                                  @"presentpriceString":@"¥ 3299",
                                  
                                  };
            
            
            //初始化模型
            GoodsUnifiedModel *model=[GoodsUnifiedModel mj_objectWithKeyValues:dic];
            //把模型添加到相应的数据源数组中
            [_dataSource addObject:model];
            
            
        }
        
        
    }else if ([self.categorynameNumString isEqualToString:@"bannerdetails"]) {
        
        //通过循环模拟数据的请求
        for (int i=0; i<16; i++) {
            
            
            //        integralString
            
            
            NSDictionary *dic = @{
                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                  @"cellidStr":[NSString stringWithFormat:@"%d",i],
                                  
                                  @"imageurlString":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
                                  
                                  @"maintitleString":@"Apple iPhone SE 玫瑰金16G 4G手机（全网通）",
                                  
                                  @"presentpriceString":@"¥ 3299",
                                  
                                  @"productspecificationsString":@"488g*1袋",
                                  
                                  };
            
            
            //初始化模型
            GoodsUnifiedModel *model=[GoodsUnifiedModel mj_objectWithKeyValues:dic];
            //把模型添加到相应的数据源数组中
            [_dataSource addObject:model];
            
            
        }
        
        
    }else if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]||[self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:classificationtypestring forKey:@"type"];
        
        [dic setObject:@(pageNum) forKey:@"page"];
        
        [dic setObject:typestring forKey:@"type2"];
        
        [HttpRequest postWithURLString:NetRequestUrl(goods) parameters:dic
                          isShowToastd:(BOOL)NO
                             isShowHud:(BOOL)NO
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                   NSMutableArray  *result=[responseObject objectForKey:@"result"];
                                   
                                   if (kArrayIsEmpty(result)) {
                                       
                                       [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       
                                       if (codeStr.intValue==1) {
                                           
                                           for (NSDictionary *dic in result) {
                                               
                                               //初始化模型
                                               GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
                                               if ([self.categorynameNumString isEqualToString:@"2"]) {
                                                   model.listString=@"";
                                                   model.buybuttontextString=@"立即购买";
                                               }
                                               //把模型添加到相应的数据源数组中
                                               [_dataSource addObject:model];
                                               
                                           }
                                           
                                       }
                                       
                                       [self.collectionView.mj_footer endRefreshing];
                                       
                                   }
                                   
                                   [self.collectionView.mj_header endRefreshing];
                                   
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
        
    }else if ([self.categorynameNumString isEqualToString:@"categoryzone"]||[self.categorynameNumString isEqualToString:@"LevelThreeClassification"]) {
        
        //        //通过循环模拟数据的请求
        //        for (int i=0; i<10; i++) {
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
        //                                  };
        //
        //
        //            //初始化模型
        //            GoodsUnifiedModel *model=[GoodsUnifiedModel mj_objectWithKeyValues:dic];
        //            //把模型添加到相应的数据源数组中
        //            [_dataSource addObject:model];
        
        
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [self.categorynameNumString isEqualToString:@"LevelThreeClassification"]?[dic setObject:self.categoryzoneid forKey:@"cat_id"]:[dic setObject:self.currentIndexId forKey:@"cat_id"];
        
        [dic setObject:@(pageNum) forKey:@"page"];
        
        [self.categorynameNumString isEqualToString:@"LevelThreeClassification"]?[dic setObject:typestring forKey:@"type"]:[dic setObject:@"" forKey:@"type"];
        
        [HttpRequest postWithURLString:NetRequestUrl(search) parameters:dic
                          isShowToastd:(BOOL)NO
                             isShowHud:(BOOL)YES
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                   NSMutableArray *result=[responseObject objectForKey:@"result"];
                                   
                                   if (kArrayIsEmpty(result)) {
                                       
                                       [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       
                                       if (codeStr.intValue==1) {
                                           
                                           for (NSDictionary * dic in result) {
                                               //初始化模型
                                               GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
                                               //把模型添加到相应的数据源数组中
                                               [_dataSource addObject:model];
                                               
                                           }
                                           
                                       }
                                       
                                       [self.collectionView.mj_footer endRefreshing];
                                       
                                   }
                                   
                                   
                                   [self.collectionView.mj_header endRefreshing];
                                   
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
        
        
        
        
    }else{
        
        
        //通过循环模拟数据的请求
        for (int i=0; i<16; i++) {
            
            
            //        integralString
            
            
            NSDictionary *dic = @{
                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                  @"cellidStr":[NSString stringWithFormat:@"%d",i],
                                  
                                  @"imageurlString":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
                                  
                                  @"maintitleString":@"Apple iPhone SE 玫瑰金16G 4G手机（全网通）",
                                  
                                  @"originalpriceString":@"¥ 6299",
                                  
                                  @"presentpriceString":@"¥ 3299",
                                  
                                  };
            
            
            //初始化模型
            GoodsUnifiedModel *model=[GoodsUnifiedModel mj_objectWithKeyValues:dic];
            //把模型添加到相应的数据源数组中
            [_dataSource addObject:model];
            
            
        }
        
    }
    
    [self.collectionView reloadData];
    
    
}

-(void)setLogisticsPhone:(NSString *)logisticsPhone
{
    _logisticsPhone = logisticsPhone;
    [HttpRequest postWithURLString:NetRequestUrl(shippingKind) parameters:@{} isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        NSInteger codeStr = [response[@"code"] integerValue];
        if (codeStr == 1) {
            NSLog(@"请求成功");
            NSArray *logistArr = response[@"result"];
            for (NSDictionary *dic in logistArr) {
                if ([dic[@"code"] isEqualToString:self.logisticsTypeString]) {
                    logisticName = dic[@"name"];
                    break;
                }
            }
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
    
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]||[self.categorynameNumString isEqualToString:@"3"]){
            layout.sectionHeadersPinToVisibleBounds = NO;
        }else{
            layout.sectionHeadersPinToVisibleBounds = YES;
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        [_collectionView registerClass:[DCCustionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID];
        [_collectionView registerClass:[GoodsIsEmptyHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodsIsEmptyHeadViewID];
        
        [_collectionView registerClass:[NinePiecesOfNineCollectionViewCell class] forCellWithReuseIdentifier:NinePiecesOfNineCollectionViewCellID];
        [_collectionView registerClass:[HighIntegralCollectionViewCell class] forCellWithReuseIdentifier:HighIntegralCollectionViewCellID];
        [_collectionView registerClass:[SellLikeHotCakesCollectionViewCell class] forCellWithReuseIdentifier:SellLikeHotCakesCollectionViewCellID];
        [_collectionView registerClass:[TheLatestRecommendedCollectionViewCell class] forCellWithReuseIdentifier:TheLatestRecommendedCollectionViewCellID];
        [_collectionView registerClass:[ShoppingCarLatestRecommendedCollectionViewCell class] forCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID];
        [_collectionView registerClass:[SpecialClearanceCollectionViewCell class] forCellWithReuseIdentifier:SpecialClearanceCollectionViewCellID];
        [_collectionView registerClass:[LogisticsTimelineCollectionViewCell class] forCellWithReuseIdentifier:LogisticsTimelineCollectionViewCellID];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:UICollectionViewCellID];
        
        [self.view addSubview:_collectionView];
        
        //进行刷新时开始刷新状态请求数据
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            pageNum=0;
            
            //            if([self.categorynameNumString isEqualToString:@"TradeLogistics"]){
            //                [self.TradeLogisticsDataSource removeAllObjects];
            //                [self loadTradeLogisticsData];
            //            }
            
            //在请求数据的时间初始化当前的数据源数组防止数据重复
            [self.dataSource removeAllObjects];
            // 马上进入刷新状态
//            [self.collectionView.mj_header beginRefreshing];
            // 进入刷新状态后会自动调用这个block
            [self setUpGoodsData];
            
        }];
        
        // 上拉加载
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            
            //上拉加载把page数加一
            pageNum++;
            
//            [self.collectionView.mj_footer  beginRefreshing];
            
            // 进入刷新状态后会自动调用这个block
            [self setUpGoodsData];
            
        }];
        
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
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH-100, 40, 40);
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
    if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]||[self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]) {
        if (section==0) {
            return 1;
        }else{
            return _dataSource.count;
        }
    }else if([self.categorynameNumString isEqualToString:@"TradeLogistics"]){
        if (section==0) {
            return kArrayIsEmpty(self.TradeLogisticsDataSource)?0:_TradeLogisticsDataSource.count;
        } else {
            return _dataSource.count;
        }
    }else{
        return _dataSource.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *gridcell = nil;
    
    if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]) {
        
        if (indexPath.section==0) {
            
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            UIImageView *cellimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
            if ([self.categorynameNumString isEqualToString:@"0"]) {
                [cellimageview setImage:[UIImage imageNamed:@"9.9baoyoubg"]];
            }else if ([self.categorynameNumString isEqualToString:@"1"]){
                [cellimageview setImage:[UIImage imageNamed:@"gaojifenbg"]];
            }else if ([self.categorynameNumString isEqualToString:@"2"]){
                [cellimageview setImage:[UIImage imageNamed:@"rexiaobangbg"]];
            }else if ([self.categorynameNumString isEqualToString:@"3"]){
                [cellimageview setImage:[UIImage imageNamed:@"xinpintuijianbg"]];
            }
            [cell.contentView addSubview:cellimageview];
            gridcell = cell;
            
        }else{
            
            if ([self.categorynameNumString isEqualToString:@"0"]) {
                
                nponcvcell = [collectionView dequeueReusableCellWithReuseIdentifier:NinePiecesOfNineCollectionViewCellID forIndexPath:indexPath];
                [nponcvcell.contentView setBackgroundColor:[UIColor whiteColor]];
                kArrayIsEmpty(self.dataSource)?:[nponcvcell setGeneralGoodsModel:_dataSource[indexPath.row]];
                gridcell = nponcvcell;
                
            }else if ([self.categorynameNumString isEqualToString:@"1"]) {
                
                HighIntegralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HighIntegralCollectionViewCellID forIndexPath:indexPath];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
                gridcell = cell;
                
            }else if ([self.categorynameNumString isEqualToString:@"2"]) {
                
                SellLikeHotCakesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SellLikeHotCakesCollectionViewCellID forIndexPath:indexPath];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
                cell.didBuyButtonClickBlock = ^(NSString *goodsid) {
                    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
                    dcgdvc.goods_id=goodsid;
                    [self.navigationController pushViewController:dcgdvc animated:YES];            };
                gridcell = cell;
                
            }else if ([self.categorynameNumString isEqualToString:@"3"]) {
                
                TheLatestRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TheLatestRecommendedCollectionViewCellID forIndexPath:indexPath];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
                gridcell = cell;
                
            }else{
                
                UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
                gridcell = cell;
                
            }
            
        }
        
    }else if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        
        if (indexPath.section==0) {
            LogisticsTimelineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LogisticsTimelineCollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            kArrayIsEmpty(self.TradeLogisticsDataSource)?:[cell setLogisticsTimelineModel:_TradeLogisticsDataSource[indexPath.row]];
            gridcell = cell;
        }else{
            HighIntegralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HighIntegralCollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
            gridcell = cell;
        }
        
    }else{
        
        if ([self.categorynameNumString isEqualToString:@"shoppingcarlatestrecommended"]) {
            
            ShoppingCarLatestRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            cell.GoodsUnifiedModel = _dataSource[indexPath.row];
            cell.didSelectedaddshoppingcarButton = ^(GeneralGoodsModel *model) {
                DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
                dcgdvc.goods_id=model.goods_id;
                [self.navigationController pushViewController:dcgdvc animated:YES];
            };
            gridcell = cell;
            
        }else if ([self.categorynameNumString isEqualToString:@"categoryzone"]) {
            
            ShoppingCarLatestRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
            cell.didSelectedaddshoppingcarButton = ^(GeneralGoodsModel *model) {
                DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
                dcgdvc.goods_id=model.goods_id;
                [self.navigationController pushViewController:dcgdvc animated:YES];
            };
            gridcell = cell;
            
        }else if ([self.categorynameNumString isEqualToString:@"bannerdetails"]) {
            
            SpecialClearanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpecialClearanceCollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            cell.GoodsUnifiedModel = _dataSource[indexPath.row];
            gridcell = cell;
            
        }else if ([self.categorynameNumString isEqualToString:@"LevelThreeClassification"]) {
            
            HighIntegralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HighIntegralCollectionViewCellID forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor whiteColor]];
            kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
            gridcell = cell;
            
        }else{
            
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
            gridcell = cell;
            
        }
        
    }
    
    return gridcell;
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]) {
            
            if (indexPath.section==0) {
                
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
                
                reusableview = headerView;
                
            }else{
                
                if([self.categorynameNumString isEqualToString:@"3"]) {
                    
                    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
                    [headerView setBackgroundColor:BACKVIEWCOLOR];
                    UIImageView *xinpintuijianImageView=[[UIImageView alloc]init];
                    [xinpintuijianImageView setImage:[UIImage imageNamed:@"zuixintuijian"]];
                    [headerView addSubview:xinpintuijianImageView];
                    xinpintuijianImageView.sd_layout
                    .centerXEqualToView(headerView)
                    .centerYEqualToView(headerView)
                    .widthIs(SCREEN_WIDTH-80)
                    .heightIs(23);
                    reusableview = headerView;
                    
                }else{
                    
                    DCCustionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID forIndexPath:indexPath];
                    headerView.dccustionheadviewblock = ^(NSString *strValue) {
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
            
            
        }else if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
            [headerView removeAllSubviews];
            if (indexPath.section==0) {
                headerView.backgroundColor = [UIColor whiteColor];
                
                UIImageView *logistImg = [[UIImageView alloc]initWithImage:UIImageNamed(@"logisticsIcon")];
                [headerView addSubview:logistImg];
                logistImg.sd_layout
                .topSpaceToView(headerView, 25)
                .leftSpaceToView(headerView, 25)
                .widthIs(45)
                .heightIs(35)
                ;
                
                UILabel *logisticsNum = [UILabel new];
                logisticsNum.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
                logisticsNum.textColor = [UIColor colorWithHexString:@"#333333"];
                logisticsNum.numberOfLines = 1;
                [headerView addSubview:logisticsNum];
                logisticsNum.sd_layout
                .leftSpaceToView(logistImg, 30)
                .centerYEqualToView(logistImg)
                .rightEqualToView(headerView)
                .heightIs(15)
                ;
                if (!kStringIsEmpty(self.logisticsNoString)) {
                    logisticsNum.text = [NSString stringWithFormat:@"物流单号：%@",self.logisticsNoString];
                    NSAttributedString *aStr = [NSString RichtextString:logisticsNum.text andstartstrlocation:5 andendstrlocation:logisticsNum.text.length - 5 andchangcoclor:[UIColor colorWithHexString:@"#d40000"] andchangefont:logisticsNum.font];
                    logisticsNum.attributedText = aStr;
                }else{
                    logisticsNum.text = @"还没发货吧~";
                }
                
                
                UILabel *logisticsCompany = [UILabel new];
                logisticsCompany.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
                logisticsCompany.textColor = [UIColor colorWithHexString:@"#333333"];
                logisticsCompany.numberOfLines = 1;
                [headerView addSubview:logisticsCompany];
                logisticsCompany.sd_layout
                .leftEqualToView(logisticsNum)
                .bottomSpaceToView(logisticsNum, 10)
                .rightEqualToView(headerView)
                .heightIs(15)
                ;
                if (!kStringIsEmpty(logisticName)) {
                    logisticsCompany.text = [NSString stringWithFormat:@"物流公司：%@",logisticName];
                    NSAttributedString *aStr = [NSString RichtextString:logisticsCompany.text andstartstrlocation:5 andendstrlocation:logisticsCompany.text.length - 5 andchangcoclor:[UIColor colorWithHexString:@"#d40000"] andchangefont:logisticsCompany.font];
                    logisticsCompany.attributedText = aStr;
                }else{
                    logisticsCompany.text = @"";
                }
                
                
                UILabel *logisticsPhone = [UILabel new];
                logisticsPhone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
                logisticsPhone.textColor = [UIColor colorWithHexString:@"#333333"];
                logisticsPhone.numberOfLines = 1;
                [headerView addSubview:logisticsPhone];
                logisticsPhone.sd_layout
                .leftEqualToView(logisticsNum)
                .topSpaceToView(logisticsNum, 10)
                .rightEqualToView(headerView)
                .heightIs(15)
                ;
                
                if (!kStringIsEmpty(self.logisticsPhone)) {
                    logisticsPhone.text = [NSString stringWithFormat:@"物流电话：%@",self.logisticsPhone];
                    NSAttributedString *aStr = [NSString RichtextString:logisticsPhone.text andstartstrlocation:5 andendstrlocation:logisticsPhone.text.length - 5 andchangcoclor:[UIColor colorWithHexString:@"#d40000"] andchangefont:logisticsPhone.font];
                    logisticsPhone.attributedText = aStr;
                }else{
                    logisticsPhone.text = @"";
                }
                
                UIView *bottomView = [UIView new];
                bottomView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
                [headerView addSubview:bottomView];
                bottomView.sd_layout
                .leftEqualToView(headerView)
                .rightEqualToView(headerView)
                .bottomEqualToView(headerView)
                .heightIs(10)
                ;
                
                reusableview = headerView;
                
            }else{
                
                if (kArrayIsEmpty(self.TradeLogisticsDataSource)) {
                    
                    GoodsIsEmptyHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodsIsEmptyHeadViewID forIndexPath:indexPath];
                    headerView.type = 3;
                    reusableview = headerView;
                    
                }else{
                    
                    UIImageView *xinpintuijianImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-80, 18)];
                    xinpintuijianImageView.centerX=headerView.centerX;
                    [xinpintuijianImageView setImage:[UIImage imageNamed:@"为您推荐"]];
                    [headerView addSubview:xinpintuijianImageView];
                    reusableview = headerView;
                    
                }
                
            }
            
        }else if ([self.categorynameNumString isEqualToString:@"LevelThreeClassification"]) {
            
            DCCustionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID forIndexPath:indexPath];
            headerView.dccustionheadviewblock = ^(NSString *strValue) {
                NSLog(@"strValue-----%@",strValue);
                typestring=strValue;
                [self.collectionView.mj_header beginRefreshing];
            };
            reusableview = headerView;
            
        }else{
            
            if ([self.categorynameNumString isEqualToString:@"shoppingcarlatestrecommended"]) {
                
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
                UIImageView *xinpintuijianImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-80, 23)];
                xinpintuijianImageView.centerX=headerView.centerX;
                [xinpintuijianImageView setImage:[UIImage imageNamed:@"zuixintuijian"]];
                [headerView addSubview:xinpintuijianImageView];
                reusableview = headerView;
                
            }else{
                
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
                reusableview = headerView;
                
            }
        }
        
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
    }
    
    return reusableview;
}
//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]) {
        if (indexPath.section==0) {
            return CGSizeMake(SCREEN_WIDTH,175);
        }else{
            return OtherCollectionViewCellSize;
        }
    }else if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        
        if (indexPath.section==0) {
            return kArrayIsEmpty(self.TradeLogisticsDataSource)?CGSizeZero:CGSizeMake(SCREEN_WIDTH,100);
        } else {
            //            return OtherCollectionViewCellSize;
            return CGSizeMake((ScreenW - 4)/2, (SCREEN_WIDTH-4)/2 + 5 + 40 + 5 + 13 + 5 + 10 + 10);
        }
        
    }else{
        return OtherCollectionViewCellSize;
    }
    
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([self.categorynameNumString isEqualToString:@"0"]||[self.categorynameNumString isEqualToString:@"1"]||[self.categorynameNumString isEqualToString:@"2"]||[self.categorynameNumString isEqualToString:@"3"]) {
        
        if (section==0) {
            return CGSizeZero; //图片滚动的宽高
        }else{
            return CGSizeMake(SCREEN_WIDTH, 45); //图片滚动的宽高
        }
        
    }else if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        if (section==0) {
            return CGSizeMake(ScreenW, 95);
        } else {
            return kArrayIsEmpty(self.TradeLogisticsDataSource)?CGSizeMake(SCREEN_WIDTH, 260):CGSizeMake(SCREEN_WIDTH, 50); //图片滚动的宽高
        }
    }else if ([self.categorynameNumString isEqualToString:@"LevelThreeClassification"]) {
        return CGSizeMake(SCREEN_WIDTH, 45); //图片滚动的宽高
    }else{
        
        if ([self.categorynameNumString isEqualToString:@"shoppingcarlatestrecommended"]) {
            return CGSizeMake(SCREEN_WIDTH, 50); //图片滚动的宽高
        }else{
            return CGSizeZero; //图片滚动的宽高
        }
        
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
    return section==0&&[self.categorynameNumString isEqualToString:@"TradeLogistics"]?0:4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了推荐的第%zd个商品",indexPath.row);
    if (indexPath.section==0&&![self.categorynameNumString isEqualToString:@"TradeLogistics"]) {
        
        GeneralGoodsModel *model = self.dataSource[indexPath.row];
        DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
        dcgdvc.goods_id=model.goods_id;
        [self.navigationController pushViewController:dcgdvc animated:YES];
        
    }else{
        if ([self.categorynameNumString isEqualToString:@"TradeLogistics"]&&indexPath.section==0) {
            return;
        }
        GeneralGoodsModel *model = self.dataSource[indexPath.row];
        DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
        dcgdvc.goods_id=model.goods_id;
        [self.navigationController pushViewController:dcgdvc animated:YES];
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
    
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

