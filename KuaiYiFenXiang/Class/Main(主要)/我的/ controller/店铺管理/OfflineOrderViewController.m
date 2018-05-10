//
//  OfflineOrderViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OfflineOrderViewController.h"
#import "HMSegmentedControl.h"
#import "OfflineOrderListViewController.h"

@interface OfflineOrderViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) HMSegmentedControl *sege;
@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation OfflineOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"线下订单";
    [self configUI];
}


- (void)configUI {
    self.sege = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"商家代付款", @"用户付款"]];
    
    self.sege.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
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
    
//    if (@available(iOS 11.0, *)) {
//        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45 , SCREEN_WIDTH, SCREEN_HEIGHT - 45 - NAVI_HEIGHT)];
    _scroll.contentSize = CGSizeMake(2*SCREEN_WIDTH, SCREEN_HEIGHT - 45 - NAVI_HEIGHT);
    _scroll.backgroundColor = kDefaultBGColor;
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    
    for (int i = 0; i <2; i++) {
        OfflineOrderListViewController *vc = [OfflineOrderListViewController new];
        vc.type = i+1;
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 45);
        [_scroll addSubview:vc.view];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        [self.scroll scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
    } else if (index == 1) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self.sege setSelectedSegmentIndex:1 animated:YES];
    } else {
        [self.sege setSelectedSegmentIndex:0 animated:YES];
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
