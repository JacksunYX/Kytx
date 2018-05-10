




// 弹窗上边缘距离
#define TopEdgeHeight  180.0
// 弹窗宽度
#define AlertWidth   (SCREEN_WIDTH-30)
// 弹窗高度
#define AlertHeight   AlertWidth/4*3


#import "CancelOrderPopoverView.h"


@interface CancelOrderPopoverView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *mAlert;
@property (nonatomic, strong) UITapGestureRecognizer *recognizerTap;
@property(nonatomic,strong) NSArray *paytextarray;
@property(nonatomic,strong) NSMutableArray *payselectarray;
@property (nonatomic, strong) UIButton *payselectButton;
@property (nonatomic, strong) UILabel *paytextLabel;
@end

@implementation CancelOrderPopoverView{
    
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




// 配置主视图
-(void)drawView
{
    
    self.paytextarray=@[@"价格不符合预期",@"收货信息填写错误",@"我不想买了",@"商品款式/数量选择错误",@"其他"];
    self.payselectarray=[@[@"1",@"0",@"0",@"0",@"0"] mutableCopy];
    
    //创建弹窗
    _mAlert =[[UIView alloc]init];
    [_mAlert setBackgroundColor:[UIColor whiteColor]];
    [_mAlert.layer setMasksToBounds:YES];
    [_mAlert.layer setCornerRadius:5.0];
    [self addSubview:_mAlert];
    _mAlert.sd_layout
    .centerXEqualToView(self)
    .centerYIs(SCREEN_HEIGHT*0.4)
    .widthIs(SCREEN_WIDTH-100)
    .heightIs(self.paytextarray.count*60+88);
    
    //给弹窗添加点击手势 点击背景视图隐藏当前页面
    _recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [_recognizerTap setNumberOfTapsRequired:1];
    _recognizerTap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:_recognizerTap];
    
    //设置自己的表视图
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, _mAlert.width, _mAlert.height) style:UITableViewStylePlain];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mytableview setBackgroundColor:BACKVIEWCOLOR];
    [mytableview setScrollEnabled:NO];
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
        return _paytextarray.count;
}

//初始化当前表视图的每行的cell以及相应的表的属性设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
            _paytextLabel = [[UILabel alloc] init];
            _paytextLabel.font=PFR15Font;
            _paytextLabel.textColor=[UIColor blackColor];
            _paytextLabel.textAlignment=NSTextAlignmentLeft;
            _paytextLabel.contentMode=UIViewContentModeCenter;
            [_paytextLabel setText:self.paytextarray[indexPath.row]];
            [cell.contentView addSubview:_paytextLabel];
            self.paytextLabel.sd_layout
            .centerYEqualToView(cell.contentView)
            .leftSpaceToView(_payselectButton, 10)
            .autoHeightRatio(0);
            [self.paytextLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
            
        return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _mAlert.width, 44)];
    [headview setBackgroundColor:[UIColor whiteColor]];

    UILabel *titleLabel=[[UILabel alloc]init];
    [titleLabel setFont:PFR15Font];
    [titleLabel setText:@"选择原因"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [headview addSubview:titleLabel];
    titleLabel.sd_layout
     .topSpaceToView(headview, 10)
     .centerXEqualToView(headview)
     .widthIs(headview.width)
     .heightIs(20);

    UILabel *subtitleLabel=[[UILabel alloc]init];
    [subtitleLabel setFont:PFR12Font];
    [subtitleLabel setText:@"订单取消后不能恢复,您所支付的金额将会返回"];
    [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subtitleLabel setTextColor:[UIColor grayColor]];
    [headview addSubview:subtitleLabel];
    subtitleLabel.sd_layout
    .topSpaceToView(titleLabel, 5)
    .centerXEqualToView(headview)
    .widthIs(headview.width)
    .heightIs(20);
    
    return headview;
  
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _mAlert.width, 44)];
    [footview setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *leftbtn=[[UIButton alloc]init];
    [leftbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftbtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftbtn.titleLabel setFont:PFR15Font];
    [leftbtn.layer setBorderWidth:1.0];
    leftbtn.layer.borderColor=BACKVIEWCOLOR.CGColor;
    [leftbtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:leftbtn];
    leftbtn.sd_layout
    .leftEqualToView(footview)
    .centerYEqualToView(footview)
    .widthIs(footview.width/2)
    .heightIs(footview.height);
    
    UIButton *rightbtn=[[UIButton alloc]init];
    [rightbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightbtn.titleLabel setFont:PFR15Font];
    [rightbtn.layer setBorderWidth:1.0];
    rightbtn.layer.borderColor=BACKVIEWCOLOR.CGColor;
    [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:rightbtn];
    rightbtn.sd_layout
    .rightEqualToView(footview)
    .centerYEqualToView(footview)
    .widthIs(footview.width/2)
    .heightIs(footview.height);
    
    return footview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //顺序遍历
        [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            idx==indexPath.row?[_payselectarray replaceObjectAtIndex:idx withObject:@"1"]:[_payselectarray replaceObjectAtIndex:idx withObject:@"0"];
        }];
        [mytableview reloadData];
}


-(void)leftBtnClick{
    
    [self close];

}

-(void)rightBtnClick{
    
    [self close];
    if (self.didClickOktHandler) {
        [_payselectarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"1"]) {
                self.didClickOktHandler(self.paytextarray[idx]);
            }
        }];
    }

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

