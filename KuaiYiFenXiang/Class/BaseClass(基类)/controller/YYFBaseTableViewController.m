//
//  YYFBaseTableViewController.m
//  NewProject
//
//  Created by apple on 2017/8/5.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "YYFBaseTableViewController.h"

@interface YYFBaseTableViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, getter=isLoading) BOOL loading;

@end

@implementation YYFBaseTableViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
    [[HttpRequest getCurrentVC].view hideBlankPageView];
    [[HttpRequest getCurrentVC].view hideErrorPageView];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    [self.view setBackgroundColor:BACKVIEWCOLOR];
    
    //设置视图的自动布局方式
    self.edgesForExtendedLayout = UIRectEdgeLeft;// 推荐使用

    
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    
    
    
    
    //设置tableview滚动条隐藏
    [self.tableView setShowsVerticalScrollIndicator:NO];
    //设置tableview为不可滚动
    [self.tableView setScrollEnabled:YES];
    //设置cell之间的线样式
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    //设置cell间的横线靠左显示
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    
//    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置cell间的横线靠左显示
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    
//    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    //设置cell点击效果
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    //自定义cell之间的横线
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.contentView.height-1, SCREEN_WIDTH, 1)];
    [lineLabel setBackgroundColor:hwcolor(213, 213, 213)];
    [cell.contentView addSubview:lineLabel];
    
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    //隐藏所有的键盘
    [self.view endEditing:YES];
    
    //隐藏所有键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    

    
    
}


//#pragma mark - 无数据占位
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    if (self.isLoading) {
//        return [UIImage imageNamed:@"loading_imgBlue_78x78" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
//    }
//    else {
//
//        UIImage *image = [UIImage imageNamed:@"DWQBlankPage" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
//        
//        return image;
//    }
//}
//
//- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
//{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
//    animation.duration = 0.25;
//    animation.cumulative = YES;
//    animation.repeatCount = MAXFLOAT;
//    
//    return animation;
//}
//
//
//- (void)setLoading:(BOOL)loading
//{
//    if (self.isLoading == loading) {
//        return;
//    }
//    
//    _loading = loading;
//    
//    [self.tableView reloadEmptyDataSet];
//}
//
////这个是设置标题文字的
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"网络不给力";
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
////这是设置内容描述的
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"请检查网络后再重试";
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
//                                 NSParagraphStyleAttributeName: paragraph
//                                 };
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
//
//////设置按钮的文本和按钮的背景图片
////- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state  {
////    NSLog(@"buttonTitleForEmptyDataSet:点击上传照片");
////    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
////    return [[NSAttributedString alloc] initWithString:@"点击上传照片" attributes:attributes];
////}
////- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
////    return [UIImage imageNamed:@"set"];
////}
////
//
//
////设置占位图空白页的背景色( 图片优先级高于文字)
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIColor whiteColor];
//}
//
//
////如果不嫌麻烦，还可以自定义一张自己的view放上去 我是嫌麻烦。。。。
////- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
////    
////}
//
////如果有头视图的话，光这样 头视图有可能会挡住，这回事就需要跳转位置了
////- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
////{
////    return SCREEN_HEIGHT * 0.5f;
////    
////}
//
//
//
//
//
////是否显示空白页，默认YES
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
//    return YES;
//}
////是否允许点击，默认YES
//- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
//    return YES;
//}
////是否允许滚动，默认NO
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}
////图片是否要动画效果，默认NO
//- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
//    return YES;
//}
////空白页点击事件
//- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
//    NSLog(@"刷新当前页面");
//}
////空白页按钮点击事件
//- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
//    NSLog(@"刷新当前页面");
//}
//
//
//- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
//{
//    return self.isLoading;
//}
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
//{
//    self.loading = YES;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
//{
//    self.loading = YES;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
//}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
