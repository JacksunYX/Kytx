//
//  MessageNotiViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "MessageNotiViewController.h"
#import "KYHeader.h"

@interface MessageNotiViewController ()

@end

@implementation MessageNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新消息通知";
    self.view.backgroundColor = kDefaultBGColor;
    
    [self configUI];
    
}

- (void)configUI {
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    aview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:aview];
    
    UILabel *alabel = [UILabel new];
    alabel.text = @"新消息通知";
    alabel.textColor = kColor333;
    alabel.font = [UIFont systemFontOfSize:15];
    
    [aview addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(aview);
    }];
    
    UILabel *desc = [UILabel new];
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        // 关闭通知
        desc.text = @"未开启";
    }else {
        desc.text = @"已开启";
    }
    
    desc.textColor = kColor999;
    desc.font = [UIFont systemFontOfSize:15];
    
    [aview addSubview:desc];
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(aview);
    }];
    
    UILabel *firstLabel = [UILabel new];
    firstLabel.text = @"如需修改，请在IPHONE的”设置“-”通知”中,找到应用程序“快益分享商城”进行更改";
    firstLabel.textColor = kColor999;
    firstLabel.numberOfLines = 0;
    firstLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.right.equalTo(aview).offset(-15);
        make.top.equalTo(aview.mas_bottom).offset(10);
    }];
    
     /*
    
    UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    bview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bview];
    [bview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(firstLabel.mas_bottom).offset(20);
    }];
    
    UILabel *blabel = [UILabel new];
    blabel.text = @"通知显示详情";
    blabel.textColor = kColor333;
    blabel.font = [UIFont systemFontOfSize:15];
    
    [bview addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bview).offset(15);
        make.centerY.equalTo(bview);
    }];
    
    UISwitch *aswitch = [[UISwitch alloc] init];
    [aswitch addTarget:self action:@selector(aswitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [bview addSubview:aswitch];
    [aswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bview).offset(-15);
        make.centerY.equalTo(bview);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UILabel *secondLabel = [UILabel new];
    secondLabel.text = @"开启后，当收到消息时，通知提示将显示发信人和内容摘要";
    secondLabel.textColor = kColor999;
    secondLabel.numberOfLines = 0;
    secondLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bview).offset(15);
        make.right.equalTo(bview).offset(-15);
        make.top.equalTo(bview.mas_bottom).offset(10);
    }];
    
    UIView *cview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    cview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:cview];
    [cview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
        make.top.equalTo(secondLabel.mas_bottom).offset(20);
    }];
    
    UILabel *cLabel = [UILabel new];
    cLabel.text = @"屏蔽通知";
    cLabel.textColor = kColor333;
    cLabel.font = [UIFont systemFontOfSize:15];
    
    [cview addSubview:cLabel];
    [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cview).offset(15);
        make.centerY.equalTo(cview);
    }];
    
    UISwitch *bswitch = [[UISwitch alloc] init];
    [bswitch addTarget:self action:@selector(bswitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [cview addSubview:bswitch];
    [bswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cview).offset(-15);
        make.centerY.equalTo(cview);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UILabel *thirdLabel = [UILabel new];
    thirdLabel.text = @"开启后，快益分享商城将自动屏蔽23：00~8：00间的任何提示";
    thirdLabel.textColor = kColor999;
    thirdLabel.numberOfLines = 0;
    thirdLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cview).offset(15);
        make.right.equalTo(cview).offset(-15);
        make.top.equalTo(cview.mas_bottom).offset(10);
    }];
     
     */
}

// 通知显示详情
- (void)aswitchValueChanged:(UISwitch *)sender {
    
}

- (void)bswitchValueChanged:(UISwitch *)sender {
    
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
