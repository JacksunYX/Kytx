//
//  SubclassModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "GeneralGoodsModel.h"
#import "TheStoreModel.h"

#import "DCCustionHeadView.h"
#import "GoodsIsEmptyHeadView.h"

#import "HighIntegralCollectionViewCell.h"

#import "TheStoreCollectionViewCell.h"

#import "StoreDisplayViewController.h"

static int pageNum=0;

@interface SearchResultsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>{
    
    NSString *typestring;
    
}

/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;

@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSMutableArray *dataSource;
@property (strong , nonatomic)NSMutableArray *recommendeddataSource;

@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const DCCustionHeadViewID = @"DCCustionHeadView";
static NSString *const GoodsIsEmptyHeadViewID = @"GoodsIsEmptyHeadView";

static NSString *const HighIntegralCollectionViewCellID = @"HighIntegralCollectionViewCell";

static NSString *const TheStoreCollectionViewCellID = @"TheStoreCollectionViewCell";

@implementation SearchResultsViewController


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
    
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationsearchbar setText:self.searchTextString];
    
    
    _dataSource=[NSMutableArray new];
    
    _recommendeddataSource=[NSMutableArray new];
    
    typestring = @"2";
    
    [self setUpGoodsData];
    
}
#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [[HttpRequest getCurrentVC].view addSubview:_backTopButton];
    [self.view insertSubview:_backTopButton aboveSubview:self.collectionView];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - NAVI_HEIGHT - 60 - BOTTOM_MARGIN - 40, 40, 40);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
//    NSLog(@"%d",_backTopButton.hidden);
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
#pragma mark - 加载数据
- (void)setUpGoodsData
{
    
    
    if ([self.searchtypes isEqualToString:@"商品"]) {
        //
        //        //通过循环模拟数据的请求
        //        for (int i=0; i<8; i++) {
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
        //            //初始化模型
        //            GoodsUnifiedModel *model=[GoodsUnifiedModel mj_objectWithKeyValues:dic];
        //            //把模型添加到相应的数据源数组中
        //            [_dataSource addObject:model];
        //
        //        }
        //
        
        
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:self.goodsname forKey:@"goods_name"];
        
        [dic setObject:@(pageNum) forKey:@"page"];
        
        [dic setObject:typestring forKey:@"type"];
        
        [HttpRequest postWithURLString:NetRequestUrl(search) parameters:dic
                          isShowToastd:(BOOL)NO
                             isShowHud:(BOOL)NO
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                   NSMutableArray *result=[responseObject objectForKey:@"result"];
                                   
                                   if (kArrayIsEmpty(result)) {
                                       //这里结果返回的是空，但是之前的同事做了一个默认加载商品的请求，不知为何
                                       pageNum==0?[self requestrecommendeddataSource]:[self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       
                                       if (codeStr.intValue==1) {
                                           
                                           if (pageNum == 0) {
                                               [self.dataSource removeAllObjects];
                                           }
                                           for (NSDictionary * dic in result) {
                                               //初始化模型
                                               GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
                                               //把模型添加到相应的数据源数组中
                                               [_dataSource addObject:model];
                                               
                                           }
                                           
                                       }else if (codeStr.intValue==2){
                                           
//                                           for (NSDictionary * dic in result) {
//                                               //初始化模型
//                                               GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
//                                               //把模型添加到相应的数据源数组中
//                                               [_recommendeddataSource addObject:model];
//
//                                           }
                                           
                                            [self requestrecommendeddataSource];
                                           
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
        
    }else if ([self.searchtypes isEqualToString:@"店铺"]){
        
        //通过循环模拟数据的请求
        //        for (int i=0; i<8; i++) {
        
        //            NSDictionary *dic = @{
        //                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
        //                                  @"cellidStr":[NSString stringWithFormat:@"%d",i],
        //
        //                                  @"storeLogoUrl":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
        //
        //                                  @"storeiNameString":@"Apple 专卖店",
        //
        //                                  @"enterStoreString":@"进入店铺",
        //
        //                                  @"shopIntroductionString":@"Apple iPhone SE 玫瑰金16G 4G手机（全网通）",
        //
        //                                  @"shopPictureArray":@[@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg"],
        //
        //                                  };
        //
        //
        //            //初始化模型
        //            TheStoreModel *model=[TheStoreModel mj_objectWithKeyValues:dic];
        //            //把模型添加到相应的数据源数组中
        //            [_dataSource addObject:model];
        //
        //
        
        
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:self.goodsname forKey:@"name"];
        
        [dic setObject:@(pageNum) forKey:@"shop_page"];
        
        [HttpRequest postWithURLString:NetRequestUrl(searchshop) parameters:dic
                          isShowToastd:(BOOL)NO
                             isShowHud:(BOOL)NO
                      isShowBlankPages:(BOOL)NO
                               success:^(id responseObject)  {
                                   
                                   NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                   NSMutableArray *result=[responseObject objectForKey:@"result"];
                                   
                                   if (kArrayIsEmpty(result)) {
                                       
                                       [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       
                                       
                                       if (codeStr.intValue==1) {
                                           if (pageNum == 0) {
                                               [self.dataSource removeAllObjects];
                                           }
                                           for (NSDictionary * dic in result) {
                                               //初始化模型
                                               TheStoreModel *model=[TheStoreModel mj_objectWithKeyValues:dic];
                                               model.enterStoreString=@"进入店铺";
                                               //                                                   model.shopPictureArray=@[@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg"];
                                               NSMutableArray *goodsarray=[dic  objectForKey:@"goods"];
                                               NSMutableArray *goodsimagearray=[NSMutableArray new];
                                               NSMutableArray *goodsidarray=[NSMutableArray new];
                                               if (kArrayIsEmpty(goodsarray)) {
                                                   model.shopPictureArray=@[@"/Public/upload/goods/2017/10-30/59f6a251877ce.jpg",@"/Public/upload/goods/2017/10-30/59f6a251877ce.jpg",@"/Public/upload/goods/2017/10-30/59f6a251877ce.jpg"];
                                               } else {
                                                   for (NSDictionary  *dic in goodsarray) {
                                                       [goodsimagearray addObject:[dic objectForKey:@"original_img"]];
                                                       [goodsidarray addObject:[dic objectForKey:@"goods_id"]];
                                                   }
                                                   model.shopPictureArray=goodsimagearray;
                                               }
                                               //把模型添加到相应的数据源数组中
                                               [_dataSource addObject:model];
                                               
                                           }
                                           
                                       }else if (codeStr.intValue==2){
                                           
                                           for (NSDictionary * dic in result) {
                                               //初始化模型
                                               TheStoreModel *model=[TheStoreModel mj_objectWithKeyValues:dic];
                                               model.enterStoreString=@"进入店铺";
                                               //                                                   model.shopPictureArray=@[@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg"];
                                               NSMutableArray *goodsarray=[dic  objectForKey:@"goods"];
                                               NSMutableArray *goodsimagearray=[NSMutableArray new];
                                               NSMutableArray *goodsidarray=[NSMutableArray new];
                                               if (kArrayIsEmpty(goodsarray)) {
                                                   model.shopPictureArray=@[@"/Public/upload/goods/2017/10-30/59f6a251877ce.jpg",@"/Public/upload/goods/2017/10-30/59f6a251877ce.jpg",@"/Public/upload/goods/2017/10-30/59f6a251877ce.jpg"];
                                               } else {
                                                   for (NSDictionary  *dic in goodsarray) {
                                                       [goodsimagearray addObject:[dic objectForKey:@"original_img"]];
                                                       [goodsidarray addObject:[dic objectForKey:@"goods_id"]];
                                                   }
                                                   model.shopPictureArray=goodsimagearray;
                                               }
                                               //把模型添加到相应的数据源数组中
                                               [_recommendeddataSource addObject:model];
                                               
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
        
        //        }
        
        
    }
    
    
    
    
}



#pragma mark - 加载数据
- (void)requestrecommendeddataSource
{
    
    
//    if ([self.searchtypes isEqualToString:@"商品"]) {
//
//        //通过循环模拟数据的请求
//        for (int i=0; i<8; i++) {
//
//
//
//            NSDictionary *dic = @{
//                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
//                                  @"goods_id":[NSString stringWithFormat:@"%d",i],
//
//                                  @"original_img":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
//
//                                  @"goods_name":@"Apple iPhone SE 玫瑰金16G 4G手机（全网通）",
//
//                                  @"market_price":@"¥ 6299",
//
//                                  @"shop_price":@"¥ 3299",
//
//                                  @"loves":@"26.00",
//
//                                  };
//
//
//            //初始化模型
//            GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
//            //把模型添加到相应的数据源数组中
//            [_recommendeddataSource addObject:model];
//
//
//        }
//
//    }else if ([self.searchtypes isEqualToString:@"店铺"]){
//
//        //通过循环模拟数据的请求
//        for (int i=0; i<8; i++) {
//
//
//
//
//            NSDictionary *dic = @{
//                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
//                                  @"business_id":[NSString stringWithFormat:@"%d",i],
//
//                                  @"logo":@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",
//
//                                  @"name":@"Apple 专卖店",
//
//                                  @"enterStoreString":@"进入店铺",
//
//                                  @"sale_num":@"888",
//                                  @"good_num":@"666",
//
//                                  @"shopPictureArray":@[@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg",@"http://gfs.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_400.jpg"],
//
//                                  };
//
//
//            //初始化模型
//            TheStoreModel *model=[TheStoreModel mj_objectWithKeyValues:dic];
//            //把模型添加到相应的数据源数组中
//            [_recommendeddataSource addObject:model];
//
//
//        }
//
//
//    }
//
//
//    [self.collectionView reloadData];
    
    
    
    
    
    
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
                               
                               if (kArrayIsEmpty(result)) {
                                   
                                   [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                   
                               }else{
                                   
                                   if (codeStr.intValue==1) {
                                       if (pageNum == 0) {
                                           [self.recommendeddataSource removeAllObjects];
                                       }
                                       
                                       for (NSDictionary * dic in result) {
                                           //初始化模型
                                           GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
                                           //把模型添加到相应的数据源数组中
                                           [self.recommendeddataSource addObject:model];
                                           
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

    
}


#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        //header
        layout.sectionHeadersPinToVisibleBounds = NO;
        //footer
        //        flowLayout.sectionFootersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:BACKVIEWCOLOR];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        [_collectionView registerClass:[DCCustionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID];
        [_collectionView registerClass:[GoodsIsEmptyHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodsIsEmptyHeadViewID];
        
        [_collectionView registerClass:[HighIntegralCollectionViewCell class] forCellWithReuseIdentifier:HighIntegralCollectionViewCellID];
        [_collectionView registerClass:[TheStoreCollectionViewCell class] forCellWithReuseIdentifier:TheStoreCollectionViewCellID];
        
        [self.view addSubview:_collectionView];
        
        //进行刷新时开始刷新状态请求数据
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            pageNum=0;
            
            //在请求数据的时间初始化当前的数据源数组防止数据重复
//            [self.dataSource removeAllObjects];
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




#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (kArrayIsEmpty(self.dataSource)) {
        return _recommendeddataSource.count;
    }else{
        return _dataSource.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    if ([self.searchtypes isEqualToString:@"商品"]) {
        
        HighIntegralCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HighIntegralCollectionViewCellID forIndexPath:indexPath];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        kArrayIsEmpty(self.dataSource)?[cell setGeneralGoodsModel:_recommendeddataSource[indexPath.row]]:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
        gridcell = cell;
        
    }else if ([self.searchtypes isEqualToString:@"店铺"]){
        
        TheStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TheStoreCollectionViewCellID forIndexPath:indexPath];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        kArrayIsEmpty(self.dataSource)?[cell setTheStoreModel:_recommendeddataSource[indexPath.row]]:[cell setTheStoreModel:_dataSource[indexPath.row]];
        cell.didSelectedEnterStoreBlock = ^(TheStoreModel *model) {
            StoreDisplayViewController *sdvc=[[StoreDisplayViewController alloc]init];
            sdvc.TheStoreModel=model;
            sdvc.business_idstring = model.business_id;
            [self.navigationController pushViewController:sdvc animated:YES];
        };
        gridcell = cell;
        
    }
    
    
    return gridcell;
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        if (kArrayIsEmpty(self.dataSource)) {
            GoodsIsEmptyHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:GoodsIsEmptyHeadViewID forIndexPath:indexPath];
            if ([self.searchtypes isEqualToString:@"商品"]) {
                headerView.type = 1;
            } else {
                headerView.type = 2;
            }
            reusableview = headerView;
        }else{
            
            if ([self.searchtypes isEqualToString:@"商品"]) {
                
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
                
            }else if ([self.searchtypes isEqualToString:@"店铺"]){
                
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
    
    if ([self.searchtypes isEqualToString:@"商品"]) {
        return OtherCollectionViewCellSize;
    }else if ([self.searchtypes isEqualToString:@"店铺"]){
        return CGSizeMake(SCREEN_WIDTH , 215);
    }else{
        return CGSizeZero;
    }
    
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (kArrayIsEmpty(self.dataSource)) {
        return CGSizeMake(SCREEN_WIDTH, 260); //图片滚动的宽高
    } else {
        
        if ([self.searchtypes isEqualToString:@"商品"]) {
            return CGSizeMake(SCREEN_WIDTH, 45); //图片滚动的宽高
        }else if ([self.searchtypes isEqualToString:@"店铺"]){
            return CGSizeZero;
        }else{
            return CGSizeZero;
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
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.searchtypes isEqualToString:@"商品"]) {
        return 4 ;
    }else if ([self.searchtypes isEqualToString:@"店铺"]){
        return 10 ;
    }else{
        return 4 ;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了推荐的第%zd个商品",indexPath.row);
    
    if ([self.searchtypes isEqualToString:@"商品"]) {
        
        GeneralGoodsModel *model = kArrayIsEmpty(_dataSource)?self.recommendeddataSource[indexPath.row]: self.dataSource[indexPath.row];
        
        DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
        
        dcgdvc.GeneralGoodsModel=model;
        //    Apple iPhone SE 玫瑰金 16G 4G 手机（全网通）-----2588-----采用IOS 10 系统，配置A9芯片，更高速-----(
        //                                                                                "http://gfs14.gomein.net.cn/T12TCTByWQ1RCvBVdK_800.jpg",
        //                                                                                "http://gfs14.gomein.net.cn/T1PwKTB5_g1RCvBVdK_800.jpg",
        //                                                                                "http://gfs13.gomein.net.cn/T1ES_TBTAg1RCvBVdK_800.jpg"
        //                                                                                )-----http://gfs17.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_360.jpg
        
        dcgdvc.goodTitle = @"Apple iPhone SE 玫瑰金 16G 4G 手机（全网通）";
        dcgdvc.goodPrice = @"2588";
        dcgdvc.goodSubtitle = @"采用IOS 10 系统，配置A9芯片，更高速";
        dcgdvc.shufflingArray = @[@"http://gfs14.gomein.net.cn/T12TCTByWQ1RCvBVdK_800.jpg",
                                  @"http://gfs14.gomein.net.cn/T1PwKTB5_g1RCvBVdK_800.jpg",
                                  @"http://gfs13.gomein.net.cn/T1ES_TBTAg1RCvBVdK_800.jpg"];
        dcgdvc.goodImageView = @"http://gfs17.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_360.jpg";
        [self.navigationController pushViewController:dcgdvc animated:YES];
        
    }else if ([self.searchtypes isEqualToString:@"店铺"]){
        
        StoreDisplayViewController *sdvc=[[StoreDisplayViewController alloc]init];
        TheStoreModel *model = kArrayIsEmpty(_dataSource)?self.recommendeddataSource[indexPath.row]: self.dataSource[indexPath.row];
        sdvc.TheStoreModel = model;
        sdvc.business_idstring = model.business_id;
        [self.navigationController pushViewController:sdvc animated:YES];
        
    }else{
        
        
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"覆盖原来的代理方法");
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"结束编辑");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索%@",textField.text);
    if (!kStringIsEmpty(textField.text)) {
        self.goodsname = textField.text;
        [self setUpGoodsData];
    }else{
        LRToast(@"请输入要搜索的内容");
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"覆盖");
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

