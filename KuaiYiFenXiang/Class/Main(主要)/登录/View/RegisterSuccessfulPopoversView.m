




// 弹窗上边缘距离
#define TopEdgeHeight  180.0
// 弹窗宽度
#define AlertWidth   (SCREEN_WIDTH-30)
// 弹窗高度
#define AlertHeight   AlertWidth/4*3


#import "RegisterSuccessfulPopoversView.h"


@interface RegisterSuccessfulPopoversView ()

@property (nonatomic, strong) UIView *mAlert;

@property (nonatomic, strong) UITapGestureRecognizer *recognizerTap;

@end

@implementation RegisterSuccessfulPopoversView{
    
    UIButton  * securityReminderBtn;
    
}

//初始化弹出背景视图的大小以及背景色
-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        
    }
    
    return self;
}




// 配置主视图
-(void)drawView:(NSString*)titleString
{
    
    //创建弹窗
    _mAlert =[[UIView alloc]init];
    [_mAlert setBackgroundColor:[UIColor whiteColor]];
    [_mAlert.layer setCornerRadius:5.0];
    [self addSubview:_mAlert];
    _mAlert.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(SCREEN_WIDTH/2)
    .heightIs(SCREEN_WIDTH/4);
    
//    //给弹窗添加点击手势 点击背景视图隐藏当前页面
//    _recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
//    [_recognizerTap setNumberOfTapsRequired:1];
//    _recognizerTap.cancelsTouchesInView = NO;
//    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:_recognizerTap];
    
    //弹窗上添加图片
    UIImageView  *headimgview =[[UIImageView alloc]init];
    [headimgview setImage:[UIImage imageNamed:@"reg_success"]];
    headimgview.layer.cornerRadius=_mAlert.width/8;
    headimgview.layer.masksToBounds=YES;
    [_mAlert addSubview:headimgview];
    headimgview.sd_layout
    .topSpaceToView(_mAlert, 10)
    .centerXEqualToView(_mAlert)
    .widthIs(_mAlert.width/5)
    .heightIs(_mAlert.width/5);
    
    
    //弹窗上添加提示label
    UILabel *winLabel=[[UILabel alloc]init];
    winLabel.text=titleString;
    [winLabel setTextColor:[UIColor blackColor]];
    [winLabel setFont:PFR18Font];
    [winLabel setTextAlignment:NSTextAlignmentCenter];
    [_mAlert addSubview:winLabel];
    winLabel.sd_layout
    .topSpaceToView(headimgview, 10)
    .leftSpaceToView(_mAlert, 0)
    .widthIs(_mAlert.width)
    .autoHeightRatio(0);
    
    
//    //弹窗上添加继续夺宝按钮
//    YYFButton *leftBtn=[[YYFButton alloc]init];
//    [leftBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//    leftBtn.layer.borderColor=[UIColor redColor].CGColor;
//    [leftBtn setBackgroundColor:[UIColor redColor]];
//    [leftBtn setTitle:@"继续夺宝" forState:UIControlStateNormal];
//    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [_mAlert addSubview:leftBtn];
//    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.sd_layout
//    .topSpaceToView(winLabel, 10)
//    .leftSpaceToView(_mAlert, SCREEN_WIDTH/5)
//    .widthIs(SCREEN_WIDTH/5)
//    .heightIs(30);
//
//
//    //弹窗上添加查看订单按钮
//    YYFButton *rightBtn=[[YYFButton alloc]init];
//    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [rightBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//    rightBtn.layer.borderColor=[UIColor redColor].CGColor;
//    [rightBtn setBackgroundColor:[UIColor whiteColor]];
//    [rightBtn setTitle:@"查看订单" forState:UIControlStateNormal];
//    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [_mAlert addSubview:rightBtn];
//    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.sd_layout
//    .topSpaceToView(winLabel, 10)
//    .rightSpaceToView(_mAlert, SCREEN_WIDTH/5)
//    .widthIs(SCREEN_WIDTH/5)
//    .heightIs(30);
//
//
//    //弹窗上添加用户提醒label
//    securityReminderBtn=[[UIButton alloc]init];
//    securityReminderBtn.selected=YES;
//    [securityReminderBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
//    [securityReminderBtn setTitle:@"安全提醒：虾米不会以任何理由要求您提供银行卡信息或支付宝额外费用，请谨防钓鱼链接或诈骗电话" forState:UIControlStateNormal];
//    [securityReminderBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    securityReminderBtn.titleLabel.font=[UIFont systemFontOfSize:10];
//    securityReminderBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10,0, 0);
//    securityReminderBtn.titleLabel.numberOfLines=2;
//    [_mAlert addSubview:securityReminderBtn];
//    securityReminderBtn.sd_layout
//    .topSpaceToView(leftBtn, 10)
//    .centerXEqualToView(_mAlert)
//    .widthIs(_mAlert.width)
//    .heightIs(30);
//
    
    // 动画显示弹窗
    [self show];
    
    

    

    
}

//继续夺宝
-(void)leftBtnClick{
    
    
}

//查看订单
-(void)rightBtnClick{
    
    
}

// 点击其他区域关闭弹窗
- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![_mAlert pointInside:[_mAlert convertPoint:location fromView:_mAlert.window] withEvent:nil]){
            [_mAlert.window removeGestureRecognizer:sender];
            [self dismiss];
        }
    }
}

// 隐藏弹窗
- (void)dismiss {
    
    
    [self close];
    
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
                         
                         
                         //弹出之后自动关闭
                         dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
                         dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                             [self close];
                         });
                         
                         
                         
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
                         
                         !_alertViewDidCloseBlock ? : _alertViewDidCloseBlock();

                     }
     ];
}



@end

