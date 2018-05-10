//
//  OnlineOrderViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OnlineOrderViewController.h"
#import "OnlineOrderListViewController.h"
#import "OrderListModel.h"

@interface OnlineOrderViewController () <UIScrollViewDelegate>
@property(strong, nonatomic)HMSegmentedControl *sege;
@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation OnlineOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"线上订单";
    
    [self configUI];
}

- (void)configUI {
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 , SCREEN_WIDTH, SCREEN_HEIGHT - 44 - NAVI_HEIGHT)];
    _scroll.contentSize = CGSizeMake(6*SCREEN_WIDTH, SCREEN_HEIGHT - 44- NAVI_HEIGHT);
    _scroll.backgroundColor = [UIColor colorWithHexString:@"fefefe"];
    if (@available(iOS 11.0, *)) {
        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _scroll.pagingEnabled = YES;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    
    for (int i = 0; i <6; i++) {
        
        OnlineOrderListViewController *vc = [[OnlineOrderListViewController alloc] init];
        vc.index = i;
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 44);
        [self addChildViewController:vc];
        
        [_scroll addSubview:vc.view];
    }
    
    self.sege = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"待付款", @"待发货", @"待收货", @"已完成",@"退款售后"]];
    self.sege.frame = CGRectMake(0, 0,  SCREEN_WIDTH, 44);
    self.sege.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.sege.backgroundColor = kWhiteColor;
    self.sege.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:ScaleWidth(15)]};
    self.sege.selectionIndicatorHeight = 2;
    self.sege.selectionIndicatorColor = [UIColor colorWithHexString:@"d40000"];
    self.sege.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"d40000"]};
   
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
    } else if (index == 5) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH*5, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44-NAVI_HEIGHT) animated:YES];
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
    } else if (scrollView.contentOffset.x == SCREEN_WIDTH*5) {
        [self.sege setSelectedSegmentIndex:5 animated:YES];
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
