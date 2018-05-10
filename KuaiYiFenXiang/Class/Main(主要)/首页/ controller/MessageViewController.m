//
//  AllOrdersViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "MessageViewController.h"

#import "MessageModel.h"

#import "MessageTableViewCell.h"

#import "MessageSubpageViewController.h"

#import "MessageDetailsViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,strong) NSArray *btnImageAttay;
@property(nonatomic,strong) NSArray *btnTextAttay;

@end

@implementation MessageViewController{
    
    UITableView*mytableview;
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = BACKVIEWCOLOR;
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - 110 - BOTTOM_MARGIN)];
    mytableview.delegate = self;
    mytableview.dataSource = self;
    mytableview.tableFooterView = [UIView new];
    mytableview.backgroundColor = BACKVIEWCOLOR;
    [self.view addSubview:mytableview];
    
//    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(shareClick) image:@"shareimage" hightimage:@"shareimage"  andTitle:@""];

    self.btnImageAttay = @[@"jiaoyiwuliu",@"gonggao",@"youhuihuodong"];
    self.btnTextAttay = @[@"交易物流",@"公告",@"优惠活动"];

    [self setupheadui];
    
    //在页面加载完成请求数据
    [self loadNewData];
    
   
}

-(void)setupheadui{
    
    for (int i=0; i<3; i++) {
        
        UIButton *headBtn = [[UIButton alloc] init];
        headBtn.backgroundColor=[UIColor whiteColor];
        NSString *imgstr=[NSString stringWithFormat:@"%@",self.btnImageAttay[i]];
        NSString *textstr=[NSString stringWithFormat:@"%@",self.btnTextAttay[i]];
        [headBtn setImage:[UIImage imageNamed:imgstr] forState:UIControlStateNormal];
        [headBtn setImage:[UIImage imageNamed:imgstr] forState:UIControlStateSelected];
        [headBtn setTitle:textstr forState:UIControlStateNormal];
        [headBtn setTitleColor:HexColor(333333) forState:UIControlStateNormal];
        headBtn.titleLabel.font = PFR12Font;
        [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headBtn setSelected:NO];
        headBtn.tag=i+100;
        [self.view addSubview:headBtn];
        headBtn.sd_layout
        .leftSpaceToView(self.view, (SCREEN_WIDTH/self.btnImageAttay.count)*i)
        .topSpaceToView(self.view, 0)
        .widthIs(SCREEN_WIDTH/self.btnImageAttay.count)
        .heightIs(100);
        [headBtn.imageView yee_MakeRedBadge:5.0 color:[UIColor redColor]];
        [headBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:19.0];
        if ([[USER_DEFAULT objectForKey:[NSString stringWithFormat:@"MessageClickIndex_%ld",headBtn.tag - 100]] isEqualToString:@"YES"]) {
            [headBtn.imageView removeBadgeView];
        }
    }

}
//进行数据的请求
-(void)loadNewData{
    
    
    
    
//        //每次进行数据请求初始化数组
//        self.dataSource=[NSMutableArray array];
//
//        //通过循环模拟数据的请求
//        for (int i=0; i<16; i++) {
//
//
////            @property (nonatomic, copy) NSString *cellid;
////            @property (nonatomic, copy) NSString *messageimagestring;
////            @property (nonatomic, copy) NSString *messagetitlestring;
////            @property (nonatomic, copy) NSString *messagesubtitlestring;
//
//            NSDictionary *dic = @{
//                                  //给每行cell添加一个ID点击按钮通过相应的ID进行相应的操作
//                                  @"cellid":[NSString stringWithFormat:@"%d",i],
//
//                                  @"messageimagestring":@"",
//                                  @"messagetitlestring":@"快易客服",
//                                  @"messagesubtitlestring":@"点击查看您与客服的聊天记录",
//
//                                  };
//
////            //初始化模型
//            MessageModel *model=[MessageModel mj_objectWithKeyValues:dic];
////
////            //把模型添加到相应的数据源数组中
//            [self.dataSource addObject:model];
//
//
//        }
//
//
//        //设置完成数据进行当前表视图的刷新
//        [mytableview reloadData];
//
    
    self.dataSource=[NSMutableArray new];
    
    // 设置请求参数可变数组
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(message) parameters:dic
                      isShowToastd:(BOOL)NO
                         isShowHud:(BOOL)NO
                  isShowBlankPages:(BOOL)NO
                           success:^(id responseObject)  {
                               
                               NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
                               NSMutableArray *result=[responseObject objectForKey:@"result"];
                               
                               if (codeStr.intValue==1) {
                                   
                                   if (kArrayIsEmpty(result)) {
                                       
                                       [mytableview.mj_footer endRefreshingWithNoMoreData];
                                       
                                   }else{
                                       
                                       for (NSDictionary *dic in result) {
                                           
                               //            //初始化模型
                                           MessageModel *model=[MessageModel mj_objectWithKeyValues:dic];
                               //
                               //            //把模型添加到相应的数据源数组中
                                           [self.dataSource addObject:model];
                                           
                                       }
                                       if (self.dataSource.count == 0) {
                                           UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无消息666"]];
                                           [mytableview addSubview:image];
                                           [image mas_makeConstraints:^(MASConstraintMaker *make) {
                                               make.center.equalTo(mytableview);
                                               make.size.mas_equalTo(CGSizeMake(ScaleWidth(188), ScaleWidth(158)));
                                           }];
                                       }
                                       
                                   }
                                   
                               }else if (codeStr.intValue==2){
                                   
                                       UIImageView *emptyImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无消息"]];
                                       [self.view addSubview:emptyImageView];
                                       emptyImageView.sd_layout
                                       .centerXEqualToView(self.view)
                                       .centerYEqualToView(self.view)
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
                                   
                               }
                               
                               [mytableview reloadData];
                               
                           } failure:^(NSError *error) {
                               //打印网络请求错误
                               NSLog(@"%@",error);
                               
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
    MessageTableViewCell *cell = [MessageTableViewCell mainTableViewCellWithTableView:tableView];
    
    //根据相应的cell的行数进行每行cell的数据设置
    kArrayIsEmpty(self.dataSource)?:[cell setMessageModel:self.dataSource[indexPath.section]];

    //设置相应的cell以及表视图的属性
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [mytableview setShowsVerticalScrollIndicator:NO];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    [cell.contentView setBackgroundColor:NAVIGATIONBAR_COLOR];
//    cell.contentView.layer.masksToBounds = YES;
//    cell.contentView.layer.cornerRadius = 15.0;
    
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取cell高度
//    return [mytableview cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.section] keyPath:@"MessageModel" cellClass:[MessageTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 100;
//    }else{
        return 10;
//    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    if (section==0) {
//        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];;
//        [headview setBackgroundColor:[UIColor whiteColor]];
//        return headview;
//    }else{
//        return nil;
//    }
//    
//}

-(void)headBtnClick:(UIButton *)btn{
    MessageSubpageViewController *msvc=[[MessageSubpageViewController alloc]init];
    [btn.imageView removeBadgeView];
    msvc.selectIndex = btn.tag - 100;
    [USER_DEFAULT setObject:@"YES" forKey:[NSString stringWithFormat:@"MessageClickIndex_%ld",btn.tag - 100]];
    [self.navigationController pushViewController:msvc animated:YES];
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
    
    MessageDetailsViewController *mdvc = [[MessageDetailsViewController alloc]init];
    MessageModel *model=self.dataSource[indexPath.section];
    mdvc.messageid=model.message_id;
    [self.navigationController pushViewController:mdvc animated:YES];
    
}
-(void)shareClick{
    
    
    
    
}


@end

