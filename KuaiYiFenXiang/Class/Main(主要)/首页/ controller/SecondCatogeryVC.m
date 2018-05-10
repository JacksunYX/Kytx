//
//  SecondCatogeryVC.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "SecondCatogeryVC.h"
#import "HomePageSecondCell.h"

@interface SecondCatogeryVC () <UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    NSInteger pageNum;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation SecondCatogeryVC

#pragma mark --- 懒加载
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = RGB(230, 230, 230);
        _collectionView.directionalLockEnabled = YES;
        [_collectionView registerClass :[UICollectionViewCell class ] forCellWithReuseIdentifier :@"cell" ];
        [_collectionView registerClass:[HomePageSecondCell class] forCellWithReuseIdentifier:HomePageSecondCellID];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            pageNum ++;
            [self questCatogeryData];
        }];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"a_id:%@  al_id:%@",self.a_id,self.al_id);
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [self questCatogeryData];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageSecondCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageSecondCellID forIndexPath:indexPath];
    [cell setModel:self.dataSource[indexPath.row]];
    
    return cell;
}

//最初一直没实现如下方法，导致莫名其妙的错误
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return DCGoodsYouLikeCellSize;
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 4, 4, 4);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个",indexPath.row);
    GeneralGoodsModel *model = self.dataSource[indexPath.row];
    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
    dcgdvc.goods_id = model.goods_id;
    [self.navigationController pushViewController:dcgdvc animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




//请求对应的数据
-(void)questCatogeryData
{
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    dic[@"a_id"] = self.a_id;
    dic[@"al_id"] = self.al_id;
    dic[@"type"] = @(pageNum);
    
    [HttpRequest postWithURLString:NetRequestUrl(qualityLoveThree) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSDictionary *result = [responseObject objectForKey:@"result"];
                               NSArray *listArr = result[@"list"];
                               
                               if (codeStr.intValue == 1) {
                                   if (!kArrayIsEmpty(listArr)) {
                                       
                                       [self.dataSource addObjectsFromArray:[GeneralGoodsModel mj_objectArrayWithKeyValuesArray:listArr]];
                                       [self.collectionView.mj_footer endRefreshing];
                                   }else{
                                       [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                   }
                               }
                               
                               [self.collectionView reloadData];
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               LRToast(@"请求失败，请检查网络~");
                               [self.collectionView.mj_footer endRefreshing];
                               [self.collectionView reloadData];
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
}















@end
