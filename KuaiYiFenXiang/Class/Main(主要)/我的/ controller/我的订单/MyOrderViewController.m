//
//  MyOrderViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MyOrderViewController.h"
#import "KYHeader.h"
#import "MyOrderListViewController.h"
#import "OrderListModel.h"
#import "MyOfflineOrderViewController.h"
#import "MyViewController.h"
#import "UIBarButtonItem+XYMenu.h"

@interface MyOrderViewController () <UIScrollViewDelegate,ZFDropDownDelegate>
@property(strong, nonatomic)HMSegmentedControl *sege;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) ZFDropDown * dropDown;
@property (nonatomic, strong) ZFTapGestureRecognizer * tap;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"我的订单";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"BACK" hightimage:@"BACK" andTitle:@""];

    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(more) image:@"myorder_more" hightimage:@"myorder_more" andTitle:@""];
    
    
    [self configUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [XYMenu dismissMenuInView:self.view];
}

- (void)configUI {
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 , SCREEN_WIDTH, SCREEN_HEIGHT - 44 - NAVI_HEIGHT)];
    _scroll.contentSize = CGSizeMake(5*SCREEN_WIDTH, SCREEN_HEIGHT - 44- NAVI_HEIGHT);
    if (@available(iOS 11.0, *)) {
        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _scroll.backgroundColor = [UIColor colorWithHexString:@"fefefe"];
    _scroll.pagingEnabled = YES;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    
    for (int i = 0; i <5; i++) {
        MyOrderListViewController *vc = [[MyOrderListViewController alloc] init];
        vc.index = i;
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 44);
        [_scroll addSubview:vc.view];
        //        vc.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            vc.page = 0;
        //            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        ////            if (i != 0) {
        //                dict[@"type"] = @(i).description;
        ////            }
        //            [HttpRequest postWithTokenURLString:NetRequestUrl(ordergoods) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        ////                NSLog(@"%@", res);
        //                if ([vc.table.mj_header isRefreshing]) {
        //                    [vc.table.mj_header endRefreshing];
        //                }
        //                vc.dataArray = [OrderListModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
        //                [vc.table reloadData];
        //            } failure:nil RefreshAction:nil];
        //        }];
        
        
        
        //        [vc.table.mj_header beginRefreshing];
    }
    
    self.sege = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"待付款", @"待发货", @"待收货", @"已完成"]];
    self.sege.frame = CGRectMake(0, 0,  SCREEN_WIDTH, 44);
    self.sege.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.sege.backgroundColor = kWhiteColor;
    self.sege.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:ScaleWidth(15)]};
    self.sege.selectionIndicatorHeight = 2;
    self.sege.selectionIndicatorColor = [UIColor colorWithHexString:@"d40000"];
    self.sege.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"d40000"]};
    if (self.index) {
        [self.sege setSelectedSegmentIndex:self.index animated:YES];
        [self.scroll scrollRectToVisible:CGRectMake((self.index) * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
        
    }
    [self.view addSubview:self.sege];
    
    [self.sege addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc" alpha:0.5];
    [self.view addSubview:line];
    line.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(1)
    .topSpaceToView(self.sege, -1)
    ;
    
    CGFloat width = 120;
    CGFloat height = 0;
    CGFloat xPos =  SCREEN_WIDTH - width - 20;
    CGFloat yPos = 0;
    self.dropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(xPos, yPos, width, height) pattern:kDropDownPatternCustom];
    self.dropDown.delegate = self;
    self.dropDown.cornerRadius=5.0;
    self.dropDown.borderStyle = kDropDownTopicBorderStyleNone;
    [self.view addSubview:self.dropDown];
//    self.tap = [[ZFTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.view addGestureRecognizer:self.tap];
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        [self.scroll scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
    } else if (index == 1) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44-NAVI_HEIGHT) animated:YES];
    } else if (index == 2) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44-NAVI_HEIGHT) animated:YES];
    } else if (index == 3) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44-NAVI_HEIGHT) animated:YES];
    } else if (index == 4) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44-NAVI_HEIGHT) animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == 0) {
        [self.sege setSelectedSegmentIndex:0 animated:YES];
    } else if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self.sege setSelectedSegmentIndex:1 animated:YES];
    } else if (scrollView.contentOffset.x == SCREEN_WIDTH*2) {
        [self.sege setSelectedSegmentIndex:2 animated:YES];
    } else if (scrollView.contentOffset.x == SCREEN_WIDTH*3) {
        [self.sege setSelectedSegmentIndex:3 animated:YES];
    } else if (scrollView.contentOffset.x == SCREEN_WIDTH*4) {
        [self.sege setSelectedSegmentIndex:4 animated:YES];
    }
}

-(void)more{
//    [self.dropDown show];
    
    NSArray *imgs = @[
                      @"myorder_xianxia",
                      @"myorder_home"
                      ];
    NSArray *titles = @[
                        @"线下订单",
                        @"首    页"
                        ];
    [XYMenu showMenuWithImages:imgs titles:titles menuType:XYMenuRightNavBar currentNavVC:self.navigationController withItemClickIndex:^(NSInteger index) {
        if (index == 1) {
            MyOfflineOrderViewController *moovc=[[MyOfflineOrderViewController alloc]init];
            [self.navigationController pushViewController:moovc animated:YES];
        } else {
            YYFTabBarViewController *tab = [[YYFTabBarViewController alloc]init];
            tab.selectedIndex = 0;
            self.view.window.rootViewController= tab;
        }
    }];
}

/**
 *  self.view添加手势取消dropDown第一响应
 */
- (void)tapAction{
    [self.dropDown resignDropDownResponder];
}
#pragma mark - ZFDropDownDelegate
- (CGFloat)dropDown:(ZFDropDown *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
    return @[@"",@""];
}
- (UITableViewCell *)dropDown:(ZFDropDown *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = @"UITableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    [cell.textLabel setFont:PFR12Font];
    if (indexPath.row==0) {
        cell.imageView.image=[UIImage imageNamed:@"myorder_xianxia"];
        cell.textLabel.text = @"线下订单";
        cell.backgroundColor = [UIColor whiteColor];
    }else if (indexPath.row==1) {
        cell.imageView.image=[UIImage imageNamed:@"myorder_home"];
        cell.textLabel.text = @"首页";
        cell.backgroundColor= [UIColor whiteColor];
    }else{
        
    }
    return cell;
}


- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        MyOfflineOrderViewController *moovc=[[MyOfflineOrderViewController alloc]init];
        [self.navigationController pushViewController:moovc animated:YES];
    } else {
        YYFTabBarViewController *tab = [[YYFTabBarViewController alloc]init];
        tab.selectedIndex = 0;
        self.view.window.rootViewController= tab;
    }
}
- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count{
    return  2;
}

- (void)back{
    
    BOOL goback = YES;
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            goback = NO;
        }
    }
    
    if (goback) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
