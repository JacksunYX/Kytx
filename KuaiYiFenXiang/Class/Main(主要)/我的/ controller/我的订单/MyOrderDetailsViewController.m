//
//  AllOrdersViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "MyOrderDetailsViewController.h"
#import "SeleteAddressModel.h"
#import "SeleteAddressTableViewCell.h"

#import "OrderGoodsModel.h"
#import "OrderGoodsTableViewCell.h"

#import "AddressViewController.h"
#import "StoreDisplayViewController.h"

#import "KYAddressModel.h"

#import "CancelOrderPopoverView.h"

#import "ToApplyForARefundViewController.h"

#import "PayChangeViewController.h"

#import "MyOrderViewController.h"
#import "AreaModel.h"
#import "DetailsRefundViewController.h"

#import "OrderListModel.h"

#import "LogisticsTimelineModel.h"

//组合支付页面
#import "GroupPayViewController.h"

@interface MyOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *addressdataSource;

@property(nonatomic,strong) NSArray *lefttextarray;
@property(nonatomic,strong) NSArray *righttextarray;

//组合支付
@property(nonatomic,strong) NSArray *payimgarray;
@property(nonatomic,strong) NSArray *paytextarray;
@property(nonatomic,strong) NSMutableArray *payselectarray;
//支付方式
@property(nonatomic,strong) NSArray *thirdPayImgArray;
@property(nonatomic,strong) NSArray *thirdPayTextArray;
@property(nonatomic,strong) NSMutableArray *thirdPaySelectArray;

@property(nonatomic,strong) UIView *bottomview;

@property (nonatomic, strong) UIButton *payselectButton;
@property (nonatomic, strong) UIImageView *payImageview;
@property (nonatomic, strong) UILabel *paytextLabel;
@property (nonatomic, strong) UILabel *paySubtextLabel;
@property (nonatomic, strong) UIImageView *paysmallImageview;

@property(nonatomic,strong) NSMutableArray *business_infoarray;
@property(nonatomic,strong) NSMutableArray *order_goodsarray;

@property(nonatomic,strong) NSArray *payinformationarray;

@property (nonatomic, assign) BOOL canPush;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MyOrderDetailsViewController{
    
    UITableView*mytableview;
    UIButton * rightBtn;
    UIButton * centerBtn;
    UIButton * leftBtn;
    NSString *realpaymentstring;
    
    NSString *currentBalance;   //用户当前余额
    NSString *consume_money;    //消费余额
    NSString *money;            //余额(可以提现的)
    
    BOOL showPaySection;    //是否显示支付分区
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    //设置自己的表视图
    if (self.noShowBot) {
        mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT) style:UITableViewStyleGrouped];
    } else {
        mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-44-BOTTOM_MARGIN) style:UITableViewStyleGrouped];
    }
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    mytableview.estimatedRowHeight = 0;
    mytableview.estimatedSectionFooterHeight = 0;
    mytableview.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:mytableview];
    
    showPaySection = [self.btntextstring isEqualToString:@"去付款"];
    
    //组合支付
    self.payimgarray = @[@"yue"];
    self.paytextarray = @[@"余额"];
    self.payselectarray = [@[@"0"] mutableCopy];
    
    
    if (ShowUPPay) {
        self.thirdPayImgArray = @[@"zhifubao",@"yinlian"];
        self.thirdPayTextArray = @[@"支付宝",@"银联"];
        self.thirdPaySelectArray = [@[@"1",@"0"] mutableCopy];
    }else{
        self.thirdPayImgArray = @[@"zhifubao"];
        self.thirdPayTextArray = @[@"支付宝"];
        self.thirdPaySelectArray = [@[@"1"] mutableCopy];
    }
    
    if (showPaySection) {
        [self getUserBalance];
    }
    //    currentBalance = @"";
    
    [self loadData];
    
}

- (void)loadData {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"area.plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:docPath];
    if (!arr || arr.count == 0) {
        [HttpRequest postWithURLString:NetRequestUrl(arealist) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                NSArray *temp = res[@"result"];
                [temp writeToFile:docPath atomically:YES];
                [self loadData];
            }
        } failure:nil RefreshAction:nil];
    } else {
        //在页面加载完成请求数据
        self.dataArray = [AreaModel mj_objectArrayWithKeyValuesArray:arr];
        [self loadupdata];
    }
    
    
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)loadupdata{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:kStringIsEmpty(self.order_snstring)?@"":self.order_snstring forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(orderDetail) parameters:requestdic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        
                                        self.lefttextarray=@[
                                                             @"商品总额",
                                                             @"总运费",
                                                             @"余额使用(含消费余额)",
                                                             @"支付宝支付",
                                                             
                                                             @"实付款",
                                                             ];
                                        
                                        NSString *total_amountstring=[result objectForKey:@"total_amount"];
                                        NSString *shipping_pricestring=[result objectForKey:@"shipping_price"];
                                        realpaymentstring=[result objectForKey:@"order_amount"];
                                        self.righttextarray=@[
                                                              [NSString stringWithFormat:@"￥%.2f",total_amountstring.floatValue],
                                                              [NSString stringWithFormat:@"¥%.2f", shipping_pricestring.floatValue],
                                                              [NSString stringWithFormat:@"￥%.2f",[result[@"gold_money"] floatValue]],
                                                              [NSString stringWithFormat:@"￥%.2f",[result[@"ali_money"] floatValue]],
                                                              
                                                              [NSString stringWithFormat:@"¥%.2f",realpaymentstring.floatValue]];
                                        
                                        NSString *addtimestring=[result objectForKey:@"add_time"];
                                        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
                                        if (interval - addtimestring.integerValue <= 3600 * 48) {
                                            self.canPush = NO;
                                        } else {
                                            self.canPush = YES;
                                        }
                                        self.payinformationarray = @[
                                                                     [NSString stringWithFormat:@"下单时间:%@",[NSString_Category Timestamptofixedformattime:@"YYYY-MM-dd HH:mm:ss" andTimeInterval:addtimestring.integerValue]], /*[NSString stringWithFormat:@"支付方式:%@",[result objectForKey:@"pay_name"]],*/
                                                    [NSString stringWithFormat:@"订单编号:%@",[result objectForKey:@"order_sn"]]];
                                        
                                        _resultdic=[result mutableCopy];
                                        [self setbottomview];
                                        [self loadNewData];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

//进行数据的请求
-(void)loadNewData{
    
    NSLog(@"result-----%@,self.orderinformationArray-----%@",_resultdic,self.orderinformationArray);
    
    //每次进行数据请求初始化数组
    self.addressdataSource=[NSMutableArray array];
    
    NSString *addres_string;
    
    NSString *province;
    NSString *city;
    NSString *district;
    NSString *address = _resultdic[@"address"];
    
    for (AreaModel *model in self.dataArray) {
        if (kStringIsEmpty(_resultdic[@"province"])) {
            break;
        }
        if (kStringIsEmpty(_resultdic[@"city"])) {
            break;
        }
        if (kStringIsEmpty(_resultdic[@"district"])) {
            break;
        }
        if ([model.area_id isEqualToString:_resultdic[@"province"]]) {
            province = model.name;
        }
        
        if ([model.area_id isEqualToString:_resultdic[@"city"]]) {
            city = model.name;
        }
        
        if ([model.area_id isEqualToString:_resultdic[@"district"]]) {
            district = model.name;
        }
    }
    
    addres_string = [NSString stringWithFormat:@"%@ %@ %@ %@", province, city, district, address];
    for (int i=0; i<2; i++) {
        NSString *temp;
        if (i == 0) {
            if ([_resultdic[@"order_status"] integerValue] == 2) {
                temp = self.orderinformationArray[2];
            } else {
                
                temp = !kStringIsEmpty([_resultdic objectForKey:@"auto_time"])? [_resultdic[@"business_status"] integerValue] == 1 ? @"请在退款售后中查看订单状态":[_resultdic objectForKey:@"auto_time"]: self.orderinformationArray[2];
                //                temp = [_resultdic objectForKey:@"auto_time"];
                if (![self.orderinformationArray[2] isEqualToString:@"您的包裹已出库,还剩199天自动确认"]) {
                    if ([self.orderinformationArray[2] isEqualToString:@"商家说明"]) {
                        temp = [@"商家留言" stringByAppendingString:_resultdic[@"business_note"]];
                    }
                    temp = self.orderinformationArray[2];
                }
            }
        }
        //        NSLog(@"temp:%@",temp);
        NSDictionary *addressdic = @{
                                     //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                     @"cellid":[NSString stringWithFormat:@"%@",kStringIsEmpty([_resultdic objectForKey:@"address_id"])?@"":[_resultdic objectForKey:@"address_id"]],
                                     
                                     @"bgUrlString":i==0?@"shouhuodizhibeijing":@"",
                                     @"leftsmalladdressUrlString":i==0?self.orderinformationArray[0]:@"dingwei",
                                     @"shouhuorenString":i==0?self.orderinformationArray[1]:kStringIsEmpty([_resultdic objectForKey:@"consignee"])?@"":[NSString stringWithFormat:@"收货人:%@",[_resultdic objectForKey:@"consignee"]],
                                     @"morensmallUrlString":i==0?@"":@"moren",
                                     @"phonenumString":i==0?@"":kStringIsEmpty([_resultdic objectForKey:@"mobile"])?@"":[_resultdic objectForKey:@"mobile"],
                                     @"shouhuoaddressString":i==0?temp:kStringIsEmpty([_resultdic objectForKey:@"address"])?@"":[NSString stringWithFormat:@"收货地址:%@",addres_string],
                                     @"rightsmallUrlString":@"",
                                     };
        
        //            //初始化模型
        SeleteAddressModel *addressmodel=[SeleteAddressModel mj_objectWithKeyValues:addressdic];
        //            //把模型添加到相应的数据源数组中
        [self.addressdataSource addObject:addressmodel];
        
    }
    
    self.business_infoarray=[NSMutableArray new];
    
    for (NSMutableDictionary * business_infodic in [_resultdic objectForKey:@"business_info"]) {
        self.order_goodsarray=[NSMutableArray new];
        NSMutableDictionary *mutabledc=[business_infodic mutableCopy];
        for (NSMutableDictionary * order_goodsdic in [_resultdic objectForKey:@"order_goods"]) {
            
            NSDictionary *ordergoodsdic = @{
                                            //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                            @"cellid":[NSString stringWithFormat:@"%@",[_resultdic objectForKey:@"order_sn"]],
                                            
                                            @"ordergoodsimgUrlString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"original_img"]],
                                            @"ordergoodstitleString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"goods_name"]],
                                            @"ordergoodsxianjiaString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"goods_price"]],
                                            
                                            @"ordergoodssubtitleString":order_goodsdic[@"spec_key_name"],
                                            
                                            @"ordergoodsyuanjiaString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"market_price"]],
                                            @"ordergoodscountString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"goods_num"]],
                                            @"ordergoodssmallimgUrlString":@"qitiantuikuan",
                                            @"isshowrefundBtnString":kStringIsEmpty(self.isshowrefundBtnString)?@"":self.isshowrefundBtnString,
                                            
                                            @"shipping_code":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"shipping_code"]],
                                            
                                            @"invoice_no":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"invoice_no"]],
                                            
                                            };
            
            //            //初始化模型
            OrderGoodsModel *ordergoodsmodel=[OrderGoodsModel mj_objectWithKeyValues:ordergoodsdic];
            //            //把模型添加到相应的数据源数组中
            [self.order_goodsarray addObject:ordergoodsmodel];
            
        }
        [mutabledc setObject:self.order_goodsarray forKey:@"order_goodsarray"];
        [self.business_infoarray addObject:mutabledc];
    }
    
    
    NSLog(@"%@",self.business_infoarray);
    
    //设置完成数据进行当前表视图的刷新
    [mytableview reloadData];
    
}

//获取当前用户的余额
-(void)getUserBalance
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [HttpRequest postWithTokenURLString:NetRequestUrl(mywallet) parameters:dic isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            currentBalance = [NSString stringWithFormat:@"%@",res[@"result"][@"total"]];
            if (currentBalance.floatValue == 0) {
                currentBalance = @"";
            }
            consume_money = [NSString stringWithFormat:@"%@",res[@"result"][@"consume_money"]];
            money = [NSString stringWithFormat:@"%@",res[@"result"][@"money"]];
            
            [mytableview reloadData];
        }
    } failure:nil RefreshAction:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (kStringIsEmpty(currentBalance)) {
        return self.business_infoarray.count + 4;
    }
    return self.business_infoarray.count + 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        
        return _addressdataSource.count;
        
    }else if(section==self.business_infoarray.count+1){
        
        return self.lefttextarray.count;
        
    }else if(section==self.business_infoarray.count+2){
        
        if (showPaySection) {
            if (kStringIsEmpty(currentBalance)) {
                return _thirdPayImgArray.count;
            }else{
                return _paytextarray.count;
            }
        }
        
        return 0;
        
    }else if(section==self.business_infoarray.count+3){
        
        if (showPaySection) {
            if (kStringIsEmpty(currentBalance)) {
                return _payinformationarray.count;
            }else{
                return _thirdPayImgArray.count;
            }
        }
        
        return _payinformationarray.count;
        
    }else if(section==self.business_infoarray.count+4){
        
        return _payinformationarray.count;
        
    }else{
        
        NSDictionary *dic=self.business_infoarray[section-1];
        NSArray *array=[dic objectForKey:@"order_goodsarray"];
        return array.count;
        
    }
}

//初始化当前表视图的每行的cell以及相应的表的属性设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        //通过cell的类方法直接初始化cell
        SeleteAddressTableViewCell *cell = [SeleteAddressTableViewCell mainTableViewCellWithTableView:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //根据相应的cell的行数进行每行cell的数据设置
        kArrayIsEmpty(self.addressdataSource)?:[cell setSeleteAddressModel:self.addressdataSource[indexPath.row]];
        return cell;
    }else  if(indexPath.section==self.business_infoarray.count+1||indexPath.section==self.business_infoarray.count+2||indexPath.section==self.business_infoarray.count+3||indexPath.section==self.business_infoarray.count+4){
        //防止cell重建引起卡顿
        // 定义唯一标识
        static NSString *CellIdentifier = @"UITableViewCell";
        // 通过唯一标识创建cell实例
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //分割线
        UIView *line = [UIView new];
        line.backgroundColor = CELLBORDERCOLOR;
        [cell.contentView addSubview:line];
        line.sd_layout
        .topSpaceToView(cell.contentView, 0.5)
        .leftEqualToView(cell.contentView)
        .rightEqualToView(cell.contentView)
        .heightIs(0.5)
        ;
        
        if (indexPath.section==self.business_infoarray.count+1) {
            
            if (indexPath.row==self.lefttextarray.count-1) {
                [cell.textLabel setFont:PFR15Font];
                [cell.detailTextLabel setFont:PFR15Font];
                [cell.textLabel setTextColor:[UIColor blackColor]];
                [cell.detailTextLabel setTextColor:[UIColor redColor]];
            }else{
                [line removeFromSuperview];
                [cell.textLabel setFont:PFR12Font];
                [cell.detailTextLabel setFont:PFR12Font];
                [cell.textLabel setTextColor:HexColor(666666)];
                [cell.detailTextLabel setTextColor:HexColor(666666)];
            }
            [cell.textLabel setText:self.lefttextarray[indexPath.row]];
            [cell.detailTextLabel setText:self.righttextarray[indexPath.row]];
            
        }else if (indexPath.section==self.business_infoarray.count+2){
            [line removeFromSuperview];
            if (self.noShowBot) {
                return cell;
            }
            if (kStringIsEmpty(currentBalance)) {
                [self setViewOnCell:cell indexPath:indexPath selectArr:self.thirdPaySelectArray payimgArr:self.thirdPayImgArray paytextArr:self.thirdPayTextArray];
            }else{
                [self setViewOnCell:cell indexPath:indexPath selectArr:self.payselectarray payimgArr:self.payimgarray paytextArr:self.paytextarray];
            }
            
        }else if (indexPath.section==self.business_infoarray.count+3){
            [line removeFromSuperview];
            if (!showPaySection&&!kStringIsEmpty(currentBalance)) {
                return cell;
            }
            if (kStringIsEmpty(currentBalance)) {
                [cell.textLabel setFont:PFR12Font];
                [cell.textLabel setTextColor:HexColor(999999)];
                [cell.textLabel setText:_payinformationarray[indexPath.row]];
            }else{
                [self setViewOnCell:cell indexPath:indexPath selectArr:self.thirdPaySelectArray payimgArr:self.thirdPayImgArray paytextArr:self.thirdPayTextArray];
            }
            
        }else if (indexPath.section==self.business_infoarray.count+4){
            [line removeFromSuperview];
            [cell.textLabel setFont:PFR12Font];
            [cell.textLabel setTextColor:HexColor(999999)];
            [cell.textLabel setText:_payinformationarray[indexPath.row]];
        }
        
        return cell;
        
    }else{
        //通过cell的类方法直接初始化cell
        OrderGoodsTableViewCell *cell = [OrderGoodsTableViewCell mainTableViewCellWithTableView:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView setBackgroundColor:BACKVIEWCOLOR];
        //根据相应的cell的行数进行每行cell的数据设置
        NSDictionary *dic=self.business_infoarray[indexPath.section-1];
        NSArray *array=[dic objectForKey:@"order_goodsarray"];
        kArrayIsEmpty(array)?:[cell setOrderGoodsModel:array[indexPath.row]];
        @weakify(self)
        cell.didClickrefundBtnHandler = ^(NSString *ordersnstring) {
            NSLog(@"ordersnstring-----%@",ordersnstring);
            @strongify(self)
            ToApplyForARefundViewController *tafrvc=[[ToApplyForARefundViewController alloc]init];
            tafrvc.refundamountString = realpaymentstring;
            tafrvc.refundordersnString = ordersnstring;
            tafrvc.isshowRefundPopView = self.isshowRefundPopView;
            [self.navigationController pushViewController:tafrvc animated:YES];
        };
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        //        return kArrayIsEmpty(self.addressdataSource)?0:[mytableview cellHeightForIndexPath:indexPath model:self.addressdataSource[indexPath.row] keyPath:@"SeleteAddressModel" cellClass:[SeleteAddressTableViewCell class] contentViewWidth:[self cellContentViewWith]];
        return 80;
    }else if(indexPath.section==self.business_infoarray.count+1){
        if (indexPath.row==self.lefttextarray.count-1) {
            return 44;
        }else{
            return 22;
        }
    }else if(indexPath.section==self.business_infoarray.count+2||indexPath.section==self.business_infoarray.count+3||indexPath.section==self.business_infoarray.count+4){
        if (self.noShowBot && indexPath.section==self.business_infoarray.count+2) {
            return 0;
        }
        //不显示余额支付时，只有4个分区
        if (kStringIsEmpty(currentBalance)) {
            
            if (indexPath.section == self.business_infoarray.count+2) {
                return 70;
            }
            
        }else{
            
            if (indexPath.section==self.business_infoarray.count+2||indexPath.section==self.business_infoarray.count+3) {
                return 70;
            }
            
        }
        return 44;
    }else{
        NSDictionary *dic=self.business_infoarray[indexPath.section-1];
        NSArray *array=[dic objectForKey:@"order_goodsarray"];
        return kArrayIsEmpty(array)?0:[mytableview cellHeightForIndexPath:indexPath model:array[indexPath.row] keyPath:@"OrderGoodsModel" cellClass:[OrderGoodsTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section!=0&&section!=self.business_infoarray.count+1&&section!=self.business_infoarray.count+3) {
    //        if (section == self.business_infoarray.count+2) {
    //            if (self.noShowBot) {
    //                return 0;
    //            }
    //            return [self.btntextstring isEqualToString:@"去付款"]?44:0.01;
    //        }else{
    //            return 44;
    //        }
    //    }else{
    //        return 0.01;
    //    }
    
    if (section == self.business_infoarray.count) {
        return 44;
    }else if (section == self.business_infoarray.count + 1) {
        
        if (showPaySection) {   //说明是未支付的订单
            return 0.01;
        }
        return 38;  //已支付的订单，需要展示支付方式
        
    }else if(section == self.business_infoarray.count + 2||section == self.business_infoarray.count + 3){
        //需要展示支付分区
        if (showPaySection) {
            //不显示余额
            if (kStringIsEmpty(currentBalance)) {
                if (section == self.business_infoarray.count + 3) {
                    return 0.01;
                }
            }
            return 44;
        }else{
            //不需要展示支付分区
            return 0.01;
        }
    }
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.business_infoarray.count+2) {
        return [self.btntextstring isEqualToString:@"去付款"]?10:0.01;
    }else{
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section!=0&&section!=self.business_infoarray.count+1) {
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [headview setBackgroundColor:[UIColor whiteColor]];
        
        if (section == self.business_infoarray.count) {
            
            NSDictionary *dic=self.business_infoarray[section-1];
            UIButton *headBtn = [[UIButton alloc] init];
            [headBtn setImage:[UIImage imageNamed:@"dingdandianpu"] forState:UIControlStateNormal];
            [headBtn setTitle:[NSString stringWithFormat:@"%@ >",[dic objectForKey:@"name"]] forState:UIControlStateNormal];
            [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            headBtn.titleLabel.font=PFR12Font;
            NSString *business_idstring=[dic objectForKey:@"business_id"];
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
            
            
            UIButton *dianhua=[[UIButton alloc]init];
            [dianhua setBackgroundImage:[UIImage imageNamed:@"xiaodianhua"] forState:UIControlStateNormal];
            [headview addSubview:dianhua];
            NSString *mobilestring=[dic objectForKey:@"mobile"];
            [dianhua setTag:mobilestring.intValue];
            [dianhua addTarget:self action:@selector(callphone:) forControlEvents:UIControlEventTouchUpInside];
            dianhua.sd_layout
            .rightSpaceToView(headview, 10)
            .centerYEqualToView(headview)
            .widthIs(15)
            .heightIs(15);
            
        }else{
            
            UILabel *titlelabel=[[UILabel alloc]init];
            [titlelabel setTextColor:[UIColor blackColor]];
            [titlelabel setFont:PFR15Font];
            [headview addSubview:titlelabel];
            titlelabel.sd_layout
            .centerYEqualToView(headview)
            .leftSpaceToView(headview, 20)
            .widthIs(SCREEN_WIDTH/2)
            .heightIs(headview.height);
            
            //分割线
            UIView *line = [UIView new];
            line.backgroundColor = CELLBORDERCOLOR;
            [headview addSubview:line];
            line.sd_layout
            .topSpaceToView(titlelabel, 0.5)
            .leftEqualToView(headview)
            .rightEqualToView(headview)
            .heightIs(0.5)
            ;
            
            //显示支付分区
            if (showPaySection) {// 2\3\4
                
                if (section == self.business_infoarray.count + 2) {
                    if (kStringIsEmpty(currentBalance)) {
                        [titlelabel setText:@"支付方式"];
                    }else{
                        [titlelabel setText:@"组合支付"];
                    }
                }else if(section == self.business_infoarray.count + 3){
                    if (kStringIsEmpty(currentBalance)) {
                        [titlelabel setText:@""];
                        [line removeFromSuperview];
                    }else{
                        [titlelabel setText:@"支付方式"];
                    }
                }else if(section == self.business_infoarray.count + 4){
                    [titlelabel setText:@""];
                    [line removeFromSuperview];
                }
                
            }else{  //2\3
                
                return nil;
            }
            
        }
        
        return headview;
        
    }else{
        //已支付
        if (!showPaySection&&section!=0) {
            UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
            [headview setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *titlelabel = [[UILabel alloc]init];
            [titlelabel setTextColor:HexColor(666666)];
            [titlelabel setFont:PFR12Font];
            [headview addSubview:titlelabel];
            titlelabel.sd_layout
            .centerYEqualToView(headview)
            .leftSpaceToView(headview, 15)
            .widthIs(SCREEN_WIDTH/2)
            .heightIs(headview.height);
            [titlelabel setText:@"支付方式"];
            
            UILabel *rightLabel = [[UILabel alloc]init];
            [rightLabel setTextColor:kColord40];
            [rightLabel setFont:PFR12Font];
            rightLabel.textAlignment = NSTextAlignmentRight;
            [headview addSubview:rightLabel];
            rightLabel.sd_layout
            .centerYEqualToView(headview)
            .rightSpaceToView(headview, 15)
            .widthIs(SCREEN_WIDTH/2)
            .heightIs(headview.height);
            
            //分割线
            UIView *line = [UIView new];
            line.backgroundColor = CELLBORDERCOLOR;
            [headview addSubview:line];
            line.sd_layout
            .topSpaceToView(titlelabel, 0.5)
            .leftEqualToView(headview)
            .rightEqualToView(headview)
            .heightIs(0.5)
            ;
            
            NSInteger payType = [self.resultdic[@"pay_array"] integerValue];
            if (payType == 1) {
                rightLabel.text = @"组合支付";
            }else{
                rightLabel.text = self.resultdic[@"pay_name"];
            }
            
            return headview;
            
        }
        return nil;
    }
    
}

//适配不同的机型大小
- (CGFloat)cellContentViewWith
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    
    return width;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (showPaySection) {
        if (indexPath.section == self.business_infoarray.count + 2) {
            
            if (kStringIsEmpty(currentBalance)) {   //说明只有第三方支付
                //顺序遍历
                [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    idx == indexPath.row?[_payselectarray replaceObjectAtIndex:idx withObject:@"1"]:[_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
                }];
                
            }else{  //组合支付
                //清除第三方支付的
                [_thirdPaySelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [_thirdPaySelectArray replaceObjectAtIndex:idx withObject:@"0"];
                }];
                //选中组合支付中的
                [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    idx == indexPath.row?[_payselectarray replaceObjectAtIndex:idx withObject:@"1"]:[_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
                }];
                
            }
            
            [mytableview reloadData];
            
        }else if (indexPath.section == self.business_infoarray.count + 3){
            //第三方支付选择
            //能够进入这里说明有组合支付
            //清空组合支付的
            [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
            }];
            //选中第三方
            [_thirdPaySelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                idx == indexPath.row?[_thirdPaySelectArray replaceObjectAtIndex:idx withObject:@"1"]:[_thirdPaySelectArray replaceObjectAtIndex:idx withObject:@"0"];
            }];
            
            [mytableview reloadData];
            
        }
    }
    
}


//通过传值修改类似cell上的显示
-(void)setViewOnCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath selectArr:(NSMutableArray *)payselectarray payimgArr:(NSArray *)payimgarray paytextArr:(NSArray *)paytextarray
{
    _payselectButton = [[UIButton alloc] init];
    [_payselectButton setImage:[UIImage imageNamed:@"normallgray"] forState:UIControlStateNormal];
    [_payselectButton setImage:[UIImage imageNamed:@"selectred"] forState:UIControlStateSelected];
    NSString *selstring = payselectarray[indexPath.row];
    [_payselectButton setSelected:selstring.intValue == 1?YES:NO];
    [cell.contentView addSubview:_payselectButton];
    self.payselectButton.sd_layout
    .centerYEqualToView(cell.contentView)
    .leftSpaceToView(cell.contentView, 20)
    .widthIs(11)
    .heightIs(11);
    
    _payImageview = [[UIImageView alloc] init];
    [_payImageview setImage:[UIImage imageNamed:payimgarray[indexPath.row]]];
    [cell.contentView addSubview:_payImageview];
    self.payImageview.sd_layout
    .centerYEqualToView(cell.contentView)
    .leftSpaceToView(_payselectButton, 10)
    .widthIs(40)
    .heightIs(40);
    
    _paytextLabel = [[UILabel alloc] init];
    _paytextLabel.font = PFR12Font;
    _paytextLabel.textColor=[UIColor blackColor];
    _paytextLabel.textAlignment=NSTextAlignmentLeft;
    _paytextLabel.contentMode=UIViewContentModeCenter;
    [_paytextLabel setText:paytextarray[indexPath.row]];
    [cell.contentView addSubview:_paytextLabel];
    
    _paySubtextLabel = [[UILabel alloc] init];
    _paySubtextLabel.font = PFR12Font;
    _paySubtextLabel.textColor = kColor999;
    _paySubtextLabel.textAlignment = NSTextAlignmentLeft;
    _paySubtextLabel.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:_paySubtextLabel];
    
    if ([_paytextLabel.text isEqualToString:@"余额"]) {
        self.paytextLabel.sd_layout
        .topEqualToView(_payImageview)
        .leftSpaceToView(_payImageview, 10)
        .autoHeightRatio(0);
        
        _paySubtextLabel.sd_layout
        .leftEqualToView(self.paytextLabel)
        .topSpaceToView(self.paytextLabel, 10)
        .rightSpaceToView(cell.contentView, 10)
        .autoHeightRatio(0)
        ;
        _paySubtextLabel.text = [NSString stringWithFormat:@"余额%@元，消费余额%@元",money,consume_money];
        
    }else{
        self.paytextLabel.sd_layout
        .centerYEqualToView(cell.contentView)
        .leftSpaceToView(_payImageview, 10)
        .autoHeightRatio(0);
    }
    [self.paytextLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
    
    _paysmallImageview = [[UIImageView alloc] init];
    if ([_paytextLabel.text isEqualToString:@"支付宝"]) {
        indexPath.row == 0?[_paysmallImageview setImage:[UIImage imageNamed:@"tuijian"]]:[_paysmallImageview setImage:[UIImage imageNamed:@""]];
    }
    
    [cell.contentView addSubview:_paysmallImageview];
    self.paysmallImageview.sd_layout
    .centerYEqualToView(cell.contentView)
    .leftSpaceToView(_paytextLabel, 10)
    .widthIs(30)
    .heightIs(15);
}


-(void)setbottomview{
    
    _bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVI_HEIGHT - 44 - BOTTOM_MARGIN, SCREEN_WIDTH,44+BOTTOM_MARGIN)];
    [_bottomview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomview];
    
    rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.titleLabel.font = kFont(15);
    rightBtn.layer.borderWidth = 1;
    rightBtn.layer.borderColor = [UIColor colorWithHexString:@"d40000"].CGColor;
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"d40000"] forState:UIControlStateNormal];
    
    centerBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.layer.cornerRadius = 3;
    centerBtn.titleLabel.font = kFont(15);
    centerBtn.layer.borderWidth = 1;
    centerBtn.layer.borderColor = kDefaultBGColor.CGColor;
    [centerBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    
    leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.layer.cornerRadius = 3;
    leftBtn.titleLabel.font = kFont(15);
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = kDefaultBGColor.CGColor;
    [leftBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    
    if ([self.btntextstring isEqualToString:@"去付款"]) {
        
        NSString *user_cancel=[NSString stringWithFormat:@"%@",[_resultdic objectForKey:@"user_cancel"]];
        
        if (user_cancel.intValue==0) {
            [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_bottomview addSubview:rightBtn];
            [centerBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [_bottomview addSubview:centerBtn];
            [leftBtn removeFromSuperview];
        } else if (user_cancel.intValue==1){
            [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_bottomview addSubview:rightBtn];
            [centerBtn removeFromSuperview];
            [leftBtn removeFromSuperview];
        }
        
    }else if ([self.btntextstring isEqualToString:@"确认收货"]){
        [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [centerBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_bottomview addSubview:centerBtn];
        [leftBtn setTitle:@"退款售后" forState:UIControlStateNormal];
        if([self.isshowrefundBtnString isEqualToString:@"NO"]) {
            leftBtn.hidden = YES;
        }
        [_bottomview addSubview:leftBtn];
    }else if ([self.btntextstring isEqualToString:@"查看物流"]){
        [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [centerBtn removeFromSuperview];
        [leftBtn removeFromSuperview];
    }else if ([self.btntextstring isEqualToString:@"催促发货"]){
        [rightBtn setTitle:@"催促发货" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [centerBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_bottomview addSubview:centerBtn];
        [_bottomview addSubview:leftBtn];
        [leftBtn setTitle:@"退款售后" forState:UIControlStateNormal];
        //        [leftBtn removeFromSuperview];
        if([self.isshowrefundBtnString isEqualToString:@"NO"]) {
            leftBtn.hidden = YES;
        }
        
        if ([_resultdic[@"service"] integerValue] == 1) {
            [centerBtn removeFromSuperview];
            [leftBtn removeFromSuperview];
            [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        }
    }else if ([self.btntextstring isEqualToString:@"删除订单"]){
        
        if ([_resultdic[@"user_cancel"] integerValue] == 1) {
            [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }else{
            //            NSInteger x = [_resultdic[@"pay_refund"] integerValue];
            //            NSInteger s = [_resultdic[@"service"] integerValue];
            //            if (x == 1||x == 2||s == 1) {
            //
            //            }
            [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        }
        
        [_bottomview addSubview:rightBtn];
        [centerBtn removeFromSuperview];
        [leftBtn removeFromSuperview];
    }else if ([self.btntextstring isEqualToString:@"查看售后"]){
        [rightBtn setTitle:@"查看售后" forState:UIControlStateNormal];
        
        [_bottomview addSubview:rightBtn];
        [centerBtn removeFromSuperview];
        [leftBtn removeFromSuperview];
    }
    
    if ([[leftBtn titleForState:UIControlStateNormal] isEqualToString:@""] && [_resultdic[@"is_vip"] integerValue] == 1) {
        [leftBtn removeFromSuperview];
    }
    
    rightBtn.sd_layout
    .centerYEqualToView(_bottomview)
    .rightSpaceToView(_bottomview, 15)
    .widthIs(80)
    .heightIs(25);
    
    centerBtn.sd_layout
    .centerYEqualToView(_bottomview)
    .rightSpaceToView(rightBtn, 15)
    .widthIs(80)
    .heightIs(25);
    
    leftBtn.sd_layout
    .centerYEqualToView(_bottomview)
    .rightSpaceToView(centerBtn, 15)
    .widthIs(80)
    .heightIs(25);
    
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.noShowBot) {
        if ([self.btntextstring isEqualToString:@"确认收货"]){
            [rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [centerBtn removeFromSuperview];
            [leftBtn removeFromSuperview];
        } else {
            [_bottomview removeFromSuperview];
        }
    }
}

-(void)rightBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
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
                                                                  [self Determineifthereisapaymentpassword:@"querenshouhuozhifu"];
                                                              }];
        [alert addAction:quxiaoaction];
        [alert addAction:quedingaction];
        [self presentViewController:alert animated:YES completion:^{ }];
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]){
        
        OrderGoodsModel *olmodel = self.order_goodsarray[0];
        
        SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
        smvc.TradeLogisticsDataSource=[NSMutableArray new];
        
        NSString *expressqueryUrl = @"https://way.jd.com/fegine/exp";
        //参数列表
        NSMutableDictionary *parame = [NSMutableDictionary new];
        [parame setObject:GetSaveString(olmodel.shipping_code) forKey:@"type"];
        [parame setObject:GetSaveString(olmodel.invoice_no) forKey:@"no"];
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
            
            //直接把返回的参数进行解析然后返回
            NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"expressqueryUrl-----%@-----resultdic-----%@",expressqueryUrl,resultdic);
            
            NSString *codeStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"code"]]; ;
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
                smvc.logisticsTypeString = olmodel.shipping_code;
                smvc.logisticsNoString = olmodel.invoice_no;
                [self.navigationController pushViewController:smvc animated:YES];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            kHiddenHUDAndAvtivity;
            
        }];
        
    }else if ([btn.titleLabel.text isEqualToString:@"取消订单"]){
        CancelOrderPopoverView *copv=[[CancelOrderPopoverView alloc]init];
        @weakify(self)
        copv.didClickOktHandler = ^(NSString *selectstring) {
            [self payCancel:selectstring];
        };
        [self.view addSubview:copv];
    }else if ([btn.titleLabel.text isEqualToString:@"催促发货"]){
        if (self.canPush) {
            LRToast(@"催促发货提交成功,请耐心等待");
        } else {
            LRToast(@"您的订单目前处于正常发货时效内，请耐心等待发货，如超过2天仍未发货请您再次催促发货");
        }
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
                                                                  [self deleteOrder];
                                                              }];
        [alert addAction:quxiaoaction];
        [alert addAction:quedingaction];
        [self presentViewController:alert animated:YES completion:^{ }];
    }else if ([btn.titleLabel.text isEqualToString:@"查看售后"]){
        DetailsRefundViewController *drvc=[[DetailsRefundViewController alloc]init];
        drvc.all_num = self.olmodel.all_num;
        drvc.refundordersnString=_resultdic[@"order_sn"];
        [self.navigationController pushViewController:drvc animated:YES];
    }
}

-(void)centerBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"去支付"]) {
        //跳转前需要做一个判断，用户或商家每月消费或收账是否到达限额
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"order_amount"] = @(self.olmodel.order_amount);
        dict[@"business_id"] = self.olmodel.business_id;
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(quotaMoney) parameters:dict isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
            NSLog(@"%@", res);
            
            if ([res[@"code"] integerValue] == 2) {
                //超过限额
                //                LRToast(res[@"msg"]);
            }else{
                NSLog(@"%@",@"未超过限额,可以进入支付界面~~~");
                [self submitordersbtnClick];
            }
        } failure:nil RefreshAction:nil];
        
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]){
        
        OrderGoodsModel *olmodel = self.order_goodsarray[0];
        
        SubclassModuleViewController *smvc = [[SubclassModuleViewController alloc]init];
        smvc.TradeLogisticsDataSource=[NSMutableArray new];
        
        NSString *expressqueryUrl = @"https://way.jd.com/fegine/exp";
        //参数列表
        NSMutableDictionary *parame = [NSMutableDictionary new];
        [parame setObject:GetSaveString(olmodel.shipping_code) forKey:@"type"];
        [parame setObject:GetSaveString(olmodel.invoice_no) forKey:@"no"];
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
                smvc.logisticsTypeString = olmodel.shipping_code;
                smvc.logisticsNoString = olmodel.invoice_no;
                [self.navigationController pushViewController:smvc animated:YES];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            
            kHiddenHUDAndAvtivity;
            
        }];
        
    }
}

-(void)leftBtnClick:(UIButton *)btn{
    ToApplyForARefundViewController *tafrvc=[[ToApplyForARefundViewController alloc]init];
    tafrvc.refundamountString=realpaymentstring;
    tafrvc.refundordersnString=self.order_snstring;
    tafrvc.isshowRefundPopView=self.isshowRefundPopView;
    tafrvc.shipping_status = _resultdic[@"shipping_status"];
    [self.navigationController pushViewController:tafrvc animated:YES];
}

-(void)callphone:(UIButton *)btn{
    NSArray *arr = _resultdic[@"business_info"];
    NSDictionary *dict = arr.firstObject;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",dict[@"mobile"]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)headBtnClick:(UIButton *)btn{
    
    StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
    sdvc.business_idstring=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:sdvc animated:YES];
    
}

-(void)submitordersbtnClick{
    
    if(kStringIsEmpty([_resultdic objectForKey:@"address"])){
        LRToast(@"请选择收货地址");
    }else{
        [self processPayLogic];
        //        [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            if ([obj isEqualToString:@"1"]) {
        //                if (idx==0) {
        //                    [self doAPPay];
        //                }else  if (idx==1) {
        //                    if (ShowUPPay) {
        //                        [self doUPPay];
        //                    }else{
        //                        [self Determineifthereisapaymentpassword:@"yuezhifu"];
        //                    }
        //                } if (idx==2) {
        //                    [self Determineifthereisapaymentpassword:@"yuezhifu"];
        //                }
        //            }
        //        }];
        
    }
    
}

-(void)payCancel:(NSString *)cancel_rasonstring{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:self.order_snstring forKey:@"order_sn"];
    [requestdic setObject:cancel_rasonstring forKey:@"cancel_reason"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(payCancel) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    //                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        //                                        LRToast(@"订单取消成功");
                                        [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                                        [_bottomview addSubview:rightBtn];
                                        [centerBtn removeFromSuperview];
                                        [leftBtn removeFromSuperview];
                                        
                                        GCDAfter1s(^{
                                            //                                            [self.navigationController popViewControllerAnimated:YES];
                                            //                                            if (self.refreshHandler) {
                                            //                                                self.refreshHandler();
                                            //                                            }
                                            MyOrderViewController *vc = [MyOrderViewController new];
                                            vc.index = self.currentIndex;
                                            [self.navigationController pushViewController:vc animated:YES];
                                        });
                                        
                                        
                                    }else{
                                        LRToast(responseObject[@"msg"])
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

-(void)deleteOrder{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:self.order_snstring forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(deleteOrder) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        GCDAfter1s(^{
                                            
                                            MyOrderViewController *vc = [MyOrderViewController new];
                                            vc.index = self.currentIndex;
                                            [self.navigationController pushViewController:vc animated:YES];
                                            //                                            [self.navigationController popViewControllerAnimated:YES];
                                            //                                            if (self.refreshHandler) {
                                            //                                                self.refreshHandler();
                                            //                                            }
                                        });
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

-(void)confirmgoods{
    
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
    payAlert.title = @"请输入支付密码";
    //    payAlert.detail = @"提现";
    //    payAlert.amount= 10;
    [payAlert show];
    @weakify(self)
    payAlert.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
        @strongify(self)
        NSMutableDictionary *requestdic=[NSMutableDictionary new];
        [requestdic setObject:self.order_snstring forKey:@"order_sn"];
        [requestdic setObject:inputPwd forKey:@"password"];
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(orderConfirm) parameters:requestdic
                               isShowToastd:(BOOL)YES
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            //                                            LRToast(@"收货成功");
                                            
                                            GCDAfter1s(^{
                                                MyOrderViewController *vc = [MyOrderViewController new];
                                                vc.index = 4;
                                                [self.navigationController pushViewController:vc animated:YES];
                                            });
                                            
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
    };
}

- (void)doAPPay
{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2017051007191557";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = AlipayPublicKey;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"body";
    order.biz_content.subject = [_resultdic[@"order_goods"] firstObject][@"goods_name"];
    order.biz_content.out_trade_no = self.order_snstring; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [_resultdic[@"order_amount"] floatValue]]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}
//生成n位的随机订单号
- (NSString *)generateTradeNOWithNum:(NSInteger)num
{
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < num; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

/*
 *支付宝支付结果回调
 */
-(void)alipayResponse:(NSNotification *)resp{
    NSLog(@"resp-----%@",resp);
    NSString  * resultStatus = [(NSDictionary *)resp.object objectForKey:@"resultStatus"];
    switch(resultStatus.integerValue){
        case 9000:{
            LRToast(@"支付成功!");
            [self requestResponse:(NSDictionary *)resp.object andorderstring:self.order_snstring];
        }
            break;
        default:{
            LRToast(@"支付失败，请重新支付!");
        }
            break;
    }
    
}

//支付成功之后的回调
-(void)requestResponse:(NSDictionary *)respdic andorderstring:(NSString *)orderstring{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:orderstring forKey:@"order_shop"];
    [requestdic setObject:[respdic objectForKey:@"resultStatus"] forKey:@"trade_status"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(response) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        GCDAfter1s(^{
                                            MyOrderViewController *vc = [MyOrderViewController new];
                                            vc.index = 2;
                                            [self.navigationController pushViewController:vc animated:YES];
                                        });
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

//判断用户是否设置支付密码
-(void)Determineifthereisapaymentpassword:(NSString *)paytypestring{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            [paytypestring isEqualToString:@"yuezhifu"]?[self doBalancePay:self.order_snstring andorder_amount:[NSString stringWithFormat:@"%.2f", realpaymentstring.floatValue] andtypestring:@"2"]:[self confirmgoods];
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:nil RefreshAction:nil];
    
    
}

-(void)doBalancePay:(NSString *)orderstring andorder_amount:(NSString *)order_amount andtypestring:(NSString *)typestring{
    
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
    payAlert.title = @"请输入支付密码";
    //    payAlert.detail = @"提现";
    //    payAlert.amount= 10;
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
        
        NSMutableDictionary *requestdic=[NSMutableDictionary new];
        [requestdic setObject:orderstring forKey:@"order_sn"];
        [requestdic setObject:order_amount forKey:@"order_amount"];
        [requestdic setObject:typestring forKey:@"type"];
        [requestdic setObject:inputPwd forKey:@"pass"];
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(moneyPay) parameters:requestdic
                               isShowToastd:(BOOL)YES
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            
                                            GCDAfter1s(^{
                                                MyOrderViewController *vc = [MyOrderViewController new];
                                                vc.index = 2;
                                                [self.navigationController pushViewController:vc animated:YES];
                                            });
                                            
                                            //                                            LRToast(@"支付成功");
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
        
    };
    
}

-(void)doUPPay{
    
    //当获得的tn不为空时，调用支付接口
    //if (tn != nil && tn.length > 0)
    //{
    [[UPPaymentControl defaultControl]
     startPay:self.order_snstring
     fromScheme:@"UPPay"
     mode:@"01"
     viewController:self];
    //}
    
}

//处理支付逻辑
/*
 进入当前页面时，默认只选择了支付宝支付
 没有余额时，默认只显示支付宝支付
 有余额时
 1)未选择余额支付，默认进入支付宝支付
 2)选择了余额支付，支付宝则置灰，此时需要判断余额是否大于当前订单实付款
 a)小于当前订单实付款，则跳转到组合支付的页面，现在是余额+支付宝支付
 b)大于当前订单实付款，则直接弹框使用余额支付
 
 */
-(void)processPayLogic
{
    //是否需要组合支付
    BOOL groupPay = realpaymentstring.integerValue > currentBalance.integerValue?YES:NO;
    BOOL clickBalance = NO;
    //先判断是否点击了余额支付
    for (id obj in _payselectarray) {
        if ([obj isEqualToString:@"1"]) {   //说明点击了组合支付
            clickBalance = YES;
        }
    }
    
    if (clickBalance == YES) {
        if (groupPay) { //余额不足，跳转到组合支付页面，默认组合支付宝
            GroupPayViewController *gpVC = [GroupPayViewController new];
            gpVC.order_shop = self.order_snstring;
            gpVC.consume_money = consume_money;
            gpVC.money = money;
            gpVC.total = currentBalance;
            gpVC.payTotal = realpaymentstring;
            gpVC.order_name = [_resultdic[@"order_goods"] firstObject][@"goods_name"];
            [self.navigationController pushViewController:gpVC animated:YES];
        }else{  //余额充足，直接弹框支付
            [self Determineifthereisapaymentpassword:@"yuezhifu"];
        }
    }else{  //只选择了支付宝支付
        // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResponse:) name:@"AliPayResult" object:nil];
        [self doAPPay];
    }
    
}



-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end





