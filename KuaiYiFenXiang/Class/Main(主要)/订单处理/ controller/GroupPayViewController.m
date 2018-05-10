//
//  GroupPayViewController.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/7.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "GroupPayViewController.h"

#import "GroupPayBtn.h"

@interface GroupPayViewController ()

@end

@implementation GroupPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"组合支付";
    self.view.backgroundColor = kWhiteColor;
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)setUI
{
    NSArray *imgArr = @[@"yue",@"zhifubao"];
    NSArray *titleArr = @[@"余额",@"支付宝"];
    NSArray *subTitleArr = @[@"可用余额100.00元",@""];
    NSArray *moneyArr = @[@"100.00",@"99.00"];
    NSMutableArray *payModelArr = [NSMutableArray new];
    for (int i = 0; i < imgArr.count; i ++) {
        GroupPayModel *payModel = [GroupPayModel new];
        payModel.imgStr = imgArr[i];
        payModel.title = titleArr[i];
        payModel.subTitle = subTitleArr[i];
        payModel.money = moneyArr[i];
        [payModelArr addObject:payModel];
    }
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = BACKVIEWCOLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    ;
    
    //组合按钮
    CGFloat y = 0;  //y轴偏移量
    CGFloat btnH = 70;
    CGFloat lineH = 10; //分割线的高度
    for (int i = 0; i < payModelArr.count; i ++) {
        GroupPayModel *payModel = payModelArr[i];
        GroupPayBtn *btn = [GroupPayBtn new];
        [scrollView addSubview:btn];
        btn.sd_layout
        .topSpaceToView(scrollView, y)
        .leftEqualToView(scrollView)
        .rightEqualToView(scrollView)
        .heightIs(btnH)
        ;
        [btn updateLayout];
        [btn setModel:payModel];
        
        btn.ClickBlock = ^(GroupPayModel *model) {
            NSLog(@"点击了%@",model.title);
        };
        
        y = CGRectGetMaxY(btn.frame) + lineH;
    }
    
    //支付按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"余额+支付宝支付￥200.00元" forState:UIControlStateNormal];
    payBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    
    [payBtn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [scrollView addSubview: payBtn];
    payBtn.sd_layout
    .topSpaceToView(scrollView, y + 50)
    .centerXEqualToView(scrollView)
    .widthIs(280)
    .heightIs(40)
    ;
    payBtn.sd_cornerRadius = @(3);
    [payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    //添加‘+’号
    for (int i = 0; i < payModelArr.count; i ++) {
        //如果只有一条，不需要添加
        if (i != payModelArr.count - 1) {
            
            UIImageView *addImg = [UIImageView new];
            [scrollView addSubview:addImg];
            [addImg setImage:UIImageNamed(@"groupPay_add")];
            addImg.sd_layout
            .centerXEqualToView(scrollView)
            .widthIs(25)
            .heightIs(25)
            .centerYIs(btnH * (i + 1) + 5)
            ;
        }
        
    }
    
}

-(void)pay
{
    LRToast(@"功能正在测试阶段~");
}










@end
