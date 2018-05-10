





//
//  AllOrdersViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "CollectionGoodsViewController.h"

#import "GeneralGoodsModel.h"

#import "CollectionGoodsTableViewCell.h"

static int pageNum=0;

@interface CollectionGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *emptyView;


@end

@implementation CollectionGoodsViewController{
    
    UITableView*mytableview;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收藏商品";
    
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    mytableview.tableFooterView = [UIView new];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    headView.backgroundColor = BACKVIEWCOLOR;
//    mytableview.tableHeaderView = headView;
    mytableview.estimatedRowHeight = 0;
    mytableview.estimatedSectionFooterHeight = 0;
    mytableview.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:mytableview];
    
    self.dataSource = [NSMutableArray new];
    
    //进行刷新时开始刷新状态请求数据
    mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        pageNum=0;
        
        //在请求数据的时间初始化当前的数据源数组防止数据重复
        [self.dataSource removeAllObjects];
        
        // 进入刷新状态后会自动调用这个block
        [self loadNewData];
        
    }];
    
    // 上拉加载
    mytableview.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        
        //上拉加载把page数加一
        pageNum++;
        
        // 进入刷新状态后会自动调用这个block
        [self loadNewData];
        
        
    }];
    
    // 马上进入刷新状态
    [mytableview.mj_header beginRefreshing];
    
}

//进行数据的请求
-(void)loadNewData{
    
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@(pageNum) forKey:@"page"];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(collectGoodslist) parameters:dic
                           isShowToastd:(BOOL)NO
                              isShowHud:(BOOL)NO
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                    NSMutableArray *result=[responseObject objectForKey:@"result"];
                                    
                                    if (kArrayIsEmpty(result)&&kArrayIsEmpty(self.dataSource)) {
                                        
                                        [mytableview.mj_footer endRefreshingWithNoMoreData];
                                        if (!self.emptyView) {
                                            UIView *aview = [UIView new];
                                            aview.backgroundColor = BACKVIEWCOLOR;
                                            self.emptyView = aview;
                                            
                                            [self.view addSubview:aview];
                                            [aview mas_makeConstraints:^(MASConstraintMaker *make) {
                                                make.center.equalTo(self.view);
                                                make.size.mas_equalTo(CGSizeMake(348/2.0, 200));
                                            }];
                                            
                                            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_collected"]];
                                            [aview addSubview:imageview];
                                            [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                                                make.left.top.right.equalTo(aview);
                                                make.height.mas_equalTo(150);
                                            }];
                                            mytableview.mj_footer = nil;
                                            UILabel *label = [UILabel new];
                                            label.textColor = kColor333;
                                            label.font = kFont(15);
                                            label.text = @"您还没有收藏任何商品";
                                            label.textAlignment = NSTextAlignmentCenter;
                                            [aview addSubview:label];
                                            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                                make.bottom.left.right.equalTo(aview);
                                                make.top.equalTo(imageview.mas_bottom);
                                            }];
                                            
                                        }
                                        
                                    }else{
                                        
                                        
                                        if (codeStr.intValue==1) {
                                            
                                            if (self.emptyView) {
                                                [self.emptyView removeFromSuperview];
                                                self.emptyView = nil;
                                            }
                                            for (NSDictionary * dic in result) {
                                                //初始化模型
                                                GeneralGoodsModel *model=[GeneralGoodsModel mj_objectWithKeyValues:dic];
                                                //把模型添加到相应的数据源数组中
                                                [_dataSource addObject:model];
                                            }
                                            [mytableview.mj_footer endRefreshing];
                                            
                                        }else{
                                            
                                            if ([responseObject[@"msg"] isEqualToString:@"没有更多数据了"]) {
                                                [mytableview.mj_footer endRefreshingWithNoMoreData];
                                            }else{
//                                                LRToast(responseObject[@"msg"]);
                                                [mytableview.mj_footer endRefreshing];
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    [mytableview.mj_header endRefreshing];
                                    
                                    [mytableview reloadData];
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                    [mytableview.mj_header endRefreshing];
                                    
                                    [mytableview.mj_footer endRefreshing];
                                    
                                    [mytableview reloadData];
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    
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
    CollectionGoodsTableViewCell *cell = [CollectionGoodsTableViewCell mainTableViewCellWithTableView:tableView];
    
    //根据相应的cell的行数进行每行cell的数据设置
    kArrayIsEmpty(self.dataSource)?:[cell setGeneralGoodsModel:self.dataSource[indexPath.section]];
    
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
    //    return [mytableview cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.section] keyPath:@"TheAnnouncementModel" cellClass:[TheAnnouncementTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
    
    GeneralGoodsModel *model = self.dataSource[indexPath.section];
    DCGoodDetailViewController *dcgdvc=[[DCGoodDetailViewController alloc]init];
    dcgdvc.goods_id = model.goods_id;
    [self.navigationController pushViewController:dcgdvc animated:YES];
    
}

//侧滑 删除 收藏按钮 显示几个就创建几个
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消\n收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        GeneralGoodsModel *model=self.dataSource[indexPath.section];
        // 设置请求参数可变数组
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:@"2" forKey:@"type"];
        
        [dic setObject:model.goods_id forKey:@"goods_id"];
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(goodsCollect) parameters:dic
                               isShowToastd:(BOOL)NO
                                  isShowHud:(BOOL)YES
                           isShowBlankPages:(BOOL)NO
                                    success:^(id responseObject)  {
                                        
                                        NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                                        NSMutableArray *result=[responseObject objectForKey:@"result"];
                                        
                                        if (codeStr.intValue==1) {
                                            [mytableview.mj_header beginRefreshing];
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        //打印网络请求错误
                                        NSLog(@"%@",error);
                                        
                                    } RefreshAction:^{
                                        //执行无网络刷新回调方法
                                        
                                    }];
        
    }];
    [deleteAction setBackgroundColor:[UIColor orangeColor]];
    return @[deleteAction];
    
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


@end




