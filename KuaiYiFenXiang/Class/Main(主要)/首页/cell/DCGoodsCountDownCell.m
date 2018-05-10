//
//  DCGoodsCountDownCell.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodsCountDownCell.h"

// Controllers

// Models
#import "DCRecommendItem.h"
// Views
#import "DCGoodsSurplusCell.h"
// Vendors
// Categories

// Others

@interface DCGoodsCountDownCell ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

/* collection */
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSMutableArray * titleidarray;

/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;

@end

static NSString *const DCGoodsSurplusCellID = @"DCGoodsSurplusCell";

@implementation DCGoodsCountDownCell


-(void)setCountDownItem:(NSMutableArray<DCRecommendItem *> *)countDownItem{
    
    _countDownItem=countDownItem;
    

    [self layoutSubviews];
    
}



#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置请求参数可变数组
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake(self.width/4, self.dc_height * 0.9);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = self.backgroundColor;
    [self addSubview:_collectionView];
    _collectionView.frame = self.bounds;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[DCGoodsSurplusCell class] forCellWithReuseIdentifier:DCGoodsSurplusCellID];
 
    _bottomLineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-8, self.width, 8)];
    [_bottomLineView setBackgroundColor:BACKVIEWCOLOR];
    [self addSubview:_bottomLineView];
    

}

#pragma mark - Setter Getter Methods
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _countDownItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DCGoodsSurplusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSurplusCellID forIndexPath:indexPath];
    cell.recommendItem = _countDownItem[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了计时商品%zd",indexPath.row);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectDCRecommendItemIndex" object:[NSString stringWithFormat:@"%ld",(long)indexPath.row] userInfo:nil];

    
}

@end
