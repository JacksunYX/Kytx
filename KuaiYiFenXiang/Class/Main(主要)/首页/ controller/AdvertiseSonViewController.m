//
//  AdvertiseSonViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "AdvertiseSonViewController.h"
#import "ShoppingCarLatestRecommendedCollectionViewCell.h"

#import "AdvertiseSonNewCell.h" //新增的tableviewcell

static NSString *const AdvertiseRecommendCollectionViewCellID = @"AdvertiseRecommendCollectionViewCellID";

@interface AdvertiseSonViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,TwoSonCellDelegate>
{
    NSInteger pageNum;
}
@property(strong, nonatomic) HMSegmentedControl *sege;
@property (nonatomic,strong) NSMutableArray *catogeryIDsArr;    //分类id数组
@property (nonatomic,strong) NSMutableArray *catogeryTitlesArr; //分类标题数组
@property (nonatomic,assign) NSInteger currentIndex;            //当前选择的分类下标


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *adGoodsArr;        //广告商品数组
@property (nonatomic,strong) NSMutableArray *recommandGoodsArr; //最新推荐的数组

@property (nonatomic,strong) UITableView *tableView;

@end

static CGFloat const headViewHeight = 175;

@implementation AdvertiseSonViewController
#pragma mark --- 懒加载
-(NSMutableArray *)adGoodsArr
{
    if (!_adGoodsArr) {
        _adGoodsArr = [NSMutableArray new];
    }
    return _adGoodsArr;
}

-(NSMutableArray *)recommandGoodsArr
{
    if (!_recommandGoodsArr) {
        _recommandGoodsArr = [NSMutableArray new];
    }
    return _recommandGoodsArr;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        //注册
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FirstGoodsCellID"];
        //分区头
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AdvertiseSonHeadID"];
        
        [_collectionView registerClass:[ShoppingCarLatestRecommendedCollectionViewCell class] forCellWithReuseIdentifier:AdvertiseRecommendCollectionViewCellID];
        
        MCWeakSelf
        //下拉刷新
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (self.collectionView.mj_footer.state == MJRefreshStateRefreshing) {
                [self.collectionView.mj_footer endRefreshing];
            }
            pageNum = 0;
            [weakSelf loadData];
            
        }];
        //上拉加载
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            if (self.collectionView.mj_header.state == MJRefreshStateRefreshing) {
                [self.collectionView.mj_header endRefreshing];
            }
            pageNum ++;
            [weakSelf questCatogeryData];
        }];
    }
    return _collectionView;
}

-(NSMutableArray *)catogeryIDsArr
{
    if (!_catogeryIDsArr) {
        _catogeryIDsArr = [NSMutableArray new];
    }
    return _catogeryIDsArr;
}

-(NSMutableArray *)catogeryTitlesArr
{
    if (!_catogeryTitlesArr) {
        _catogeryTitlesArr = [NSMutableArray new];
    }
    return _catogeryTitlesArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = BACKVIEWCOLOR;
        //添加下面这三句，可以防止在ios11系统下的带分区的tableview刷新时上下跳动
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NormalCellID"];
        [_tableView registerClass:[AdvertiseSonNewCell class] forCellReuseIdentifier:AdvertiseSonNewCellID];
        
        MCWeakSelf
        //下拉刷新
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            pageNum = 0;
            [weakSelf loadData];
            
        }];
        //上拉加载
        _tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            pageNum ++;
            [weakSelf questCatogeryData];
        }];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.model.name;
    
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .rightEqualToView(self.view)
    ;
    
    
    [self.collectionView.mj_header beginRefreshing];
}

-(void)setUI2
{
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.navigationItem.title = self.model.name;
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .rightEqualToView(self.view)
    ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.mj_header beginRefreshing];
}

//加载数据
-(void)loadData
{
    NSDictionary *dic = @{
                          @"id":self.model.ad_id,
                          };
    [HttpRequest postWithURLString:NetRequestUrl(sonAdvertise) parameters:dic isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
        NSDictionary *result = response[@"result"];
        
        if ([response[@"code"] integerValue] == 1) {
            
            self.adGoodsArr = [AdvertiseSonModel mj_objectArrayWithKeyValuesArray:result[@"res"]];
            NSArray *catogeryArr = result[@"data"];
            [self.catogeryTitlesArr removeAllObjects];
            [self.catogeryIDsArr removeAllObjects];
            self.currentIndex = 0;
            if (catogeryArr.count > 0) {
                
                for (NSDictionary *dic in catogeryArr) {
                    
                    [self.catogeryTitlesArr addObject:[dic objectForKey:@"name"]];
                    [self.catogeryIDsArr addObject:[dic objectForKey:@"id"]];
                    
                }
                self.currentIndex = 0;
                
            }
            
            [self questCatogeryData];
            
//            [self.collectionView reloadData];
            
        }else{
            LRToast(response[@"msg"]);
        }
        [self endRefresh];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self endRefresh];
        LRToast(@"请求出错，请检查网络");
    } RefreshAction:^{
        //        [self loadData];
    }];
}

//加载最新推荐的商品
- (void)loadRecommandData
{
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"1" forKey:@"type"];
    
    [dic setObject:@(pageNum) forKey:@"page"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(goods) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSMutableArray *result=[responseObject objectForKey:@"result"];
                                    
                                    if (pageNum == 0) {
                                        [self.recommandGoodsArr removeAllObjects];
                                    }
                                    if (kArrayIsEmpty(result)) {
                                        
                                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                        
                                    }else{
                                        
                                        if (codeStr.intValue==1) {
                                            
                                            for (NSDictionary * dic in result) {
                                                //初始化模型
                                                GeneralGoodsModel *model = [GeneralGoodsModel mj_objectWithKeyValues:dic];
                                                //把模型添加到相应的数据源数组中
                                                [self.recommandGoodsArr addObject:model];
                                            }
                                            
                                        }
                                        [self.collectionView.mj_footer endRefreshing];
                                    }
                                    
                                    [self.collectionView reloadData];
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                    [self endRefresh];
                                    
                                    [self.collectionView reloadData];
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

//请求对应的数据
-(void)questCatogeryData
{
//    if (kArrayIsEmpty(self.catogeryIDsArr)) {
//        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
//        return;
//    }
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *catogeryID ;
    if (self.catogeryIDsArr.count) {
        catogeryID = self.catogeryIDsArr[self.currentIndex];
    }else{
        catogeryID = @"0";
    }
    //如果id不存在，那就默认传0
    kStringIsEmpty(catogeryID)?[dic setObject:@"0" forKey:@"id"]:[dic setObject:catogeryID forKey:@"id"];
    dic[@"page"] = @(pageNum);
    dic[@"p_id"] = self.model.ad_id;
    
    [HttpRequest postWithURLString:NetRequestUrl(specialClassify) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSArray *result = [responseObject objectForKey:@"result"];
                               if (pageNum == 0) {
                                   [self.recommandGoodsArr removeAllObjects];
                               }
                               if (codeStr.intValue == 1) {
                                   if (!kArrayIsEmpty(result)) {
                                       [self.recommandGoodsArr addObjectsFromArray:[GeneralGoodsModel mj_objectArrayWithKeyValuesArray:result]];
//                                       [self.collectionView.mj_footer endRefreshing];
                                       [self.tableView.mj_footer endRefreshing];
                                   }else{
//                                       [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                       [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                   }
                               }else{
//                                   [self.collectionView.mj_footer endRefreshing];
                                   [self.tableView.mj_footer endRefreshing];
                               }
                               
//                               [self.collectionView reloadData];
                               [self.tableView reloadData];
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               LRToast(@"请求失败，请检查网络~");
//                               [self.collectionView.mj_footer endRefreshing];
//                               [self.collectionView reloadData];
                               
                               [self.tableView.mj_footer endRefreshing];
                               [self.tableView reloadData];
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
}

-(void)setSegMentWithData:(NSArray *)titleArr
{
    
    self.sege = [[HMSegmentedControl alloc] initWithSectionTitles:titleArr];
    self.sege.frame = CGRectMake(0, 0,  SCREEN_WIDTH, 50);
    self.sege.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.sege.backgroundColor = kWhiteColor;
    self.sege.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:ScaleWidth(15)]};
    self.sege.selectionIndicatorHeight = 2;
    self.sege.selectionIndicatorColor = [UIColor colorWithHexString:@"d40000"];
    self.sege.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"d40000"]};
    self.sege.selectedSegmentIndex = self.currentIndex;
    [self.sege addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    self.currentIndex = index;
    pageNum = 0;
    NSLog(@"点击了第%ld个分类",index);
    [self questCatogeryData];
}

//结束刷新
-(void)endRefresh
{
//    if (self.collectionView.mj_header.state == MJRefreshStateRefreshing) {
//        [self.collectionView.mj_header endRefreshing];
//    }
//    if (self.collectionView.mj_footer.state == MJRefreshStateRefreshing) {
//        [self.collectionView.mj_footer endRefreshing];
//    }
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark -----   UICollectionViewDataSource   -----
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.adGoodsArr.count;
    }
    return self.recommandGoodsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstGoodsCellID" forIndexPath:indexPath];
        UIImageView *imageView = [UIImageView new];
        [cell.contentView addSubview:imageView];
        AdvertiseSonModel *goodModel = self.adGoodsArr[indexPath.row];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,goodModel.image]] placeholderImage:nil];
        
        imageView.sd_layout
        .leftEqualToView(cell.contentView)
        .topEqualToView(cell.contentView)
        .rightEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        ;
        
    }
    if (indexPath.section == 1) {
        ShoppingCarLatestRecommendedCollectionViewCell *ce = [collectionView dequeueReusableCellWithReuseIdentifier:AdvertiseRecommendCollectionViewCellID forIndexPath:indexPath];
        [ce.contentView setBackgroundColor:[UIColor whiteColor]];
        ce.GeneralGoodsModel = self.recommandGoodsArr[indexPath.row];
        cell = ce;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenW, kScaelW(150));
    }
    return CGSizeMake((SCREEN_WIDTH - 5)/2, (SCREEN_WIDTH - 5)/2 + 80);
}

//分区尾大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

//分区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(ScreenW, headViewHeight);
    }
    if (section == 1&&self.catogeryTitlesArr.count) {
       return CGSizeMake(ScreenW, 50);
    }
    return CGSizeZero;
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

//分区头部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AdvertiseSonHeadID" forIndexPath:indexPath];
        if (headerView.subviews.count>0) {
            [headerView removeAllSubviews];
        }
        
        if (indexPath.section == 0) {
            headerView.backgroundColor = [UIColor whiteColor];
            UIImageView *headImage = [UIImageView new];
            [headerView addSubview:headImage];
            [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,self.model.son_image]] placeholderImage:nil];
            
            headImage.sd_layout
            .leftEqualToView(headerView)
            .topEqualToView(headerView)
            .rightEqualToView(headerView)
//            .bottomEqualToView(headerView)
            .bottomSpaceToView(headerView, - 0.5)
            ;
        }
        if (indexPath.section == 1) {
            headerView.backgroundColor = [UIColor whiteColor];
//            UILabel *titleLabel = [UILabel new];
//            [headerView addSubview:titleLabel];
//            titleLabel.sd_layout
//            .centerXEqualToView(headerView)
//            .heightIs(10)
//            .centerYEqualToView(headerView)
//            ;
//            titleLabel.textColor =[UIColor redColor];
//            [titleLabel setSingleLineAutoResizeWithMaxWidth:ScreenW - 20];
//            titleLabel.text = @"··· 口碑星品 ···";
            [self setSegMentWithData:self.catogeryTitlesArr];
            [headerView addSubview:self.sege];
        }
        
        reusableview = headerView;
    }
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个item",indexPath.row);
    if (indexPath.section == 0) {
        AdvertiseSonModel *goodsModel = self.adGoodsArr[indexPath.row];
        DCGoodDetailViewController *DCGoodDetailVc = [[DCGoodDetailViewController alloc] init];
        DCGoodDetailVc.goods_id = goodsModel.son_id;
        [self.navigationController pushViewController:DCGoodDetailVc animated:YES];
    }
    if (indexPath.section == 1) {
        GeneralGoodsModel *GeneralGoodsModel = self.recommandGoodsArr[indexPath.row];
        DCGoodDetailViewController *DCGoodDetailVc = [[DCGoodDetailViewController alloc] init];
        DCGoodDetailVc.GeneralGoodsModel = GeneralGoodsModel;
        [self.navigationController pushViewController:DCGoodDetailVc animated:YES];
    }
    
}


#pragma mark ----- UITableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.catogeryIDsArr.count > 0) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 + self.adGoodsArr.count;
    }
    if (self.recommandGoodsArr.count%2 == 0) {
        return self.recommandGoodsArr.count/2;
    }
    return self.recommandGoodsArr.count/2 + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellID" forIndexPath:indexPath];
        [cell.contentView removeAllSubviews];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *adGoodView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, headViewHeight)];
        adGoodView.backgroundColor = kWhiteColor;
        NSString *imgStr;
        if (indexPath.row == 0) {
            imgStr = [NSString stringWithFormat:@"%@%@",DefaultDomainName,self.model.son_image];
        }else{
            AdvertiseSonModel *goodModel = self.adGoodsArr[indexPath.row - 1];
            imgStr = [NSString stringWithFormat:@"%@%@",DefaultDomainName,goodModel.image];
        }
        [adGoodView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
        [cell addSubview:adGoodView];
        
    }else{
        AdvertiseSonNewCell *newcell = (AdvertiseSonNewCell *)[tableView dequeueReusableCellWithIdentifier:AdvertiseSonNewCellID forIndexPath:indexPath];
        newcell.delegate = self;
        GeneralGoodsModel *leftModel;
        GeneralGoodsModel *rightModel;
        newcell.backgroundColor = BACKVIEWCOLOR;
        //两种情况
        leftModel = self.recommandGoodsArr[(indexPath.row+1)*2 - 2];
        
        NSInteger cellRow;  //行数
        if (self.recommandGoodsArr.count%2 == 0) {  //偶数
            cellRow = self.recommandGoodsArr.count/2;
            rightModel = self.recommandGoodsArr[(indexPath.row+1)*2 - 1];
        }else{  //奇数
            cellRow = self.recommandGoodsArr.count/2 + 1;
            //说明是最后一行，不需要给右边的model赋值
            if (indexPath.row == cellRow - 1) {
                
            }else{
                rightModel = self.recommandGoodsArr[(indexPath.row+1)*2 - 1];
            }
        }
        newcell.tag = indexPath.row ;
        [newcell setDataLeft:leftModel right:rightModel];
        
        cell = newcell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return headViewHeight;
    }
    return (SCREEN_WIDTH - 5)/2 + 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    if (self.catogeryIDsArr.count > 0) {
        return 50;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    if (section == 1) {
        headerView.backgroundColor = kWhiteColor;
        if (self.catogeryTitlesArr.count) {
            [self setSegMentWithData:self.catogeryTitlesArr];
            [headerView addSubview:self.sege];
        }
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            AdvertiseSonModel *goodsModel = self.adGoodsArr[indexPath.row -1];
            DCGoodDetailViewController *DCGoodDetailVc = [[DCGoodDetailViewController alloc] init];
            DCGoodDetailVc.goods_id = goodsModel.son_id;
            [self.navigationController pushViewController:DCGoodDetailVc animated:YES];
        }
    }
}

#pragma mark ----- TwoSonCellDelegate
-(void)clickHandleGoodsData:(GeneralGoodsModel *)model
{
    DCGoodDetailViewController *DCGoodDetailVc = [[DCGoodDetailViewController alloc] init];
    DCGoodDetailVc.GeneralGoodsModel = model;
    [self.navigationController pushViewController:DCGoodDetailVc animated:YES];
}






@end
