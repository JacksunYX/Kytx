//
//  MyOrderListViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MyOfflineOrderViewController.h"
#import "OfflineOrdersTableViewCell.h"
#import "StoreDisplayViewController.h"
#import "MyOrderDetailsViewController.h"
#import "PayChangeViewController.h"
#import "DetailsRefundViewController.h"
#import "MyViewController.h"
#import "OfflineOrdersModel.h"
#import "CancelOrderPopoverView.h"
#import "GoPayViewController.h"

@interface MyOfflineOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<OfflineOrdersModel *>*dataArray;
@end

@implementation MyOfflineOrderViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //返回及时刷新数据
    [self configUI];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    
    self.navigationItem.title=@"我的线下订单";
    
    //重写返回方法点击返回直接返回到个人中心页面
//    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"BACK" hightimage:@"BACK" andTitle:@""];
    
    //    [self configUI];
    
}

- (void)configUI {
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    
    //    if (@available(iOS 11.0, *)) {
    //        table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    } else {
    //        // Fallback on earlier versions
    //    }
    
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
    [table registerClass:[OfflineOrdersTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(order_goods_offline) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
          
            if ([res[@"code"] integerValue] == 1) {
                self.dataArray = [OfflineOrdersModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
                [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    OfflineOrdersModel *model=obj;
                    if (kStringIsEmpty(model.order_sn)) {
                        [self.dataArray removeObject:obj];
                    }
                }];
            }
            
            [self.table.mj_header endRefreshing];
            [self.table.mj_footer endRefreshing];
            [self.table reloadData];
        } failure:nil RefreshAction:nil];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //        if (i != 0) {
//        dict[@"type"] = @(self.index).description;
        //        }
        dict[@"page"] = @(++self.page).description;
        [HttpRequest postWithTokenURLString:NetRequestUrl(order_goods_offline) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                
                NSArray *temp = [OfflineOrdersModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
                if (temp.count > 0) {
                    self.dataArray = [[self.dataArray arrayByAddingObjectsFromArray:temp] mutableCopy];
                    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        OfflineOrdersModel *model=obj;
                        if (kStringIsEmpty(model.order_sn)) {
                            [self.dataArray removeObject:obj];
                        }
                    }];
                    [self.table.mj_footer endRefreshing];
                }else{
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                }
                
            }else{
                [self.table.mj_footer endRefreshing];
            }
            
            [self.table reloadData];
        } failure:nil RefreshAction:nil];
    }];
    
    [self.table.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    OfflineOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    kArrayIsEmpty(self.dataArray)?:[cell setOfflineOrdersModel:self.dataArray[indexPath.section]];
//    [cell.contentView setBackgroundColor:BACKVIEWCOLOR];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [headview setBackgroundColor:[UIColor whiteColor]];
    
    //订单模型
    OfflineOrdersModel *model=self.dataArray[section];
    //商品模型
    //    GoodListModel *glmodel=model.goods_list[0];
    
    UIButton *headBtn = [[UIButton alloc] init];
    [headBtn setImage:[UIImage imageNamed:@"dingdandianpu"] forState:UIControlStateNormal];
    [headBtn setTitle:[NSString stringWithFormat:@"%@ >",model.name] forState:UIControlStateNormal];
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
        if(model.is_go.intValue==0){
            stateLabel.text = @"待付款";
        }else if (model.is_go.intValue==1){
            stateLabel.text = @"已完成";
        }
        
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.textColor = [UIColor colorWithHexString:@"d40000"];
    [headview addSubview:stateLabel];
    stateLabel.sd_layout
    .centerYEqualToView(headview)
    .rightSpaceToView(headview, 15)
    .autoHeightRatio(0);
    [stateLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    UIView *line = [UIView new];
    
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [headview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headview);
        make.height.mas_equalTo(0.5);
    }];
    
    
    return headview;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [footview setBackgroundColor:[UIColor whiteColor]];
    
    OfflineOrdersModel *model=self.dataArray[section];
    
//    UILabel * itemCountLabel = [UILabel new];
//    itemCountLabel.text = [NSString stringWithFormat:@"共%@件",model.all_num];
//    itemCountLabel.font = kFont(13);
//    itemCountLabel.textColor = kColor333;
//    [footview addSubview:itemCountLabel];
//    itemCountLabel.sd_layout
//    .rightSpaceToView(footview, 10)
//    .topSpaceToView(footview, 10)
//    .autoHeightRatio(0);
//    [itemCountLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
//
//    UILabel * postLabel = [UILabel new];
//    postLabel.text = [NSString stringWithFormat:@"（含运费￥%@）",model.shipping_price];
//    postLabel.font = kFont(13);
//    postLabel.textColor = kColor333;
//    [footview addSubview:postLabel];
//    postLabel.sd_layout
//    .centerYEqualToView(itemCountLabel)
//    .rightSpaceToView(itemCountLabel, 0)
//    .autoHeightRatio(0);
//    [postLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
//
//    UILabel * sumLabel = [UILabel new];
//    sumLabel.text = [NSString stringWithFormat:@"￥%.2f",model.order_amount];
//    sumLabel.font = kFont(15);
//    sumLabel.textColor = [UIColor colorWithHexString:@"d40000"];
//    [footview addSubview:sumLabel];
//    sumLabel.sd_layout
//    .centerYEqualToView(postLabel)
//    .rightSpaceToView(postLabel, 0)
//    .autoHeightRatio(0);
//    [sumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
//
//    UILabel *alabel = [UILabel new];
//    alabel.font = kFont(13);
//    alabel.textColor = kColor333;
//    alabel.text = @"合计：";
//    [footview addSubview:alabel];
//    alabel.sd_layout
//    .centerYEqualToView(sumLabel)
//    .rightSpaceToView(sumLabel, 0)
//    .autoHeightRatio(0);
//    [alabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
//
//    UILabel *newlineLabel=[[UILabel alloc]init];
//    [newlineLabel setBackgroundColor:BACKVIEWCOLOR];
//    [footview addSubview:newlineLabel];
//    newlineLabel.sd_layout
//    .topSpaceToView(itemCountLabel, 10)
//    .leftEqualToView(footview)
//    .rightEqualToView(footview)
//    .heightIs(1);
    
    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.titleLabel.font = kFont(15);
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.borderColor = [UIColor colorWithHexString:@"d40000"].CGColor;
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"d40000"] forState:UIControlStateNormal];
    rightBtn.tag=section;
    
    UIButton * leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.layer.cornerRadius = 3;
    leftBtn.titleLabel.font = kFont(15);
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = kDefaultBGColor.CGColor;
    [leftBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    leftBtn.tag=section;
        if(model.is_go.intValue==0){
            [rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [footview addSubview:rightBtn];
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [footview addSubview:leftBtn];
        }else if (model.is_go.intValue==1){
            [rightBtn setTitle:@"交易成功" forState:UIControlStateNormal];
            [footview addSubview:rightBtn];
            [leftBtn removeFromSuperview];
        }
        
    
    rightBtn.sd_layout
    .centerYEqualToView(footview)
    .rightSpaceToView(footview, 15)
    .widthIs(80)
    .heightIs(25);
    
    leftBtn.sd_layout
    .centerYEqualToView(footview)
    .rightSpaceToView(rightBtn, 15)
    .widthIs(80)
    .heightIs(25);
    
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)headBtnClick:(UIButton *)btn{
    StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
    sdvc.business_idstring=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:sdvc animated:YES];
}
-(void)leftBtnClick:(UIButton *)btn{
    
    OfflineOrdersModel *olmodel=self.dataArray[btn.tag];
//    GoodListModel *glmodel=olmodel.goods_list[0];
    
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

}
-(void)rightBtnClick:(UIButton *)btn{
    
    OfflineOrdersModel *olmodel=self.dataArray[btn.tag];
//    GoodListModel *glmodel=olmodel.goods_list[0];
    
    if ([btn.titleLabel.text isEqualToString:@"去付款"]) {
        
//    MyOrderDetailsViewController *modvc=[[MyOrderDetailsViewController alloc]init];
//    modvc.order_snstring=olmodel.order_sn;
//    modvc.btntextstring=@"去付款";
//    modvc.orderinformationArray=@[@"daifukuan_icon",@"待付款",@"订单为您保留7天,超时后将自动关闭交易"];
//    [self.navigationController pushViewController:modvc animated:YES];

        GoPayViewController *gpvc=[[GoPayViewController alloc]init];
        gpvc.type=@"4";
        gpvc.price=olmodel.money;
        gpvc.tn=olmodel.order_sn;
        
        [self.navigationController pushViewController:gpvc animated:YES];
        
    }else if ([btn.titleLabel.text isEqualToString:@"交易成功"]){
        
    }
    
}

-(void)deleteOrder:(NSString *)order_snstring{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:kStringIsEmpty(order_snstring)?@"":order_snstring forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(deleteOfflineOrder) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
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

- (void)back{
    
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[MyViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
    
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

