//
//  CashOutViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "CashOutViewController.h"
#import "KYHeader.h"
#import "PayChangeViewController.h"
#import "CashOutDetailViewController.h"

@interface CashOutViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *cardDict;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UITextField *tf2;

@end

@implementation CashOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    self.view.backgroundColor = kDefaultBGColor;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor999, NSFontAttributeName :Font(14)} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor999, NSFontAttributeName :Font(14)} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = item1;
    
    MCWeakSelf;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf.view endEditing:YES];
    }];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self configNavi];
    
    [self configUI];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:nil RefreshAction:nil];
    
    
}


- (void)configUI {
    self.view.backgroundColor = BACKVIEWCOLOR;
    __block NSString *imagename;
    [self.cardDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString *obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:self.bank_id]) {
            imagename = [key stringByAppendingString:@"logo"];
            
            *stop = YES;
        }
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = BACKVIEWCOLOR;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *line1 = [UIView new];
    
    line1.backgroundColor = kWhiteColor;
    
    [scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.right.equalTo(scrollView);
        make.height.mas_equalTo(90);
        make.top.equalTo(scrollView);
    }];
    
    UIView *aview = [UIView new];
    aview.backgroundColor = [UIColor whiteColor];
    aview.layer.cornerRadius = 30;
    aview.layer.borderColor = kWhite(0.8).CGColor;
    aview.layer.borderWidth = 1;
    
    [scrollView addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
    
    [aview addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(aview);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *alabel = [self labelWithText:self.bank_name];
    
    [scrollView addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview.mas_right).offset(10);
        make.bottom.equalTo(imageview.mas_centerY).offset(-5);
    }];
    
    UILabel *blabel = [self labelWithText:[NSString stringWithFormat:@"尾号%@储蓄卡", [self.bank_number substringWithRange:NSMakeRange(self.bank_number.length-4, 4)]]];
    
    [scrollView addSubview:blabel];
    [blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alabel);
        make.top.equalTo(imageview.mas_centerY).offset(5);
    }];
    
    UIView *backView1 = [UIView new];
    backView1.backgroundColor = BACKVIEWCOLOR;
    [scrollView addSubview:backView1];
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.top.equalTo(aview.mas_bottom).offset(15);
        make.height.mas_equalTo(32);
    }];
    
    
    NSString *balance = [NSString stringWithFormat:@"可提现金额 %@ 元",self.money];
    NSInteger changeLength = (self.money.length + 2);
    NSMutableAttributedString *str = [NSString RichtextString:balance andstartstrlocation:balance.length - changeLength andendstrlocation:changeLength - 2 andchangcoclor:kColord40 andchangefont:Font(13)];
    
//    UILabel *dlabel = [self labelWithText:[@"余额￥" stringByAppendingString:self.money]];
    
    UILabel *dlabel = [UILabel new];
    dlabel.textColor = kColor333;
    dlabel.font = Font(13);
    dlabel.attributedText = str;
    
    [backView1 addSubview:dlabel];
    [dlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView1).offset(15);
        make.centerY.equalTo(backView1);
        make.right.equalTo(backView1).offset(- 15);
    }];
    
    UIView *backView2 = [UIView new];
    backView2.backgroundColor = kWhiteColor;
    [scrollView addSubview:backView2];
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.top.equalTo(backView1.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.textColor = kColor333;
    tf.placeholder = @"输入金额为100的倍数";
    self.tf = tf;
    tf.delegate = self;
    tf.font = kFont(15);
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *rightView = [self labelWithText:@"元"];
    rightView.font = kFont(15);
    rightView.frame = CGRectMake(0, 0, 20, 44);

    tf.rightView = rightView;
    tf.rightViewMode = UITextFieldViewModeAlways;
    
    [scrollView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(clabel.mas_right).offset(10);
//        make.centerY.equalTo(clabel);
        make.top.equalTo(backView1.mas_bottom);
        make.right.equalTo(scrollView).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *clabel = [self labelWithText:@"提现金额"];
    [scrollView addSubview:clabel];
    [clabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview);
        make.right.equalTo(tf.mas_left).offset(- 10);
        make.centerY.equalTo(tf);
//        make.top.equalTo(dlabel.mas_bottom).offset(15);
    }];
    [clabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    
    UIView *line2 = [UIView new];
    
    line2.backgroundColor = kDefaultBGColor;
    
    [scrollView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(15);
        make.right.equalTo(scrollView).offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(tf.mas_bottom).offset(0.5);
    }];
    
    UIView *backView3 = [UIView new];
    backView3.backgroundColor = kWhiteColor;
    [scrollView addSubview:backView3];
    [backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.top.equalTo(backView2.mas_bottom).offset(0.5);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf2 = [[UITextField alloc] init];
    tf2.placeholder = @"请输入支付密码";
    tf2.secureTextEntry = YES;
    tf2.textColor = kColor333;
    self.tf2 = tf2;
    tf2.font = kFont(15);
    
    [scrollView addSubview:tf2];
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom);
        make.right.equalTo(scrollView).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *elabel = [self labelWithText:@"支付密码"];
    [scrollView addSubview:elabel];
    [elabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview);
        make.right.equalTo(tf2.mas_left).offset(- 10);
        make.centerY.equalTo(tf2);
    }];
    [elabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = kDefaultBGColor;
    
    [scrollView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(tf2.mas_bottom).offset(0.5);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(17);
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tixian:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    
    [scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.top.equalTo(line3.mas_bottom).offset(15);
        make.left.equalTo(scrollView).offset(30);
        make.right.equalTo(scrollView).offset(-30);
    }];
    
    //提现规则
    UIWebView *ruleView = [UIWebView new];
    ruleView.scrollView.showsVerticalScrollIndicator = NO;
//    ruleView.scrollView.scrollEnabled = NO;
    ruleView.scrollView.backgroundColor = BACKVIEWCOLOR;
    ruleView.backgroundColor = BACKVIEWCOLOR;
    [scrollView addSubview:ruleView];
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollView);
        make.top.equalTo(btn.mas_bottom).offset(10);
//        make.bottom.equalTo(scrollView.mas_bottom).offset(- 15);
        make.height.mas_equalTo(350);
    }];
    NSString *ruleStr = [DefaultDomainName stringByAppendingString:cashoutrule_url];
    NSLog(@"url地址：%@",ruleStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ruleStr]];
    [ruleView loadRequest:request];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.tf) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else  {
            NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
            if (![arr containsObject:string]) {
                return NO;
            }
            
            if (self.tf.text.length >= 8) {
                self.tf.text = [textField.text substringToIndex:8];
                return NO;
            }
        }
    }
    return YES;
}

- (void)tixian:(UIButton *)sender {
    if ([self.tf.text hasPrefix:@"."] || [self.tf.text hasSuffix:@"."]) {
        LRToast(@"您输入的金额有误！请重新输入");
        return;
    }
    if ([self.tf.text floatValue] < 100) {
        LRToast(@"提现金额应为100的整数倍");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"money"] = self.tf.text;
    dict[@"paymima"] = self.tf2.text;
    
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(cahsout) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            GCDAfter1s(^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else if ([res[@"code"] integerValue] == 3) {
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:nil RefreshAction:nil];
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = kFont(15);
    label.textColor = kColor333;
    return label;
}

- (void)configNavi {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateHighlighted];
//    self.navigationItem.rightBarButtonItem = item1;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor333}];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
}


- (void)right2:(UIBarButtonItem *)sender {
    KYWebViewController *vc = [KYWebViewController new];
    vc.web_url = cashoutrule_url;
    vc.name = @"提现规则";
    [self.navigationController pushViewController:vc animated:YES];
}

// 提现记录
- (void)right:(UIBarButtonItem *)sender {
    
    CashOutDetailViewController *vc = [CashOutDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"中国银行", @"农业银行", @"工商银行", @"建设银行", @"浦发银行", @"平安银行", @"邮政储蓄银行", @"光大银行", @"华夏银行", @"招商银行", @"交通银行", @"民生银行", @"兴业银行", @"中信银行", @"广发银行"];
    }
    return _dataArray;
}

- (NSMutableDictionary *)cardDict {
    if (!_cardDict) {
        NSArray *temp = @[@"104100000045",@"103100019027",@"102100004951",@"105100000033",@"310290098012",@"313584000019",@"403100000004",@"303100000006",@"304100040000",@"308584001024",@"301290011110",@"305100000013",@"309391000011",@"302521038101",@"306581000003"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [self.dataArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dict[obj] = temp[idx];
        }];
        _cardDict = dict;
    }
    
    return _cardDict;
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
