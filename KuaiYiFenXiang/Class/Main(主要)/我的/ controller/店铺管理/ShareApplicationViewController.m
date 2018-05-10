//
//  ShareApplicationViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShareApplicationViewController.h"
#import "KYHeader.h"
#import "ComingViewController.h"

@interface ShareApplicationViewController ()

@end

@implementation ShareApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"申请分享商家";
    self.view.backgroundColor = kDefaultBGColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- NAVI_HEIGHT - 50)];
    
    scroll.backgroundColor = kDefaultBGColor;
    [self.view addSubview:scroll];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn setTitle:@"立即入驻" forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(17);
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *top = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我要开店banner"]];
    
    [scroll addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(scroll);
        make.height.mas_equalTo(ScaleHeight(349/2.0));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIView *view1 = [UIView new];
    
    view1.backgroundColor = kWhiteColor;
    [scroll addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scroll);
        make.top.equalTo(top.mas_bottom).offset(10);
    }];
    
    UILabel *title1 = [UILabel new];
    
    title1.text = @"分享商家介绍";
    title1.font = kFont(15);
    title1.textColor = kColor333;
    
    [view1 addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1).offset(15);
        make.top.equalTo(view1).offset(15);
    }];
    
    UILabel *content1 = [UILabel new];
    
    content1.textColor = kColor666;
    content1.font = kFont(13);
    content1.numberOfLines = 0;
    content1.text = @"快益分享商城角色，注册成为分享会员后，可申请成为分享商家\n线上商城：可发布线上商品在线销售\n线下商城：线下销售，并可生成收款二维码进行收款\n提交相关材料后，审核通过后默认开通线上商城+线下店铺功能";
    
    [view1 addSubview:content1];
    [content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1);
        make.top.equalTo(title1.mas_bottom).offset(15);
        make.right.equalTo(view1).offset(-15);
        make.bottom.equalTo(view1).offset(-15);
    }];
    
    UIView *view2 = [UIView new];
    
    view2.backgroundColor = kWhiteColor;
    [scroll addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scroll);
        make.top.equalTo(view1.mas_bottom).offset(10);
    }];
    
    UILabel *title2 = [UILabel new];
    
    title2.text = @"分享商家利益";
    title2.font = kFont(15);
    title2.textColor = kColor333;
    
    [view2 addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2).offset(15);
        make.top.equalTo(view2).offset(15);
    }];
    
    UILabel *content2 = [UILabel new];
    
    content2.textColor = kColor666;
    content2.numberOfLines = 0;
    content2.font = kFont(13);
    content2.text = @"1.销售产品获得利润\n2.让利获得平台激励\n3.享有自身推荐会员消费激励额的25%作为收益\n4.享受自身推荐商家销售激励额的15%作为收益";
    
    [view2 addSubview:content2];
    [content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title2);
        make.top.equalTo(title2.mas_bottom).offset(15);
        make.right.equalTo(view2).offset(-15);
        make.bottom.equalTo(view2).offset(-15);
    }];
    
    UIView *view3 = [UIView new];
    
    view3.backgroundColor = kWhiteColor;
    [scroll addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scroll);
        make.top.equalTo(view2.mas_bottom).offset(10);
    }];
    
    UILabel *title3 = [UILabel new];
    
    title3.text = @"店铺优势";
    title3.font = kFont(15);
    title3.textColor = kColor333;
    
    [view3 addSubview:title3];
    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3).offset(15);
        make.top.equalTo(view3).offset(15);
    }];
    
    UILabel *content3 = [UILabel new];
    
    content3.textColor = kColor666;
    content3.font = kFont(13);
    content3.numberOfLines = 0;
    content3.text = @"1.提升企业美度\n2.线上+线下多渠道拓展\n3.锁定人脉，跨界收益\n4.促销让利即可获得积分激励";
    
    [view3 addSubview:content3];
    [content3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title3);
        make.top.equalTo(title3.mas_bottom).offset(15);
        make.right.equalTo(view3).offset(-15);
        make.bottom.equalTo(view3).offset(-15);
    }];
    
    UILabel *alabel = [UILabel new];
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:@"* 详情咨询客户热线：400-998-9798"];
    [attstr addAttribute:NSForegroundColorAttributeName value:kColord40 range:NSMakeRange(0, 1)];
    
    [attstr addAttribute:NSForegroundColorAttributeName value:kColor999 range:NSMakeRange(1, attstr.length - 1)];
    alabel.font = kFont(13);
    [alabel setAttributedText:attstr];
    
    [scroll addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scroll).offset(15);
        make.top.equalTo(view3.mas_bottom).offset(15);
        make.bottom.equalTo(scroll).offset(-60);
    }];
}

- (void)click:(UIButton *)sender {
    ComingViewController *vc = [ComingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
