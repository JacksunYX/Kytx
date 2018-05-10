//
//  SubclassModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "QualityZoneViewController.h"

#import "SubclassModuleViewController.h"

@interface QualityZoneViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,SubClassVCRefreshDelegate>{
    UICollectionReusableView *headerView;
}

@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UIView *bgView;
/** 记录上一次选中的Button */
@property (nonatomic , weak) UIButton *selectBtn;
/* 标题按钮地下的指示器 */
@property (weak ,nonatomic) UIView *indicatorView;
@property(nonatomic,strong) NSMutableArray *titlearray;
@property(nonatomic,strong) NSMutableArray *titleidarray;

@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const UICollectionViewCellID = @"UICollectionViewCell";

@implementation QualityZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=self.titlestring;
    
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadRealData];
    
}

- (void)loadRealData{
    
    
    self.titlearray = [NSMutableArray new];
    self.titleidarray = [NSMutableArray new];
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:self.two_idstring forKey:@"a_id"];
    //    [dic setObject:@"1" forKey:@"show_type"];
    
    [HttpRequest postWithURLString:NetRequestUrl(qualityLoveThree) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = responseObject[@"code"];
                               NSDictionary *result = responseObject[@"result"];
                               NSArray *activeArr = result[@"active"];
                               if (codeStr.intValue==1) {
                                   
                                   for (NSDictionary *dic in activeArr) {
                                       
                                       [self.titlearray addObject:[dic objectForKey:@"name"]];
                                       [self.titleidarray addObject:[dic objectForKey:@"id"]];
                                       
                                   }
                                   [self setUpChildViewControllers];
                                   
                               }
                               
                               [self.collectionView reloadData];
                               //                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               //
                               //
                               //                               });
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - 10);
        [_collectionView setBackgroundColor:BACKVIEWCOLOR];
        _collectionView.showsVerticalScrollIndicator = NO;        //注册
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:UICollectionViewCellID];
        
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *gridcell = nil;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UICollectionViewCellID forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    if (indexPath.section==0) {
        UIImageView *cellimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
        NSString *temp = [self.titlestring stringByReplacingOccurrencesOfString:@"/" withString:@""];
        [cellimageview setImage:[UIImage imageNamed:temp]];
        [cell.contentView addSubview:cellimageview];
    }else{
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.pagingEnabled = YES;
//        _scrollerView.backgroundColor = hwrandomcolor;
        _scrollerView.backgroundColor = self.view.backgroundColor;
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titlearray.count, 0);
        _scrollerView.delegate = self;
        [cell.contentView addSubview:_scrollerView];
    }
    gridcell = cell;
    
    return gridcell;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
        if (indexPath.section==1) {
            
            NSArray *titles = self.titlearray;
            CGFloat margin = 0;
            CGFloat buttonW = headerView.width/4;
            CGFloat buttonH = headerView.height-1;
            CGFloat buttonY = 0;
            for (NSInteger i = 0; i < titles.count; i++) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:titles[i] forState:0];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundColor:BACKVIEWCOLOR];
                button.tag = i;
                button.titleLabel.font = PFR15Font;
                [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat buttonX = i * (buttonW + margin);
                button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
                [headerView addSubview:button];
                
            }
            
            if (!kArrayIsEmpty(headerView.subviews)) {
                UIButton *firstButton = headerView.subviews[0];
                [self topBottonClick:firstButton]; //默认选择第一个
                
                UIView *indicatorView = [[UIView alloc]init];
                self.indicatorView = indicatorView;
                indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
                
                indicatorView.dc_height = 2;
                indicatorView.dc_y = headerView.dc_height - indicatorView.dc_height;
                
                [firstButton.titleLabel sizeToFit];
                indicatorView.dc_width = firstButton.titleLabel.dc_width;
                indicatorView.dc_centerX = firstButton.dc_centerX;
                
                [headerView addSubview:indicatorView];
            }
            
        }else{
            
        }
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
        return CGSizeMake(SCREEN_WIDTH,175);
    }else{
        return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-NAVIGATION_TAB_HEIGHT-6.5);
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
#pragma mark - 添加子控制器View
-(void)addChildViewController
{
    NSInteger index = _scrollerView.contentOffset.x / _scrollerView.width;
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview) return; //判断添加就不用再添加了
    
    
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断回到顶部按钮是否隐藏
    //    _collectionView.scrollEnabled = (scrollView.contentOffset.y >= 175) ? NO : YES;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildViewController];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.dc_width;
    UIButton *button = headerView.subviews[index];
    
    [self topBottonClick:button];
    
    [self addChildViewController];
}

#pragma mark - 点击事件
#pragma mark - 头部按钮点击
- (void)topBottonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _selectBtn = button;
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.dc_width = button.titleLabel.dc_width;
        weakSelf.indicatorView.dc_centerX = button.dc_centerX;
    }];
    
    CGPoint offset = _scrollerView.contentOffset;
    offset.x = _scrollerView.dc_width * button.tag;
    [_scrollerView setContentOffset:offset animated:NO];
}


#pragma mark - 添加子控制器
-(void)setUpChildViewControllers
{
    for (int i = 0; i<self.titlearray.count; i++) {
        SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc] init];
        smvc.delegate = self;
        smvc.categorynameNumString = @"categoryzone";
        smvc.currentIndexId = self.titleidarray[i];
        smvc.a_id = self.two_idstring;
        [self addChildViewController:smvc];
        smvc.view.frame = CGRectMake(i * _scrollerView.dc_width, 0, _scrollerView.dc_width, _scrollerView.dc_height);
        [_scrollerView addSubview:smvc.view];
    }
    //    [self addChildViewController];
    
}

#pragma mark ---- SubClassVCRefreshDelegate ----
-(void)subVCDataHaveRefresh
{
    NSLog(@"刷新一下");
    [self.collectionView reloadData];
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
