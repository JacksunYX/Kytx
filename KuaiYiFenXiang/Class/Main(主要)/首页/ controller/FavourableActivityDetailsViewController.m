//
//  ClassificationModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "FavourableActivityDetailsViewController.h"

#import "FavourableActivityDetailsSubViewController.h"

@interface FavourableActivityDetailsViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>

@property(nonatomic,strong) NSArray *titlearray;

@end

@implementation FavourableActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"新年大钜惠";
    
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    
    self.tabBarOrignY=1;
    
    self.dataSource = self;
    
    self.delegate = self;
    
    
    [self loadData];
    
    
}

- (void)loadData {
    
 self.titlearray=@[@"0:00",@"10:00",@"14:00",@"24:00",@"0:00",@"10:00",@"14:00",@"24:00"];
    
    [self reloadData];
    
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return self.titlearray.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    FavourableActivityDetailsSubViewController *fadsvc = [[FavourableActivityDetailsSubViewController alloc]init];
    fadsvc.titleid = [@(index) stringValue];
    return fadsvc;
    
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = self.titlearray[index];
    return title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
