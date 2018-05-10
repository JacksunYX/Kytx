//
//  GoPayViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/26.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "GoPayViewController.h"
#import "MyOrderViewController.h"
#import "StoreManagementViewController.h"
#import "OfflineOrderListViewController.h"
#import "StoreDisplayViewController.h"

@interface GoPayViewController ()

@property(nonatomic, strong) UIImageView *image1;
@property(nonatomic, strong) UIImageView *image2;
@property(nonatomic, strong) UIImageView *image3;

@end

@implementation GoPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paydone) name:@"AliPayResult" object:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BACK"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)back:(UIBarButtonItem *)item {
    if ([self.type isEqualToString:@"5"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    BOOL isfinish = NO;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[StoreManagementViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            isfinish = YES;
        }
    }
    if (!isfinish) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)paydone {
    if ([self.type isEqualToString:@"5"]) {
        LRToast(@"支付成功");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        if (self.handler) {
            self.handler();
        }
        return;
    }
    BOOL isfinish = NO;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[StoreManagementViewController class]]) {
            LRToast(@"支付成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:vc animated:YES];
            });
            isfinish = YES;
            break;
        }
        if ([vc isKindOfClass:[StoreDisplayViewController class]]) {
            LRToast(@"支付成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:vc animated:YES];
            });
            isfinish = YES;
            break;
        }
    }
    
    if (!isfinish) {
        LRToast(@"支付成功");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}



- (void)configUI {
    if ([self.type isEqualToString:@"3"]) {
        self.title = @"申请开店";
    } else if ([self.type isEqualToString:@"4"]||[self.type isEqualToString:@"1"]) {
        self.title = @"用户付款";
    }else if ([self.type isEqualToString:@"5"]) {
        self.title = @"用户付款";
    }
    self.view.backgroundColor = kDefaultBGColor;
    UIView *aview = [UIView new];
    aview.backgroundColor = kWhiteColor;
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(18);
    }];
    
    UILabel *alabel = [UILabel new];
    
    if ([self.type isEqualToString:@"3"]) {
        alabel.text = @"需缴纳开店金额：￥365.00元";
    } else if ([self.type isEqualToString:@"4"]||[self.type isEqualToString:@"1"]) {
        alabel.text = [NSString stringWithFormat:@"%@%@元", @"需缴纳金额：￥", self.price];
    }else if ([self.type isEqualToString:@"5"]) {
        alabel.text = [NSString stringWithFormat:@"%@%@元", @"需缴纳金额：￥", self.price];
    }
    alabel.font = kFont(15);
    alabel.textColor = kColor333;
    
    [aview addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(aview);
        make.top.equalTo(aview).offset(17);
    }];
    
    UIView *line1 = [UIView new];
    
    line1.backgroundColor = kDefaultBGColor;
    [aview addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(aview);
        make.height.mas_equalTo(1);
        make.top.equalTo(alabel.mas_bottom).offset(17);
    }];
    
    UILabel *blabel = [UILabel new];
    
    blabel.text = @"支付方式";
    blabel.font = kFont(15);
    blabel.textColor = kColor333;
    
    [aview addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(aview);
        make.top.equalTo(line1.mas_bottom).offset(15);
        make.left.equalTo(aview).offset(15);
    }];
    
    UIView *line2 = [UIView new];
    
    line2.backgroundColor = kDefaultBGColor;
    [aview addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(aview);
        make.height.mas_equalTo(1);
        make.top.equalTo(blabel.mas_bottom).offset(15);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.backgroundColor = kWhiteColor;
    btn1.tag = 1001;
    [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [aview addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(aview);
        make.top.equalTo(line2.mas_bottom);
        make.height.mas_equalTo(70);
    }];
    
    self.image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中"]];
    self.image1.tag = 1;
    [btn1 addSubview:self.image1];
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.left.equalTo(aview).offset(15);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UIImageView *zhifubao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"支付宝"]];
    [btn1 addSubview:zhifubao];
    [zhifubao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image1.mas_right).offset(15);
        make.centerY.equalTo(self.image1);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"支付宝";
    label1.font = kFont(15);
    label1.textColor = kColor333;
    
    [btn1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.left.equalTo(zhifubao.mas_right).offset(15);
    }];
    
    UILabel *clabel = [UILabel new];
    
    clabel.font = kFont(13);
    clabel.text = @" 推荐 ";
    clabel.backgroundColor = kColord40;
    clabel.layer.cornerRadius = 3;
    clabel.layer.masksToBounds = YES;
    clabel.textColor = kWhiteColor;
    
    [btn1 addSubview:clabel];
    [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(15);
        make.centerY.equalTo(zhifubao);
    }];
    
    /*************/
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2.backgroundColor = kWhiteColor;
    btn2.tag = 1002;
    [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [aview addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(aview);
        make.top.equalTo(btn1.mas_bottom);
        if (ShowUPPay) {
            make.height.mas_equalTo(70);
        }else{
            make.height.mas_equalTo(0);
        }
    }];
    
    self.image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选中"]];
    
    [btn2 addSubview:self.image2];
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn2);
        make.left.equalTo(btn2).offset(15);
        if (ShowUPPay) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }else{
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }
    }];
    
    UIImageView *yinlian = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"银联"]];
    [btn2 addSubview:yinlian];
    [yinlian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image2.mas_right).offset(15);
        make.centerY.equalTo(self.image2);
        if (ShowUPPay) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }else{
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }
        
    }];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"银联支付";
    label2.font = kFont(15);
    label2.textColor = kColor333;
    [btn2 addSubview:label2];
    if (ShowUPPay) {
        label2.hidden = NO;
    }else{
        label2.hidden = YES;
    }
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yinlian);
        make.left.equalTo(yinlian.mas_right).offset(15);
    }];
    
    /******************/
     UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
     
     btn3.backgroundColor = kWhiteColor;
     btn3.tag = 1003;
     [btn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
     
     [aview addSubview:btn3];
     [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.right.equalTo(aview);
     make.top.equalTo(btn2.mas_bottom);
     make.height.mas_equalTo(70);
         make.bottom.equalTo(aview);
         
     }];
     
     self.image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选中"]];
     
     [btn3 addSubview:self.image3];
     [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.equalTo(btn3);
     make.left.equalTo(btn3).offset(15);
     make.size.mas_equalTo(CGSizeMake(12, 12));
     }];
     
     UIImageView *yue = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"余额支付"]];
     [aview addSubview:yue];
     [yue mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.image3.mas_right).offset(15);
     make.centerY.equalTo(self.image3);
     make.size.mas_equalTo(CGSizeMake(40, 40));
     }];
     
     UILabel *label3 = [UILabel new];
     label3.text = @"余额支付";
     label3.font = kFont(15);
     label3.textColor = kColor333;
     
     [btn3 addSubview:label3];
     [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.equalTo(btn3);
     make.left.equalTo(yue.mas_right).offset(15);
     }];
    
    if ([self.type isEqualToString:@"3"]) {
        
        UILabel *flabel = [UILabel new];
        
        flabel.font = kFont(12);
        flabel.textColor = kColor999;
        flabel.numberOfLines = 0;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"*  备注：支付成功后，一个工作日内完成审核"];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"d40000"] range:NSMakeRange(0, 1)];
        [flabel setAttributedText:att];
        
        [self.view addSubview:flabel];
        [flabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(aview.mas_bottom).offset(15);
        }];
    } else if ([self.type isEqualToString:@"4"]||[self.type isEqualToString:@"1"]) {
        
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gopay) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"去支付" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(17);
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(label3.mas_bottom).offset(100);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(40);
    }];
}


- (void)click:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1001:
        {
            self.image1.image = [UIImage imageNamed:@"选中"];
            self.image2.image = [UIImage imageNamed:@"未选中"];
            self.image3.image = [UIImage imageNamed:@"未选中"];
            self.image1.tag = 1;
            self.image2.tag = 0;
            self.image3.tag = 0;
        }
            break;
        case 1002:
        {
            self.image1.image = [UIImage imageNamed:@"未选中"];
            self.image2.image = [UIImage imageNamed:@"选中"];
            self.image3.image = [UIImage imageNamed:@"未选中"];
            self.image1.tag = 0;
            self.image2.tag = 1;
            self.image3.tag = 0;
        }
            break;
        case 1003:
        {
            self.image1.image = [UIImage imageNamed:@"未选中"];
            self.image2.image = [UIImage imageNamed:@"未选中"];
            self.image3.image = [UIImage imageNamed:@"选中"];
            self.image1.tag = 0;
            self.image2.tag = 0;
            self.image3.tag = 1;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)gopay {
    NSLog(@"");
//    if ([self.image1.image isEqual:[UIImage imageNamed:@"选中"]]) {
//        [self doAPPayAnmount:self.price.floatValue];
////        [self doAPPayAnmount:0.01];
//    } else if ([self.image2.image isEqual:[UIImage imageNamed:@"选中"]]) {
//        [self doUPPay];
//
//    } else if ([self.image3.image isEqual:[UIImage imageNamed:@"选中"]]) {
//        NSString *typestr;
//        if ([self.type isEqualToString:@"5"]) {
//            typestr = @"4";
//        } else {
//            typestr = self.type;
//        }
//        [self doBalancePay:self.tn andorder_amount:self.price andtypestring:typestr];
//
//    }
    
    if (self.image1.tag == 1) {
        [self doAPPayAnmount:self.price.floatValue];
    }else if (self.image2.tag == 1){
        [self doUPPay];
    }else if (self.image3.tag == 1){
        NSString *typestr;
        if ([self.type isEqualToString:@"5"]) {
            typestr = @"4";
        } else {
            typestr = self.type;
        }
        [self doBalancePay:self.tn andorder_amount:self.price andtypestring:typestr];
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
