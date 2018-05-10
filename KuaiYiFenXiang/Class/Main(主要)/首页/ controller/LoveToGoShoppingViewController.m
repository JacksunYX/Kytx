//
//  SubclassModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "LoveToGoShoppingViewController.h"

#import "GoodsUnifiedModel.h"
#import "DCRecommendItem.h"

#import "ShoppingCarLatestRecommendedCollectionViewCell.h"

#import "DCGoodsCountDownCell.h"

#import "SubclassModuleViewController.h"

static int pageNum=0;

@interface LoveToGoShoppingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    NSString *currentIndexId;

}

@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSMutableArray<GoodsUnifiedModel *> *dataSource;

/* 推荐商品数据 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *countDownItem;

@property (strong , nonatomic)NSMutableArray * titleidarray;
@property (strong , nonatomic)NSMutableArray * titletextarray;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;

@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const ShoppingCarLatestRecommendedCollectionViewCellID = @"ShoppingCarLatestRecommendedCollectionViewCell";

static NSString *const DCGoodsCountDownCellID = @"DCGoodsCountDownCell";


@implementation LoveToGoShoppingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentIndex:) name:@"SelectDCRecommendItemIndex" object:nil];
    
    pageNum=0;
    
}
-(void)currentIndex:(NSNotification *)resp{
    
    NSLog(@"%@",resp.object);
    
    NSString *indexstring=resp.object;
    
    SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
    smvc.categorynameNumString = @"LevelThreeClassification";
    smvc.categoryzoneid=self.titleidarray[indexstring.integerValue];
    smvc.titlestring=self.titletextarray[indexstring.integerValue];
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [_backTopButton removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=self.titlestring;
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(shareClick) image:@"shareimage" hightimage:@"shareimage"  andTitle:@""];

    self.view.backgroundColor = BACKVIEWCOLOR;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;

    _dataSource=[NSMutableArray new];
    
    _countDownItem = [NSMutableArray array];
    
    _titletextarray=[NSMutableArray array];
    _titleidarray=[NSMutableArray array];

    [self requestData];
    
    [self setUpGoodsData];

}
-(void)requestData{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:kStringIsEmpty(self.two_idstring)?@"":self.two_idstring forKey:@"a_id"];
    
//    [dic setObject:@"2" forKey:@"show_type"];
    
    [HttpRequest postWithURLString:NetRequestUrl(qualityLoveThree) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSMutableArray *result=[responseObject objectForKey:@"result"];
                               
                               if (codeStr.intValue==1) {
                                   
                                   for (NSDictionary *dic in result) {
                                       
                                       NSDictionary *modeldic=@{
                                                                @"image_url":[dic objectForKey:@"image"],
                                                                @"price":[dic objectForKey:@"name"],
                                                                };
                                       [_titletextarray addObject:[dic objectForKey:@"name"]];
                                       [_titleidarray addObject:[dic objectForKey:@"id"]];
                                       //初始化模型
                                       DCRecommendItem *model=[DCRecommendItem mj_objectWithKeyValues:modeldic];
                                       //把模型添加到相应的数据源数组中
                                       [_countDownItem addObject:model];
                                       
                                   }
                                   
                               }
                               
                               NSLog(@"%@",_countDownItem);
                               
                               [_collectionView reloadData];
                               
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
    
    
    
//    //    /** 图片URL */
//    //    @property (nonatomic, copy ) NSString *imageurlString;
//    //    /** 商品标题 */
//    //    @property (nonatomic, copy ) NSString *maintitleString;
//    //    /** 商品原价 */
//    //    @property (nonatomic, copy ) NSString *originalpriceString;
//    //    /** 商品现价 */
//    //    @property (nonatomic, copy ) NSString *presentpriceString;
//
//
//    _dataSource=[NSMutableArray new];
//
//
//
//        //通过循环模拟数据的请求
//        for (int i=0; i<16; i++) {
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
//
//        }
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

    
    
}


#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setScrollEnabled:YES];
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - 10);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];

        [_collectionView registerClass:[ShoppingCarLatestRecommendedCollectionViewCell class] forCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID];
        [_collectionView registerClass:[DCGoodsCountDownCell class] forCellWithReuseIdentifier:DCGoodsCountDownCellID];
        
        
        [self.view addSubview:_collectionView];
        
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

        [self setUpSuspendView];
        
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
        DCGoodsCountDownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsCountDownCellID forIndexPath:indexPath];
        kArrayIsEmpty(_countDownItem)?:[cell setCountDownItem:[_countDownItem mutableCopy]];
        gridcell = cell;
    }else{
    ShoppingCarLatestRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:_dataSource[indexPath.row]];
    gridcell = cell;
    }
    return gridcell;
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
            UIImageView *cellimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
            [cellimageview setImage:[UIImage imageNamed:self.titlestring]];
            [headerView addSubview:cellimageview];
            
            UIImageView *xinpintuijianImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH-80, 23)];
            xinpintuijianImageView.centerX=headerView.centerX;
            [xinpintuijianImageView setImage:[UIImage imageNamed:@"zuixintuijian"]];
            [headerView addSubview:xinpintuijianImageView];
            reusableview = headerView;

    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        
    }
    
    return reusableview;
}

//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        return CGSizeMake(ScreenW, 150);
    }else{
        return OtherCollectionViewCellSize;
    }
    
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        return CGSizeZero;
    }else{
        return CGSizeMake(SCREEN_WIDTH, 225); //图片滚动的宽高
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
    NSLog(@"点击了推荐的第%zd个商品",indexPath.row);
    GeneralGoodsModel *model=self.dataSource[indexPath.row];
    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
    dcgdvc.goods_id=model.goods_id;
    [self.navigationController pushViewController:dcgdvc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"_collectionView.contentOffset.y-%f",_collectionView.contentOffset.y);
    
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
    
}

-(void)shareClick{
    
    
    
    
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
