//
//  BannerDetailsTableViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "BannerDetailsTableViewController.h"
#import "ClassificationModuleViewController.h"

@interface BannerDetailsTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *mytableview;
    
    ClassificationModuleViewController *cmvc;
    
}


@end

@implementation BannerDetailsTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canscrollmessage:) name:@"BannerDetailsTableViewControllerCansSrollMessage" object:nil];
    
}

-(void)canscrollmessage:(NSNotification *)canscroll{
    
    if ([canscroll.object isEqualToString:@"YES"]) {
        [mytableview setScrollEnabled:YES];
    }else if ([canscroll.object isEqualToString:@"NO"]){
        [mytableview setScrollEnabled:NO];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=self.titlestring;
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self Action:@selector(shareClick) image:@"shareimage" hightimage:@"shareimage"  andTitle:@""];

    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-74) style:UITableViewStyleGrouped];
    [mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    [self.view addSubview:mytableview];
    
    cmvc=[[ClassificationModuleViewController alloc]init];
    cmvc.two_idstring=self.two_idstring;
    cmvc.categorynameNumString=self.categorynameNumString;

 
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
         return 1;
  }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
      //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"UITableViewCell";
    // 通过唯一标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
 
    [self addChildViewController:cmvc];
    [cell.contentView addSubview:cmvc.view];
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
         return SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - NAVIGATION_TAB_HEIGHT;
 }


 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
         return 185;
 }



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
 
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185)];
    [headerView setBackgroundColor:BACKVIEWCOLOR];
    
     UIImageView *headimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerView.height-10)];
    [headimageview setImage:[UIImage imageNamed:@"banner1"]];
    [headerView addSubview:headimageview];

     return headerView;
    
    
        
        
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"mytableview.contentOffset.y-%f",mytableview.contentOffset.y);
    
    
    if (mytableview.contentOffset.y >= 175) {

        [mytableview setScrollEnabled:NO];
        
        [[NSNotificationCenter defaultCenter ]postNotificationName:@"SubclassModuleViewControllerCansSrollMessage" object:@"YES"];

        
    }else{
        
        [mytableview setScrollEnabled:YES];

        [[NSNotificationCenter defaultCenter ]postNotificationName:@"SubclassModuleViewControllerCansSrollMessage" object:@"NO"];

    }
    

}

-(void)shareClick{
    
    
    
    
}

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
