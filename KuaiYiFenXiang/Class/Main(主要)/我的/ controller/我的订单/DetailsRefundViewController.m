//
//  AllOrdersViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "DetailsRefundViewController.h"
#import "DetailsRefundModel.h"
#import "DetailsRefundTableViewCell.h"
#import "MyOrderViewController.h"
#import "CheckLogisticsPopView.h"

@interface DetailsRefundViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSArray *youhuitextArray;
@property (nonatomic, strong) NSArray *youhuimoneyArray;
@property (nonatomic, strong) NSArray *refundinformationArray;
@property (nonatomic, strong) UIView *bottomview;
@property (nonatomic, strong) NSMutableArray *datasourceArray;
@property (nonatomic, strong) NSDictionary *resultdic;
@property (nonatomic, strong) NSArray *headtitletextArray;

@property (nonatomic, strong) NSMutableArray *shippingcodeArray;
@property (nonatomic, strong) NSMutableArray *shippingnameArray;

@end

@implementation DetailsRefundViewController{
    UITableView*mytableview;
    UITableView*downtableview;
    UIButton * rightBtn;
    UIButton * centerBtn;
    UIButton * leftBtn;
    
    UITextField *CourierNameTextField;
    UITextField *CourierNOTextField;
    
    UIButton *upanddownButton;
    
    NSString *shipping_codeString;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultBGColor;
    self.navigationItem.title = @"退款详情";
    
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BOTTOM_MARGIN - NAVI_HEIGHT - 44) style:UITableViewStyleGrouped];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    [self.view addSubview:mytableview];
    
    //设置自己的表视图
    downtableview=[[UITableView alloc]initWithFrame:CGRectMake(88, 375, 238, 238) style:UITableViewStyleGrouped];
    [downtableview setBackgroundColor:BACKVIEWCOLOR];
    downtableview.delegate=self;
    downtableview.dataSource=self;
    [self requestshippingKind];
    
    
    
}

//退款订单上传获取快递种类
-(void)requestshippingKind{
    
    self.shippingcodeArray=[NSMutableArray new];
    self.shippingnameArray=[NSMutableArray new];
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [HttpRequest postWithTokenURLString:NetRequestUrl(shippingKind) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    
                                    if (codeStr.intValue==1) {
                                        NSMutableArray *requestarray=[responseObject objectForKey:@"result"];
                                        for (NSDictionary *dic in requestarray) {
                                            [self.shippingcodeArray addObject:[dic objectForKey:@"code"]];
                                            [self.shippingnameArray addObject:[dic objectForKey:@"name"]];
                                        }
                                        [self loadupdata];
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
}

-(void)loadupdata{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:self.refundordersnString forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(refundDetail) parameters:requestdic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    result=[self validDict:result];
                                    
                                    if (codeStr.intValue==1) {
                                     
                                        self.youhuitextArray=@[@"拼团优惠",@"活动优惠"];
                                        self.youhuimoneyArray=@[@"-¥0.00",@"-¥0.00"];
                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                        
                                        self.refundinformationArray=@[[NSString stringWithFormat:@"退款原因:%@",[result objectForKey:@"cause"]],[NSString stringWithFormat:@"退款说明:%@",[result objectForKey:@"state"]],[NSString stringWithFormat:@"申请件数:%@",self.all_num],[NSString stringWithFormat:@"申请时间:%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[result[@"addtime"] floatValue]]]],[NSString stringWithFormat:@"申请单号:%@",[result objectForKey:@"order_sn"]]];
                                        
                                        _resultdic=result;
                                        
                                        //每次进行数据请求初始化数组
                                        self.datasourceArray=[NSMutableArray array];
                                        
                                        //判断发货还是没有发货状态字符
                                        NSString *shipping_statusString=[result objectForKey:@"shipping_status"];
//                                        NSString *shipping_statusString=@"1";
                                        //判断用户有没有付款状态字符
                                        NSString *pay_refund=[result objectForKey:@"pay_refund"];
                                        NSString *pay_status=[result objectForKey:@"pay_status"];
                                        //判断商家是否同意字符
                                        NSString *business_status=[result objectForKey:@"business_status"];
                                        //判断买家是否已经发货的状态字符 如果该状态字符传为空就说明买家还没发货
                                        NSString *shipping_name=[result objectForKey:@"shipping_name"];
                                        NSString *shipping_code=[result objectForKey:@"shipping_code"];
                                        //判断商家是否已经收货的状态字符 如果是0就说明商家还没有进行任何操作 如果是1就说明商家已经确认收货
                                        NSString *business_confirm=[result objectForKey:@"business_confirm"];
                                        
                                        //平台是否同意退款
                                        NSString *terrace_status = [result objectForKey:@"terrace_status"];
                                        //是否平台介入
                                        NSString *service = [result objectForKey:@"service"];
                                        //type判断退款类型,为“退货退款”时才显示商家地址
                                        NSString *type=[result objectForKey:@"type"];
//                                        NSLog(@"type:%@",type);
                                        
                                        if ([type isEqualToString:@"仅退款"]) {
                                            
                                        for (int i=0; i<3; i++) {
                                            
                                            NSDictionary *dic = @{
//                                                                  @"RefundIsSelectString":[NSString stringWithFormat:@"%d",i],
                                                                  @"RefundRedNumString":[NSString stringWithFormat:@"%d",i+1],
//                                                                  @"RefundStatusString":@"正在退款",
//                                                                  @"RefundTimeString":@"2018-8-8",
//                                                                  @"RefundSubtitleString":@"正在申请退款延期会自动把卷想退回到相应的阶段账户里",
                                                                  };
                                            
                                            //            //初始化模型
                                            DetailsRefundModel *model=[DetailsRefundModel mj_objectWithKeyValues:dic];
                                            
                                            i==0?model.RefundStatusString=@"申请退款":@"";
                                            i==1?model.RefundStatusString=@"审核通过":@"";
                                            i==2?model.RefundStatusString=@"退款成功":@"";
                                            
                                            i==0?model.RefundTimeString=[result objectForKey:@"addtime"]:@"";
                                            //是否有平台介入
                                            if (service.integerValue == 1) {
                                                i==1?model.RefundTimeString=([[result objectForKey:@"terrace_time"] integerValue] == 0) ? @"" : [result objectForKey:@"terrace_time"]:@"";
                                            }else{
                                                i==1?model.RefundTimeString=([[result objectForKey:@"business_time"] integerValue] == 0) ? @"" : [result objectForKey:@"business_time"]:@"";
                                            }
                                            i==2?model.RefundTimeString=[result objectForKey:@"pass_time"]:@"";

                                            i==0?model.RefundSubtitleString=@"您的退款申请已经提交成功":@"";
                                            i==1?model.RefundSubtitleString=@"商家将在1-3个工作日内处理":@"";
                                            i==2?model.RefundSubtitleString=@"商家审核通过后,退款将在3-5个工作日内返回":@"";
                                            
                                            if (pay_refund.intValue==1 && business_status.intValue==0) {
//                                                [_ensureStatuesLabel setText:@"退款中"];
                                                self.headtitletextArray=@[@"申请退款,等待审核",@"若商家同意：退款至您支付账号。\n若商家拒绝：您可以申请平台介入。\n若商家未处理：超过3天，系统自动为您退款",[result objectForKey:@"other_content"]];
                                                i<=0?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                            }else if (pay_refund.intValue==1 && business_status.intValue==1){
//                                                [_ensureStatuesLabel setText:@"审核通过"];
                                                self.headtitletextArray=@[@"商家同意退款",[@"商家留言：" stringByAppendingString:_resultdic[@"business_note"]]];
                                                
                                                i<=1?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                            }else if (pay_refund.intValue==2){
//                                                [_ensureStatuesLabel setText:@"退款成功"];
                                                self.headtitletextArray=@[@"退款成功",@"本次交易已经关闭"];
                                                i<=2?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                            }else if ((pay_refund.intValue==1 && business_status.intValue==2) || (pay_refund.integerValue == 0 && business_status.integerValue == 2)){
//                                                [_ensureStatuesLabel setText:@"退款失败"];
                                                if (service.integerValue == 1) {
                                                    if ([result[@"terrace_status"] integerValue] == 1) {
                                                        self.headtitletextArray = @[@"平台同意退款",[NSString stringWithFormat:@"平台留言：%@",result[@"terrace_reason"]]];
                                                        i<=1?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    } else if ([result[@"terrace_status"] integerValue] == 2) {
                                                        self.headtitletextArray = @[@"平台拒绝退款",[@"平台留言：" stringByAppendingString:result[@"terrace_reason"]]];
                                                        i<=0?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    } else {
                                                        
                                                        self.headtitletextArray = @[@"\n平台介入，等待处理",@""];
                                                        i<=0?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    }
                                                } else {
                                                    self.headtitletextArray=@[@"退款失败",[NSString stringWithFormat:@"商家说明：%@", [result objectForKey:@"business_note"]]];
                                                }
                                                
                                                
                                            }
                                            
                                            
                                            
                                            //            //把模型添加到相应的数据源数组中
                                            [self.datasourceArray addObject:model];
                                            
                                        }
                                            
                                        }else{
                                            
                                            for (int i=0; i<6; i++) {
                                                
                                                NSDictionary *dic = @{
                                                                      //                                                                  @"RefundIsSelectString":[NSString stringWithFormat:@"%d",i],
                                                                      @"RefundRedNumString":[NSString stringWithFormat:@"%d",i+1],
                                                                      //                                                                  @"RefundStatusString":@"正在退款",
                                                                      //                                                                  @"RefundTimeString":@"2018-8-8",
                                                                      //                                                                  @"RefundSubtitleString":@"正在申请退款延期会自动把卷想退回到相应的阶段账户里",
                                                                      };
                                                
                                                //            //初始化模型
                                                DetailsRefundModel *model=[DetailsRefundModel mj_objectWithKeyValues:dic];
                       
                                                i==0?model.RefundStatusString=@"申请退款":@"";
                                                i==1?model.RefundStatusString=@"审核通过":@"";
                                                i==2?model.RefundStatusString=@"买家发货":@"";
                                                i==3?model.RefundStatusString=@"买家已发货":@"";
                                                i==4?model.RefundStatusString=@"商家确认收货":@"";
                                                i==5?model.RefundStatusString=@"退款成功":@"";
                                                
                                                i==0?model.RefundTimeString=[result objectForKey:@"addtime"]:@"";
                                                
                                                if (service.integerValue == 1) {
                                                    i==1?model.RefundTimeString=([[result objectForKey:@"terrace_time"] integerValue] == 0) ? @"" : [result objectForKey:@"terrace_time"]:@"";
                                                }else{
                                                    i==1?model.RefundTimeString=([[result objectForKey:@"business_time"] integerValue] == 0) ? @"" : [result objectForKey:@"business_time"]:@"";
                                                }
                                                
                                                i==2?model.RefundTimeString=([[result objectForKey:@"shipping_time"] integerValue] == 0) ? @"" : [result objectForKey:@"shipping_time"]:@"";
                                                
                                                i==3?model.RefundTimeString=([[result objectForKey:@"shipping_time"] integerValue] == 0) ? @"" : [result objectForKey:@"shipping_time"]:@"";
                                                
                                                i==4?model.RefundTimeString=([[result objectForKey:@"business_confirmtime"] integerValue] == 0) ? @"" : [result objectForKey:@"business_confirmtime"]:@"";
                                                
                                                i==5?model.RefundTimeString=([[result objectForKey:@"pass_time"] integerValue] == 0) ? @"" : [result objectForKey:@"pass_time"]:@"";

                                                i==0?model.RefundSubtitleString=@"您的退款申请已经提交成功":@"";
                                                i==1?model.RefundSubtitleString=@"商家将在1-3个工作日内处理":@"";
                                                i==2?model.RefundSubtitleString=@"等待买家发货并上传运单号":@"";
                                                i==3?model.RefundSubtitleString=[result[@"shipping_name"]isEqualToString:@""]?@"":[NSString stringWithFormat:@"快递：%@",[self.shippingnameArray objectAtIndex:[self.shippingcodeArray indexOfObject:[result objectForKey:@"shipping_name"]]]]:@"";
//                                                i==4?model.RefundSubtitleString=@"商家将在1-3个工作日内处理":@"";
                                                i==4?model.RefundSubtitleString=@"等待卖家发货并上传运单号":@"";
                                                i==5?model.RefundSubtitleString=@"商家审核通过后,退款将在3-5个工作日内返回":@"";
                                                
                                                
                                                i<=0?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                if ([result[@"service"] integerValue] == 1) {
                                                    //平台介入
                                                    //平台同意
                                                    if ([result[@"terrace_status"] integerValue] == 1) {
                                                        self.headtitletextArray = @[@"平台同意退款",[NSString stringWithFormat:@"平台留言：%@ \n商家地址：%@  %@  %@",result[@"terrace_reason"],result[@"business_address_name"],result[@"business_address_mobile"],result[@"business_address"]]];
                                                        model.RefundLeafletsNoButtonUserInteractionEnabled=@"NO";
                                                        //这里还要分买家是否发货，商家是否收到货等情况
                                                        if (kStringIsEmpty(shipping_name) && kStringIsEmpty(shipping_code)){
                                                            //未发货
                                                            model.RefundLeafletsNoButtonUserInteractionEnabled=@"YES"; self.headtitletextArray=@[@"等待买家寄回商品",@"需寄回商品,等待商家审核"];
                                                            i<=2?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                        }else if (!kStringIsEmpty(shipping_name) && !kStringIsEmpty(shipping_code)&& business_confirm.intValue==0){
                                                            //已发货，未收货
                                                            self.headtitletextArray=@[@"买家已发货",@"等待商家收货"];
                                                            i<=3?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                        }
                                                        else if (!kStringIsEmpty(shipping_name) && !kStringIsEmpty(shipping_code) &&  (pay_refund.intValue==1 || pay_refund.intValue==0)&& pay_status.intValue==1 && business_confirm.intValue==1){
                                                            
                                                            //已发货，已收货
                                                            self.headtitletextArray=@[@"\n已确认收货，等待退款",@""];
                                                            i<=4?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                        }
                                                        else if (pay_refund.intValue==2 && pay_status.intValue==3){
                                                            self.headtitletextArray=@[@"退款成功",@"本次交易已经关闭"];
                                                            i<=5?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                        }
                                                        
                                                    } else if ([result[@"terrace_status"] integerValue] == 2) {
                                                        //平台拒绝
                                                        self.headtitletextArray = @[@"平台拒绝退款",[@"平台留言：" stringByAppendingString:result[@"terrace_reason"]]];
                                                        
                                                    }else {
                                                        self.headtitletextArray=@[@"\n平台介入，等待处理",@""];
                                                        
                                                    }
                                                    
                                                }else{
                                                    //只有商家
                                                    if ([shipping_name isEqualToString:@""] && shipping_code.integerValue == 0&&pay_refund.intValue==1 && business_status.intValue==0) {
                                                        self.headtitletextArray=@[@"申请退款,等待审核",@"若商家同意：退款至您支付账号。\n若商家拒绝：您可以申请平台介入。\n若商家未处理：超过3天，系统自动为您退款"];
                                                    }else if ((pay_refund.intValue==1 && business_status.intValue==2)|| (pay_refund.integerValue == 0 && business_status.integerValue == 2)){
                                                        self.headtitletextArray=@[@"审核不通过",[NSString stringWithFormat:@"商家说明:%@",[result objectForKey:@"business_note"]]];
                                                    }else if (kStringIsEmpty(shipping_name) && kStringIsEmpty(shipping_code)&&pay_refund.intValue==1 && business_status.intValue==1){
                                                        //这种状态代表商家同意退款，但是用户尚未发货
                                                        model.RefundLeafletsNoButtonUserInteractionEnabled = @"YES";
                                                        self.headtitletextArray=@[@"审核通过",[NSString stringWithFormat:@"需寄回商品,等待商家审核 \n商家地址：%@  %@  %@",result[@"business_address_name"],result[@"business_address_mobile"],result[@"business_address"]]];
                                                        i<=1?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    }else if (kStringIsEmpty(shipping_name) && kStringIsEmpty(shipping_code)){
                                                        
                                                        self.headtitletextArray=@[@"等待买家寄回商品",@"需寄回商品,等待商家审核"];
                                                        i<=2?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    }else if (!kStringIsEmpty(shipping_name) && !kStringIsEmpty(shipping_code)&& business_confirm.intValue==0){
                                                        
                                                        self.headtitletextArray=@[@"买家已发货",@"等待商家收货"];
                                                        i<=3?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    }
                                                    else if (!kStringIsEmpty(shipping_name) && !kStringIsEmpty(shipping_code) &&  pay_refund.intValue==1 && pay_status.intValue==1 && business_confirm.intValue==1){

                                                        self.headtitletextArray=@[@"\n已确认收货，等待退款",@""];
                                                        i<=4?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    }
                                                    else if (pay_refund.intValue==2 && pay_status.intValue==3 && business_status.intValue==1){
                                                        
                                                        self.headtitletextArray=@[@"退款成功",@"本次交易已经关闭"];
                                                        i<=5?[model setRefundIsSelectString:@"1"]:[model setRefundIsSelectString:@"0"];
                                                    }
                                                }
                                                
                                                
                                                //把模型添加到相应的数据源数组中
                                                [self.datasourceArray addObject:model];
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                    if (self.noShowBot) {
                                        
                                    } else {
                                        
                                        [self setbottomview];
                                    }

                                    [mytableview reloadData];
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView==mytableview?3:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==mytableview){
        
    if (section==0) {
        return self.datasourceArray.count;
    } else if (section==1) {
        return self.youhuitextArray.count;
    }else if (section==2){
        return self.refundinformationArray.count;
    }else{
        return 0;
    }
        
    }else{
        return self.shippingnameArray.count;
    }
}

//初始化当前表视图的每行的cell以及相应的表的属性设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView==mytableview){

    if (indexPath.section==0) {
        //通过cell的类方法直接初始化cell
        DetailsRefundTableViewCell *cell = [DetailsRefundTableViewCell mainTableViewCellWithTableView:tableView];
        //根据相应的cell的行数进行每行cell的数据设置
        kArrayIsEmpty(self.datasourceArray)?:[cell setDetailsRefundModel:self.datasourceArray[indexPath.row]];
       
        //上传单号
        cell.didSelectedRefundLeafletsNoButtonBlock = ^(DetailsRefundModel *model) {
            
            [self LeafletsNo];
            
        };
        
        //查看物流
        cell.didSelectedCheckLogisticsBlock = ^(DetailsRefundModel *model) {
       
            [self CheckLogistics];
            
        };
        
        return cell;
    }else{
        //防止cell重建引起卡顿
        // 定义唯一标识
        static NSString *CellIdentifier = @"UITableViewCell";
        // 通过唯一标识创建cell实例
        UITableViewCell *cell;
//        = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
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
    
        [cell.textLabel setFont:PFR15Font];
        
    if (indexPath.section==1) {
        [cell.textLabel setText:self.youhuitextArray[indexPath.row]];
         [cell.detailTextLabel setText:self.youhuimoneyArray[indexPath.row]];
    }else if (indexPath.section==2){
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setText:self.refundinformationArray[indexPath.row]];
    }
    
    return cell;
        
    }
        
    }else{
     
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
        
        [cell.textLabel setText:self.shippingnameArray[indexPath.row]];
        
        return cell;

    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==mytableview){

    if (indexPath.section==0) {
        return [mytableview cellHeightForIndexPath:indexPath model:self.datasourceArray[indexPath.row] keyPath:@"DetailsRefundModel" cellClass:[DetailsRefundTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }else{
        return 44;
    }
        
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(tableView==mytableview){

        if (section==0) {
            return 108;
        } else if (section==1){
            return 44;
        }else{
            return 0.01;
        }
        
    }else{
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(tableView==mytableview){

    if (section==0) {
        return 44;
    }else{
        return 10;
    }
        
    }else{
        return 0.01;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView==mytableview){

        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 108)];
        [headview setBackgroundColor:[UIColor whiteColor]];
        
        if (section==0) {
            
            UIImageView *headbgimageview=[[UIImageView alloc]init];
            [headbgimageview setImage:[UIImage imageNamed:@"shouhuodizhibeijing"]];
            [headview addSubview:headbgimageview];
            headbgimageview.sd_layout
            .centerXEqualToView(headview)
            .centerYEqualToView(headview)
            .widthIs(headview.width)
            .heightIs(headview.height);
            
            UILabel *headlabel=[[UILabel alloc]init];
            [headlabel setTextColor:[UIColor whiteColor]];
            [headlabel setFont:PFR15Font];
            [headbgimageview addSubview:headlabel];
            [headlabel setText:self.headtitletextArray[0]];
            headlabel.sd_layout
            .topSpaceToView(headbgimageview, 10)
            .leftSpaceToView(headbgimageview, 20)
            .rightSpaceToView(headbgimageview, 20)
            .autoHeightRatio(0);
//            [headlabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 20];
            
            UILabel *headsublabel=[[UILabel alloc]init];
            headsublabel.numberOfLines = 0;
            [headsublabel setTextColor:[UIColor whiteColor]];
            [headsublabel setFont:PFR13Font];
            [headsublabel setText:self.headtitletextArray[1]];
            [headbgimageview addSubview:headsublabel];
            headsublabel.sd_layout
            .topSpaceToView(headlabel, 10)
            .leftEqualToView(headlabel)
            .rightSpaceToView(headbgimageview, 20)
            .autoHeightRatio(0);
//            [headsublabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 20];
            
        }else if(section==1){
                UILabel *titlelabel=[[UILabel alloc]init];
                [titlelabel setText:@"以下优惠金额将不允许被退还"];
                [titlelabel setTextColor:[UIColor blackColor]];
                [titlelabel setFont:PFR15Font];
                [headview addSubview:titlelabel];
                titlelabel.sd_layout
                .centerYEqualToView(headview)
                .leftSpaceToView(headview, 20)
                .rightSpaceToView(headview, 20)
                .heightIs(headview.height);
        }else{
            return nil;
        }
        
        return headview;
        
    }else{
        return nil;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(tableView==mytableview){

    if (section==0) {
        UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [footview setBackgroundColor:[UIColor whiteColor]];
        
//        [SXColorLabel setAnotherColor:[UIColor blackColor]];
//        [SXColorLabel setAnotherFont:PFR15Font];
//        SXColorLabel *footlabel  = [[SXColorLabel alloc]init];
//        [footlabel setAnotherColor:[UIColor redColor]];
//        [footlabel setAnotherFont:PFR15Font];
//        footlabel.text = @"退款金额:[<[¥100]>]";
        
        UILabel *footlabel=[[UILabel alloc]init];
        [footlabel setFont:PFR15Font];
        [footlabel setTextColor:[UIColor redColor]];
        footlabel.text = [NSString stringWithFormat:@"退款金额:¥%@",[_resultdic objectForKey:@"money"]];
        [footview addSubview:footlabel];
        footlabel.sd_layout
        .leftSpaceToView(footview, 20)
        .centerYEqualToView(footview)
        .autoHeightRatio(0);
        [footlabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        return footview;
    }else{
        return nil;
    }
        
    }else{
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
    if(tableView==mytableview){
        
    }else{
        [downtableview removeFromSuperview];
        [upanddownButton setSelected:NO];
        [CourierNameTextField setText:self.shippingnameArray[indexPath.row]];
        shipping_codeString=self.shippingcodeArray[indexPath.row];

    }
}

-(void)setbottomview{
    
    _bottomview = [UIView new];
    [_bottomview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomview];
    _bottomview.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(44)
    ;
    
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
    
    NSString *pay_refund=[_resultdic objectForKey:@"pay_refund"];
    NSString *business_status=[_resultdic objectForKey:@"business_status"];
    NSString *terrace_status = _resultdic[@"terrace_status"];
    NSString *service = _resultdic[@"service"];

    if (pay_refund.intValue==1 && business_status.intValue==0) {
        //                                                [_ensureStatuesLabel setText:@"退款中"];
        [rightBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [centerBtn setTitle:@"平台介入" forState:UIControlStateNormal];
        [_bottomview addSubview:centerBtn];
        [leftBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
        [_bottomview addSubview:leftBtn];
    }else if (pay_refund.intValue==1 && business_status.intValue==1){
        //                                                [_ensureStatuesLabel setText:@"审核通过"];
        [rightBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [centerBtn setTitle:@"平台介入" forState:UIControlStateNormal];
        [_bottomview addSubview:centerBtn];
        [leftBtn removeFromSuperview];
    }else if (pay_refund.intValue==2){
        //                                                [_ensureStatuesLabel setText:@"退款成功"];
        [rightBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [centerBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_bottomview addSubview:centerBtn];
        [_bottomview addSubview:centerBtn];
        [leftBtn removeFromSuperview];
    }else if ((pay_refund.intValue==1 && business_status.intValue==2)|| (pay_refund.integerValue == 0 && business_status.integerValue == 2)){
        //                                                [_ensureStatuesLabel setText:@"退款失败"];
        [rightBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [_bottomview addSubview:rightBtn];
        [_bottomview addSubview:centerBtn];
        [_bottomview addSubview:leftBtn];
        if (business_status.integerValue == 2&&service.integerValue == 0) {
            [leftBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
        }else if (terrace_status.integerValue == 1){
            [leftBtn removeFromSuperview];
        }else if (terrace_status.integerValue == 2){
            [leftBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
        }else{
            [leftBtn removeFromSuperview];
        }
        [centerBtn setTitle:@"平台介入" forState:UIControlStateNormal];
        
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
}

-(void)rightBtnClick:(UIButton *)btn{

    NSMutableString * str=[NSMutableString stringWithFormat:@"telprompt://%@",[_resultdic objectForKey:@"mobile"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

-(void)centerBtnClick:(UIButton *)btn{
    
    if ([btn.titleLabel.text isEqualToString:@"平台介入"]) {
        
    NSMutableString * str=[NSMutableString stringWithFormat:@"telprompt://%@",@"4009989798"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else if ([btn.titleLabel.text isEqualToString:@"删除订单"]){
        
        [self deleteOrder];
        
    } else if ([btn.titleLabel.text isEqualToString:@"撤销申请"]) {
        [self leftBtnClick:btn];
    }

}

-(void)leftBtnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"平台介入"]) {
        
        NSMutableString * str=[NSMutableString stringWithFormat:@"telprompt://%@",@"4009989798"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"您将撤销本次申请"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *quxiaoaction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 
                                                             }];
        UIAlertAction *quedingaction = [UIAlertAction actionWithTitle:@"确定"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action){
                                                                  [self cancelapplication];
                                                              }];
        [alert addAction:quxiaoaction];
        [alert addAction:quedingaction];
        [self presentViewController:alert animated:YES completion:^{ }];
    }
}

-(void)deleteOrder{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:self.refundordersnString forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(deleteOrder) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        GCDAfter1s(^{
                                          [self.navigationController popViewControllerAnimated:YES];
                                        });
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

-(void)cancelapplication{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:self.refundordersnString forKey:@"order_sn"];
    [HttpRequest postWithTokenURLString:NetRequestUrl(backOutRefund) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
//                                        LRToast(@"订单已撤销");
                                        GCDAfter1s(^{
                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                        });
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
}

-(void)LeafletsNo{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"填写快递信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //获取第1个输入框；
//        CourierNameTextField = alertController.textFields.firstObject;
//        
//        //获取第2个输入框；
//        CourierNOTextField = alertController.textFields.lastObject;
        
        NSLog(@"快递名称 = %@，快递单号 = %@",CourierNameTextField.text,CourierNOTextField.text);
        
        NSMutableDictionary *requestdic=[NSMutableDictionary new];
        [requestdic setObject:self.refundordersnString forKey:@"order_sn"];
        [requestdic setObject:shipping_codeString forKey:@"shipping_name"];
        [requestdic setObject:CourierNOTextField.text forKey:@"shipping_code"];
        [HttpRequest postWithTokenURLString:NetRequestUrl(sales_return) parameters:requestdic
                               isShowToastd:(BOOL)NO
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            [self loadupdata];
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];

        
    }]];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请选择快递名称";
        textField.delegate=self;
        textField.userInteractionEnabled=YES;
        [textField setText:self.shippingnameArray[0]];
        CourierNameTextField=textField;
        shipping_codeString=self.shippingcodeArray[0];
        
        upanddownButton=[[UIButton alloc]init];
        [upanddownButton setImage:[UIImage imageNamed:@"group_btn_arrow_down"] forState:UIControlStateNormal];
        [upanddownButton setImage:[UIImage imageNamed:@"group_btn_arrow_up"] forState:UIControlStateSelected];
        [textField addSubview:upanddownButton];
        upanddownButton.sd_layout
        .rightEqualToView(textField)
        .centerYEqualToView(textField)
        .widthIs(16)
        .heightIs(20);
        [upanddownButton addTarget:self action:@selector(upanddownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    //定义第二个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入快递单号";
        CourierNOTextField=textField;
    }];
    [self presentViewController:alertController animated:true completion:nil];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
    
}

-(void)CheckLogistics{
    
    CheckLogisticsPopView *clpv=[[CheckLogisticsPopView alloc]init];
    [clpv loadTradeLogisticsData:[_resultdic objectForKey:@"shipping_name"] andlogisticsnoString:[_resultdic objectForKey:@"shipping_code"]];
    [self.view addSubview:clpv];
    
}

-(void)upanddownButtonClick:(UIButton *)btn{
    
    [btn setSelected:!btn.selected];
    
    btn.isSelected==YES?[self.view.window addSubview:downtableview]:[downtableview removeFromSuperview];
    
}


@end





