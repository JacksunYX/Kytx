//
//  DCCommodityViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//
#define tableViewH  100

#import "DCCommodityViewController.h"
#import "SubclassModuleViewController.h"
// Models
#import "DCClassMianItem.h"
#import "DCCalssSubItem.h"
#import "DCClassGoodsItem.h"
// Views
#import "DCClassCategoryCell.h"
#import "DCGoodsSortCell.h"
#import "DCBrandSortCell.h"
#import "DCBrandsSortHeadView.h"
// Vendors
// Categories

// Others

@interface DCCommodityViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* collectionViw */
@property (strong , nonatomic)UICollectionView *collectionView;

/* 左边数据 */
@property (strong , nonatomic)NSMutableArray<DCClassGoodsItem *> *titleItem;
/* 右边数据 */
@property (strong , nonatomic)NSMutableArray<DCClassMianItem *> *mainItem;

@property (strong , nonatomic)NSMutableArray *datasource1;

@property (strong , nonatomic)NSMutableArray *datasource2;

@property (strong , nonatomic)NSMutableArray *headimageviewUrlArray;

@property (nonatomic, copy) NSString *headimageviewUrl;

@end

static NSString *const DCClassCategoryCellID = @"DCClassCategoryCell";
static NSString *const DCBrandsSortHeadViewID = @"DCBrandsSortHeadView";
static NSString *const DCGoodsSortCellID = @"DCGoodsSortCell";
static NSString *const DCBrandSortCellID = @"DCBrandSortCell";

@implementation DCCommodityViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, 0, tableViewH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCClassCategoryCell class] forCellReuseIdentifier:DCClassCategoryCellID];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
//        layout.sectionHeadersPinToVisibleBounds = YES;//头部悬浮
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = CGRectMake(tableViewH, 0, SCREEN_WIDTH - tableViewH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN);
        //注册Cell
        [_collectionView registerClass:[DCGoodsSortCell class] forCellWithReuseIdentifier:DCGoodsSortCellID];
        [_collectionView registerClass:[DCBrandSortCell class] forCellWithReuseIdentifier:DCBrandSortCellID];
        //注册Header
        [_collectionView registerClass:[DCBrandsSortHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCBrandsSortHeadViewID];
    }
    return _collectionView;
}


#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"分类";
    
    [self setUpTab];
    
    [self setUpData];
    
}

#pragma mark - initizlize
- (void)setUpTab
{
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 加载数据
- (void)setUpData
{
    
    _titleItem = [NSMutableArray new];
    _mainItem = [NSMutableArray new];
    _datasource2 = [NSMutableArray new];
    _headimageviewUrlArray = [NSMutableArray new];

    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [dic setObject:@"1" forKey:@"vesion"];

    [HttpRequest postWithURLString:NetRequestUrl(categoryList) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {

            NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
            NSMutableArray *result=[responseObject objectForKey:@"result"];

        if (codeStr.intValue==1) {

            //获取左边数据
            for (NSDictionary * dic in result) {
                
            _datasource1 = [NSMutableArray new];

            NSDictionary *onedic=[dic objectForKey:@"one"];
            NSDictionary *titledic=@{
                                    @"title":[onedic objectForKey:@"name"],
                                    };
            [_headimageviewUrlArray addObject:[onedic objectForKey:@"image"]];
            [_titleItem addObject:[DCClassGoodsItem mj_objectWithKeyValues:titledic]];

                
                //获取右边数据
            NSMutableArray *tmenuarray=[onedic objectForKey:@"tmenu"];
            for (NSDictionary *twodic in tmenuarray) {
               NSString *namestring=[twodic objectForKey:@"name"];
               NSString *imgstring=[twodic objectForKey:@"image"];
               NSMutableArray *sub_menuarray=[twodic objectForKey:@"sub_menu"];
               NSMutableArray *goodsarray=[NSMutableArray new];
               for (NSDictionary * threedic in sub_menuarray) {
                   NSLog(@"%@",threedic);
                   NSDictionary *goodsdic=@{
                                            @"goods_id":[threedic objectForKey:@"id"],
                                            @"goods_title":[threedic objectForKey:@"name"],
                                            @"image_url":kStringIsEmpty([threedic objectForKey:@"image"])?@"http://gfs17.gomein.net.cn/T1CvZTBsbv1RCvBVdK_800.jpg":[threedic objectForKey:@"image"],
                                            };
                   [goodsarray addObject:goodsdic];
               }

               NSDictionary *goodsdic=@{
                                        @"titleimageUrl":kStringIsEmpty(imgstring)?@"http://gfs17.gomein.net.cn/T1CvZTBsbv1RCvBVdK_800.jpg":imgstring,
                                        @"title":namestring,
                                        @"goods":goodsarray,
                                        };

                //记载单个分类模型
               [_datasource1 addObject:[DCClassMianItem mj_objectWithKeyValues:goodsdic]];
            }
                //记载所有分类模型
                [_datasource2 addObject:_datasource1];
            }

                
            }
           
           _headimageviewUrl=_headimageviewUrlArray[0];
           _mainItem = _datasource2[0];
           [self.tableView reloadData];
           [self.collectionView reloadData];
           [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

       } failure:^(NSError *error) {
           //打印网络请求错误
           NSLog(@"%@",error);

           [self.collectionView reloadData];

       } RefreshAction:^{
           //执行无网络刷新回调方法

       }];

    
    
//    _titleItem = [DCClassGoodsItem mj_objectArrayWithFilename:@"ClassifyTitles.plist"];
//    _mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods01.plist"];
//    //默认选择第一行（注意一定要在加载完数据之后）
//    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:DCClassCategoryCellID forIndexPath:indexPath];
    cell.titleItem = _titleItem[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _headimageviewUrl = _headimageviewUrlArray[indexPath.row];
    _mainItem = _datasource2[indexPath.row];
    [self ScrollToTop];
    [self.collectionView reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainItem.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainItem[section].goods.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if ([_mainItem[_mainItem.count - 1].title isEqualToString:@"热门品牌"]) {
        if (indexPath.section == _mainItem.count - 1) {//品牌
            DCBrandSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCBrandSortCellID forIndexPath:indexPath];
            cell.subItem = _mainItem[indexPath.section].goods[indexPath.row];
            gridcell = cell;
        }
        else {//商品
            DCGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSortCellID forIndexPath:indexPath];
            cell.subItem = _mainItem[indexPath.section].goods[indexPath.row];
            gridcell = cell;
        }
    }else{//商品
        DCGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSortCellID forIndexPath:indexPath];
        cell.subItem = _mainItem[indexPath.section].goods[indexPath.row];
        gridcell = cell;
    }

    return gridcell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        DCBrandsSortHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCBrandsSortHeadViewID forIndexPath:indexPath];
        headerView.headTitle = _mainItem[indexPath.section];
        if (indexPath.section==0) {
            UIImageView* titleImageView=[[UIImageView alloc]init];
            [titleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,_headimageviewUrl]] placeholderImage:[UIImage imageNamed:@"applogo"]];
            [headerView addSubview:titleImageView];
            titleImageView.sd_layout
            .topSpaceToView(headerView, 15)
            .leftSpaceToView(headerView, 15)
            .rightSpaceToView(headerView, 15)
            .heightIs(100);
        }else{
            for (UIImageView *imageview in headerView.subviews) {
                if ([imageview isKindOfClass:[UIImageView class]]) {
                    [imageview removeFromSuperview];
                }
            }
        }
        reusableview = headerView;

    }
    return reusableview;
}
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        if ([_mainItem[_mainItem.count - 1].title isEqualToString:@"热门品牌"]) {
            if (indexPath.section == _mainItem.count - 1) {//品牌
                return CGSizeMake((SCREEN_WIDTH - tableViewH - 6)/3, 60);
            }else{//商品
                return CGSizeMake((SCREEN_WIDTH - tableViewH - 6)/3, (SCREEN_WIDTH - tableViewH - 6)/3 + 20);
            }
        }else{
            return CGSizeMake((SCREEN_WIDTH - tableViewH - 6)/3, (SCREEN_WIDTH - tableViewH - 6)/3 + 20);
        }
    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGSizeMake(SCREEN_WIDTH, 160);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 25);
    }
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了个第%zd分组第%zd几个Item",indexPath.section,indexPath.row);
    SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
    DCCalssSubItem * model = _mainItem[indexPath.section].goods[indexPath.row];
    smvc.categorynameNumString = @"LevelThreeClassification";
    smvc.categoryzoneid = model.goods_id;
    smvc.titlestring = model.goods_title;
    [self.navigationController pushViewController:smvc animated:YES];
}

#pragma 设置StatusBar为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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


@end
