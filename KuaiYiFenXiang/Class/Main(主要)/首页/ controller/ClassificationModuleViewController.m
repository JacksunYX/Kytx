//
//  ClassificationModuleViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ClassificationModuleViewController.h"

#import "SubclassModuleViewController.h"

@interface ClassificationModuleViewController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>

@property(nonatomic,strong) NSMutableArray *titlearray;
@property(nonatomic,strong) NSMutableArray *titleidarray;

@end

@implementation ClassificationModuleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    if ([self.categorynameNumString isEqualToString:@"0"]) {
        self.navigationItem.title=@"9.9包邮";
    }else if([self.categorynameNumString isEqualToString:@"1"]){
        self.navigationItem.title=@"高积分";
     }else if([self.categorynameNumString isEqualToString:@"2"]){
        self.navigationItem.title=@"热销榜";
     }else if([self.categorynameNumString isEqualToString:@"3"]){
        self.navigationItem.title=@"新品推荐";
     }else if([self.categorynameNumString isEqualToString:@"4"]){
        
    }
    
    
    
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressBounceView;

    
    self.tabBarOrignY=1;
    
    self.dataSource = self;
    
    self.delegate = self;
    
    if ([self.categorynameNumString isEqualToString:@"categoryzone"]) {
        
        self.tabBar.layout.progressWidth=SCREEN_WIDTH/5;
        self.tabBar.layout.cellWidth=SCREEN_WIDTH/4.5;
        self.tabBar.layout.normalTextFont=[UIFont systemFontOfSize:15];
        self.tabBar.layout.selectedTextFont=[UIFont systemFontOfSize:18];

        [self loadRealData];
    }else{
        [self loadData];
    }
    
}

- (void)loadData {
    
    NSArray * titlearray = @[@"电器",@"家居",@"母婴",@"家纺",@"电器",@"家居",@"母婴",@"家纺",@"电器",@"家居",@"母婴",@"家纺",@"电器",@"家居",@"母婴",@"家纺"];
    
    self.titlearray=[titlearray mutableCopy];
    
    [self reloadData];
    
}
- (void)loadRealData{
    
    
    self.titlearray=[NSMutableArray new];
    self.titleidarray=[NSMutableArray new];
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:self.two_idstring forKey:@"two_id"];
    [dic setObject:@"1" forKey:@"show_type"];

    [HttpRequest postWithURLString:NetRequestUrl(qualityLoveThree) parameters:dic
                      isShowToastd:(BOOL)YES
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSMutableArray *result=[responseObject objectForKey:@"result"];
                               
                                   if (codeStr.intValue==1) {
                                       
                                       for (NSDictionary *dic in result) {
                                           
                                           [self.titlearray addObject:[dic objectForKey:@"name"]];
                                           [self.titleidarray addObject:[dic objectForKey:@"id"]];

                                       }
                                       
                                   }
                               
                               [self reloadData];
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectIndex" object:self.titleidarray[0] userInfo:nil];

                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                           } RefreshAction:^{
                               //执行无网络刷新回调方法
                               
                           }];
    
    

}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return self.titlearray.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
//    smvc.titleid = [@(index) stringValue];
    smvc.titleid = self.titleidarray[index];
    smvc.categorynameNumString=self.categorynameNumString;
    return smvc;

}

- (void)tabPagerControllerDidEndScrolling:(TYTabPagerController *)tabPagerController animate:(BOOL)animate{
    NSLog(@"%ld",(long)tabPagerController.tabBar.curIndex);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectIndex" object:self.titleidarray[tabPagerController.tabBar.curIndex] userInfo:nil];
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
