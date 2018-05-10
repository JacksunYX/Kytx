
//
//  ListViewController.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ListViewController.h"
#import "KYHeader.h"
//#import "SXMarquee.h"
#import "MarqueeLabel.h"
#import "TheAnnouncementDetailsViewController.h"
#import "MessageSubpageViewController.h"
#import "PointRankViewController.h"
#import "ShareMemberViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong)MarqueeLabel *mar;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) NSArray *noticeArray;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"排行榜";
    self.view.backgroundColor = kDefaultBGColor;
    
    [self configUI];
    
    self.count = 0;
}

- (void)loadData {
    NSDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithURLString:NetRequestUrl(paihangbang) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            NSDictionary *dict = res[@"result"];
            
            self.pointLabel.text = dict[@"love_value"];
            self.memberLabel.text = dict[@"user_total"];
            self.shopLabel.text = dict[@"shop_total"];
            self.noticeArray = dict[@"notice"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"love_time"] floatValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"MM月dd日";
            self.timeLabel.text = [formatter stringFromDate:date];
            [self.table reloadData];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    self.count++;
                    if (self.count == self.noticeArray.count-1) {
                        self.count = 0;
                        [self.table scrollToRow:self.count inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    } else {
                        [self.table scrollToRow:self.count inSection:0 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }];
            }
        }
    } failure:nil RefreshAction:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}


- (void)configUI {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"排行榜背景"]];
    [self.view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(170));
    }];
    
//    _mar = [[MarqueeLabel alloc] initWithFrame:CGRectMake(50, 200, SCREEN_WIDTH, 44) duration:5.0 andFadeLength:10.0];
////    [_mar changeMarqueeLabelFont:[UIFont systemFontOfSize:13]];
//    _mar.backgroundColor = kWhiteColor;
//    [self.view addSubview:_mar];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(110, 200, SCREEN_WIDTH-110-70, 44) style:UITableViewStylePlain];
    _table.showsVerticalScrollIndicator = NO;
    _table.scrollEnabled = NO;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
//    [_mar start];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor whiteColor];
    view1.frame = CGRectMake(0, 200, 50, 44);
    [self.view addSubview:view1];
    
    UIImageView *gonggaoImageView=[[UIImageView alloc]init];
    [gonggaoImageView setImage:[UIImage imageNamed:@"shouye_img_toutiao"]];
    [view1 addSubview:gonggaoImageView];
    [gonggaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1).offset(15);
        make.centerY.equalTo(_table);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:kColor333 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"更多>" forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(13);
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.centerY.equalTo(_table);
        make.height.equalTo(_table);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn9.backgroundColor = [UIColor whiteColor];
    [btn9 setTitleColor:kColor333 forState:UIControlStateNormal];
    [btn9 setTitle:@"快益公告：" forState:UIControlStateNormal];
    btn9.titleLabel.font = kFont(13);
    [self.view addSubview:btn9];
    [btn9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gonggaoImageView.mas_right).offset(10);
        make.centerY.equalTo(_table);
        make.height.equalTo(_table);
        make.width.mas_equalTo(70);
    }];
    
    UIView *line2 = [UIView new];
    
    line2.backgroundColor  = kDefaultBGColor;
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn);
        make.height.equalTo(@25);
        make.width.equalTo(@1);
        make.centerY.equalTo(btn);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"按钮"]];
    imageView1.userInteractionEnabled = YES;
    
    [self.view addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(70));
        make.top.equalTo(_table.mas_bottom).offset(20);
    }];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"广告"]];
    
    [self.view addSubview:imageview2];
    [imageview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(125.5));
        make.top.equalTo(imageView1.mas_bottom).offset(20);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.backgroundColor = [UIColor clearColor];
    [imageView1 addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1);
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.top.bottom.equalTo(imageView1);
    }];
    [btn1 addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2.backgroundColor = [UIColor clearColor];
    [imageView1 addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView1);
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.top.bottom.equalTo(imageView1);
    }];
    [btn2 addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shangjia = [self labelWithText:@"商家入驻"];
    
    [imageview addSubview:shangjia];
    [shangjia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview).offset(-SCREEN_WIDTH/4.0);
        make.bottom.equalTo(imageview).offset(-15);
    }];
    UILabel *fenxiang = [self labelWithText:@"分享会员"];
    
    [imageview addSubview:fenxiang];
    [fenxiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview).offset(SCREEN_WIDTH/4.0);
        make.bottom.equalTo(imageview).offset(-15);
    }];
    
    UILabel *shangjiacount = [self labelWithText:@"15897"];
    
    self.shopLabel = shangjiacount;
    
    [imageview addSubview:shangjiacount];
    [shangjiacount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview).offset(-SCREEN_WIDTH/4.0);
        make.bottom.equalTo(shangjia.mas_top).offset(-10);
    }];
    
    UILabel *fenxiangcount = [self labelWithText:@"99999"];
    
    self.memberLabel = fenxiangcount;
    
    [imageview addSubview:fenxiangcount];
    [fenxiangcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview).offset(SCREEN_WIDTH/4.0);
        make.bottom.equalTo(fenxiang.mas_top).offset(-10);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kDefaultBGColor;
    [imageview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview);
        make.bottom.equalTo(imageview).offset(-15);
        make.height.mas_equalTo(45);
        make.width.equalTo(@1);
    }];
    
    UILabel *blabel = [UILabel new];
    blabel.text = @"0.00";
    self.pointLabel = blabel;
    blabel.textColor = kWhiteColor;
    blabel.font = kFont(24);
    blabel.backgroundColor = [UIColor clearColor];
    [imageview addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview);
        make.top.equalTo(imageview).offset(ScaleHeight(65));
    }];
    blabel.layer.shadowColor = [UIColor blackColor].CGColor;
    blabel.layer.shadowOpacity = 0.5;
    blabel.layer.shadowOffset = CGSizeMake(0, 2);
    blabel.layer.shadowRadius = 2;
    
    UILabel *clabel = [UILabel new];
    self.timeLabel = clabel;
    
    clabel.textColor = kWhiteColor;
    clabel.font = kFont(15);
    clabel.backgroundColor = [UIColor clearColor];
    [imageview addSubview:clabel];
    [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(imageview);
//        make.bottom.equalTo(blabel.mas_top);
        make.top.equalTo(imageview.mas_top).offset(27);
        make.centerX.equalTo(imageview).offset(- 15);
    }];
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = kWhiteColor;
    label.font = kFont(ScaleWidth(12));
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.noticeArray[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.textColor = kColor333;
    cell.textLabel.font = kFont(13);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TheAnnouncementDetailsViewController *tadvc = [[TheAnnouncementDetailsViewController alloc]init];
    NSDictionary *dict = self.noticeArray[indexPath.row];
    tadvc.TheAnnouncementDetailsid = dict[@"article_id"];
    [self.navigationController pushViewController:tadvc animated:YES];
}

- (void)left:(UIButton *)sender {
    if ([KYHeader checkLogin]) {
        
        PointRankViewController *vc = [PointRankViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)right:(UIButton *)sender {
    ShareMemberViewController *vc = [ShareMemberViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)more:(UIButton *)sender {
    MessageSubpageViewController *msvc=[[MessageSubpageViewController alloc]init];
    msvc.selectIndex=1;
    [self.navigationController pushViewController:msvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (NSArray *)noticeArray {
    if (!_noticeArray) {
        _noticeArray = [NSArray array];
    }
    return _noticeArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
