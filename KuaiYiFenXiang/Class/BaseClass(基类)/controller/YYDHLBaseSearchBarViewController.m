//
//  YYDHLBaseViewController.m
//  ProvideHelper
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDHLBaseSearchBarViewController.h"
//搜索商品结果
#import "SearchResultsViewController.h"


@interface YYDHLBaseSearchBarViewController ()<UITextFieldDelegate,PYSearchViewControllerDelegate>

@end

@implementation YYDHLBaseSearchBarViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[HttpRequest getCurrentVC].view hideBlankPageView];
    [[HttpRequest getCurrentVC].view hideErrorPageView];
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置根控制器的属性
    self.view.backgroundColor = BACKVIEWCOLOR;
    self.navigationController.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBarHidden = NO;
    
    //设置视图布局属性 设置之后视图会按自己设置的布局进行相应布局
    self.edgesForExtendedLayout = UIRectEdgeLeft;// 推荐使用
    
    //设置navigationBar的中间为searchBar
    self.navigationsearchbar=[[YYFSearchBar alloc] init];
    self.navigationsearchbar.delegate=self;
    self.navigationItem.titleView = self.navigationsearchbar;
    
    
}

//给视图添加点击手势 在点击视图时隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //隐藏所有的键盘
    [self.view endEditing:YES];
    
    //隐藏所有键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self initAndJumpSearchViewController];
    
}

-(void)initAndJumpSearchViewController{
    
    // 1. Create an Array of popular search   设置建议用户的搜索标签
    NSArray *hotSeaches = @[
                            @"纸巾",
                            @"零食",
                            @"吹风机",
                            @"电饭锅",
                            @"电风扇",
                            @"家用摄像头",
                            @"抱枕靠垫",
                            @"床品四件套",
                            @"遮阳帽",
                            @"休闲鞋",
                            ];
    
    // 2. Create a search view controller  创建搜索控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索商品", @"搜索商品") andsearchHeadViewHidden:(NSString *)@"NO" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText,NSString *searchtypes,NSString * VagueOrSpecific) {
        
        // Called when search begain.
        // eg：Push to a temp view controller
        
        //开始搜索之后的回调方法 实际开发过程中将搜索的关键词传递到下一个页面进行搜索 然后设置页面
        NSLog(@"开始搜索-%@-----%@-----%@-----%@-----%@",searchViewController,searchBar,searchText,searchtypes,VagueOrSpecific);
        
        SearchResultsViewController *sfprvc=[[SearchResultsViewController alloc]init];
        sfprvc.searchtypes = searchtypes;
        sfprvc.goodsname = searchText;
        //        sfprvc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemBottomWithTarget:self Action:@selector(backClick) image:@"BACK" hightimage:@"BACK" andTitle:@""];
        if (kStringIsEmpty(searchText)) {
            LRToast(@"请输入要搜索的内容");
        }else{
            sfprvc.searchTextString = searchText;
//            [searchViewController.navigationController  pushViewController:sfprvc animated:NO];
            //使用以下2句话替换，直接在当前搜索页面展示搜索结果
//            searchViewController.showSearchResultWhenSearchBarRefocused = YES;
//            searchViewController.showSearchResultWhenSearchTextChanged = YES;
            searchViewController.searchResultShowMode = PYSearchResultShowModePush;
            searchViewController.searchResultController = sfprvc;
        }
        
        //        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
        //            if ([VagueOrSpecific isEqualToString:@"isSearchButtonClick"]) {
        //
        //            SearchResultsViewController    *sfprvc=[[SearchResultsViewController alloc]init];
        //            sfprvc.searchtypes=searchtypes;
        //            sfprvc.goodsname=searchText;
        //            [self.navigationController  pushViewController:sfprvc animated:YES];
        //
        //            }else if ([VagueOrSpecific isEqualToString:@"isSearchCellClick"]){
        //
        //                if ([searchtypes isEqualToString:@"商品"]) {
        //
        //                    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
        //
        //                    //    Apple iPhone SE 玫瑰金 16G 4G 手机（全网通）-----2588-----采用IOS 10 系统，配置A9芯片，更高速-----(
        //                    //                                                                                "http://gfs14.gomein.net.cn/T12TCTByWQ1RCvBVdK_800.jpg",
        //                    //                                                                                "http://gfs14.gomein.net.cn/T1PwKTB5_g1RCvBVdK_800.jpg",
        //                    //                                                                                "http://gfs13.gomein.net.cn/T1ES_TBTAg1RCvBVdK_800.jpg"
        //                    //                                                                                )-----http://gfs17.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_360.jpg
        //
        //                    dcgdvc.goodTitle = @"Apple iPhone SE 玫瑰金 16G 4G 手机（全网通）";
        //                    dcgdvc.goodPrice = @"2588";
        //                    dcgdvc.goodSubtitle = @"采用IOS 10 系统，配置A9芯片，更高速";
        //                    dcgdvc.shufflingArray = @[@"http://gfs14.gomein.net.cn/T12TCTByWQ1RCvBVdK_800.jpg",
        //                                              @"http://gfs14.gomein.net.cn/T1PwKTB5_g1RCvBVdK_800.jpg",
        //                                              @"http://gfs13.gomein.net.cn/T1ES_TBTAg1RCvBVdK_800.jpg"];
        //                    dcgdvc.goodImageView = @"http://gfs17.gomein.net.cn/T1WkxTB7Dv1RCvBVdK_360.jpg";
        //                    [self.navigationController pushViewController:dcgdvc animated:YES];
        //
        //
        //                }else if ([searchtypes isEqualToString:@"店铺"]){
        //
        //                    StoreDisplayViewController *sdvc=[[StoreDisplayViewController alloc]init];
        //                    [self.navigationController pushViewController:sdvc animated:YES];
        //
        //                }else{
        //
        //
        //                }
        //
        //            }
        //
        //        }];
        
        
        
    }];
    
    //设置上一次搜索的数据
    [searchViewController.searchBar setText:self.navigationsearchbar.text];
    searchViewController.searchBarBackgroundColor = hwcolor(235, 235, 235);
    //设置搜索视图的样式属性
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoriesCount = 10;
    
    // 4. Set delegate  设置搜索控制器的代理
    searchViewController.delegate = self;
    
    // 5. Present a navigation controller  点击搜索框之后跳转到搜索页面
//    YYFNavigationController *nav = [[YYFNavigationController alloc] initWithRootViewController:searchViewController];
    
//    [self presentViewController:nav animated:NO completion:nil];
    
    [self.navigationController pushViewController:searchViewController animated:NO];
}



#pragma mark - PYSearchViewControllerDelegate  设置搜索历史记录
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText searchType:(NSString *)searchType
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            //            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
            //                NSString *searchSuggestion = [NSString stringWithFormat:@"%@ Search suggestion %d",searchType,i];
            //                [searchSuggestionsM addObject:searchSuggestion];
            //            }
            //            // Refresh and display the search suggustions
            //            searchViewController.searchSuggestions = searchSuggestionsM;
            
            // 设置请求参数可变数组
            NSMutableDictionary *dic = [NSMutableDictionary new];
            
            [dic setObject:searchText forKey:@"name"];
            
            if ([searchType isEqualToString:@"商品"]) {
                [dic setObject:@"1" forKey:@"type"];
            } else if ([searchType isEqualToString:@"店铺"]){
                [dic setObject:@"2" forKey:@"type"];
            }
            
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            
            [HttpRequest postWithURLString:NetRequestUrl(likeGoods) parameters:dic
                              isShowToastd:(BOOL)NO
                                 isShowHud:(BOOL)NO
                          isShowBlankPages:(BOOL)NO
                                   success:^(id responseObject)  {
                                       
                                       NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                       NSMutableArray *result=[responseObject objectForKey:@"result"];
                                       
                                       if (codeStr.intValue==1) {
                                           
                                           if (!kArrayIsEmpty(result)) {
                                               
                                               for (NSDictionary * dic in result) {
                                                   
                                                   [searchSuggestionsM addObject:[dic objectForKey:@"name"]];
                                                   
                                               }
                                               
                                           }
                                           
                                           searchViewController.searchSuggestions = searchSuggestionsM;
                                           
                                       }
                                       
                                       
                                   } failure:^(NSError *error) {
                                       //打印网络请求错误
                                       NSLog(@"%@",error);
                                       
                                   } RefreshAction:^{
                                       //执行无网络刷新回调方法
                                       
                                   }];
            
        });
    }
}

@end
