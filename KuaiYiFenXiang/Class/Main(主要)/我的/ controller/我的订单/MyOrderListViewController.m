//
//  MyOrderListViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "StoreDisplayViewController.h"
#import "MyOrderDetailsViewController.h"
#import "PayChangeViewController.h"
#import "DetailsRefundViewController.h"
#import "MyViewController.h"
#import "MyOrderViewController.h"
#import "LogisticsTimelineModel.h"
#import "ShoppingCarViewController.h"
#import "DCGoodDetailViewController.h"

#import "ShoppingCarLatestRecommendedCollectionViewCell.h"

@interface MyOrderListViewController () <
UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

>

{
    UIButton * rightBtn ;
    UIButton * leftBtn ;
    
    NSInteger pageNum;  //最新推荐的请求页码
}
//用来显示最新推荐的视图
@property (nonatomic,strong) UICollectionView *collectionView;
//推荐数据数组
@property (nonatomic,strong) NSMutableArray *recommendDataSource;
@end

static NSString *const UICollectionReusableViewID = @"UICollectionReusableView";

static NSString *const MyOrderListRecommendCellID = @"MyOrderListCellID";

@implementation MyOrderListViewController

#pragma mark --- 懒加载
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT - BOTTOM_MARGIN) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID];
        
        [_collectionView registerClass:[ShoppingCarLatestRecommendedCollectionViewCell class] forCellWithReuseIdentifier:MyOrderListRecommendCellID];
        
        MCWeakSelf;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (_collectionView.mj_footer.isRefreshing) {
                [_collectionView.mj_header endRefreshing];
                return ;
            }
            pageNum = 0;
            [weakSelf questGetOrderList];
        }];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (_collectionView.mj_header.isRefreshing) {
                [_collectionView.mj_footer endRefreshing];
                return ;
            }
            pageNum ++;
            [weakSelf questRecommendData];
        }];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)recommendDataSource
{
    if (!_recommendDataSource) {
        _recommendDataSource = [NSMutableArray new];
    }
    return _recommendDataSource;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    if (self.index == 0) {
        @weakify(self)
        [[NSNotificationCenter defaultCenter] addObserverForName:@"refreshAllOrder" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [weak_self.table.mj_header beginRefreshing];
        }];
    }
    
    self.navigationItem.title=self.index==5?@"退款/售后":@"我的订单";
    //重写返回方法点击返回直接返回到个人中心页面
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"BACK" hightimage:@"BACK" andTitle:@""];
    self.dataArray = [NSMutableArray new];
    
    [self configUI];
    
    //关闭全屏滑动
    self.fd_interactivePopDisabled = YES;
    
}

- (void)configUI {
    
    UITableView *table =  self.index==5?[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN) style:UITableViewStyleGrouped]:[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - NAVI_HEIGHT - BOTTOM_MARGIN) style:UITableViewStyleGrouped];
    
    
    table.estimatedSectionHeaderHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedRowHeight = 0;
    table.tableFooterView = [UIView new];
    table.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self.view addSubview:table];
    
    table.dataSource = self;
    
    table.delegate = self;
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.showsVerticalScrollIndicator = NO;
    
    table.sectionHeaderHeight = 0;
    table.sectionFooterHeight = 10;
    
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.table = table;
    [table registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:@"cell"];
    @weakify(self);
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.table.mj_footer.state == MJRefreshStateRefreshing) {
            [self.table.mj_header endRefreshing];
            return ;
        }
        self.page = 0;
        [self questGetOrderList];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.table.mj_header.state == MJRefreshStateRefreshing) {
            [self.table.mj_footer endRefreshing];
            return ;
        }
        self.page ++;
        [self questGetOrderList];
    }];
    
    [self.table.mj_header beginRefreshing];
}

//订单列表请求
-(void)questGetOrderList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(self.index).description;
    dict[@"page"] = @(self.page).description;
    [HttpRequest postWithTokenURLString:NetRequestUrl(ordergoods) parameters:dict isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        //        NSLog(@"%@", res);
        NSMutableArray *dataArr = [self.dataArray mutableCopy];
        if ([res[@"code"] integerValue] == 1) {
            NSArray *temp = [OrderListModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
            
            if (temp.count>0) {
                if (self.page == 0) {
                    dataArr = [temp mutableCopy];
                }else{
                    [dataArr addObjectsFromArray:temp];
                }
                
                [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    OrderListModel *model=obj;
                    if (model.user_cancel.intValue==2) {
                        [dataArr removeObject:obj];
                    }
                }];
                [self.table.mj_header endRefreshing];
                [self.table.mj_footer endRefreshing];
            }else{
                if (self.page == 0) {
                    dataArr = [temp mutableCopy];
                }else{
                    [dataArr addObjectsFromArray:temp];
                }
                
                [self.table.mj_header endRefreshing];
                [self.table.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            LRToast(res[@"msg"]);
        }
        if (dataArr.count > 0) {
            [self.collectionView.mj_header endRefreshing];
            self.collectionView.hidden = YES;
        }else{
            [self questRecommendData];
            self.collectionView.hidden = NO;
        }
        self.dataArray = dataArr;
        [self.table reloadData];
    } failure:^(NSError *error) {
        [self.table.mj_header endRefreshing];
        [self.table.mj_footer endRefreshing];
        
    }  RefreshAction:nil];
    
}

//最新推荐列表请求
- (void)questRecommendData
{
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"1" forKey:@"type"];
    
    [dic setObject:@(pageNum) forKey:@"page"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(goods) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSMutableArray *result=[responseObject objectForKey:@"result"];
                                    
                                    
                                    if (kArrayIsEmpty(result)) {
                                        
                                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                                        
                                    }else{
                                        
                                        if (codeStr.intValue==1) {
                                            
                                            if (pageNum == 0) {
                                                [self.recommendDataSource removeAllObjects];
                                            }
                                            
                                            for (NSDictionary * dic in result) {
                                                //初始化模型
                                                GeneralGoodsModel *model = [GeneralGoodsModel mj_objectWithKeyValues:dic];
                                                //把模型添加到相应的数据源数组中
                                                
                                                [self.recommendDataSource addObject:model];
                                            }
                                            
                                        }
                                        
                                        [self.collectionView.mj_footer endRefreshing];
                                        
                                    }
                                    
                                    [self.collectionView.mj_header endRefreshing];
                                    
                                    [self.collectionView reloadData];
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                    [self.collectionView.mj_header endRefreshing];
                                    
                                    [self.collectionView.mj_footer endRefreshing];
                                    
                                    [self.collectionView reloadData];
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].goods_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kArrayIsEmpty(self.dataArray)?:[cell setOrderListModel:self.dataArray[indexPath.section]];
    kArrayIsEmpty(self.dataArray[indexPath.section].goods_list)?:[cell setGoodListModel:self.dataArray[indexPath.section].goods_list[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [headview setBackgroundColor:[UIColor whiteColor]];
    
    //订单模型
    OrderListModel *model=self.dataArray[section];
    //商品模型
    //    GoodListModel *glmodel=model.goods_list[0];
    
    UIButton *headBtn = [[UIButton alloc] init];
    [headBtn setImage:[UIImage imageNamed:@"dingdandianpu"] forState:UIControlStateNormal];
    [headBtn setTitle:[NSString stringWithFormat:@"%@ >",model.goods_list.firstObject.name] forState:UIControlStateNormal];
    [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headBtn.titleLabel.font=PFR12Font;
    NSString *business_idstring=model.business_id;
    [headBtn setTag:business_idstring.intValue];
    [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    headBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    headBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [headview addSubview:headBtn];
    headBtn.sd_layout
    .leftSpaceToView(headview,10)
    .centerYEqualToView(headview)
    .widthIs(SCREEN_WIDTH/2)
    .heightIs(15);
    
    UILabel *stateLabel=[[UILabel alloc]init];
    GoodListModel *goodsModel = model.goods_list.firstObject;
    BOOL business_confirm = [goodsModel.business_confirm isEqualToString:@"1"];
    //判断是退款售后中的还是普通状态的
    
    stateLabel.text = [self processHeadLogicWithOrderModel:model Push:NO];
    /*
     if (model.pay_refund.intValue==1&&model.shipping_status.intValue==0&&(model.business_status.intValue==0||model.business_status.intValue==1)){
     if (model.business_status.intValue==1) {
     stateLabel.text = @"商家同意退款，等待处理";
     } else {
     stateLabel.text = @"待发货,退款中";
     }
     }else if (model.pay_refund.intValue==2&&model.pay_status.intValue==3&&model.order_status.integerValue != 2){
     stateLabel.text = @"退款成功,交易关闭";
     }else if (model.pay_refund.intValue==0&&model.shipping_status.intValue==0&&model.business_status.intValue==2){
     if (model.service.integerValue == 1) {
     if (model.terrace_status.integerValue == 1) {
     stateLabel.text = @"平台同意申请，等待退款";
     } else if(model.terrace_status.integerValue == 2){
     stateLabel.text = @"平台拒绝，等待买家处理";
     } else {
     
     stateLabel.text = @"平台介入，等待处理";
     }
     } else {
     stateLabel.text = @"商家拒绝，待用户处理";
     }
     }else if (model.pay_refund.intValue==1&&model.shipping_status.intValue==1&&model.business_status.intValue == 0){
     stateLabel.text = @"申请退款，商家处理中";
     
     } else if (model.pay_refund.intValue==1&&model.shipping_status.intValue==1&&model.business_status.intValue==1){
     if ([model.type isEqualToString:@"仅退款"]) {
     stateLabel.text = @"商家同意,等待退款";
     }else{
     
     if (![goodsModel.maijiafahuo isEqual:@""]){
     if(business_confirm){
     stateLabel.text = @"商家已确认收货，等待退款";
     }
     else {
     stateLabel.text = @"已发货，待商家收货";
     }
     }else {
     
     stateLabel.text = @"商家同意退款，待用户处理";
     }
     }
     
     }else if (model.pay_refund.intValue==1&&model.shipping_status.intValue==1&&model.business_status.intValue==2){
     stateLabel.text = @"商家拒绝，待用户处理";
     }
     
     else if (model.order_status.integerValue != 2 && model.business_status.integerValue == 2){
     if (model.service.integerValue == 1) {
     if (model.terrace_status.integerValue == 1) {
     stateLabel.text = @"平台同意退款，等待买家处理";
     } else {
     stateLabel.text = @"平台拒绝退款，等待买家处理";
     }
     
     } else {
     
     stateLabel.text = @"待收货,退款失败";
     }
     }else if (model.user_cancel.intValue==1&&model.pay_status.intValue==0){
     stateLabel.text = @"未支付,交易关闭";
     }else if(model.pay_refund.intValue==0&&model.order_status.intValue==0&&model.shipping_status.intValue==0&&model.pay_status.intValue==0){
     stateLabel.text = @"待付款";
     }else if (model.pay_refund.intValue==0&&(model.order_status.intValue==0||model.order_status.intValue==1)&&model.shipping_status.intValue==0&&model.pay_status.intValue==1){
     stateLabel.text = @"待发货";
     }else if (model.pay_refund.intValue==0&&model.order_status.intValue==1&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
     if (model.business_status.integerValue == 2) {
     if (model.service.integerValue == 1) {
     if (model.terrace_status.integerValue == 1) {
     stateLabel.text = @"平台同意退款，等待买家处理";
     } else if (model.terrace_status.integerValue == 2){
     stateLabel.text = @"平台拒绝，等待买家处理";
     } else {
     
     stateLabel.text = @"平台介入，等待处理";
     }
     } else {
     stateLabel.text = @"商家拒绝，待用户处理";
     }
     
     } else {
     
     stateLabel.text = @"待收货";
     }
     }else if (model.pay_refund.intValue==0&&model.order_status.intValue==2&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
     stateLabel.text = @"已完成";
     }
     
     */
    
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.textColor = [UIColor colorWithHexString:@"d40000"];
    [headview addSubview:stateLabel];
    stateLabel.sd_layout
    .centerYEqualToView(headview)
    .rightSpaceToView(headview, 15)
    .autoHeightRatio(0);
    [stateLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3+40];
    
    
    return headview;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [footview setBackgroundColor:[UIColor whiteColor]];
    
    OrderListModel *model=self.dataArray[section];
    
    UILabel * itemCountLabel = [UILabel new];
    
    UILabel * postLabel = [UILabel new];
    
    UILabel * sumLabel = [UILabel new];
    
    UILabel *alabel = [UILabel new];
    
    
    [footview sd_addSubviews:@[
                               itemCountLabel,
                               alabel,
                               sumLabel,
                               postLabel,
                               
                               ]];
    
    itemCountLabel.text = [NSString stringWithFormat:@"共%@件",model.all_num];
    itemCountLabel.font = kFont(13);
    itemCountLabel.textColor = kColor333;
    itemCountLabel.sd_layout
    .rightSpaceToView(footview, 10)
    .topSpaceToView(footview, 10)
    .autoHeightRatio(0);
    [itemCountLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    alabel.font = kFont(13);
    alabel.textColor = kColor333;
    alabel.text = @"合计：";
    alabel.sd_layout
    .centerYEqualToView(itemCountLabel)
    .leftSpaceToView(footview, 20)
    .autoHeightRatio(0);
    [alabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    sumLabel.text = [NSString stringWithFormat:@"￥%.2f",model.order_amount];
    sumLabel.font = kFont(15);
    sumLabel.textColor = [UIColor colorWithHexString:@"d40000"];
    sumLabel.sd_layout
    .centerYEqualToView(itemCountLabel)
    .leftSpaceToView(alabel, 0)
    .autoHeightRatio(0);
    [sumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    postLabel.text = [NSString stringWithFormat:@"（含运费￥%@）",model.shipping_price];
    postLabel.font = kFont(13);
    postLabel.textColor = kColor333;
    postLabel.sd_layout
    .centerYEqualToView(itemCountLabel)
    .leftSpaceToView(sumLabel, 0)
    .autoHeightRatio(0);
    [postLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    
    
    UILabel *newlineLabel=[[UILabel alloc]init];
    [newlineLabel setBackgroundColor:BACKVIEWCOLOR];
    [footview addSubview:newlineLabel];
    newlineLabel.sd_layout
    .topSpaceToView(itemCountLabel, 10)
    .leftEqualToView(footview)
    .rightEqualToView(footview)
    .heightIs(1);
    
    rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.titleLabel.font = kFont(15);
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.borderColor = [UIColor colorWithHexString:@"d40000"].CGColor;
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"d40000"] forState:UIControlStateNormal];
    rightBtn.tag=section;
    
    leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.layer.cornerRadius = 3;
    leftBtn.titleLabel.font = kFont(15);
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = kDefaultBGColor.CGColor;
    [leftBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    leftBtn.tag=section;
    
    NSString *text = [self processHeadLogicWithOrderModel:model Push:NO];
    [footview addSubview:rightBtn];
    [footview addSubview:leftBtn];
    
    if (!kStringIsEmpty(model.type)) {
        //查看售后
        [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        if (model.pay_refund.integerValue == 2&&model.pay_status.integerValue == 3) {
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }else{
            [leftBtn removeFromSuperview];
        }
        
    }else{
        //正常订单
        switch (model.pay_status.integerValue) {
            case 0:
            {
                [rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
                if (model.user_cancel.integerValue == 1) {
                    [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                }
                [leftBtn removeFromSuperview];
                
            }
                break;
            case 1:
            {
                //已付款
                if (model.order_status.integerValue == 0) {
                    [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [rightBtn setTitle:@"催促发货" forState:UIControlStateNormal];
                }else if (model.order_status.integerValue == 1){
                    [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                }else if (model.order_status.integerValue == 2){
                    [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [leftBtn removeFromSuperview];
                }
            }
                
                break;
            default:
                break;
        }
    }
    
    /*
     //判断是不是退款售后的退款售后的按钮状态只有一个查看详情 如果是其他状态的再进行判断
     //用户没有支付，直接取消了订单
     if (model.user_cancel.intValue==1&&model.pay_status.intValue==0) {
     
     [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     
     }else if (model.pay_refund.intValue==2&&model.pay_status.intValue==3) {
     //退款成功
     [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     
     }else if ((model.pay_refund.intValue==1||model.pay_refund.intValue==2 || (model.pay_refund.integerValue == 0 && model.business_status.integerValue == 2)) && self.index == 5) {
     //退款中、退款完成或退款失败
     [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     
     }else if(model.pay_refund.intValue==0&&model.order_status.intValue==0&&model.shipping_status.intValue==0&&model.pay_status.intValue==0){
     //未支付
     [rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }else if ((model.pay_refund.intValue==0 || model.pay_refund.intValue==1)&&(model.order_status.intValue==0||model.order_status.intValue==1)&&model.shipping_status.intValue==0&&model.pay_status.intValue==1){
     
     if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==0&&(model.business_status.intValue==0)) {
     [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
     [rightBtn setTitle:@"催促发货" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [footview addSubview:leftBtn];
     }else if (model.service.integerValue == 1||model.business_status.integerValue == 2){
     //代表平台介入
     [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }
     else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
     [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==1 &&model.terrace_status.integerValue == 1){
     [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==1 && model.terrace_status.integerValue == 0){
     [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
     [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }
     }else if ((model.pay_refund.intValue==0 || model.pay_refund.intValue==1)&&model.order_status.intValue==1&&model.shipping_status.intValue==1&&model.pay_status.integerValue == 1){
     // 待收货
     if(model.pay_refund.integerValue == 1 || (model.pay_refund.integerValue == 0 && model.business_status.integerValue == 2) || model.pay_refund.integerValue == 2){
     [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }else if (model.order_status.intValue==1&&model.pay_refund.intValue==0&&(model.business_status.intValue==0||model.business_status.intValue==2)) {
     
     [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
     [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [footview addSubview:leftBtn];
     } else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
     [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
     [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [footview addSubview:leftBtn];
     }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==1 && model.terrace_status.integerValue == 1){
     [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
     [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
     [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [footview addSubview:leftBtn];
     }
     }else if (model.pay_refund.intValue==0&&model.order_status.intValue==2&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
     [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
     [footview addSubview:rightBtn];
     [leftBtn removeFromSuperview];
     }
     
     */
    rightBtn.sd_layout
    .topSpaceToView(newlineLabel, 5)
    .rightSpaceToView(footview, 15)
    .widthIs(80)
    .heightIs(25);
    
    leftBtn.sd_layout
    .topSpaceToView(newlineLabel, 5)
    .rightSpaceToView(rightBtn, 15)
    .widthIs(80)
    .heightIs(25);
    
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lineLabel=[[UILabel alloc]init];
    [lineLabel setBackgroundColor:BACKVIEWCOLOR];
    [footview addSubview:lineLabel];
    lineLabel.sd_layout
    .bottomEqualToView(footview)
    .centerXEqualToView(footview)
    .widthIs(SCREEN_WIDTH)
    .heightIs(10);
    
    return footview;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderListModel *model = self.dataArray[indexPath.section];
    
    [self processHeadLogicWithOrderModel:model Push:YES];
    
    
    /*
     
     if ((model.pay_refund.intValue==1||model.pay_refund.intValue==2 || (model.pay_refund.integerValue == 0 && model.business_status.integerValue == 2)) && self.index == 5) {
     
     DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
     drvc.refundordersnString=model.order_sn;
     [self.navigationController pushViewController:drvc animated:YES];
     
     }else {
     if(model.order_status.intValue==0&&model.shipping_status.intValue==0&&model.pay_status.intValue==0){
     
     modvc.btntextstring=@"去付款";
     modvc.orderinformationArray=@[@"daifukuan_icon",@"待付款",@"订单为您保留1天,超时后将自动关闭交易"];
     }else if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.shipping_status.intValue==0&&model.pay_status.intValue==1){
     if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==0&&(model.business_status.intValue==0||model.business_status.intValue==2)) {
     modvc.btntextstring=@"催促发货";
     if (model.terrace_status.integerValue == 2) {
     modvc.orderinformationArray=@[@"daifahuo_icon",@"未发货",@"退款失败，待用户处理"];
     }else if (model.terrace_status.integerValue == 1) {
     modvc.orderinformationArray=@[@"daifahuo_icon",@"",@"平台同意退款，等待处理"];
     } else {
     if (model.service.integerValue == 1 && model.terrace_status.integerValue == 0) {
     modvc.orderinformationArray=@[@"",@"",@"已申请平台介入，等待处理"];
     } else {
     modvc.orderinformationArray=@[@"daifahuo_icon",@"待发货",@"您的订单已支付成功,预计48小时内完成发货"];
     }
     
     }
     } else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
     modvc.btntextstring=@"查看售后";
     modvc.orderinformationArray=@[@"yiwancheng_icon",@"退款申请中",@"待商家处理"];
     }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==1){
     modvc.btntextstring=@"删除订单";
     modvc.orderinformationArray=@[@"yiguanbi_icon",@"审核通过",@"请在退款售后中查看订单状态"];
     }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
     modvc.btntextstring=@"查看物流";
     modvc.orderinformationArray=@[@"yiwancheng_icon",@"已完成",@"您已确认收货"];
     }
     modvc.isshowrefundBtnString=@"show";
     modvc.isshowRefundPopView=@"NO";
     }else if (model.order_status.intValue==1&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
     if (model.order_status.intValue==1&&model.pay_refund.intValue==0&&(model.business_status.intValue==0||model.business_status.intValue==2)) {
     
     if (model.service.integerValue == 1 && model.terrace_status.integerValue == 0) {
     modvc.orderinformationArray=@[@"",@"",@"已申请平台介入，等待处理"];
     modvc.btntextstring=@"查看售后";
     } else if (model.terrace_status.integerValue == 1) {
     modvc.orderinformationArray=@[@"",@"",@"平台同意退款，待买家发货"];
     modvc.btntextstring=@"查看售后";
     } else if (model.terrace_status.integerValue == 2) {
     modvc.orderinformationArray=@[@"",@"",@"平台拒绝退款，待买家处理"];
     modvc.btntextstring=@"查看售后";
     }else {
     if (model.business_status.integerValue == 2) {
     modvc.orderinformationArray=@[@"daishouhuo_icon",@"已发货",@"退款失败，待用户处理"];
     modvc.btntextstring=@"查看售后";
     } else {
     modvc.orderinformationArray=@[@"daishouhuo_icon",@"待收货",@"您的包裹已出库,还剩199天自动确认"];
     modvc.btntextstring=@"确认收货";
     }
     
     }
     } else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
     modvc.btntextstring=@"查看售后";
     if (model.pay_refund.integerValue == 1&&model.pay_status.integerValue == 1) {
     modvc.orderinformationArray=@[@"",@"",@"退款申请中，待卖家处理"];
     } else {
     modvc.orderinformationArray=@[@"daishouhuo_icon",@"待收货",@"您的包裹已出库,还剩199天自动确认"];
     }
     }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==1&&model.terrace_status.integerValue == 1){
     modvc.btntextstring=@"删除订单";
     modvc.orderinformationArray=@[@"yiguanbi_icon",@"已关闭",@"买家主动取消订单"];
     }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==1&&model.terrace_status.integerValue == 0){
     modvc.btntextstring=@"删除订单";
     modvc.orderinformationArray=@[@"yiguanbi_icon",@"审核通过",@"请在退款售后中查看订单状态"];
     }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
     modvc.btntextstring=@"确认收货";
     modvc.orderinformationArray=@[@"daishouhuo_icon",@"待收货",@"您的包裹已出库,还剩199天自动确认"];
     }
     modvc.isshowrefundBtnString=@"show";
     modvc.isshowRefundPopView=@"YES";
     }else if (model.pay_refund.intValue==0&&model.order_status.intValue==2&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
     modvc.btntextstring=@"查看物流";
     modvc.orderinformationArray=@[@"yiwancheng_icon",@"已完成",@"您已确认收货"];
     
     }else if (model.pay_refund.integerValue == 2 && model.pay_status.integerValue == 3) {//退款完成
     modvc.btntextstring=@"查看售后";
     modvc.orderinformationArray=@[@"yiwancheng_icon",@"",@"退款成功，交易关闭"];
     }
     
     if (model.user_cancel.intValue==1&&model.pay_status.intValue==0){
     
     modvc.btntextstring=@"删除订单";
     modvc.orderinformationArray=@[@"yiguanbi_icon",@"已关闭",@"买家主动取消订单"];
     
     }
     if (model.shipping_status.integerValue == 1) {
     //            if (kStringIsEmpty(model.refund_again)) {
     //
     //            } else
     //                if (model.refund_again.integerValue == 1) {
     //                    modvc.isshowrefundBtnString = @"NO";
     //                }
     } else if (model.shipping_status.integerValue == 0) {
     if (model.service.integerValue == 1) {  //平台介入
     //                if (model.terrace_status.integerValue == 1) {   //平台同意
     //                    modvc.orderinformationArray=@[@"daifahuo_icon",@"平台同意退款，等待处理"];
     //                }else{
     //                    modvc.orderinformationArray=@[@"daifahuo_icon",@"未发货",@"退款失败，待用户处理"];
     //                }
     }else{
     //非平台介入
     if(model.business_status.integerValue == 2) {
     modvc.isshowrefundBtnString = @"NO";
     modvc.orderinformationArray=@[@"daifahuo_icon",@"未发货",@"退款失败，待用户处理"];
     modvc.btntextstring = @"查看售后";
     }
     }
     
     }
     
     modvc.order_snstring=model.order_sn;
     [self.navigationController pushViewController:modvc animated:YES];
     
     }
     */
    
}
-(void)headBtnClick:(UIButton *)btn{
    StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
    sdvc.business_idstring=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:sdvc animated:YES];
}

-(void)leftBtnClick:(UIButton *)btn{
    
    OrderListModel *olmodel=self.dataArray[btn.tag];
    if (!olmodel.goods_list.count) {
        LRToast(@"商品数据有误");
        return;
    }
    GoodListModel *glmodel=olmodel.goods_list[0];
    
    SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
    smvc.TradeLogisticsDataSource=[NSMutableArray new];
    
    NSString *expressqueryUrl = @"https://way.jd.com/fegine/exp";
    //参数列表
    NSMutableDictionary *parame = [NSMutableDictionary new];
    [parame setObject:GetSaveString(glmodel.shipping_code) forKey:@"type"];
    [parame setObject:GetSaveString(glmodel.invoice_no) forKey:@"no"];
    [parame setObject:@"d08ce5d77a6d395a23de6745d9b7407e" forKey:@"appkey"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 5;
    
    if (![MBProgressHUD allHUDsForView:kWindow].count)kShowHUDAndActivity;
    
    [manager GET:expressqueryUrl parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        kHiddenHUDAndAvtivity;
        
        //直接吧返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"expressqueryUrl-----%@-----resultdic-----%@",expressqueryUrl,resultdic);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"code"]]; ;
        NSDictionary *resultdic1=[resultdic objectForKey:@"result"];
        NSString *status = [NSString stringWithFormat:@"%@",[resultdic1 objectForKey:@"status"]]; ;
        NSDictionary *resultdic2=[resultdic1 objectForKey:@"result"];
        //        NSMutableArray *listarray=kDictIsEmpty(resultdic2)?[NSMutableArray new]:[resultdic2 objectForKey:@"list"];
        if (codeStr.intValue==10000) {
            
            if ([resultdic2 isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *listarray=[resultdic2 objectForKey:@"list"];
                
                for (NSDictionary *dic in listarray) {
                    
                    //初始化模型
                    LogisticsTimelineModel *model=[LogisticsTimelineModel mj_objectWithKeyValues:dic];
                    //把模型添加到相应的数据源数组中
                    //                    [self.TradeLogisticsDataSource addObject:model];
                    [smvc.TradeLogisticsDataSource addObject:model];
                    
                }
                smvc.logisticsPhone = resultdic2[@"expPhone"];
            }
            
            smvc.categorynameNumString=@"TradeLogistics";
            smvc.logisticsTypeString = glmodel.shipping_code;
            smvc.logisticsNoString = glmodel.invoice_no;
            [self.navigationController pushViewController:smvc animated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        kHiddenHUDAndAvtivity;
        
    }];
    
    //    SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
    //    smvc.logisticsTypeString = glmodel.shipping_code;
    //    smvc.logisticsNoString = glmodel.invoice_no;
    //    smvc.categorynameNumString=@"TradeLogistics";
    //    [self.navigationController pushViewController:smvc animated:YES];
    
}

-(void)rightBtnClick:(UIButton *)btn{
    
    OrderListModel *olmodel = self.dataArray[btn.tag];
    if (!olmodel.goods_list.count) {
        LRToast(@"商品数据有误");
        return;
    }
    GoodListModel *glmodel=olmodel.goods_list[0];
    
    if (olmodel.pay_refund.intValue==1||olmodel.pay_refund.intValue==2 || (olmodel.pay_refund.integerValue == 0 && olmodel.business_status.integerValue == 2)) {
        if([btn.titleLabel.text isEqualToString:@"查看售后"]) {
            DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
            drvc.refundordersnString=olmodel.order_sn;
            drvc.all_num = olmodel.all_num;
            [self.navigationController pushViewController:drvc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除订单吗?"
                                                                           message:@"订单删除不能恢复,请谨慎操作"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quxiaoaction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     
                                                                 }];
            UIAlertAction *quedingaction = [UIAlertAction actionWithTitle:@"确定"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      [self deleteOrder:olmodel.order_sn];
                                                                  }];
            [alert addAction:quxiaoaction];
            [alert addAction:quedingaction];
            [self presentViewController:alert animated:YES completion:^{ }];
            
        }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]){
            
            SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
            smvc.TradeLogisticsDataSource=[NSMutableArray new];
            
            NSString *expressqueryUrl = @"https://way.jd.com/fegine/exp";
            //参数列表
            NSMutableDictionary *parame = [NSMutableDictionary new];
            [parame setObject:GetSaveString(glmodel.shipping_code) forKey:@"type"];
            [parame setObject:GetSaveString(glmodel.invoice_no) forKey:@"no"];
            [parame setObject:@"d08ce5d77a6d395a23de6745d9b7407e" forKey:@"appkey"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            /**
             *  可以接受的类型
             */
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            manager.requestSerializer.timeoutInterval = 5;
            
            if (![MBProgressHUD allHUDsForView:kWindow].count)kShowHUDAndActivity;
            
            [manager GET:expressqueryUrl parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                kHiddenHUDAndAvtivity;
                
                //直接吧返回的参数进行解析然后返回
                NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"expressqueryUrl-----%@-----resultdic-----%@",expressqueryUrl,resultdic);
                
                NSString *codeStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"code"]];
                NSDictionary *resultdic1=[resultdic objectForKey:@"result"];
                NSString *status;
                NSDictionary *resultdic2;
                if ([resultdic1 isKindOfClass:[NSDictionary class]]) {
                    status = [NSString stringWithFormat:@"%@",[resultdic1 objectForKey:@"status"]];
                    resultdic2 = [resultdic1 objectForKey:@"result"];
                }
                //        NSMutableArray *listarray=kDictIsEmpty(resultdic2)?[NSMutableArray new]:[resultdic2 objectForKey:@"list"];
                if (codeStr.intValue==10000) {
                    
                    if ([resultdic2 isKindOfClass:[NSDictionary class]]) {
                        NSMutableArray *listarray=[resultdic2 objectForKey:@"list"];
                        
                        for (NSDictionary *dic in listarray) {
                            
                            //初始化模型
                            LogisticsTimelineModel *model=[LogisticsTimelineModel mj_objectWithKeyValues:dic];
                            //把模型添加到相应的数据源数组中
                            //                    [self.TradeLogisticsDataSource addObject:model];
                            [smvc.TradeLogisticsDataSource addObject:model];
                            
                        }
                        smvc.logisticsPhone = resultdic2[@"expPhone"];
                    }
                    
                    smvc.categorynameNumString=@"TradeLogistics";
                    smvc.logisticsTypeString = glmodel.shipping_code;
                    smvc.logisticsNoString = glmodel.invoice_no;
                    [self.navigationController pushViewController:smvc animated:YES];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                kHiddenHUDAndAvtivity;
                
            }];
            
        } else if ([btn.titleLabel.text isEqualToString:@"确认收货"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"确认已收到商品"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quxiaoaction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     
                                                                 }];
            UIAlertAction *quedingaction = [UIAlertAction actionWithTitle:@"确定"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      [self Determineifthereisapaymentpassword:@"querenshouhuozhifu" andorder_snstring:olmodel.order_sn];
                                                                  }];
            [alert addAction:quxiaoaction];
            [alert addAction:quedingaction];
            [self presentViewController:alert animated:YES completion:^{ }];
            
        }else if ([btn.titleLabel.text isEqualToString:@"催促发货"]){
            //这里催促发货似乎并没有调用接口
            if ([[NSDate date] timeIntervalSince1970] - olmodel.pay_time.integerValue <= 48*3600) {
                LRToast(@"您的订单目前处于正常发货时效内，请耐心等待发货，如超过2天仍未发货请您再次催促发货");
            } else {
                LRToast(@"催促发货提交成功,请耐心等待");
            }
            
            //        }else if ([btn.titleLabel.text isEqualToString:@"查看详情"]&&self.index == 5){
            //            //退款详情
            //            DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
            //            drvc.refundordersnString=olmodel.order_sn;
            //            [self.navigationController pushViewController:drvc animated:YES];
        }
        
    } else if (olmodel.pay_refund.intValue==0){
        if([btn.titleLabel.text isEqualToString:@"查看售后"]) {
            DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
            drvc.refundordersnString=olmodel.order_sn;
            drvc.all_num = olmodel.all_num;
            [self.navigationController pushViewController:drvc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"去付款"]) {
            
            MyOrderDetailsViewController *modvc=[[MyOrderDetailsViewController alloc]init];
            modvc.olmodel = olmodel;
            modvc.order_snstring=olmodel.order_sn;
            modvc.btntextstring=@"去付款";
            modvc.orderinformationArray=@[@"daifukuan_icon",@"待付款",@"订单为您保留7天,超时后将自动关闭交易"];
            [self.navigationController pushViewController:modvc animated:YES];
            
        }else if ([btn.titleLabel.text isEqualToString:@"催促发货"]){
            if ([[NSDate date] timeIntervalSince1970] - olmodel.pay_time.integerValue <= 48*3600) {
                LRToast(@"您的订单目前处于正常发货时效内，请耐心等待发货，如超过2天仍未发货请您再次催促发货");
            } else {
                LRToast(@"催促发货提交成功,请耐心等待");
            }
        }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]){
            
            SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
            smvc.TradeLogisticsDataSource=[NSMutableArray new];
            
            
            NSString *expressqueryUrl = @"https://way.jd.com/fegine/exp";
            //参数列表
//            NSLog(@"glmodel.invoice_no:%@",olmodel.order_sn);
            NSMutableDictionary *parame = [NSMutableDictionary new];
            [parame setObject:GetSaveString(glmodel.shipping_code) forKey:@"type"];
            [parame setObject:GetSaveString(glmodel.invoice_no) forKey:@"no"];
            [parame setObject:@"d08ce5d77a6d395a23de6745d9b7407e" forKey:@"appkey"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            /**
             *  可以接受的类型
             */
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            manager.requestSerializer.timeoutInterval = 5;
            
            if (![MBProgressHUD allHUDsForView:kWindow].count)kShowHUDAndActivity;
            
            [manager GET:expressqueryUrl parameters:parame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                kHiddenHUDAndAvtivity;
                
                //直接吧返回的参数进行解析然后返回
                NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"expressqueryUrl-----%@-----resultdic-----%@",expressqueryUrl,resultdic);
                
                NSString *codeStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"code"]];
                NSDictionary *resultdic1 = [resultdic objectForKey:@"result"];
                
                NSString *status;
                NSDictionary *resultdic2;
                if ([resultdic1 isKindOfClass:[NSDictionary class]]) {
                    status = [NSString stringWithFormat:@"%@",[resultdic1 objectForKey:@"status"]];
                    resultdic2 = [resultdic1 objectForKey:@"result"];
                }
                
                //        NSMutableArray *listarray=kDictIsEmpty(resultdic2)?[NSMutableArray new]:[resultdic2 objectForKey:@"list"];
                if (codeStr.intValue == 10000) {
                    
                    if ([resultdic2 isKindOfClass:[NSDictionary class]]) {
                        NSMutableArray *listarray = [resultdic2 objectForKey:@"list"];
                        
                        for (NSDictionary *dic in listarray) {
                            
                            //初始化模型
                            LogisticsTimelineModel *model=[LogisticsTimelineModel mj_objectWithKeyValues:dic];
                            //把模型添加到相应的数据源数组中
                            //                    [self.TradeLogisticsDataSource addObject:model];
                            [smvc.TradeLogisticsDataSource addObject:model];
                            
                        }
                        smvc.logisticsPhone = resultdic2[@"expPhone"];
                    }
                    
                    smvc.categorynameNumString=@"TradeLogistics";
                    smvc.logisticsTypeString = glmodel.shipping_code;
                    smvc.logisticsNoString = glmodel.invoice_no;
                    
                    
                    [self.navigationController pushViewController:smvc animated:YES];
                    
                }
                if (codeStr.intValue == 10030) {
                    LRToast(resultdic[@"msg"]);
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                kHiddenHUDAndAvtivity;
                
            }];
            
            //        SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
            //        smvc.logisticsTypeString = glmodel.shipping_code;
            //        smvc.logisticsNoString = glmodel.invoice_no;
            //        smvc.categorynameNumString=@"TradeLogistics";
            //        [self.navigationController pushViewController:smvc animated:YES];
            
        }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除订单吗?"
                                                                           message:@"订单删除不能恢复,请谨慎操作"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quxiaoaction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     
                                                                 }];
            UIAlertAction *quedingaction = [UIAlertAction actionWithTitle:@"确定"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      [self deleteOrder:olmodel.order_sn];
                                                                  }];
            [alert addAction:quxiaoaction];
            [alert addAction:quedingaction];
            [self presentViewController:alert animated:YES completion:^{ }];
            
        }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"确认已收到商品"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *quxiaoaction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     
                                                                 }];
            UIAlertAction *quedingaction = [UIAlertAction actionWithTitle:@"确定"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      [self Determineifthereisapaymentpassword:@"querenshouhuozhifu" andorder_snstring:olmodel.order_sn];
                                                                  }];
            [alert addAction:quxiaoaction];
            [alert addAction:quedingaction];
            [self presentViewController:alert animated:YES completion:^{ }];
            
        }
        
    }
    
}

-(void)deleteOrder:(NSString *)order_snstring{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:order_snstring forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(deleteOrder) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        //                                        [self.navigationController popViewControllerAnimated:YES];
                                        [self.table.mj_header beginRefreshing];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

-(void)Determineifthereisapaymentpassword:(NSString *)paytypestring andorder_snstring:(NSString *)order_snstring{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            [self confirmgoods:order_snstring];
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:nil RefreshAction:nil];
    
    
}

-(void)confirmgoods:(NSString *)order_snstring{
    
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
    payAlert.title = @"请输入支付密码";
    //    payAlert.detail = @"提现";
    //    payAlert.amount= 10;
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
        
        NSMutableDictionary *requestdic=[NSMutableDictionary new];
        [requestdic setObject:order_snstring forKey:@"order_sn"];
        [requestdic setObject:inputPwd forKey:@"password"];
        [HttpRequest postWithTokenURLString:NetRequestUrl(orderConfirm) parameters:requestdic
                               isShowToastd:(BOOL)YES
                                  isShowHud:(BOOL)NO
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            MyOrderViewController *vc = [MyOrderViewController new];
                                            vc.index=4;
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
    };
}

- (void)back{
    
    YYFNavigationController *vc = self.parentViewController;
    for (UIViewController *temp in vc.viewControllers) {
        if ([temp isKindOfClass:[MyViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[ShoppingCarViewController class]]){
            [self.navigationController popToViewController:temp animated:YES];
        }else if ([temp isKindOfClass:[DCGoodDetailViewController class]]){
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据订单模型，处理订单逻辑(后面带bool代表是否跳转)
-(NSString *)processHeadLogicWithOrderModel:(OrderListModel *)orderModel Push:(BOOL)push
{
    NSString *stateText;
    MyOrderDetailsViewController *modvc=[[MyOrderDetailsViewController alloc]init];
    MCWeakSelf
    modvc.refreshHandler = ^{
//        [weakSelf.table.mj_header beginRefreshing];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAllOrder" object:nil];
    };
    
    if (kStringIsEmpty(orderModel.type)) {
        //正常订单
        if (!kStringIsEmpty([self processInNormalTypeWithPushVC:modvc orderModel:orderModel])) {
            stateText = [self processInNormalTypeWithPushVC:modvc orderModel:orderModel];
        }
        
    }else{
        //异常订单
        if (self.index == 5&&push) {
            DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
            drvc.all_num = orderModel.all_num;
            drvc.refundordersnString = orderModel.order_sn;
            [self.navigationController pushViewController:drvc animated:YES];
            return @"";
        }
        modvc.btntextstring = @"查看售后";
        //这里分仅退款和退货退款
        //仅退款
        if (!kStringIsEmpty([self processInRefundTypeWithPushVC:modvc orderModel:orderModel])) {
            stateText = [self processInRefundTypeWithPushVC:modvc orderModel:orderModel];
        }
        //退货退款
        if (!kStringIsEmpty([self processInSalesReturnRefundTypeWithPushVC:modvc orderModel:orderModel])) {
            stateText = [self processInSalesReturnRefundTypeWithPushVC:modvc orderModel:orderModel];
        }
        
    }
    
    if (push) {
        modvc.olmodel = orderModel;
        modvc.order_snstring = orderModel.order_sn;
        modvc.currentIndex = self.index;
        [self.navigationController pushViewController:modvc animated:YES];
        return @"";
    }
    //    NSLog(@"stateText:%@",stateText);
    return stateText;
}

//正常订单
-(NSString *)processInNormalTypeWithPushVC:(MyOrderDetailsViewController *)modvc orderModel:(OrderListModel *)orderModel
{
    NSString *stateText;
    //付款状态
    switch (orderModel.pay_status.integerValue) {
        case 0:
        {
            //看是否用户取消过
            switch (orderModel.user_cancel.integerValue) {
                case 0:
                {
                    stateText = @"待支付";
                    modvc.btntextstring = @"去付款";
                    modvc.orderinformationArray = @[
                                                    @"daifukuan_icon",
                                                    @"待付款",
                                                    @"订单为您保留1天,超时后将自动关闭交易"
                                                    ];
                }
                    break;
                    
                case 1:
                {
                    stateText = @"订单取消，交易关闭";
                    modvc.btntextstring = @"删除订单";
                    modvc.orderinformationArray = @[
                                                    @"yiguanbi_icon",
                                                    @"已关闭",
                                                    @"买家主动取消订单"
                                                    ];
                }
                    break;
                    
                case 2:
                {
                    LRToast(@"订单已删除,无法查阅")
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
            break;
        case 1:
        {
            stateText = @"已付款";
            if (orderModel.order_status.integerValue == 0) {
                stateText = @"待发货";
                modvc.btntextstring = @"催促发货";
                modvc.orderinformationArray = @[
                                                @"daifahuo_icon",
                                                @"待发货",
                                                @"您的订单已支付成功,预计48小时内完成发货"
                                                ];
            }else if (orderModel.order_status.integerValue == 1){
                stateText = @"待收货";
                modvc.btntextstring = @"确认收货";
                modvc.orderinformationArray = @[
                                                @"daishouhuo_icon",
                                                @"待收货",
                                                @"您的包裹已出库,还剩199天自动确认"
                                                ];
                
            }else if (orderModel.order_status.integerValue == 2){
                stateText = @"已完成";
                modvc.btntextstring = @"查看物流";
                modvc.orderinformationArray = @[
                                                @"yiwancheng_icon",
                                                @"已完成",
                                                @"您已确认收货"
                                                ];
            }
        }
            
            break;
        default:
            break;
    }
    return stateText;
}

//仅退款
-(NSString *)processInRefundTypeWithPushVC:(MyOrderDetailsViewController *)modvc orderModel:(OrderListModel *)orderModel
{
    NSString *stateText;
    if ([orderModel.type isEqualToString:@"仅退款"]) {
        
        if (orderModel.service.integerValue == 1) {
            //平台介入
            switch (orderModel.terrace_status.integerValue) {
                case 0:
                {
                    stateText = @"平台介入，等待处理";
                    modvc.orderinformationArray = @[
                                                    @"",
                                                    @"",
                                                    @"已申请平台介入，等待处理"
                                                    ];
                }
                    break;
                case 1:
                {
                    stateText = @"平台同意退款,等待处理";
                    if (orderModel.pay_refund.integerValue == 2) {
                        stateText = @"退款成功，交易关闭";
                        modvc.orderinformationArray  =@[
                                                        @"",
                                                        @"退款成功",
                                                        @"交易关闭"
                                                        ];
                    }else{
                        modvc.orderinformationArray = @[
                                                        @"",
                                                        @"",
                                                        @"平台同意退款，等待处理"
                                                        ];
                    }
                    
                }
                    break;
                case 2:
                {
                    stateText = @"平台拒绝退款，等待用户处理";
                    modvc.orderinformationArray = @[
                                                    @"",
                                                    @"",
                                                    @"平台拒绝，待用户处理"
                                                    ];
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            //平台未介入
            switch (orderModel.business_status.integerValue) {
                case 0:
                {
                    if (orderModel.shipping_status.integerValue == 0) {
                        //未发货的退款
                        stateText = @"待发货，退款中";
                        
                    }else{
                        //发货的退款
                        stateText = @"待收货，退款中";
                    }
                    modvc.orderinformationArray  =@[
                                                    @"",
                                                    @"",
                                                    @"退款申请中，待卖家处理"
                                                    ];
                }
                    break;
                case 1:
                {
                    stateText = @"商家同意，等待退款";
                    if (orderModel.pay_refund.integerValue == 2) {
                        stateText = @"退款成功，交易关闭";
                        modvc.orderinformationArray  =@[
                                                        @"",
                                                        @"退款成功",
                                                        @"交易关闭"
                                                        ];
                    }else{
                        modvc.orderinformationArray  =@[
                                                        @"",
                                                        @"商家同意退款",
                                                        @"等待处理"
                                                        ];
                    }
                }
                    break;
                case 2:
                {
                    stateText = @"商家拒绝，等待用户处理";
                    if (orderModel.shipping_status.integerValue == 0) {
                        modvc.orderinformationArray  =@[
                                                        @"",
                                                        @"未发货",
                                                        @"退款失败，待用户处理"
                                                        ];
                    }else{
                        modvc.orderinformationArray  =@[
                                                        @"",
                                                        @"已发货",
                                                        @"退款失败，待用户处理"
                                                        ];
                    }
                }
                    
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    return stateText;
}

//退货退款
-(NSString *)processInSalesReturnRefundTypeWithPushVC:(MyOrderDetailsViewController *)modvc orderModel:(OrderListModel *)orderModel
{
    NSString *stateText;
    if ([orderModel.type isEqualToString:@"退货退款"]) {
        //            NSLog(@"退货退款");
        if (orderModel.service.integerValue == 1) {
            //平台介入
            switch (orderModel.terrace_status.integerValue) {
                case 0:
                {
                    stateText = @"平台介入，等待处理";
                    modvc.orderinformationArray = @[
                                                    @"",
                                                    @"",
                                                    @"已申请平台介入，等待处理"
                                                    ];
                }
                    break;
                case 1: //平台同意退款
                {
                    GoodListModel *goodModel = orderModel.goods_list[0];
                    if (goodModel.maijiafahuo.integerValue == 0) {
                        //未发货
                        stateText = @"平台同意，等待用户处理";
                        modvc.orderinformationArray = @[
                                                        @"",
                                                        @"",
                                                        @"平台同意退款，待用户发货"
                                                        ];
                    }else{
                        
                        if (goodModel.business_confirm.integerValue == 0) {
                            stateText = @"已发货，待商家收货";
                            modvc.orderinformationArray = @[
                                                            @"",
                                                            @"",
                                                            @"等待商家确认收货"
                                                            ];
                        }else{
                            stateText = @"商家已确认收货，等待退款";
                            modvc.orderinformationArray = @[
                                                            @"",
                                                            @"",
                                                            @"商家已确认收货，等待退款"
                                                            ];
                            //是否退款成功
                            if (orderModel.pay_refund.integerValue == 2&&orderModel.pay_status.integerValue == 3) {
                                stateText = @"退款成功，交易关闭";
                                modvc.orderinformationArray = @[
                                                                @"",
                                                                @"",
                                                                @"退款成功，交易关闭"
                                                                ];
                            }
                            
                        }
                        
                    }
                }
                    break;
                case 2: //平台拒绝退款
                {
                    stateText = @"平台拒绝，等待用户处理";
                    modvc.orderinformationArray = @[
                                                    @"",
                                                    @"",
                                                    @"退款失败，待用户处理"
                                                    ];
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            //平台未介入
            switch (orderModel.business_status.integerValue) {
                case 0:
                {
                    stateText = @"申请退款，商家处理中";
                    modvc.orderinformationArray  =@[
                                                    @"",
                                                    @"",
                                                    @"退款申请中，待卖家处理"
                                                    ];
                }
                    break;
                case 1:
                {
                    modvc.btntextstring = @"查看售后";
                    GoodListModel *goodModel = orderModel.goods_list[0];
                    if (goodModel.maijiafahuo.integerValue == 0) {
                        //未发货
                        stateText = @"商家同意，等待用户处理";
                        modvc.orderinformationArray  =@[
                                                        @"",
                                                        @"",
                                                        @"商家同意退款，待用户处理"
                                                        ];
                        
                    }else{
                        
                        if (goodModel.business_confirm.integerValue == 0) {
                            stateText = @"已发货，待商家收货";
                            modvc.orderinformationArray  =@[
                                                            @"",
                                                            @"",
                                                            @"等待商家确认收货"
                                                            ];
                        }else{
                            stateText = @"商家已确认收货，等待退款";
                            modvc.orderinformationArray  =@[
                                                            @"",
                                                            @"",
                                                            @"商家已确认收货，等待退款"
                                                            ];
                            //是否退款成功
                            if (orderModel.pay_refund.integerValue == 2&&orderModel.pay_status.integerValue == 3) {
                                stateText = @"退款成功，交易关闭";
                                modvc.orderinformationArray  =@[
                                                                @"",
                                                                @"",
                                                                @"退款成功，交易关闭"
                                                                ];
                            }
                            
                        }
                        
                    }
                }
                    break;
                case 2:
                {
                    stateText = @"商家拒绝，等待用户处理";
                    modvc.orderinformationArray  =@[
                                                    @"",
                                                    @"",
                                                    @"退款失败，待用户处理"
                                                    ];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    return stateText;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recommendDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    
    ShoppingCarLatestRecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyOrderListRecommendCellID forIndexPath:indexPath];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    cell.GeneralGoodsModel = self.recommendDataSource[indexPath.row];
    gridcell = cell;
    
    return gridcell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionReusableViewID forIndexPath:indexPath];
        if (headerView.subviews.count >0) {
            [headerView removeAllSubviews];
        }
        CGFloat recommendImgH = 24;
        CGFloat marginY = 10;
        CGFloat noticeLabelH = 20;
        
        UIImageView *recommendImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,230 - recommendImgH - (50 - recommendImgH)/2, SCREEN_WIDTH - 80, recommendImgH)];
        recommendImageView.centerX = headerView.centerX;
        [recommendImageView setImage:[UIImage imageNamed:@"zuixintuijian"]];
        [headerView addSubview:recommendImageView];
        //提示文字
        UILabel *noticeLabel = [UILabel new];
        noticeLabel.font = Font(12);
        noticeLabel.text = @"您还没有相关订单噢~去逛逛吧~";
        [noticeLabel sizeToFit];
        noticeLabel.frame = CGRectMake((ScreenW - noticeLabel.frame.size.width)/2, CGRectGetMinY(recommendImageView.frame) - noticeLabelH - marginY, noticeLabel.frame.size.width, noticeLabelH);
        [headerView addSubview:noticeLabel];
        //提示图片
        UIImageView *noticeImgView = [UIImageView new];
        noticeImgView.frame = CGRectMake((ScreenW - 130)/2, 10, 170, 130);
        noticeImgView.image = UIImageNamed(@"noOrderStatus");
        [headerView addSubview:noticeImgView];
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        
    }
    
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((SCREEN_WIDTH - 5)/2, (SCREEN_WIDTH - 5)/2 + 80);
    
}


#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 50 + 130 + 20 + 30); //图片滚动的宽高
    
}


/**
 这里我用代理设置以下间距 感兴趣可以自己调整值看看差别
 */
#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4 ;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4 ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了推荐的第%zd个商品",indexPath.row);
    GeneralGoodsModel *model = self.recommendDataSource[indexPath.row];
    
    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
    dcgdvc.goods_id = model.goods_id;
    [self.navigationController pushViewController:dcgdvc animated:YES];
}











@end
