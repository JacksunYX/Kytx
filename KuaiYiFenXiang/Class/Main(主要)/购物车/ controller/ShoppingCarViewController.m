
//
//  ShoppingCarViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "JVShopcartTableViewProxy.h"
#import "JVShopcartBottomView.h"
#import "JVShopcartCell.h"
#import "JVShopcartHeaderView.h"
#import "DCEmptyCartView.h"
#import "JVShopcartFooterView.h"
#import "JVShopcartFormat.h"
#import "Masonry.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JVShopcartBrandModel.h"
#import "MakeSureTheOrderViewController.h"
#import "CollectionGoodsViewController.h"

@interface ShoppingCarViewController ()<JVShopcartFormatDelegate>

@property (nonatomic, strong) UITableView *shopcartTableView;   /**< 购物车列表 */
@property (nonatomic, strong) JVShopcartBottomView *shopcartBottomView;    /**< 购物车底部视图 */
@property (nonatomic, strong) JVShopcartTableViewProxy *shopcartTableViewProxy;    /**< tableView代理 */
@property (nonatomic, strong) JVShopcartFormat *shopcartFormat;    /**< 负责购物车逻辑处理 */
@property (nonatomic, strong) UIButton *editButton;    /**< 编辑按钮 */

/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;

@end

@implementation ShoppingCarViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    YYFNavigationController *Navi = (YYFNavigationController *)self.navigationController;
//    [Navi showNavigationDownLine];
    
    [self requestShopcartListData];
    [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:0 totalCount:0 isAllselected:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
//    YYFNavigationController *Navi = (YYFNavigationController *)self.navigationController;
//    [Navi hideNavigationDownLine];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationDownLine];
    //    [self addSubview];
    //    [self layoutSubview];
    
}

-(void)addNavigationDownLine
{
    UIView *line = [UIView new];
    line.backgroundColor = kWhite(0.8);
    [self.view addSubview:line];
    line.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(0)
    .heightIs(0.5)
    ;
}

#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;

    _backTopButton.sd_layout
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.shopcartBottomView, 30)
    .widthIs(40)
    .heightEqualToWidth()
    ;
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    if (self.shopcartTableView.contentOffset.y > ScreenH) {
        [self.shopcartTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }else{
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.shopcartTableView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.shopcartTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }];
    }
}

- (void)requestShopcartListData {
    [self.shopcartFormat requestShopcartProductList];
}

#pragma mark JVShopcartFormatDelegate
//这是请求购物车列表成功之后的回调方法，将装有Model的数组回调到控制器；控制器将其赋给TableView的代理类JVShopcartTableViewProxy并刷新TableView。
- (void)shopcartFormatRequestProductListDidSuccessWithArray:(NSMutableArray *)dataArray {
    if ([self.shopcartTableView.mj_header isRefreshing]) {
        [self.shopcartTableView.mj_header endRefreshing];
    }
    !kArrayIsEmpty(dataArray)?[self.shopcartBottomView setHidden:NO]:[self.shopcartBottomView setHidden:YES];
    !kArrayIsEmpty(dataArray)?[self.editButton setHidden:NO]:[self.editButton setHidden:YES];
    self.shopcartTableViewProxy.dataArray = dataArray;
    [self addSubview];
    [self layoutSubview];
    [self.shopcartTableView reloadData];
    int i = 0;
    for (JVShopcartBrandModel *model in dataArray) {
        for (JVShopcartProductModel *productModel in model.products) {
            i += productModel.productQty;
        }
    }
    
    [self.tabBarController.tabBar.items[3] setBadgeValue:@(i).description];
}
//这是用户在操作了单选、多选、全选、删除这些会改变底部结算视图里边的全选按钮状态、商品总价和商品数的统一回调方法，这条API会将用户操作之后的结果，也就是是否全选、商品总价和和商品总数回调给JVShopcartViewController， 控制器拿着这些数据调用底部结算视图BottomView的configure方法并刷新TableView，就完成了UI更新。
- (void)shopcartFormatAccountForTotalPrice:(float)totalPrice totalCount:(NSInteger)totalCount isAllSelected:(BOOL)isAllSelected {
    [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:totalPrice totalCount:totalCount isAllselected:isAllSelected];
    [self.shopcartTableView reloadData];
}
//这是用户点击结算按钮的回调方法，这条API会将剔除了未选中ProductModel的模型数组回调给JVShopcartViewController，但并不改变原数据源因为用户随时可能返回。
- (void)shopcartFormatSettleForSelectedProducts:(NSArray *)selectedProducts {
    
    NSLog(@"结算------%@",selectedProducts);
    [self settlementgoods:selectedProducts];
    
}

//这是用户删除了购物车所有数据之后的回调方法，你可能会做些视图的隐藏或者提示。
- (void)shopcartFormatWillDeleteSelectedProducts:(NSArray *)selectedProducts {
    
    NSLog(@"删除------%@",selectedProducts);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认要删除这%ld个宝贝吗？", selectedProducts.count] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletecartgoods:[selectedProducts mutableCopy]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//这是用户删除了购物车所有数据之后的回调方法，你可能会做些视图的隐藏或者提示。
- (void)shopcartFormatWillCollectSelectedProducts:(NSArray *)selectedProducts {
    
    NSLog(@"收藏------%@",selectedProducts);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认要收藏这%ld个宝贝吗？", selectedProducts.count] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self collectcartgoods:[selectedProducts mutableCopy]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)shopcartFormatHasDeleteAllProducts {
    
}

#pragma mark getters
- (UITableView *)shopcartTableView {
    if (_shopcartTableView == nil){
        _shopcartTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _shopcartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_shopcartTableView registerClass:[JVShopcartCell class] forCellReuseIdentifier:@"JVShopcartCell"];
        [_shopcartTableView registerClass:[JVShopcartHeaderView class] forHeaderFooterViewReuseIdentifier:@"JVShopcartHeaderView"];
        [_shopcartTableView registerClass:[DCEmptyCartView class] forHeaderFooterViewReuseIdentifier:@"DCEmptyCartView"];
        [_shopcartTableView registerClass:[JVShopcartFooterView class] forHeaderFooterViewReuseIdentifier:@"JVShopcartFooterView"];
        _shopcartTableView.showsVerticalScrollIndicator = NO;
        _shopcartTableView.delegate = self.shopcartTableViewProxy;
        _shopcartTableView.dataSource = self.shopcartTableViewProxy;
        _shopcartTableView.rowHeight = 120;
        _shopcartTableView.sectionFooterHeight = 10;
        _shopcartTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shopcartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shopcartTableView.estimatedSectionHeaderHeight = 0;
        _shopcartTableView.estimatedSectionFooterHeight = 0;
        _shopcartTableView.estimatedRowHeight = 0;
        
        MCWeakSelf
        _shopcartTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestShopcartListData];;
        }];
        _shopcartTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshShoppingCartNewCommendGoodNotify object:nil];
            
        }];
        
        
    }
    return _shopcartTableView;
}

- (JVShopcartTableViewProxy *)shopcartTableViewProxy {
    if (_shopcartTableViewProxy == nil){
        _shopcartTableViewProxy = [[JVShopcartTableViewProxy alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartTableViewProxy.shopcartProxyProductSelectBlock = ^(BOOL isSelected, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat selectProductAtIndexPath:indexPath isSelected:isSelected];
        };
        
        //刷新首部
        _shopcartTableViewProxy.shopcartProxyTopRefreshBlock = ^{
            [weakSelf.shopcartTableView reloadData];
        };
        //刷新尾部
        _shopcartTableViewProxy.shopcartProxyBottomRefreshBlock = ^(BOOL finishLoad){
            
            if (finishLoad) {
                [weakSelf.shopcartTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
               [weakSelf.shopcartTableView.mj_footer endRefreshing];
            }
            [weakSelf.shopcartTableView reloadData];
        };
        
        _shopcartTableViewProxy.shopcartProxyBrandSelectBlock = ^(BOOL isSelected, NSInteger section){
            [weakSelf.shopcartFormat selectBrandAtSection:section isSelected:isSelected];
        };
        
        _shopcartTableViewProxy.shopcartProxyChangeCountBlock = ^(NSInteger count, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat changeCountAtIndexPath:indexPath count:count];
        };
        
        _shopcartTableViewProxy.shopcartProxyDeleteBlock = ^(NSIndexPath *indexPath,JVShopcartProductModel *model){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要删除这个宝贝吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                [weakSelf.shopcartFormat deleteProductAtIndexPath:indexPath];
                NSMutableArray *selectedProducts=[NSMutableArray new];
                [selectedProducts addObject:model];
                [weakSelf deletecartgoods:selectedProducts];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        
        _shopcartTableViewProxy.shopcartProxyStarBlock = ^(NSIndexPath *indexPath,JVShopcartProductModel *model){
            [weakSelf.shopcartFormat starProductAtIndexPath:indexPath];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要收藏这个宝贝吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {            NSMutableArray *selectedProducts=[NSMutableArray new];
                [selectedProducts addObject:model];
                [weakSelf collectcartgoods:selectedProducts];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        
        _shopcartTableViewProxy.didSelectedJVShopcartTableViewProxy = ^(NSString *goodidstring) {
            DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
            dcgdvc.goods_id=goodidstring;
            [weakSelf.navigationController pushViewController:dcgdvc animated:YES];
        };
        
        _shopcartTableViewProxy.didSelectedBlankPageButton = ^(NSString *buttonText) {
            
            if ([buttonText isEqualToString:@"点击了逛一逛"]) {
                SubclassModuleViewController *smvc=[[SubclassModuleViewController alloc]init];
                smvc.categorynameNumString=@"0";
                [weakSelf.navigationController pushViewController:smvc animated:YES];
            }else if ([buttonText isEqualToString:@"点击了我的收藏"]){
                CollectionGoodsViewController *cgvc = [CollectionGoodsViewController new];
                [weakSelf.navigationController pushViewController:cgvc animated:YES];
            }
            
        };
        //商品点击回调
        _shopcartTableViewProxy.didSelectedRowBlock = ^(JVShopcartProductModel *model) {
            DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
            dcgdvc.goods_id=model.productId;
            [weakSelf.navigationController pushViewController:dcgdvc animated:YES];
        };
        
        //滚动时回调
        _shopcartTableViewProxy.scrollViewDidScrolledBlock = ^(UIScrollView *scrollView) {
//            NSLog(@"滑动了");
            //判断回到顶部按钮是否隐藏
            weakSelf.backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;
        };
        
    }
    
    return _shopcartTableViewProxy;
}

- (JVShopcartBottomView *)shopcartBottomView {
    if (_shopcartBottomView == nil){
        _shopcartBottomView = [[JVShopcartBottomView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _shopcartBottomView.shopcartBotttomViewAllSelectBlock = ^(BOOL isSelected){
            [weakSelf.shopcartFormat selectAllProductWithStatus:isSelected];
        };
        
        _shopcartBottomView.shopcartBotttomViewSettleBlock = ^(){
            [weakSelf.shopcartFormat settleSelectedProducts];
        };
        
        _shopcartBottomView.shopcartBotttomViewStarBlock = ^(){
            [weakSelf.shopcartFormat starSelectedProducts];
        };
        
        _shopcartBottomView.shopcartBotttomViewDeleteBlock = ^(){
            [weakSelf.shopcartFormat beginToDeleteSelectedProducts];
        };
    }
    return _shopcartBottomView;
}

- (JVShopcartFormat *)shopcartFormat {
    if (_shopcartFormat == nil){
        _shopcartFormat = [[JVShopcartFormat alloc] init];
        _shopcartFormat.delegate = self;
    }
    return _shopcartFormat;
}

- (UIButton *)editButton {
    if (_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(0, 0, 40, 40);
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (void)editButtonAction {
    self.editButton.selected = !self.editButton.isSelected;
    [self.shopcartBottomView changeShopcartBottomViewWithStatus:self.editButton.isSelected];
}

- (void)addSubview {
    if (kArrayIsEmpty(self.shopcartTableViewProxy.dataArray)) {
        
    }else{
        UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
        self.navigationItem.rightBarButtonItem = editBarButtonItem;
    }
    
    [self.view addSubview:self.shopcartTableView];
    
    [self.view addSubview:self.shopcartBottomView];
    
    [self setUpSuspendView];
    
}

- (void)layoutSubview {
    
    
    if (kArrayIsEmpty(self.shopcartTableViewProxy.dataArray)) {
        
        if ([self.SuperiorControllerString isEqualToString:@"DCGoodDetailViewController"]) {
            
            self.shopcartTableView.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 0.5)
            .heightIs(SCREEN_HEIGHT - NAVI_HEIGHT)
            .widthIs(SCREEN_WIDTH);
            
        }else{
            
            self.shopcartTableView.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 0.5)
            .heightIs(SCREEN_HEIGHT-NAVI_HEIGHT-NAVIGATION_TAB_HEIGHT)
            .widthIs(SCREEN_WIDTH);
            
        }
        
    }else{
        
        if ([self.SuperiorControllerString isEqualToString:@"DCGoodDetailViewController"]) {
            
            self.shopcartTableView.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 0.5)
            .heightIs(SCREEN_HEIGHT-NAVI_HEIGHT-50)
            .widthIs(SCREEN_WIDTH);
            
        }else{
            
            self.shopcartTableView.sd_layout
            .centerXEqualToView(self.view)
            .topSpaceToView(self.view, 0.5)
            .heightIs(SCREEN_HEIGHT-NAVI_HEIGHT-TAB_HEIGHT-50)
            .widthIs(SCREEN_WIDTH);
            
        }
    }
    
    
    self.shopcartBottomView.sd_layout
    .topSpaceToView(self.shopcartTableView, 0)
    .centerXEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(50);
    
}

-(void)deletecartgoods:(NSMutableArray *)selectedProducts{
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSMutableArray *deletegoodsidarray=[NSMutableArray new];
    for (JVShopcartProductModel *model in selectedProducts) {
        [deletegoodsidarray addObject:model.cartId];
    }
    [dic setObject:deletegoodsidarray forKey:@"data"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(delCart) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        [self requestShopcartListData];
                                        [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:0 totalCount:0 isAllselected:NO];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}
-(void)collectcartgoods:(NSMutableArray *)selectedProducts{
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSMutableArray *collrctgoodsidarray=[NSMutableArray new];
    for (JVShopcartProductModel *model in selectedProducts) {
        [collrctgoodsidarray addObject:model.productId];
    }
    [dic setObject:collrctgoodsidarray forKey:@"goods_id"];
    [dic setObject:@"1" forKey:@"type"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(goodsCollect) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        [self requestShopcartListData];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

-(void)settlementgoods:(NSMutableArray *)selectedProducts{
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSMutableArray *settlementgoodsarray=[NSMutableArray new];
    for (JVShopcartBrandModel *jvsbmodel in selectedProducts) {
        for (JVShopcartProductModel *jvspmodel in jvsbmodel.products) {
            NSLog(@"isSelected-----%@",jvspmodel.isSelected==YES?@"YES":@"NO");
            NSString *spestring=[NSString stringWithFormat:@"%@_%ld",jvspmodel.cart_id,(long)jvspmodel.productQty];
            jvspmodel.isSelected!=YES?:[settlementgoodsarray addObject:spestring];
            
        }
    }
    //拼接成数组
//    NSMutableString *goodStr = [@"" mutableCopy];
//    if (settlementgoodsarray.count) {
//        [goodStr appendFormat:@"["];
//        for (int i = 0; i < settlementgoodsarray.count; i ++) {
//            if (i == settlementgoodsarray.count - 1) {
//                [goodStr appendFormat:@"\"%@\"",settlementgoodsarray[i]];
//                [goodStr appendFormat:@"]"];
//            }else{
//                [goodStr appendFormat:@"\"%@\",",settlementgoodsarray[i]];
//            }
//        }
//    }
//    NSLog(@"goodStr:%@",goodStr);
    
    [dic setObject:@"" forKey:@"invoice_title"];
    [dic setObject:@"" forKey:@"couponTypelecy"];
    [dic setObject:@"" forKey:@"coupon_id"];
    [dic setObject:@"" forKey:@"couponCode"];
    [dic setObject:@"" forKey:@"address_id"];
    [dic setObject:settlementgoodsarray forKey:@"goods_info"];
    [dic setObject:@"1" forKey:@"type"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(buyCart) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        
                                        MakeSureTheOrderViewController *mstovc = [MakeSureTheOrderViewController new];
                                        mstovc.resultdic=[result mutableCopy];
                                        //                                        mstovc.CommodityInformationDic=[addCarDic mutableCopy];
                                        mstovc.type = 1; mstovc.DecideWhichControllerComesIn=@"ShoppingCarViewController";
                                        mstovc.baseDic = [dic mutableCopy];
                                        
                                        [self.navigationController pushViewController:mstovc animated:YES];
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

@end

