//
//  OnlineOrderLIstViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OnlineOrderListViewController.h"
//#import "OrderListTableViewCell.h"
#import "StoreDisplayViewController.h"
#import "MyOrderDetailsViewController.h"
#import "PayChangeViewController.h"
#import "DetailsRefundViewController.h"
#import "MyViewController.h"
#import "OnlineOrderListTableViewCell.h"

@interface OnlineOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation OnlineOrderListViewController

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
    
    self.navigationItem.title=@"线上订单";
    
}

- (void)configUI {
    
    UITableView *table =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - NAVI_HEIGHT) style:UITableViewStyleGrouped];
    
    if (@available(iOS 11.0, *)) {
        table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    table.tableFooterView = [UIView new];
    table.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self.view addSubview:table];
    
    table.dataSource = self;
    
    table.delegate = self;
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    table.showsVerticalScrollIndicator = NO;
    
    table.sectionHeaderHeight = 0;
    table.sectionFooterHeight = 10;
    
    table.estimatedSectionHeaderHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedRowHeight = 0;
    
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.table = table;
    [table registerClass:[OnlineOrderListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //            if (i != 0) {
        dict[@"type"] = @(self.index).description;
        //            }
        [HttpRequest postWithTokenURLString:NetRequestUrl(onlineorder) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            
            if ([res[@"code"] integerValue] == 1) {
                NSArray *temp = [OrderListModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
                if (temp.count) {
                    self.dataArray = [temp mutableCopy];
                    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        OrderListModel *model=obj;
                        if (model.user_cancel.intValue==2) {
                            [self.dataArray removeObject:obj];
                        }
                    }];
                    [self.table.mj_footer endRefreshing];
                }else{
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                }
                [self.table.mj_header endRefreshing];
                [self.table reloadData];
            }
        } failure:^(NSError *error){
            if ([self.table.mj_header isRefreshing]) {
                [self.table.mj_header endRefreshing];
            }
            if ([self.table.mj_footer isRefreshing]) {
                [self.table.mj_footer endRefreshing];
            }
        } RefreshAction:nil];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //        if (i != 0) {
        dict[@"type"] = @(self.index).description;
        //        }
        dict[@"page"] = @(++self.page).description;
        [HttpRequest postWithTokenURLString:NetRequestUrl(onlineorder) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
            
            if ([res[@"code"] integerValue] == 1) {
                
                NSArray *temp = [OrderListModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
                
                if (temp.count) {
                    self.dataArray = [[self.dataArray arrayByAddingObjectsFromArray:temp] mutableCopy];
                    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        OrderListModel *model=obj;
                        if (model.user_cancel.intValue==2) {
                            [self.dataArray removeObject:obj];
                        }
                    }];
                    [self.table.mj_footer endRefreshing];
                }else{
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.table reloadData];
            }
            
        } failure:^(NSError *error){
            if ([self.table.mj_footer isRefreshing]) {
                [self.table.mj_footer endRefreshing];
            }
        } RefreshAction:nil];
    }];
    
    [self.table.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].goods_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnlineOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
    OrderListModel *model = self.dataArray[section];
    //商品模型
    GoodListModel *glmodel = model.goods_list[0];
    
    UIButton *headBtn = [[UIButton alloc] init];
    [headBtn setImage:[UIImage imageNamed:@"dingdandianpu"] forState:UIControlStateNormal];
    [headBtn setTitle:[NSString stringWithFormat:@"%@ >",glmodel.name] forState:UIControlStateNormal];
    [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headBtn.titleLabel.font=PFR12Font;
    NSString *business_idstring=@"1334";
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
    
    //判断是退款售后中的还是普通状态的
    if (self.index==5) {
        
        if (model.pay_refund.intValue==1&&model.shipping_status.intValue==0&&model.business_status.intValue==0){
            stateLabel.text = @"待发货,退款中";
        }else if (model.pay_refund.intValue==2&&model.shipping_status.intValue==1&&model.business_status.intValue==1){
            stateLabel.text = @"退款成功,交易关闭";
        }else if (model.pay_refund.intValue==1&&model.shipping_status.intValue==0&&model.business_status.intValue==2){
            stateLabel.text = @"待发货,退款失败";
        }else if (model.pay_refund.intValue==1&&model.shipping_status.intValue==1&&model.business_status.intValue==0){
            stateLabel.text = @"待收货,退款中";
        }else if (model.pay_refund.intValue==1&&model.shipping_status.intValue==1&&model.business_status.intValue==2){
            stateLabel.text = @"待收货,退款失败";
        }
        
    } else {
        
        
        if(model.order_status.intValue==0&&model.shipping_status.intValue==0&&model.pay_status.intValue==0){
            stateLabel.text = @"待付款";
        }else if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.shipping_status.intValue==0&&model.pay_status.intValue==1){
            stateLabel.text = @"待发货";
        }else if (model.order_status.intValue==1&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
            stateLabel.text = @"待收货";
        }else if (model.order_status.intValue==2&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
            stateLabel.text = @"已完成";
        }else if (model.pay_refund.integerValue == 2){
            stateLabel.text = @"退款完成,交易关闭";
        }
        
    }
    
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.textColor = [UIColor colorWithHexString:@"d40000"];
    [headview addSubview:stateLabel];
    stateLabel.sd_layout
    .centerYEqualToView(headview)
    .rightSpaceToView(headview, 15)
    .autoHeightRatio(0);
    [stateLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    
    return headview;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [footview setBackgroundColor:[UIColor whiteColor]];
    
    OrderListModel *model=self.dataArray[section];
    
    UILabel * itemCountLabel = [UILabel new];
    itemCountLabel.text = [NSString stringWithFormat:@"共%@件",model.all_num];
    itemCountLabel.font = kFont(13);
    itemCountLabel.textColor = kColor333;
    [footview addSubview:itemCountLabel];
    itemCountLabel.sd_layout
    .rightSpaceToView(footview, 10)
    .topSpaceToView(footview, 10)
    .autoHeightRatio(0);
    [itemCountLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    UILabel *alabel = [UILabel new];
    alabel.font = kFont(13);
    alabel.textColor = kColor333;
    alabel.text = @"合计：";
    [footview addSubview:alabel];
    alabel.sd_layout
    .centerYEqualToView(itemCountLabel)
    .leftSpaceToView(footview, 15)
    .autoHeightRatio(0);
    [alabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    UILabel * sumLabel = [UILabel new];
    sumLabel.text = [NSString stringWithFormat:@"￥%.2f",model.order_amount];
    sumLabel.font = kFont(15);
    sumLabel.textColor = [UIColor colorWithHexString:@"d40000"];
    [footview addSubview:sumLabel];
    sumLabel.sd_layout
    .centerYEqualToView(alabel)
    .leftSpaceToView(alabel, 0)
    .autoHeightRatio(0);
    [sumLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    
    UILabel * postLabel = [UILabel new];
    postLabel.text = [NSString stringWithFormat:@"（含运费￥%@）",model.shipping_price];
    postLabel.font = kFont(13);
    postLabel.textColor = kColor333;
    [footview addSubview:postLabel];
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
    
    //    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.layer.cornerRadius = 3;
    //    rightBtn.titleLabel.font = kFont(15);
    //    rightBtn.layer.borderWidth = 1;
    //    rightBtn.layer.borderColor = [UIColor colorWithHexString:@"d40000"].CGColor;
    //    [rightBtn setTitleColor:[UIColor colorWithHexString:@"d40000"] forState:UIControlStateNormal];
    //    rightBtn.tag=section;
    //
    //    UIButton * leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftBtn.layer.cornerRadius = 3;
    //    leftBtn.titleLabel.font = kFont(15);
    //    leftBtn.layer.borderWidth = 1;
    //    leftBtn.layer.borderColor = kDefaultBGColor.CGColor;
    //    [leftBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    //    leftBtn.tag=section;
    
    //判断是不是退款售后的退款售后的按钮状态只有一个查看详情 如果是其他状态的再进行判断
    //    if (self.index==5) {
    //
    //        [rightBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    //        [footview addSubview:rightBtn];
    //        [leftBtn removeFromSuperview];
    //
    //    } else {
    //        if(model.order_status.intValue==0&&model.shipping_status.intValue==0&&model.pay_status.intValue==0){
    //            [rightBtn setTitle:@"去付款" forState:UIControlStateNormal];
    //            [footview addSubview:rightBtn];
    //            [leftBtn removeFromSuperview];
    //        }else if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.shipping_status.intValue==0&&model.pay_status.intValue==1){
    //            if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==0&&model.business_status.intValue==0) {
    //                [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //                [rightBtn setTitle:@"催促发货" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [footview addSubview:leftBtn];
    //            } else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
    //                [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [leftBtn removeFromSuperview];
    //            }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==1){
    //                [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [leftBtn removeFromSuperview];
    //            }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
    //                [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [leftBtn removeFromSuperview];
    //            }
    //        }else if (model.order_status.intValue==1&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
    //            if (model.order_status.intValue==1&&model.pay_refund.intValue==0&&model.business_status.intValue==0) {
    //                [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //                [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [footview addSubview:leftBtn];
    //            } else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
    //                [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //                [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [footview addSubview:leftBtn];
    //            }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==1){
    //                [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [leftBtn removeFromSuperview];
    //            }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
    //                [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //                [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    //                [footview addSubview:rightBtn];
    //                [footview addSubview:leftBtn];
    //            }
    //        }else if (model.order_status.intValue==2&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
    //            [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    //            [footview addSubview:rightBtn];
    //            [leftBtn removeFromSuperview];
    //        }
    //
    //    }
    //
    //    rightBtn.sd_layout
    //    .topSpaceToView(newlineLabel, 5)
    //    .rightSpaceToView(footview, 15)
    //    .widthIs(80)
    //    .heightIs(25);
    //
    //    leftBtn.sd_layout
    //    .topSpaceToView(newlineLabel, 5)
    //    .rightSpaceToView(rightBtn, 15)
    //    .widthIs(80)
    //    .heightIs(25);
    //
    //    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
   /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderListModel *model=self.dataArray[indexPath.section];
    
    MyOrderDetailsViewController *modvc=[[MyOrderDetailsViewController alloc]init];
    modvc.noShowBot = YES;
    if (self.index==5) {
        
        DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
        drvc.noShowBot = YES;
        drvc.refundordersnString=model.order_sn;
        [self.navigationController pushViewController:drvc animated:YES];
        
    } else {
        if(model.order_status.intValue==0&&model.shipping_status.intValue==0&&model.pay_status.intValue==0){
            modvc.btntextstring=@"去付款";
            modvc.orderinformationArray=@[@"daifukuan_icon",@"待付款",@"订单为您保留7天,超时后将自动关闭交易"];
        }else if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.shipping_status.intValue==0&&model.pay_status.intValue==1){
            if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==0&&model.business_status.intValue==0) {
                modvc.btntextstring=@"催促发货";
                modvc.orderinformationArray=@[@"daifahuo_icon",@"待发货",@"您的订单已支付成功,商家将在规定时间内完成发货"];
            } else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
                modvc.btntextstring=@"查看物流";
                modvc.orderinformationArray=@[@"yiwancheng_icon",@"已完成",@"您已确认收货"];
            }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==1){
                modvc.btntextstring=@"删除订单";
                modvc.orderinformationArray=@[@"yiguanbi_icon",@"已关闭",@"买家主动取消订单"];
            }else  if ((model.order_status.intValue==0||model.order_status.intValue==1)&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
                modvc.btntextstring=@"查看物流";
                modvc.orderinformationArray=@[@"yiwancheng_icon",@"已完成",@"您已确认收货"];
            }
            modvc.isshowrefundBtnString=@"show";
        }else if (model.order_status.intValue==1&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
            if (model.order_status.intValue==1&&model.pay_refund.intValue==0&&model.business_status.intValue==0) {
                modvc.btntextstring = @"确认收货";
                modvc.orderinformationArray=@[@"daishouhuo_icon",@"待收货",@"您的包裹已出库,还剩16天自动确认"];
            } else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==0){
                modvc.btntextstring=@"确认收货";
                modvc.orderinformationArray=@[@"daishouhuo_icon",@"待收货",@"您的包裹已出库,还剩16天自动确认"];
            }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==1){
                modvc.btntextstring=@"删除订单";
                modvc.orderinformationArray=@[@"yiguanbi_icon",@"已关闭",@"买家主动取消订单"];
            }else  if (model.order_status.intValue==1&&model.pay_refund.intValue==1&&model.business_status.intValue==2){
                modvc.btntextstring=@"确认收货";
                modvc.orderinformationArray=@[@"daishouhuo_icon",@"待收货",@"您的包裹已出库,还剩16天自动确认"];
            }
            modvc.isshowrefundBtnString=@"show";
        }else if (model.order_status.intValue==2&&model.shipping_status.intValue==1&&model.pay_status.intValue==1){
            modvc.btntextstring=@"查看物流";
            modvc.orderinformationArray=@[@"yiwancheng_icon",@"已完成",@"您已确认收货"];
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
    GoodListModel *glmodel=olmodel.goods_list[0];
    
    SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
    smvc.logisticsTypeString = glmodel.shipping_code;
    smvc.logisticsNoString = glmodel.invoice_no;
    smvc.categorynameNumString=@"TradeLogistics";
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)rightBtnClick:(UIButton *)btn{
    
    OrderListModel *olmodel=self.dataArray[btn.tag];
    GoodListModel *glmodel=olmodel.goods_list[0];
    
    if (self.index==5) {
        
        DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
        drvc.refundordersnString=olmodel.order_sn;
        [self.navigationController pushViewController:drvc animated:YES];
        
    } else {
        
        if ([btn.titleLabel.text isEqualToString:@"去付款"]) {
            MyOrderDetailsViewController *modvc=[[MyOrderDetailsViewController alloc]init];
            modvc.order_snstring=olmodel.order_sn;
            modvc.btntextstring=@"去付款";
            modvc.orderinformationArray=@[@"daifukuan_icon",@"待付款",@"订单为您保留7天,超时后将自动关闭交易"];
            [self.navigationController pushViewController:modvc animated:YES];
        }else if ([btn.titleLabel.text isEqualToString:@"催促发货"]){
            LRToast(@"催促发货提交成功,请耐心等待");
        }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]){
            
            SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
            smvc.logisticsTypeString = glmodel.shipping_code;
            smvc.logisticsNoString = glmodel.invoice_no;
            smvc.categorynameNumString=@"TradeLogistics";
            [self.navigationController pushViewController:smvc animated:YES];
            
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
                           isShowToastd:(BOOL)NO
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
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
    };
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
