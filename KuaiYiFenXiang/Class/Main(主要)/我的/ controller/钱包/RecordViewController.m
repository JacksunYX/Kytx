//
//  RecordViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "RecordViewController.h"
#import "KYHeader.h"
#import "RecordListViewController.h"
#import "RecordModel.h"
#import "RecordDetailViewController.h"

@interface RecordViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) HMSegmentedControl *sege;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) RecordListViewController *vc1;
@property (nonatomic, strong) RecordListViewController *vc2;
@property (nonatomic, strong) RecordListViewController *vc3;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值记录";
    
    [self configUI];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
    
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(recordlist) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            NSArray *arr = [RecordModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
            NSMutableArray *arr1 = [NSMutableArray array];
            NSMutableArray *arr2 = [NSMutableArray array];
            NSMutableArray *arr3 = [NSMutableArray array];
            for (RecordModel *model in arr) {
//                NSLog(@"%ld", model.status);
                if (model.status == 0) {
                    [arr1 addObject:model];
                } else if (model.status == 1) {
                    [arr2 addObject:model];
                } else {
                    [arr3 addObject:model];
                }
            }
            self.vc1.dataArray = arr1.copy;
            self.vc2.dataArray = arr2.copy;
            self.vc3.dataArray = arr3.copy;
            
            if (self.vc1.dataArray.count == 0) {
                
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无记录666"]];
                [self.vc1.table addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.vc1.table);
                    make.size.mas_equalTo(CGSizeMake(ScaleWidth(170), ScaleWidth(162.5)));
                }];
            }
            
            if (self.vc2.dataArray.count == 0) {
                
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无记录666"]];
                [self.vc2.table addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.vc2.table);
                    make.size.mas_equalTo(CGSizeMake(ScaleWidth(170), ScaleWidth(162.5)));
                }];
            }
            
            if (self.vc3.dataArray.count == 0) {
                
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无记录666"]];
                [self.vc3.table addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.vc3.table);
                    make.size.mas_equalTo(CGSizeMake(ScaleWidth(170), ScaleWidth(162.5)));
                }];
            }
            
            [self.vc1 filterArray];
            [self.vc2 filterArray];
            [self.vc3 filterArray];
            
            [self.vc1.table reloadData];
            [self.vc2.table reloadData];
            [self.vc3.table reloadData];
        }
        
    } failure:nil RefreshAction:nil];
}

- (void)configUI {
    
    self.view.backgroundColor = kDefaultBGColor;
    self.sege = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"审核中", @"审核通过", @"审核不通过"]];
    self.sege.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    self.sege.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.sege.backgroundColor = kWhiteColor;
    self.sege.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:ScaleWidth(15)]};
    self.sege.selectionIndicatorHeight = 2;
    self.sege.selectionIndicatorColor = [UIColor colorWithHexString:@"d40000"];
    self.sege.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"d40000"]};
    [self.view addSubview:self.sege];
    
    [self.sege addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45 , SCREEN_WIDTH, SCREEN_HEIGHT - 45 - NAVI_HEIGHT)];
    _scroll.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT - 45 - NAVI_HEIGHT);
    _scroll.backgroundColor = [UIColor colorWithHexString:@"fefefe"];
    _scroll.pagingEnabled = YES;
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    
    for (int i = 0; i <3; i++) {
        
        RecordListViewController *vc = [RecordListViewController new];
        vc.view.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-45);
        __weak typeof(self) weakself = self;
        vc.pushHander = ^(RecordModel *model) {
            RecordDetailViewController *vc = [RecordDetailViewController new];
            vc.record_id = model.record_id;
            vc.type = model.status;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        [_scroll addSubview:vc.view];
        if (i == 0) {
            self.vc1 = vc;
        } else if (i == 1) {
            self.vc2 = vc;
        } else {
            self.vc3 = vc;
        }
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    if (index == 0) {
        [self.scroll scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
    } else if (index == 1) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
    } else if (index == 2) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == SCREEN_WIDTH * 2) {
        [self.sege setSelectedSegmentIndex:2 animated:YES];
    } else if (scrollView.contentOffset.x == SCREEN_WIDTH) {
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
