//
//  DCTopLineFootView.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCTopLineFootView.h"

// Controllers

// Models

// Views
#import "DCNumericalScrollView.h"
// Vendors

// Categories

// Others

@interface DCTopLineFootView ()<UIScrollViewDelegate,NoticeViewDelegate,NewsBannerDelegate>

/* 滚动 */
@property (strong , nonatomic)DCNumericalScrollView *numericalScrollView;
/* 底部 */
@property (strong , nonatomic)UIView *bottomLineView;

@end

@implementation DCTopLineFootView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

//        [self setUpUI];
//
//        [self setUpBase];
        
    }
    return self;
}


- (void)setUpUI
{
//    NSArray *titles = @[@"CDDMall首单新人礼~",
//                       @"github你值得拥有，欢迎点赞~",
//                       @"项目持续更新中~"];
//    NSArray *btnts = @[@"新人礼",
//                       @"github",
//                       @"点赞"];
//    
//    
//    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    _bottomLineView.backgroundColor = BACKVIEWCOLOR;
//    [self addSubview:_bottomLineView];
//    
//    //初始化
//    _numericalScrollView = [[DCNumericalScrollView alloc]initWithFrame:CGRectMake(0, 10, self.width, self.height-10) andImage:@"shouye_img_toutiao" andDataTArray:titles WithDataIArray:btnts];
//    _numericalScrollView.delegate = self;
//    //设置定时器多久循环
//    _numericalScrollView.interval = 5;
//    [self addSubview:_numericalScrollView];
//    //开始循环
//    [_numericalScrollView startTimer];
    
    
    
//    self.backgroundColor = [UIColor whiteColor];
//
//    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    _bottomLineView.backgroundColor = BACKVIEWCOLOR;
//    [self addSubview:_bottomLineView];
    self.backgroundColor = BACKVIEWCOLOR;
    UIView *bottomBackView = [UIView new];
    bottomBackView.backgroundColor = kWhiteColor;
    [self addSubview:bottomBackView];
    bottomBackView.sd_layout
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .heightIs(44)
    ;
    
    UIImageView *gonggaoImageView=[[UIImageView alloc]init];
    [gonggaoImageView setImage:[UIImage imageNamed:@"shouye_img_toutiao"]];
    [bottomBackView addSubview:gonggaoImageView];
    gonggaoImageView.sd_layout
    .leftSpaceToView(bottomBackView, 10)
//    .topSpaceToView(self, 10)
    .centerYEqualToView(bottomBackView)
//    .bottomEqualToView(self)
    .heightIs(20)
    .widthIs(20);
    
    UILabel *label = [UILabel new];
    label.textColor = kColor333;
    label.font = kFont(13);
    label.text = @"快益公告：";
    [bottomBackView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gonggaoImageView.mas_right).offset(10);
        make.width.mas_equalTo(70);
        make.centerY.equalTo(bottomBackView);
    }];
    
    
    NewsBanner *newsView = [[NewsBanner alloc]initWithFrame:CGRectMake(110, 0, SCREEN_WIDTH - 180, 44 )];
//    newsView.backgroundColor = [UIColor redColor];
    [newsView.notice setTextColor:hwcolor(51, 51, 51)];
    newsView.noticeList = self.noticeList;
    newsView.duration = 3;
    [bottomBackView addSubview:newsView];
    newsView.delegate = self;
    [newsView star];
    
    
    
    
    
    //设置图片
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44)];
    //按钮点击事件
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateHighlighted];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(13);
    [btn setTitleColor:hwcolor(51, 51, 51) forState:UIControlStateNormal];
    [btn.titleLabel setFont:PFR15Font];
    // 直接设置按钮的图片和文字的布局样式以及之间的间隔
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:0.0];
    [bottomBackView addSubview:btn];
    
    //分割线
    UIView *line = [UIView new];
    line.backgroundColor = kWhite(0.8);
    [bottomBackView addSubview:line];
    line.sd_layout
    .widthIs(0.5)
    .topSpaceToView(bottomBackView, 10)
    .bottomSpaceToView(bottomBackView, 10)
    .rightSpaceToView(btn, 1)
    ;
    
}


#pragma mark - Setter Getter Methods

#pragma mark - 滚动条点击事件
- (void)noticeViewSelectNoticeActionAtIndex:(NSInteger)index{
    NSLog(@"点击了第%zd头条滚动条",index);
}

- (void)NewsBanner:(NewsBanner *)newsBanner didSelectIndex:(NSInteger)selectIndex
{
    NSLog(@"%ld",selectIndex);
    
    __weak typeof(self) weakself = self;
    
    if (weakself.dctoplinefootviewblock) {
        //将自己的值传出去，完成传值
        weakself.dctoplinefootviewblock(selectIndex);
    }
    
}


-(void)btnClick{

    __weak typeof(self) weakself = self;
    
    if (weakself.dctoplinefootviewmoreblock) {
        //将自己的值传出去，完成传值
        weakself.dctoplinefootviewmoreblock();
    }
    
}




@end
