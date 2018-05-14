//
//  AllOrdersViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "MakeSureTheOrderViewController.h"
#import "SeleteAddressModel.h"
#import "SeleteAddressTableViewCell.h"

#import "OrderGoodsModel.h"
#import "OrderGoodsTableViewCell.h"

#import "AddressViewController.h"
#import "StoreDisplayViewController.h"

#import "KYAddressModel.h"

#import "PayChangeViewController.h"

#import "MyOrderViewController.h"
#import "AreaModel.h"

//组合支付页面
#import "GroupPayViewController.h"

@interface MakeSureTheOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

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
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *addressArr;  //保存获取到的收货地址的数组
@property (nonatomic, strong) NSDictionary *address;//保存默认地址

@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) UILabel *shifukuanlabel;


@end

@implementation MakeSureTheOrderViewController{
    
    UITableView*mytableview;
    NSString *realpaymentstring;
    NSString *blockreturnaddressstring;
    NSString *mobileString;
    
    NSString *currentBalance;   //用户当前总余额
    NSString *consume_money;    //消费余额
    NSString *money;            //余额(可以提现的)
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResponse:) name:@"AliPayResult" object:nil];
    
    self.navigationItem.title = @"确认订单";
    NSLog(@"%@",_resultdic);
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-BOTTOM_MARGIN-44) style:UITableViewStyleGrouped];
    mytableview.estimatedRowHeight = 0;
    mytableview.estimatedSectionHeaderHeight = 0;
    mytableview.estimatedSectionFooterHeight = 0;
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    [self.view addSubview:mytableview];
    
    self.lefttextarray=@[@"商品总额",@"总运费",@"拼团优惠",@"活动优惠",@"实付款"];
    
    NSString *total_amountstring=[_resultdic objectForKey:@"total_amount"];
    NSString *shipping_pricestring=[_resultdic objectForKey:@"shipping_price"];
    realpaymentstring=[_resultdic objectForKey:@"order_amount"];
    self.righttextarray=@[[NSString stringWithFormat:@"￥%.2f",total_amountstring.floatValue],[NSString stringWithFormat:@"¥%.2f", shipping_pricestring.floatValue],@"-￥0.00",@"-￥0.00",[NSString stringWithFormat:@"¥%.2f",realpaymentstring.floatValue]];
    
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
    
    [self setbottomviewWithType:@"支付宝支付"];
    
    [self getUserBalance];
    
    [self loadData];
    
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
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(getaddress) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            self.addressArr = [KYAddressModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
            for (KYAddressModel *addressModel in self.addressArr) {
                
                //为空说明不是编辑模式
                if (kStringIsEmpty(self.address_id)) {
                    if (addressModel.is_default) {
                        //有默认的
                        self.address = [addressModel mj_keyValues];
                    }
                }else{
                    //不为空说明
                    if ([addressModel.address_id isEqualToString:self.address_id]) {
                        //将编辑过的地址重新获取
                        self.address = [addressModel mj_keyValues];
                    }
                }
                
            }
            if (kDictIsEmpty(self.address)) {
                self.address = @{
                                 @"address" : @"",
                                 @"address_id" : @"",
                                 @"city" : @"",
                                 @"consignee" : @"",
                                 @"district" : @"",
                                 @"mobile" : @"",
                                 @"province" : @"",
                                 
                                 };
            }
            [self loadAddressData];
            
        } failure:^(NSError *error) {
            
        } RefreshAction:^{
            
        }];
        [self loadGoodData];
    }
    
}

//进行数据的请求
-(void)loadAddressData
{
    
    self.address_id = self.address[@"address_id"];
    //每次进行数据请求初始化数组
    self.addressdataSource = [NSMutableArray array];
    
    NSString *province;
    NSString *city;
    NSString *district;
    
    for (AreaModel *model in self.dataArray) {
        
        if ([model.area_id isEqualToString:self.address[@"province"]]) {
            province = model.name;
        }
        
        if ([model.area_id isEqualToString:self.address[@"city"]]) {
            city = model.name;
        }
        
        if ([model.area_id isEqualToString:self.address[@"district"]]) {
            district = model.name;
        }
    }
    
    NSDictionary *addressdic = @{
                                 //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                 @"cellid":self.address_id,
                                 
                                 @"bgUrlString":@"shouhuodizhibeijing",
                                 @"leftsmalladdressUrlString":@"dingwei",
                                 @"shouhuorenString":kStringIsEmpty([self.address objectForKey:@"consignee"])?@"":[NSString stringWithFormat:@"收货人:%@",[self.address objectForKey:@"consignee"]],
                                 @"morensmallUrlString":kStringIsEmpty([self.address objectForKey:@"address"])?@"":@"moren",
                                 @"phonenumString":kStringIsEmpty([self.address objectForKey:@"mobile"])?@"":[self.address objectForKey:@"mobile"],
                                 @"shouhuoaddressString":kStringIsEmpty([self.address objectForKey:@"address"])?@"请选择收货地址":[NSString stringWithFormat:@"%@%@%@%@",province, city, district, self.address[@"address"]],
                                 @"rightsmallUrlString":@"rightjiantou",
                                 };
    
    //            //初始化模型
    SeleteAddressModel *addressmodel = [SeleteAddressModel mj_objectWithKeyValues:addressdic];
    //            //把模型添加到相应的数据源数组中
    [self.addressdataSource addObject:addressmodel];
    
    
    
    //    for (NSMutableDictionary * business_infodic in self.model.business_info) {
    
    //        NSString * bbusiness_idstring=[business_infodic objectForKey:@"business_id"];
    //        for (NSMutableDictionary * order_goodsdic in [_resultdic objectForKey:@"order_goods"]) {
    //            NSString * gbusiness_idstring=[order_goodsdic objectForKey:@"business_id"];
    //            if ([gbusiness_idstring isEqualToString:bbusiness_idstring]) {
    
    
    //    }
    
    [mytableview reloadData];
}

//加载商品数据
-(void)loadGoodData
{
    self.business_infoarray=[NSMutableArray new];
    
    for (NSMutableDictionary * business_infodic in [_resultdic objectForKey:@"business_info"]) {
        self.order_goodsarray = [NSMutableArray new];
        NSMutableDictionary *mutabledc = [business_infodic mutableCopy];
        NSString * bbusiness_idstring = [business_infodic objectForKey:@"business_id"];
        for (NSMutableDictionary * order_goodsdic in [_resultdic objectForKey:@"order_goods"]) {
            NSString * gbusiness_idstring = [order_goodsdic objectForKey:@"business_id"];
            if ([gbusiness_idstring isEqualToString:bbusiness_idstring]) {
                
                NSDictionary *ordergoodsdic = @{
                                                //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                                @"cellid":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"goods_id"]],
                                                
                                                @"ordergoodsimgUrlString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"original_img"]],
                                                @"ordergoodstitleString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"goods_name"]],
                                                @"ordergoodsxianjiaString":[order_goodsdic objectForKey:@"goods_price"],
                                                //                                                @"ordergoodssubtitleString":order_goodsdic[@"spec_key_name"] ? order_goodsdic[@"spec_key_name"]:@"",
                                                @"ordergoodssubtitleString":order_goodsdic[@"spec_key_name"],
                                                
                                                @"ordergoodsyuanjiaString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"market_price"]],
                                                @"ordergoodscountString":[NSString stringWithFormat:@"%@",[order_goodsdic objectForKey:@"goods_num"]],
                                                @"ordergoodssmallimgUrlString":@"qitiantuikuan",
                                                };
                
                //            //初始化模型
                OrderGoodsModel *ordergoodsmodel=[OrderGoodsModel mj_objectWithKeyValues:ordergoodsdic];
                //            //把模型添加到相应的数据源数组中
                [self.order_goodsarray addObject:ordergoodsmodel];
                
            }
        }
        [mutabledc setObject:self.order_goodsarray forKey:@"order_goodsarray"];
        [self.business_infoarray addObject:mutabledc];
    }
    
    
    NSLog(@"%@",self.business_infoarray);
    
    //设置完成数据进行当前表视图的刷新
    [mytableview reloadData];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (kStringIsEmpty(currentBalance)) {
        return self.business_infoarray.count + 3;
    }
    
    return self.business_infoarray.count + 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _addressdataSource.count;
    }else if(section==self.business_infoarray.count+1){
        return self.lefttextarray.count;
    }else if(section==self.business_infoarray.count+2){
        return _paytextarray.count;
    }else if(section==self.business_infoarray.count+3){
        return _thirdPayTextArray.count;
    }else{
        NSDictionary *dic=self.business_infoarray[section-1];
        NSArray *array=[dic objectForKey:@"order_goodsarray"];
        return array.count;
    }
}

- (SeleteAddressTableViewCell *)extracted:(UITableView * _Nonnull)tableView {
    SeleteAddressTableViewCell *cell = [SeleteAddressTableViewCell mainTableViewCellWithTableView:tableView];
    return cell;
}

//初始化当前表视图的每行的cell以及相应的表的属性设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        //通过cell的类方法直接初始化cell
        SeleteAddressTableViewCell * cell = [self extracted:tableView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //根据相应的cell的行数进行每行cell的数据设置
        kArrayIsEmpty(self.addressdataSource)?:[cell setSeleteAddressModel:self.addressdataSource[indexPath.row]];
        return cell;
    }else  if(indexPath.section==self.business_infoarray.count+1||indexPath.section == self.business_infoarray.count+2||indexPath.section == self.business_infoarray.count+3){
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
                [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            }
            [cell.textLabel setText:self.lefttextarray[indexPath.row]];
            [cell.detailTextLabel setText:self.righttextarray[indexPath.row]];
            
        }else{
            [line removeFromSuperview];
            if (indexPath.section == self.business_infoarray.count + 2) {
                //没有余额，则不需要展示组合支付
                if (kStringIsEmpty(currentBalance)) {
                    [self setViewOnCell:cell indexPath:indexPath selectArr:self.thirdPaySelectArray payimgArr:self.thirdPayImgArray paytextArr:self.thirdPayTextArray];
                }else{
                    [self setViewOnCell:cell indexPath:indexPath selectArr:self.payselectarray payimgArr:self.payimgarray paytextArr:self.paytextarray];
                }
            }else if (indexPath.section == self.business_infoarray.count + 3)
            {
                [self setViewOnCell:cell indexPath:indexPath selectArr:self.thirdPaySelectArray payimgArr:self.thirdPayImgArray paytextArr:self.thirdPayTextArray];
            }
            //没有余额，则不需要展示组合支付
            //            if (kStringIsEmpty(currentBalance)) {
            //                [self setViewOnCell:cell indexPath:indexPath selectArr:self.thirdPaySelectArray payimgArr:self.thirdPayImgArray paytextArr:self.thirdPayTextArray];
            //            }else{
            //
            //                if (indexPath.section == self.business_infoarray.count+2) {
            //                    [self setViewOnCell:cell indexPath:indexPath selectArr:self.payselectarray payimgArr:self.payimgarray paytextArr:self.paytextarray];
            //                }else if(indexPath.section == self.business_infoarray.count+3){
            //                    [self setViewOnCell:cell indexPath:indexPath selectArr:self.thirdPaySelectArray payimgArr:self.thirdPayImgArray paytextArr:self.thirdPayTextArray];
            //                }
            //            }
            
            
            
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
    }else if(indexPath.section==self.business_infoarray.count+2||indexPath.section==self.business_infoarray.count+3){
        return 70;
    }else{
        NSDictionary *dic=self.business_infoarray[indexPath.section-1];
        NSArray *array=[dic objectForKey:@"order_goodsarray"];
        return kArrayIsEmpty(array)?0:[mytableview cellHeightForIndexPath:indexPath model:array[indexPath.row] keyPath:@"OrderGoodsModel" cellClass:[OrderGoodsTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0&&section!=self.business_infoarray.count+1) {
        return 44;
    }else{
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.business_infoarray.count+1) {
        return 10;
    }else{
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section!=0&&section!=self.business_infoarray.count+1) {
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [headview setBackgroundColor:[UIColor whiteColor]];
        if (section!=self.business_infoarray.count+2&&section!=self.business_infoarray.count+3) {
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
            mobileString=[dic objectForKey:@"mobile"];
            [dianhua addTarget:self action:@selector(callphone:) forControlEvents:UIControlEventTouchUpInside];
            dianhua.sd_layout
            .rightSpaceToView(headview, 10)
            .centerYEqualToView(headview)
            .widthIs(15)
            .heightIs(15);
            
        }else{
            
            UILabel *titlelabel=[[UILabel alloc]init];
            if (kStringIsEmpty(currentBalance)) {
                [titlelabel setText:@"支付方式"];
            }else{
                
                if (section == self.business_infoarray.count+2) {
                    [titlelabel setText:@"组合支付"];
                }else{
                    [titlelabel setText:@"支付方式"];
                }
                
            }
            [titlelabel setTextColor:[UIColor blackColor]];
            [titlelabel setFont:PFR15Font];
            [headview addSubview:titlelabel];
            titlelabel.sd_layout
            .centerYEqualToView(headview)
            .leftSpaceToView(headview, 20)
            .widthIs(SCREEN_WIDTH/2)
            .heightIs(headview.height)
            ;
            
            //分割线
            UIView *speratorLine = [UIView new];
            speratorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
            [headview addSubview:speratorLine];
            speratorLine.sd_layout
            .leftEqualToView(headview)
            .bottomEqualToView(headview)
            .rightEqualToView(headview)
            .heightIs(0.5)
            ;
            
        }
        
        return headview;
        
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
    if (indexPath.section == self.business_infoarray.count + 2) {
        
        if (kStringIsEmpty(currentBalance)) {   //说明只有第三方支付
            //顺序遍历
            [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                idx == indexPath.row?[_payselectarray replaceObjectAtIndex:idx withObject:@"1"]:[_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
            }];
            [self setbottomviewWithType:@"支付宝支付"];
        }else{  //组合支付
            //清除第三方支付的
            [_thirdPaySelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [_thirdPaySelectArray replaceObjectAtIndex:idx withObject:@"0"];
            }];
            //选中组合支付中的
            [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                idx == indexPath.row?[_payselectarray replaceObjectAtIndex:idx withObject:@"1"]:[_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
            }];
            [self setbottomviewWithType:@"组合支付"];
        }
        
        //        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        //        [mytableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
        [self setbottomviewWithType:@"支付宝支付"];
        //        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        //        [mytableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [mytableview reloadData];
        
    } else if (indexPath.section==0) {
        
        AddressViewController *avc = [AddressViewController new];
        avc.titleType = 1;
        MCWeakSelf
        avc.deleteAddressBlock = ^(NSString *deletedAddress_id) {
            NSLog(@"删除的地址id：%@",deletedAddress_id);
            
            if ([deletedAddress_id isEqualToString:weakSelf.address_id]) {
                //如果删除的地址中包括已经显示的，那么需要清除这里的记录显示
                NSMutableDictionary *dic = [NSMutableDictionary new];
                for (NSString *key in weakSelf.address) {
                    [dic setValue:@"" forKey:key];
                }
                weakSelf.address = [NSDictionary dictionaryWithDictionary:dic];
                weakSelf.address_id = @"";  //置空
                [self.addressdataSource removeAllObjects];
                SeleteAddressModel *addressmodel = [SeleteAddressModel new];
                addressmodel.cellid = @"";
                addressmodel.bgUrlString = @"shouhuodizhibeijing";
                addressmodel.leftsmalladdressUrlString = @"dingwei";
                addressmodel.shouhuorenString = @"";
                addressmodel.morensmallUrlString = @"";
                addressmodel.phonenumString = @"";
                addressmodel.shouhuoaddressString = @"请选择收货地址";
                addressmodel.rightsmallUrlString = @"rightjiantou";
                [self.addressdataSource addObject:addressmodel];
                [mytableview reloadData];   //刷新界面
                
            }else{
                NSLog(@"删除的地址不是已选择的");
            }
            
        };
        
        avc.editeAddressBlock = ^(NSString *editeAddress_id) {
            NSLog(@"编辑完的地址id:%@",editeAddress_id);
            if ([editeAddress_id isEqualToString:weakSelf.address_id]) {
                //说明编辑完的正好是现在已选择了的
                [weakSelf loadData];
            }
        };
        
        avc.didSelectedAddressHander = ^(KYAddressModel *model) {
            NSLog(@"%@---%@---%@---%@",model.address_id,model.consignee,model.mobile,model.address);
            
            [weakSelf checkAddress:[weakSelf.resultdic objectForKey:@"order_shop"] andaddressid:model.address_id compete:^{
                
                blockreturnaddressstring=model.address;
                //每次进行数据请求初始化数组
                weakSelf.addressdataSource=[NSMutableArray array];
                NSString *province;
                NSString *city;
                NSString *district;
                
                for (AreaModel *temp in weakSelf.dataArray) {
                    if ([model.province isEqualToString:temp.area_id]) {
                        province = temp.name;
                    }
                    if ([model.city isEqualToString:temp.area_id]) {
                        city = temp.name;
                    }
                    if ([model.district isEqualToString:temp.area_id]) {
                        district = temp.name;
                    }
                }
                
                NSDictionary *addressdic = @{
                                             //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                             @"cellid":[NSString stringWithFormat:@"%@",model.address_id],
                                             
                                             @"bgUrlString":@"shouhuodizhibeijing",
                                             @"leftsmalladdressUrlString":@"dingwei",
                                             @"shouhuorenString":[NSString stringWithFormat:@"收货人:%@",model.consignee],
                                             @"morensmallUrlString":model.is_default==YES?@"moren":@"",
                                             @"phonenumString":model.mobile,
                                             @"shouhuoaddressString":[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@%@%@", province, city, district, model.address]],
                                             @"rightsmallUrlString":@"rightjiantou",
                                             };
                
                //            //初始化模型
                SeleteAddressModel *addressmodel=[SeleteAddressModel mj_objectWithKeyValues:addressdic];
                //            //把模型添加到相应的数据源数组中
                [weakSelf.addressdataSource addObject:addressmodel];
                
                NSString *total_amountstring=[weakSelf.resultdic objectForKey:@"total_amount"];
                NSString *shipping_pricestring=[weakSelf.resultdic[@"shipping_price"] description];
                realpaymentstring=[weakSelf.resultdic objectForKey:@"order_amount"];
                
                weakSelf.righttextarray=@[[NSString stringWithFormat:@"￥%.2f",total_amountstring.floatValue],[NSString stringWithFormat:@"¥%.2f", shipping_pricestring.floatValue],@"-￥0.00",@"-￥0.00",[NSString stringWithFormat:@"¥%.2f",realpaymentstring.floatValue]];
                weakSelf.shifukuanlabel.text =[NSString stringWithFormat:@"实付款:￥%.2f",realpaymentstring.floatValue];
                [mytableview reloadData];
            }];
            
            
        };
        
        [self.navigationController pushViewController:avc animated:YES];
        
    }else{
        
        
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

-(void)checkAddress:(NSString *)ordersn andaddressid:(NSString *)addressid compete:(void(^)())completionBlock{
    MCWeakSelf
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    //    [requestdic setObject:ordersn forKey:@"order_sn"];
    //    [requestdic setObject:addressid forKey:@"address_id"];
    
    //    [HttpRequest postWithTokenURLString:NetRequestUrl(checkAddress) parameters:requestdic
    //                           isShowToastd:(BOOL)NO
    //                              isShowHud:(BOOL)NO
    //                       isShowBlankPages:(BOOL)NO
    //                                success:^(id responseObject)  {
    //
    //                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
    //                                    NSDictionary *result=[responseObject objectForKey:@"result"];
    //
    //                                    if (codeStr.intValue==1) {
    //                                        _resultdic = [result mutableCopy];
    //                                        self.address_id = requestdic[@"address_id"];
    //                                        completionBlock();
    //                                    }
    //
    //                                } failure:^(NSError *error) {
    //                                    //打印网络请求错误
    //                                    NSLog(@"%@",error);
    //
    //                                } RefreshAction:^{
    //                                    //执行无网络刷新回调方法
    //
    //                                }];
    
    weakSelf.baseDic[@"address_id"] = addressid;
    if (weakSelf.type == 1) {
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(buyCart) parameters:self.baseDic
                               isShowToastd:(BOOL)NO
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            
                                            weakSelf.resultdic = [result mutableCopy];
                                            weakSelf.address_id = addressid;
                                            completionBlock();
                                            
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
    } else if (weakSelf.type == 2) {
        [HttpRequest postWithTokenURLString:NetRequestUrl(buyNow) parameters:self.baseDic
                               isShowToastd:(BOOL)NO
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSDictionary *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            
                                            weakSelf.resultdic = [result mutableCopy];
                                            weakSelf.address_id = addressid;
                                            completionBlock();
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
    }
}


-(void)setbottomviewWithType:(NSString *)type
{
    
    if (_bottomview) {
        
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:￥%.2f",type,realpaymentstring.floatValue]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:[NSString stringWithFormat:@"%@:",type]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        self.shifukuanlabel.attributedText = hintString;
    }else{
        _bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NAVI_HEIGHT- 44 - BOTTOM_MARGIN, SCREEN_WIDTH,44+BOTTOM_MARGIN)];
        [self.view addSubview:_bottomview];
        
        UILabel *linelabel=[[UILabel alloc]init];
        [linelabel setBackgroundColor:[UIColor lightGrayColor]];
        [_bottomview addSubview:linelabel];
        linelabel.sd_layout
        .topEqualToView(_bottomview)
        .centerXEqualToView(_bottomview)
        .widthIs(_bottomview.width)
        .heightIs(1);
        
        YYFButton *submitordersbtn=[[YYFButton alloc]init];
        [submitordersbtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [submitordersbtn.titleLabel setFont:PFR12Font];
        [_bottomview addSubview:submitordersbtn];
        [submitordersbtn addTarget:self action:@selector(submitordersbtnClick) forControlEvents:UIControlEventTouchUpInside];
        submitordersbtn.sd_layout
        .centerYEqualToView(_bottomview)
        .rightEqualToView(_bottomview)
        .widthIs(SCREEN_WIDTH/4)
        .heightIs(_bottomview.height);
        
        UILabel *shifukuanlabel = [[UILabel alloc]init];
        [shifukuanlabel setTextColor:[UIColor redColor]];
        self.shifukuanlabel = shifukuanlabel;
        [shifukuanlabel setFont:PFR15Font];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:￥%.2f",type,realpaymentstring.floatValue]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:[NSString stringWithFormat:@"%@:",type]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        shifukuanlabel.attributedText=hintString;
        [_bottomview addSubview:shifukuanlabel];
        shifukuanlabel.sd_layout
        .centerYEqualToView(_bottomview)
        .rightSpaceToView(submitordersbtn, 10)
        .autoHeightRatio(0);
        [shifukuanlabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    }
    
    
}

-(void)callphone:(UIButton *)btn{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobileString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)headBtnClick:(UIButton *)btn{
    
    StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
    sdvc.business_idstring=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:sdvc animated:YES];
    
}

//提交订单
-(void)submitordersbtnClick{
    
    if(kStringIsEmpty([_resultdic objectForKey:@"address"])&&kStringIsEmpty(blockreturnaddressstring)){
        LRToast(@"请选择收货地址");
    }else{
        if (self.address_id) {
            
            self.baseDic[@"address_id"] = self.address_id;
        }
        self.baseDic[@"type"] = @"2";
        
        if (self.type == 1) {
            
            [HttpRequest postWithTokenURLString:NetRequestUrl(buyCart) parameters:self.baseDic
                                   isShowToastd:(BOOL)YES
                                      isShowHud:(BOOL)YES
                               isShowBlankPages:(BOOL)NO
                                        success:^(id responseObject)  {
                                            
                                            NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                            NSDictionary *result=[responseObject objectForKey:@"result"];
                                            
                                            if (codeStr.intValue==1) {
                                                _resultdic[@"order_shop"] = responseObject[@"result"][@"order_shop"];
                                                
                                                [self processPayLogic];
                                                
                                            }
                                            
                                        } failure:^(NSError *error) {
                                            //打印网络请求错误
                                            NSLog(@"%@",error);
                                            
                                        } RefreshAction:^{
                                            //执行无网络刷新回调方法
                                            
                                        }];
        } else if (self.type == 2) {
            [HttpRequest postWithTokenURLString:NetRequestUrl(buyNow) parameters:self.baseDic
                                   isShowToastd:(BOOL)YES
                                      isShowHud:(BOOL)YES
                               isShowBlankPages:(BOOL)NO
                                        success:^(id responseObject)  {
                                            
                                            NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                            NSDictionary *result=[responseObject objectForKey:@"result"];
                                            
                                            if (codeStr.intValue==1) {
                                                
                                                _resultdic[@"order_shop"] = responseObject[@"result"][@"order_shop"];
                                                
                                                [self processPayLogic];
                                                
                                            }
                                            
                                        } failure:^(NSError *error) {
                                            //打印网络请求错误
                                            NSLog(@"%@",error);
                                            
                                        } RefreshAction:^{
                                            //执行无网络刷新回调方法
                                            
                                        }];
        }
        
        
    }
    
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
            gpVC.order_shop = _resultdic[@"order_shop"];
            gpVC.consume_money = consume_money;
            gpVC.money = money;
            gpVC.total = currentBalance;
            gpVC.payTotal = realpaymentstring;
            gpVC.order_name = [_resultdic[@"order_goods"] firstObject][@"goods_name"];
            [self.navigationController pushViewController:gpVC animated:YES];
        }else{  //余额充足，直接弹框支付
            [self Determineifthereisapaymentpassword];
        }
    }else{  //只选择了支付宝支付
        [self doAPPay];
    }
    
//    [_thirdPaySelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isEqualToString:@"1"]) {
//
//            if (idx == 0) {
//                [self doAPPay];
//            }
            //                                                        else  if (idx==1) {
            //                                                            if (ShowUPPay) {
            //                                                                [self doUPPay];
            //                                                            }else{
            //                                                                [self Determineifthereisapaymentpassword];
            //                                                            }
            //                                                        }else if (idx==2) {
            //                                                            [self Determineifthereisapaymentpassword];
            //                                                        }
            
//        }
//    }];
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
    order.biz_content.out_trade_no = [_resultdic objectForKey:@"order_shop"]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", realpaymentstring.floatValue]; //商品价格
    
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
            if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                LRToast(@"支付取消");
                GCDAfter1s(^{
                    MyOrderViewController *vc = [MyOrderViewController new];
                    vc.index = 1;
                    [self.navigationController pushViewController:vc animated:YES];
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                });
            }
        }];
    }
}
//生成随机订单号
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
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
            // 移除当前对象监听的事件
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            LRToast(@"支付成功");
            [self requestResponse:(NSDictionary *)resp.object andorderstring:[_resultdic objectForKey:@"order_shop"]];
        }
            break;
            
        default:{
            LRToast(@"支付失败");
            GCDAfter1s(^{
                MyOrderViewController *vc = [MyOrderViewController new];
                vc.index = 1;
                [self.navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            });
            
        }
            break;
    }
    
}

-(void)requestResponse:(NSDictionary *)respdic andorderstring:(NSString *)orderstring{
    
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:orderstring forKey:@"order_shop"];
    [requestdic setObject:[respdic objectForKey:@"resultStatus"] forKey:@"trade_status"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(response) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)NO
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

//进行支付之前先判断用户是否设置了支付密码 如果没有设置跳转到设置页面
-(void)Determineifthereisapaymentpassword{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
        if ([res[@"code"] integerValue] == 1) {
            
            [self doBalancePay:[_resultdic objectForKey:@"order_shop"] andorder_amount:[NSString stringWithFormat:@"%.2f", realpaymentstring.floatValue] andtypestring:@"1"];
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:nil RefreshAction:nil];
    
    
}

//余额支付
-(void)doBalancePay:(NSString *)orderstring andorder_amount:(NSString *)order_amount andtypestring:(NSString *)typestring{
    
    DCPaymentView *payAlert = [[DCPaymentView alloc]init];
    payAlert.title = @"请输入支付密码";
    //    payAlert.detail = @"提现";
    //    payAlert.amount= 10;
    [payAlert show];
    MCWeakSelf
    payAlert.cancelHandler = ^{
        MyOrderViewController *vc = [MyOrderViewController new];
        vc.index = 1;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    payAlert.completeHandle = ^(NSString *inputPwd) {
        //        NSLog(@"密码是%@",inputPwd);
        
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
                                        
                                        NSInteger codeStr = [responseObject[@"code"] integerValue];
                                        NSDictionary *result = [responseObject objectForKey:@"result"];
                                        
                                        if (codeStr == 1||codeStr == 2) {
                                            
                                            GCDAfter1s(^{
                                                MyOrderViewController *vc = [MyOrderViewController new];
                                                if (codeStr == 1) {
                                                    vc.index = 2;
                                                }else{
                                                    vc.index = 1;
                                                }
                                                
                                                [weakSelf.navigationController pushViewController:vc animated:YES];
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

//银联支付
-(void)doUPPay{
    
    //当获得的tn不为空时，调用支付接口
    //if (tn != nil && tn.length > 0)
    //{
    [[UPPaymentControl defaultControl]
     startPay:[_resultdic objectForKey:@"order_shop"]
     fromScheme:@"UPPay"
     mode:@"01"
     viewController:self];
    //}
    
}


- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end




