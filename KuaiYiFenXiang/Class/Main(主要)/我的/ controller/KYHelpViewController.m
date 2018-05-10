//
//  KYHelpViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYHelpViewController.h"
#import "KYHeader.h"
#import <WebKit/WebKit.h>

@interface KYHelpViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) HMSegmentedControl *sege;
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) UIWebView *web1;
@property (nonatomic, strong) UIWebView *web2;

@end

@implementation KYHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
    
}

- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 , SCREEN_WIDTH, SCREEN_HEIGHT - 44 - NAVI_HEIGHT)];
    _scroll.contentSize = CGSizeMake(2*SCREEN_WIDTH, SCREEN_HEIGHT - 44- NAVI_HEIGHT);
    _scroll.backgroundColor = [UIColor colorWithHexString:@"fefefe"];
    _scroll.pagingEnabled = YES;
//            _scroll.backgroundColor = [UIColor greenColor];
//    _scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    _scroll.delegate = self;
    
    for (int i = 0; i <2; i++) {
        UIWebView *a = [[UIWebView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-44)];
        if (i == 0) {
            
            NSString *str = [FormalDomain stringByAppendingString:helpInfo_url];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"?type=%d", i+1]];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
            [a loadRequest:request];
        }
        [_scroll addSubview:a];
        if (i == 0) {
            self.web1 = a;
        }else if (i == 1) {
            self.web2 = a;
        }
    }
    self.sege = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"会员篇", @"VIP篇"]];
    self.sege.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.sege.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.sege.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    self.sege.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:ScaleWidth(15)]};
    self.sege.selectionIndicatorHeight = 2;
    self.sege.selectionIndicatorColor = [UIColor colorWithHexString:@"d40000"];
    self.sege.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"d40000"]};
    [self.view addSubview:self.sege];
    
    [self.sege addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index = segmentedControl.selectedSegmentIndex;
    
    NSString *str = [FormalDomain stringByAppendingString:helpInfo_url];
    
    
    if (index == 0) {
        [self.scroll scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
            str = [str stringByAppendingString:@"?type=1"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [self.web1 loadRequest:request];
    } else if (index == 1) {
        [self.scroll scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) animated:YES];
        str = [str stringByAppendingString:@"?type=2"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [self.web2 loadRequest:request];

    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSString *str = [FormalDomain stringByAppendingString:helpInfo_url];
    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [self.sege setSelectedSegmentIndex:1 animated:YES];
        str = [str stringByAppendingString:@"?type=2"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [self.web2 loadRequest:request];

    } else {
        [self.sege setSelectedSegmentIndex:0 animated:YES];
        str = [str stringByAppendingString:@"?type=1"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [self.web1 loadRequest:request];

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
