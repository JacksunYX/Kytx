//
//  HomePageSecondeVC.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/14.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "HomePageSecondeVC.h"
#import "SecondCatogeryVC.h"

#import "MainTouchTableTableView.h"
#import "WMPageController.h"

static CGFloat const headViewHeight = 175;

@interface HomePageSecondeVC ()<UITableViewDelegate,UITableViewDataSource,scrollDelegate,WMPageControllerDelegate>
{
    NSString *headImgStr;
}

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;
@property(nonatomic,strong)UIImageView *headImageView;  //头部图片

@property (nonatomic,strong) NSMutableArray *classifyIDArr;  //子分类id数组
@property (nonatomic,strong) NSMutableArray *classifyTitleArr;  //子分类名称数组

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveMainTableView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveParentScrollView;

@end

@implementation HomePageSecondeVC

#pragma mark --- 懒加载
-(NSMutableArray *)classifyIDArr
{
    if (!_classifyIDArr) {
        _classifyIDArr = [NSMutableArray new];
    }
    return _classifyIDArr;
}

-(NSMutableArray *)classifyTitleArr
{
    if (!_classifyTitleArr) {
        _classifyTitleArr = [NSMutableArray new];
    }
    return _classifyTitleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self questClassify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.titleStr;
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
    //支持下刷新。关闭弹簧效果
    self.mainTableView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.canScroll = YES;
}

//头部图片
-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView = [UIImageView new];
//        _headImageView.backgroundColor = hwrandomcolor;
        _headImageView.frame = CGRectMake(0, - headViewHeight -10,ScreenW,headViewHeight);
        _headImageView.userInteractionEnabled = YES;

    }
    return _headImageView;
}

//主视图
-(MainTouchTableTableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,ScreenW,ScreenH - NAVI_HEIGHT)];
        _mainTableView.delegate=self;
        _mainTableView.dataSource=self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight + 10,0, 0, 0);
        _mainTableView.backgroundColor = RGB(230, 230, 230);;
    }
    return _mainTableView;
}

//请求子分类
- (void)questClassify
{
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:self.a_id forKey:@"a_id"];
    
    [HttpRequest postWithURLString:NetRequestUrl(qualityLoveThree) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = responseObject[@"code"];
                               NSDictionary *result = responseObject[@"result"];
                               NSArray *activeArr = result[@"active"];
                               headImgStr = result[@"img"];
                               if (codeStr.intValue==1) {
                                   
                                   for (NSDictionary *dic in activeArr) {
                                       
                                       [self.classifyTitleArr addObject:[dic objectForKey:@"name"]];
                                       [self.classifyIDArr addObject:[dic objectForKey:@"id"]];
                                       
                                   }
                                   [self.headImageView sd_setImageWithURL:JointImgUrl(headImgStr)];
                                   [self.mainTableView reloadData];
                                   
                               }else{
                                   LRToast(responseObject[@"msg"])
                               }
                               
                               
                              
                           } failure:^(NSError *error) {
                               
                               LRToast(@"请求失败，请检查网络")
                               
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
}


#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    
    //离开顶部 主View 可以滑动
    self.canScroll = YES;
}

-(void)scrollViewChangeTab:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    /*
     * 如果已经离开顶端 切换tab parentScrollView的contentOffset 应该初始化位置
     * 这一规则 仿简书
     */
    if (self.canScroll) {
        self.parentScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*
     *  处理联动事件
     */
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= headViewHeight) {
        
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        offsetY = tabOffsetY;
    }
    
    self.isTopIsCanNotMoveParentScrollView = self.isTopIsCanNotMoveMainTableView;
    
    if (offsetY >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.isTopIsCanNotMoveMainTableView = YES;
    }else{
        self.isTopIsCanNotMoveMainTableView = NO;
    }
    
    if (self.isTopIsCanNotMoveMainTableView != self.isTopIsCanNotMoveParentScrollView) {
        if (!self.isTopIsCanNotMoveParentScrollView && self.isTopIsCanNotMoveMainTableView) {
            //滑动到顶端
            self.canScroll = NO;
        }
        
        if(self.isTopIsCanNotMoveParentScrollView && !self.isTopIsCanNotMoveMainTableView){
            //离开顶端
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }else{
                self.parentScrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }else
    {
//        if (!self.canScroll){
//            //支持下刷新,下拉时maintableView 没有滚动到位置 parentScrollView 不进行刷新
//            CGFloat parentScrollViewOffsetY = self.parentScrollView.contentOffset.y;
//            if(parentScrollViewOffsetY >0)
//                self.parentScrollView.contentOffset = CGPointMake(0, 0);
//        }else
//        {
            self.parentScrollView.contentOffset = CGPointMake(0, 0);
//        }
    }
    
    
    /**
     * 处理头部视图
     */
    //    CGFloat yOffset  = scrollView.contentOffset.y;
    //    if(yOffset < -headViewHeight) {
    //
    //        CGRect f = self.headImageView.frame;
    //        f.origin.y= yOffset ;
    //        f.size.height=  -yOffset;
    //        f.origin.y= yOffset;
    //
    //        //改变头部视图的fram
    //        self.headImageView.frame= f;
    //        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+56, 80, 80);
    //        _avatarImage.frame = avatarF;
    //        _countentLabel.frame = CGRectMake((f.size.width-Main_Screen_Width)/2+40, (f.size.height-headViewHeight)+172, Main_Screen_Width-80, 36);
    //    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenH - NAVI_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


#pragma mark -- setter/getter

-(UIView *)setPageViewControllers
{
    WMPageController *pageController = [self p_defaultController];
    pageController.title = @"Line";
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 15;
    pageController.menuBGColor = kWhiteColor;
    pageController.titleColorSelected = kColord40;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (int i = 0; i < self.classifyTitleArr.count; i ++) {
        SecondCatogeryVC * catogeryVC  = [SecondCatogeryVC new];
        catogeryVC.a_id = self.a_id;
        catogeryVC.al_id = self.classifyIDArr[i];
        catogeryVC.delegate = self;
        [viewControllers addObject:catogeryVC];
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:self.classifyTitleArr];
    [pageVC setViewFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT)];
    pageVC.delegate = self;
    pageVC.menuItemWidth = 85;
    pageVC.menuHeight = 44;
    pageVC.postNotification = YES;
    pageVC.bounces = NO;
    return pageVC;
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
}









@end
