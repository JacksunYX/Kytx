//
//  VIPOrderViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/25.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "VIPOrderViewController.h"
#import "SeleteAddressModel.h"
#import "SeleteAddressTableViewCell.h"

#import "OrderGoodsModel.h"
//#import "OrderGoodsTableViewCell.h"

#import "AddressViewController.h"
#import "StoreDisplayViewController.h"

#import "KYAddressModel.h"

#import "PayChangeViewController.h"

#import "MyOrderViewController.h"
#import "VIPOrderGoodsTableViewCell.h"

#import "AreaModel.h"
#import "VIPSuccessViewController.h"

@interface VIPOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *addressdataSource;

@property(nonatomic,strong) NSArray *lefttextarray;
@property(nonatomic,strong) NSArray *righttextarray;
@property(nonatomic,strong) NSArray *payimgarray;
@property(nonatomic,strong) NSArray *paytextarray;
@property(nonatomic,strong) NSMutableArray *payselectarray;

@property(nonatomic,strong) UIView *bottomview;

@property (nonatomic, strong) UIButton *payselectButton;
@property (nonatomic, strong) UIImageView *payImageview;
@property (nonatomic, strong) UILabel *paytextLabel;
@property (nonatomic, strong) UIImageView *paysmallImageview;

@property(nonatomic,strong) NSMutableArray *business_infoarray;
@property(nonatomic,strong) NSMutableArray *order_goodsarray;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *addressArr;  //保存获取到的收货地址的数组

@property (nonatomic, strong) NSString *address_id;
@property (nonatomic, strong) UILabel *shifukuanlabel;


@end

@implementation VIPOrderViewController

{
    
    UITableView*mytableview;
    NSString *realpaymentstring;
    NSString *blockreturnaddressstring;
    NSString *mobileString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    self.view.backgroundColor = kDefaultBGColor;
    
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-BOTTOM_MARGIN-44) style:UITableViewStyleGrouped];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    [self.view addSubview:mytableview];
    [mytableview registerClass:[SeleteAddressTableViewCell class] forCellReuseIdentifier:@"SeleteAddressTableViewCell"];
    
    self.lefttextarray = @[@"商品总额",@"总运费",@"拼团优惠",@"活动优惠",@"实付款"];
    
    NSString *total_amountstring=@"399.00";
    NSString *shipping_pricestring=@"0";
    realpaymentstring=@"399.00";
    self.righttextarray=@[[NSString stringWithFormat:@"￥%.2f",total_amountstring.floatValue],[NSString stringWithFormat:@"¥%.2f", shipping_pricestring.floatValue],@"-￥0.00",@"-￥0.00",[NSString stringWithFormat:@"¥%.2f",realpaymentstring.floatValue]];
    
    if (ShowUPPay) {
        self.payimgarray = @[@"zhifubao",@"yinlian",@"yue"];
        self.paytextarray = @[@"支付宝",@"银联",@"余额支付"];
        self.payselectarray = [@[@"1",@"0",@"0"] mutableCopy];
    }else{
        self.payimgarray = @[@"zhifubao",@"yue"];
        self.paytextarray = @[@"支付宝",@"余额支付"];
        self.payselectarray = [@[@"1",@"0"] mutableCopy];
    }
    
    [self setbottomview];
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
                                 @"shouhuoaddressString":kStringIsEmpty([self.address objectForKey:@"address"])?@"请选择收货地址":[NSString stringWithFormat:@"收货地址:%@%@%@%@",province, city, district, self.address[@"address"]],
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
    self.business_infoarray = [NSMutableArray new];
    self.order_goodsarray=[NSMutableArray new];
    NSMutableDictionary *mutabledc=[@{} mutableCopy];
    NSDictionary *ordergoodsdic = @{
                                    //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                                    @"cellid":self.model.goods_id,
                                    @"ordergoodsimgUrlString":self.model.original_img,
                                    @"ordergoodstitleString":self.model.goods_name,
                                    @"ordergoodsxianjiaString":@"",
                                    @"ordergoodssubtitleString":@"3.99分",
                                    @"ordergoodsyuanjiaString":@"",
                                    @"ordergoodscountString":@"",
                                    @"ordergoodssmallimgUrlString":@"积",
                                    };
    
    //            //初始化模型
    OrderGoodsModel *ordergoodsmodel = [OrderGoodsModel mj_objectWithKeyValues:ordergoodsdic];
    //            //把模型添加到相应的数据源数组中
    [self.order_goodsarray addObject:ordergoodsmodel];
    
    [mutabledc setObject:self.order_goodsarray forKey:@"order_goodsarray"];
    [self.business_infoarray addObject:mutabledc];
    
    [mytableview reloadData];
    
    NSLog(@"%@",self.business_infoarray);
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.business_infoarray.count+3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _addressdataSource.count;
    }else if(section==self.business_infoarray.count+1){
        return 0;
    }else if(section==self.business_infoarray.count+2){
        return _paytextarray.count;
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
        SeleteAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SeleteAddressTableViewCell" forIndexPath:indexPath];
        
        //根据相应的cell的行数进行每行cell的数据设置
        kArrayIsEmpty(self.addressdataSource)?:[cell setSeleteAddressModel:self.addressdataSource[indexPath.row]];
        return cell;
    }else  if(indexPath.section==self.business_infoarray.count+1||indexPath.section==self.business_infoarray.count+2){
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
        if (indexPath.section==self.business_infoarray.count+1) {
            
            if (indexPath.row==self.lefttextarray.count-1) {
                [cell.textLabel setFont:PFR15Font];
                [cell.detailTextLabel setFont:PFR15Font];
                [cell.textLabel setTextColor:[UIColor blackColor]];
                [cell.detailTextLabel setTextColor:[UIColor redColor]];
            }else{
                [cell.textLabel setFont:PFR12Font];
                [cell.detailTextLabel setFont:PFR12Font];
                [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            }
            [cell.textLabel setText:self.lefttextarray[indexPath.row]];
            [cell.detailTextLabel setText:self.righttextarray[indexPath.row]];
            
        }else{
            
            _payselectButton = [[UIButton alloc] init];
            [_payselectButton setImage:[UIImage imageNamed:@"normallgray"] forState:UIControlStateNormal];
            [_payselectButton setImage:[UIImage imageNamed:@"selectred"] forState:UIControlStateSelected];
            NSString *selstring=self.payselectarray[indexPath.row];
            [_payselectButton setSelected:selstring.intValue==1?YES:NO];
            [cell.contentView addSubview:_payselectButton];
            self.payselectButton.sd_layout
            .centerYEqualToView(cell.contentView)
            .leftSpaceToView(cell.contentView, 20)
            .widthIs(11)
            .heightIs(11);
            
            _payImageview = [[UIImageView alloc] init];
            [_payImageview setImage:[UIImage imageNamed:self.payimgarray[indexPath.row]]];
            [cell.contentView addSubview:_payImageview];
            self.payImageview.sd_layout
            .centerYEqualToView(cell.contentView)
            .leftSpaceToView(_payselectButton, 10)
            .widthIs(40)
            .heightIs(40);
            
            _paytextLabel = [[UILabel alloc] init];
            _paytextLabel.font=PFR12Font;
            _paytextLabel.textColor=[UIColor blackColor];
            _paytextLabel.textAlignment=NSTextAlignmentLeft;
            _paytextLabel.contentMode=UIViewContentModeCenter;
            [_paytextLabel setText:self.paytextarray[indexPath.row]];
            [cell.contentView addSubview:_paytextLabel];
            self.paytextLabel.sd_layout
            .centerYEqualToView(cell.contentView)
            .leftSpaceToView(_payImageview, 10)
            .autoHeightRatio(0);
            [self.paytextLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/3];
            
            _paysmallImageview = [[UIImageView alloc] init];
            indexPath.row==0?[_paysmallImageview setImage:[UIImage imageNamed:@"tuijian"]]:[_paysmallImageview setImage:[UIImage imageNamed:@""]];
            [cell.contentView addSubview:_paysmallImageview];
            self.paysmallImageview.sd_layout
            .centerYEqualToView(cell.contentView)
            .leftSpaceToView(_paytextLabel, 10)
            .widthIs(30)
            .heightIs(15);
            
        }
        return cell;
        
    }else{
        //通过cell的类方法直接初始化cell
        VIPOrderGoodsTableViewCell *cell = [VIPOrderGoodsTableViewCell mainTableViewCellWithTableView:tableView];
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
    }else if(indexPath.section==self.business_infoarray.count+2){
        return 44;
    }else{
        NSDictionary *dic=self.business_infoarray[indexPath.section-1];
        NSArray *array=[dic objectForKey:@"order_goodsarray"];
        return kArrayIsEmpty(array)?0:[mytableview cellHeightForIndexPath:indexPath model:array[indexPath.row] keyPath:@"OrderGoodsModel" cellClass:[VIPOrderGoodsTableViewCell class] contentViewWidth:[self cellContentViewWith]];
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
        if (section!=self.business_infoarray.count+2) {
            NSDictionary *dic=self.business_infoarray[section-1];
            UIButton *headBtn = [[UIButton alloc] init];
            [headBtn setImage:[UIImage imageNamed:@"dingdandianpu"] forState:UIControlStateNormal];
            [headBtn setTitle:[NSString stringWithFormat:@"%@ >",self.model.business_info.name] forState:UIControlStateNormal];
            [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            headBtn.titleLabel.font=PFR12Font;
            NSString *business_idstring=self.model.business_info.business_id;
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
            
            
        }else{
            
            UILabel *titlelabel=[[UILabel alloc]init];
            [titlelabel setText:@"支付方式"];
            [titlelabel setTextColor:[UIColor blackColor]];
            [titlelabel setFont:PFR15Font];
            [headview addSubview:titlelabel];
            titlelabel.sd_layout
            .centerYEqualToView(headview)
            .leftSpaceToView(headview, 20)
            .widthIs(SCREEN_WIDTH/2)
            .heightIs(headview.height);
            
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
    if (indexPath.section==self.business_infoarray.count+2) {
        //顺序遍历
        [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            idx==indexPath.row?[_payselectarray replaceObjectAtIndex:idx withObject:@"1"]:[_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
        }];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:self.business_infoarray.count+2];
//        [mytableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [mytableview reloadData];
        
    } else if (indexPath.section==0) {
        AddressViewController *avc=[AddressViewController new];
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
                    [weakSelf.addressdataSource removeAllObjects];
                    SeleteAddressModel *addressmodel = [SeleteAddressModel new];
                    addressmodel.cellid = @"";
                    addressmodel.bgUrlString = @"shouhuodizhibeijing";
                    addressmodel.leftsmalladdressUrlString = @"dingwei";
                    addressmodel.shouhuorenString = @"";
                    addressmodel.morensmallUrlString = @"";
                    addressmodel.phonenumString = @"";
                    addressmodel.shouhuoaddressString = @"请选择收货地址";
                    addressmodel.rightsmallUrlString = @"rightjiantou";
                    [weakSelf.addressdataSource addObject:addressmodel];
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
            
            weakSelf.address_id = model.address_id;
            
                blockreturnaddressstring = model.address;
                //每次进行数据请求初始化数组
                weakSelf.addressdataSource = [NSMutableArray array];
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
                                             @"shouhuoaddressString":[NSString stringWithFormat:@"收货地址:%@",[NSString stringWithFormat:@"%@%@%@%@", province, city, district, model.address]],
                                             @"rightsmallUrlString":@"rightjiantou",
                                             };
                
                //            //初始化模型
                SeleteAddressModel *addressmodel=[SeleteAddressModel mj_objectWithKeyValues:addressdic];
                //            //把模型添加到相应的数据源数组中
                [weakSelf.addressdataSource addObject:addressmodel];
            
                [mytableview reloadData];
            
        };
        
        [self.navigationController pushViewController:avc animated:YES];
        
    }else{
        
        
    }
    
    
}


-(void)setbottomview{
    
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
    [submitordersbtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitordersbtn.titleLabel setFont:PFR12Font];
    [_bottomview addSubview:submitordersbtn];
    [submitordersbtn addTarget:self action:@selector(submitordersbtnClick) forControlEvents:UIControlEventTouchUpInside];
    submitordersbtn.sd_layout
    .centerYEqualToView(_bottomview)
    .rightEqualToView(_bottomview)
    .widthIs(SCREEN_WIDTH/3)
    .heightIs(_bottomview.height);
    
    UILabel *shifukuanlabel=[[UILabel alloc]init];
    [shifukuanlabel setTextColor:[UIColor redColor]];
    self.shifukuanlabel = shifukuanlabel;
    [shifukuanlabel setFont:PFR15Font];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付款:￥%.2f",realpaymentstring.floatValue]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range=[[hintString string]rangeOfString:@"实付款:"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    shifukuanlabel.attributedText=hintString;
    [_bottomview addSubview:shifukuanlabel];
    shifukuanlabel.sd_layout
    .centerYEqualToView(_bottomview)
    .rightSpaceToView(submitordersbtn, 10)
    .autoHeightRatio(0);
    [shifukuanlabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
}

-(void)headBtnClick:(UIButton *)btn{
    
    StoreDisplayViewController *sdvc = [[StoreDisplayViewController alloc] init];
    sdvc.business_idstring=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self.navigationController pushViewController:sdvc animated:YES];
    
}

//提交订单
-(void)submitordersbtnClick{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if(kStringIsEmpty(self.address_id)){
        LRToast(@"请选择收货地址");
        return;
    }
    
    dict[@"address_id"] = self.address_id;
    dict[@"goods_id"] = self.model.goods_id;
    dict[@"order_amount"] = @"399.00";
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(vipOrder) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            self.tn = res[@"result"][@"order_shop"];
            self.info = @"快益分享商城VIP";
            [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:@"1"]) {
                    
                    if (idx==0) {
                        [self doAPPayAnmount:399.00];
                    }else  if (idx==1) {
                        if (ShowUPPay) {
                            [self doUPPay];
                        }else{
                            [self Determineifthereisapaymentpassword];
                        }
                    } if (idx==2) {
                        [self Determineifthereisapaymentpassword];
                    }
                }
            }];
        }
    } failure:nil RefreshAction:nil];
   
    
}

//进行支付之前先判断用户是否设置了支付密码 如果没有设置跳转到设置页面
-(void)Determineifthereisapaymentpassword{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            [self doBalancePay:self.tn andorder_amount:@"399.00" andtypestring:@"3"];
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    } failure:nil RefreshAction:nil];
    
    
}

- (void)paydone {
    
    GCDAfter1s(^{
        VIPSuccessViewController *vc = [VIPSuccessViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}

@end
