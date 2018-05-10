




// 弹窗上边缘距离
#define TopEdgeHeight  180.0
// 弹窗宽度
#define AlertWidth   (SCREEN_WIDTH-30)
// 弹窗高度
#define AlertHeight   AlertWidth/4*3


#import "CheckLogisticsPopView.h"

#import "LogisticsTimelineModel.h"

#import "LogisticsTimelineTableViewCell.h"

@interface CheckLogisticsPopView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *mAlert;
@property (nonatomic, strong) UITapGestureRecognizer *recognizerTap;
@property (strong , nonatomic)NSMutableArray *TradeLogisticsDataSource;
@end

@implementation CheckLogisticsPopView{
    
    UITableView*mytableview;
    
}

//初始化弹出背景视图的大小以及背景色
-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        
        //画出背景视图上的弹窗
        [self drawView];
    }
    
    return self;
}

//进行数据的请求
-(void)loadTradeLogisticsData:(NSString *)logisticsnsmeString andlogisticsnoString:(NSString *)logisticsnsnoString{

    self.TradeLogisticsDataSource=[NSMutableArray new];
    
    NSString *expressqueryUrl=kStringIsEmpty(logisticsnsmeString)?@"https://way.jd.com/fegine/exp?type=zto&no=454244690951&appkey=d08ce5d77a6d395a23de6745d9b7407e":[NSString stringWithFormat:@"https://way.jd.com/fegine/exp?type=%@&no=%@&appkey=d08ce5d77a6d395a23de6745d9b7407e",logisticsnsmeString,logisticsnsnoString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:expressqueryUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //直接吧返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"expressqueryUrl-----%@-----resultdic-----%@",expressqueryUrl,resultdic);
       
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"code"]]; ;
        NSDictionary *resultdic1=[resultdic objectForKey:@"result"];
        NSString *status = [NSString stringWithFormat:@"%@",[resultdic1 objectForKey:@"status"]]; ;
        NSDictionary *resultdic2=[resultdic1 objectForKey:@"result"];
        //        NSMutableArray *listarray=kDictIsEmpty(resultdic2)?[NSMutableArray new]:[resultdic2 objectForKey:@"list"];
        if (codeStr.intValue==10000&&status.intValue==0) {

            NSMutableArray *listarray=[resultdic2 objectForKey:@"list"];
            
            for (NSDictionary *dic in listarray) {
                
                //初始化模型
                LogisticsTimelineModel *model=[LogisticsTimelineModel mj_objectWithKeyValues:dic];
                //把模型添加到相应的数据源数组中
                [self.TradeLogisticsDataSource addObject:model];
                
            }
            
        } else {
            UILabel *label = [UILabel new];
            label.text = @"暂无信息";
            label.font = kFont(15);
            label.textColor = kColor333;
            [mytableview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(mytableview);
            }];
        }
        
        [mytableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
    
    
}


// 配置主视图
-(void)drawView
{
    
    //创建弹窗
    _mAlert =[[UIView alloc]init];
    [_mAlert setBackgroundColor:[UIColor whiteColor]];
    [_mAlert.layer setCornerRadius:10];
    [self addSubview:_mAlert];
    _mAlert.sd_layout
    .centerXEqualToView(self)
    .centerYIs(SCREEN_HEIGHT*0.4)
    .widthIs(SCREEN_WIDTH-100)
    .heightIs(SCREEN_HEIGHT*0.6);
    
    //给弹窗添加点击手势 点击背景视图隐藏当前页面
    _recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [_recognizerTap setNumberOfTapsRequired:1];
    _recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:_recognizerTap];
    
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mAlert.width, _mAlert.height) style:UITableViewStylePlain];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    [_mAlert addSubview:mytableview];
    
    // 动画显示弹窗
    [self show];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _TradeLogisticsDataSource.count;
}

//初始化当前表视图的每行的cell以及相应的表的属性设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"LogisticsTimelineTableViewCell";
    // 通过唯一标识创建cell实例
    LogisticsTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[LogisticsTimelineTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    kArrayIsEmpty(self.TradeLogisticsDataSource)?:[cell setLogisticsTimelineModel:self.TradeLogisticsDataSource[indexPath.row]];
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kArrayIsEmpty(self.TradeLogisticsDataSource)?0:[mytableview cellHeightForIndexPath:indexPath model:self.TradeLogisticsDataSource[indexPath.section] keyPath:@"LogisticsTimelineModel" cellClass:[LogisticsTimelineTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _mAlert.width, 44)];
    [headview setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    [titleLabel setFont:PFR15Font];
    [titleLabel setText:@"物流信息"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [headview addSubview:titleLabel];
    titleLabel.sd_layout
    .centerYEqualToView(headview)
    .centerXEqualToView(headview)
    .widthIs(headview.width)
    .heightIs(20);
    
    return headview;
    
}


// 点击其他区域关闭弹窗
- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![_mAlert pointInside:[_mAlert convertPoint:location fromView:_mAlert.window] withEvent:nil]){
            [_mAlert.window removeGestureRecognizer:sender];
            [self close];
        }
    }
}

//弹窗显示动画
- (void)show
{
    
    _mAlert.transform = CGAffineTransformMakeScale(1.2, 1.2);
    _mAlert.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                         _mAlert.transform = CGAffineTransformMakeScale(1, 1);
                         _mAlert.alpha = 1.0f;
                         
                     }
                     completion:nil
     ];
}
//弹窗关闭动画
- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _mAlert.alpha = 0.0f;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}



@end

