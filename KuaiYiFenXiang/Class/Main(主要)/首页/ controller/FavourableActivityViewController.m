//
//  AllOrdersViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "FavourableActivityViewController.h"

#import "FavourableActivityModel.h"

#import "FavourableActivityTableViewCell.h"

#import "FavourableActivityDetailsScrollViewController.h"

#import "GetDiscountView.h" //注册红包弹框

@interface FavourableActivityViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) NSMutableArray *dataSource;



@end

@implementation FavourableActivityViewController{
    
    UITableView*mytableview;
    NSInteger pageNum;
}


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公告";
    
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    mytableview.tableFooterView = [UIView new];
    mytableview.estimatedRowHeight = 0;
    mytableview.estimatedSectionFooterHeight = 0;
    mytableview.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:mytableview];
    mytableview.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    
    //进行刷新时开始刷新状态请求数据
    mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        pageNum=0;
        
        [self requestToGetDiscountList];
        
    }];
    
    // 上拉加载
    mytableview.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        
        //上拉加载把page数加一
        pageNum++;
        
        [self requestToGetDiscountList];
        
    }];
    
    [mytableview.mj_header beginRefreshing];
}

//进行数据的请求
-(void)loadNewData{
    
    
    
    
    
    
    //每次进行数据请求初始化数组
    self.dataSource=[NSMutableArray array];

    //通过循环模拟数据的请求
    for (int i = 0; i < 8; i++) {



//        @property (nonatomic, copy) NSString *cellid;
//        @property (nonatomic, copy) NSString *youhuititleString;
//        @property (nonatomic, copy) NSString *youhuitimeString;
//        @property (nonatomic, copy) NSString *youhuiimageString;
//        @property (nonatomic, copy) NSString *youhuicontentString;
//        @property (nonatomic, copy) NSString *checkdetailsBtnString;

        NSDictionary *dic = @{
                              //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
                              @"cellid":[NSString stringWithFormat:@"%d",i],

                              @"youhuititleString":@"褐色高领毛衣",
                              @"youhuitimeString":@"2018-1-1",
                              @"youhuiimageString":@"",
                              @"youhuicontentString":@"褐色高领毛衣褐色高领毛衣褐色高领毛衣褐色高领毛衣褐色高领毛衣褐色高领毛衣",
                              @"checkdetailsBtnString":@"查看详情",

                              };

        //            //初始化模型
        FavourableActivityModel *model=[FavourableActivityModel mj_objectWithKeyValues:dic];
        //
        //            //把模型添加到相应的数据源数组中
        [self.dataSource addObject:model];


    }


    //设置完成数据进行当前表视图的刷新
    [mytableview reloadData];

    if (kArrayIsEmpty(self.dataSource)) {
        [self showEmptyView];
    }
    
}

//获取活动列表
-(void)requestToGetDiscountList
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"page"] = @(pageNum);
    [HttpRequest postWithTokenURLString:NetRequestUrl(favourableList) parameters:dic isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
        if ([res[@"code"] integerValue] == 1) {
            NSArray *discountArr = [DiscountListModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
            [self hideEmptyView];
            if (kArrayIsEmpty(discountArr)) {
                if (pageNum == 0) { //说明是下拉无数据，则直接显示无内容
                    [self showEmptyView];
                    [self endRefresh];
                }else{
                    [mytableview.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                
                if (pageNum == 0) {
                    [self.dataSource removeAllObjects];
                    [mytableview.mj_footer endRefreshing];
                }
                
                [self.dataSource addObjectsFromArray:discountArr];
                
                [mytableview reloadData];
                
                [self endRefresh];
            }
        }else{  //code不为1时
            [self endRefresh];
            [mytableview reloadData];
        }
        
    } failure:^(NSError *error) {
        [self endRefresh];
    } RefreshAction:nil];
    
}

//请求活动是否需要弹框
-(void)requestToShowDiscountViewWithDiscountId:(NSString *)discountId
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = discountId;
    [HttpRequest postWithTokenURLString:NetRequestUrl(favourableType) parameters:dic isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        if ([res[@"code"] integerValue] == 1) {
            if ([res[@"result"][@"get"] integerValue] == 1) {
                //未领取
                if (discountId.integerValue == 1) { //为1代表是红包
                    [self showGetDiscountViewWithId:discountId];
                }else{
                    //其他待定
                }
                
            }else{
                NSLog(@"已领取");
            }
        }
        
    } failure:nil RefreshAction:nil];
}

-(void)showEmptyView
{
    UIImageView *emptyImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无消息"]];
    [self.view addSubview:emptyImageView];
    emptyImageView.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(self.view.height * 0.4)
    .widthIs(SCREEN_WIDTH/3)
    .heightIs(SCREEN_WIDTH/3);
    
    UILabel *emptyLabel=[[UILabel alloc]init];
    [emptyLabel setTextColor:[UIColor grayColor]];
    [emptyLabel setText:@"暂无此类消息哦,去商城逛逛吧!"];
    [emptyLabel setFont:PFR15Font];
    [emptyLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:emptyLabel];
    emptyLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(emptyImageView, 10)
    .widthIs(SCREEN_WIDTH)
    .heightIs(30);
    
    [mytableview.mj_footer setHidden:YES];
}

//去除无内容提示
-(void)hideEmptyView
{
    for (id view in self.view.subviews) {
        if (![view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
        }
    }
    [mytableview.mj_footer setHidden:NO];
}

-(void)endRefresh
{
    if ([mytableview.mj_header isRefreshing]) {
        [mytableview.mj_header endRefreshing];
    }
    if ([mytableview.mj_footer isRefreshing]) {
        [mytableview.mj_footer endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


//初始化当前表视图的每行的cell以及相应的表的属性设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //通过cell的类方法直接初始化cell
    FavourableActivityTableViewCell *cell = [FavourableActivityTableViewCell mainTableViewCellWithTableView:tableView];
    
    //根据相应的cell的行数进行每行cell的数据设置
//    cell.FavourableActivityModel = self.dataSource[indexPath.section];
    cell.discountModel = self.dataSource[indexPath.section];
    
    //设置相应的cell以及表视图的属性
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [mytableview setShowsVerticalScrollIndicator:NO];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView.layer setMasksToBounds:YES];
    [cell.contentView.layer setCornerRadius:10];
//    cell.contentView.layer.borderWidth = 1;
//    cell.contentView.layer.borderColor = CELLBORDERCOLOR.CGColor;
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取cell高度
    return [mytableview cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.section] keyPath:@"discountModel" cellClass:[FavourableActivityTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DiscountListModel *model = self.dataSource[indexPath.section];
    NSInteger type = model.type.integerValue;
    switch (type) {
        case 1:
        {
            [self requestToShowDiscountViewWithDiscountId:model.discount_id];
        }
            break;
            
        default:
            break;
    }
    
//    FavourableActivityDetailsScrollViewController *fadsvc = [[FavourableActivityDetailsScrollViewController alloc]init];
//    [self.navigationController pushViewController:fadsvc animated:YES];
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 6.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor cyanColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
}

//弹出红包领取框
-(void)showGetDiscountViewWithId:(NSString *)discount_id
{
    GetDiscountView *discountView = [GetDiscountView new];
    [self.view addSubview:discountView];
    MCWeakSelf;
    discountView.getDiscountBlock = ^{
        [weakSelf getDiscountWithId:discount_id];
    };
    
    discountView.closeBlock = ^{
        
    };
}

-(void)getDiscountWithId:(NSString *)discount_id
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = discount_id;
    [HttpRequest postWithTokenURLString:NetRequestUrl(favourable) parameters:dic isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            GCDAfter1s(^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
}

@end




