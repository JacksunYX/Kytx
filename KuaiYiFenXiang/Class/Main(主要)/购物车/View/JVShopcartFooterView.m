//
//  JVShopcartFooterView.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "JVShopcartFooterView.h"

#import "GoodsUnifiedModel.h"

#import "ShoppingCarLatestRecommendedCollectionViewCell.h"

static int pageNum = 0;

@interface JVShopcartFooterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (strong , nonatomic)UICollectionView *collectionView;


@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const ShoppingCarLatestRecommendedCollectionViewCellID = @"ShoppingCarLatestRecommendedCollectionViewCell";

@implementation JVShopcartFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.collectionView.backgroundColor = BACKVIEWCOLOR;
    
    self.dataSource=[NSMutableArray new];

    [self setUpGoodsData];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RefreshShoppingCartNewCommendGoodNotify object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"上拉加载");
        pageNum ++;
        [self setUpGoodsData];
    }];

}

#pragma mark - 加载数据
- (void)setUpGoodsData
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
                               
                               NSInteger datacount = _dataSource.count;
                               if (datacount>0) {
                                   NSInteger x = datacount % 2;
                                   CGFloat cellH = ((SCREEN_WIDTH - 5)/2 + 80); //cell高度
                                   CGFloat marginY = 4;    //y轴间距
                                   if (x) {    //奇数
                                       x = datacount / 2 + 1; //记得+1
                                   }else{  //偶数
                                       x = datacount / 2 ; //直接得到行数
                                   }
                                   //            return SCREEN_HEIGHT*2+20;
                                   CGFloat collectionViewHeight = 50 + x * cellH + (x - 1) * marginY;
                                   self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, collectionViewHeight);
                               }else{
                                   self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
                               }
                               
                               [self.collectionView reloadData];
                               
                               if ([self.delegate respondsToSelector:@selector(haveloadHeadData)]&&pageNum == 0) {
                                   [self.delegate haveloadHeadData];
                               }
                               if ([self.delegate respondsToSelector:@selector(haveLoadFootData:)]&&pageNum != 0) {
                                   if (result.count<10) {
                                       //说明已经加载完了
                                       [self.delegate haveLoadFootData:YES];
                                   }else{
                                       [self.delegate haveLoadFootData:NO];
                                   }
                                   
                               }
                               
                               
                               
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
        [_collectionView setScrollEnabled:NO];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 2 + 30);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        
        [_collectionView registerClass:[ShoppingCarLatestRecommendedCollectionViewCell class] forCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}




#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    
    ShoppingCarLatestRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShoppingCarLatestRecommendedCollectionViewCellID forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    cell.GeneralGoodsModel = _dataSource[indexPath.row];
    cell.didSelectedaddshoppingcarButton = ^(GeneralGoodsModel *model) {
        if (self.didSelectedJVShopcartFooterView) {
            self.didSelectedJVShopcartFooterView(model.goods_id);
        }
    };
    gridcell = cell;
    
    return gridcell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
        
        UIImageView *xinpintuijianImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH-80, 23)];
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
    
    return CGSizeMake((SCREEN_WIDTH - 5)/2, (SCREEN_WIDTH - 5)/2 + 80);
    
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 50); //图片滚动的宽高
    
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
    if (self.didSelectedJVShopcartFooterView) {
        self.didSelectedJVShopcartFooterView(model.goods_id);
    }
}

@end
