//
//  BankCardViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "BankCardViewController.h"
#import "KYHeader.h"
#import "KYWebViewController.h"
#import "PayChangeViewController.h"
#import "PayChangeViewController.h"

@interface BankCardViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *atf;
@property (nonatomic, strong) UITextField *btf;
@property (nonatomic, strong) UITextField *ctf;
@property (nonatomic, strong) UITextField *dtf;
@property (nonatomic, strong) UITextField *etf;
@property (nonatomic, strong) UITextField *ftf;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *cardDict;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSString *selectedBank;

@property (nonatomic, strong) NSString *bank_name;
@property (nonatomic, strong) NSString *bank_number;
@property (nonatomic, strong) NSString *bank_id;
@property (nonatomic, strong) UIButton *ri;
@property (nonatomic, assign) CGFloat time;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.view.backgroundColor = kDefaultBGColor;
    
//    [self configNavi];
    
//    [self configUI];
    self.time = 60;
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColor333}];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)configNaviWithTitle:(NSString *)title {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(bankinfo) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 3) {
            // 未绑定
            [self configUI];
            [self configNaviWithTitle:@"规则"];
        } else if ([res[@"code"] integerValue] == 1) {
            // 已绑定
//            self.bank_name = [res[@"result"][@"bank_name"] description];
            self.bank_number = [res[@"result"][@"number"] description];
            self.bank_id = [res[@"result"][@"card"] description];
            
            [self configDoneUI];
            [self configNaviWithTitle:@"解除绑定"];
        }
    } failure:nil RefreshAction:nil];
}

- (void)configDoneUI {
    self.title = @"我的银行卡";
    
    [self.cardDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString *obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:self.bank_id]) {
            self.bank_name = key;
        }
    }];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.bank_name]];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(ScaleWidth(690/2.0), ScaleWidth(180)));
    }];
    
    UILabel *label = [UILabel new];
    label.font = kFont(22);
    label.textColor = kWhiteColor;
    [imageview addSubview:label];
    label.text = [@"****      ****      ****      " stringByAppendingString:[self.bank_number substringWithRange:NSMakeRange(self.bank_number.length - 4, 4)]];
    [imageview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageview).offset(ScaleWidth(10));
        
    }];
    
    UILabel *flabel = [UILabel new];
    
    flabel.font = kFont(11);
    flabel.textColor = kColor999;
    flabel.numberOfLines = 0;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"*  为了资金安全，资金仅能同卡进出，如需更换银行卡，点击银行卡可解除绑定"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"d40000"] range:NSMakeRange(0, 1)];
    [flabel setAttributedText:att];
    
    [self.view addSubview:flabel];
    [flabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview);
        make.width.mas_equalTo(imageview);
        make.top.equalTo(imageview.mas_bottom).offset(15);
    }];
}

- (void)configUI {
    self.title = @"银行卡绑定";
    UIView *aview = [self viewWithTitle:@"持卡人："];
    
    for (UIView *sub in aview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.atf = (UITextField *)sub;
            self.atf.keyboardType = UIKeyboardTypeDefault;
            self.atf.delegate = self;
            break;
        }
    }
    
    
    
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    UIView *bview = [self viewWithTitle:@"银行卡号："];
    
    for (UIView *sub in bview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.btf = (UITextField *)sub;
            self.btf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:bview];
    [bview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(aview.mas_bottom);
    }];
    
    UIView *cview = [self viewWithTitle:@"开户银行："];
    
    for (UIView *sub in cview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.ctf = (UITextField *)sub;
            self.ctf.delegate = self;
            break;
        }
    }
    
    
    
    [self.view addSubview:cview];
    [cview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(bview.mas_bottom);
    }];
    
    
    UIView *dview = [self viewWithTitle:@"手机号码："];
    
    for (UIView *sub in dview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.dtf = (UITextField *)sub;
            self.dtf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:dview];
    [dview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(cview.mas_bottom);
    }];
    
    UIView *eview = [self viewWithTitle:@"身份证号码："];
    
    for (UIView *sub in eview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.etf = (UITextField *)sub;
            self.etf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:eview];
    [eview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(dview.mas_bottom);
    }];
    
    UIView *fview = [self viewWithTitle:@"短信验证码："];
    
    for (UIView *sub in fview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.ftf = (UITextField *)sub;
            self.ftf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:fview];
    [fview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(eview.mas_bottom);
    }];
    
    UIView *rightview= [UIView new];
    rightview.backgroundColor = [UIColor whiteColor];
    rightview.frame = CGRectMake(0, 0, 105, 40);
    
    UIButton *ri = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ri setTitle:@"获取验证码" forState:UIControlStateNormal];
    [ri setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [ri addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    ri.titleLabel.font = kFont(15);
    [ri setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    ri.layer.cornerRadius = 3;
    ri.layer.masksToBounds = YES;
    
    [rightview addSubview:ri];
    ri.frame = CGRectMake(0, 10, 100, 30);
    self.ri = ri;
    
    self.ftf.rightView = rightview;
    self.ftf.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *flabel = [UILabel new];
    
    flabel.font = kFont(11);
    flabel.textColor = kColor999;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"*此卡仅用于提现，不支持绑定信用卡，目前只支持绑定一张银行卡"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"d40000"] range:NSMakeRange(0, 1)];
    [flabel setAttributedText:att];
    
    [self.view addSubview:flabel];
    [flabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(fview.mas_bottom).offset(15);
    }];
    
    UIView *line1 = [UIView new];
    
    line1.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(aview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView *line2 = [UIView new];
    
    line2.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView *line3 = [UIView new];
    
    line3.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView *line4 = [UIView new];
    
    line4.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView *line5 = [UIView new];
    
    line5.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(eview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(120, 100, 160, 30) style:UITableViewStylePlain];
    self.table = table;
//    table.backgroundColor = [UIColor redColor];
    table.backgroundColor = kDefaultBGColor;
    table.delegate = self;
    table.dataSource = self;
    table.layer.cornerRadius = 5;
    table.layer.masksToBounds = YES;
    table.layer.borderColor = kColor999.CGColor;
    table.layer.borderWidth = 0.5;
//    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ctf.mas_centerY).offset(-15);
        make.left.equalTo(self.ctf).offset(120);
        make.right.equalTo(self.ctf).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView *imageaaa = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上箭头"]];
    imageaaa.transform = CGAffineTransformRotate(imageaaa.transform, M_PI);
    [self.view addSubview:imageaaa];
    [imageaaa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ctf);
        make.right.equalTo(table).offset(-5);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)click:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = self.atf.text;
    dict[@"number"] = self.btf.text;
    dict[@"idcard"] = self.etf.text;
    dict[@"mobile_code"] = self.ftf.text;
    dict[@"card"] = self.cardDict[self.selectedBank];
    dict[@"mobile"] = self.dtf.text;
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(bindbankcard) parameters:dict isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            [self back];
//            NSLog(@"%@", res);
            
        }
    } failure:nil RefreshAction:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCode:(UIButton *)sender {
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(sendValidate) parameters:[@{@"type" : @"6", @"send" : self.dtf.text} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
//        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            self.timer = timer;
            [self.ri setBackgroundImage:[KYHeader imageWithColor:kColor666] forState:UIControlStateNormal];
            self.ri.userInteractionEnabled = NO;
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [timer fire];
        }
    } failure:nil RefreshAction:nil];
}

- (void)timerAction {
    self.time--;
    
    [self.ri setTitle:[NSString stringWithFormat:@"重新发送(%@)", @(self.time).description] forState:UIControlStateNormal];
    if (self.time == 0) {
        self.time = 60;
        [self.timer invalidate];
        self.timer = nil;
        [self.ri setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
        [self.ri setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.ri.userInteractionEnabled = YES;
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.ctf]) {
        return NO;
    }
    self.isOpen = NO;
    [self.table reloadData];
    [self updateViewConstraints];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.isOpen ? self.dataArray[indexPath.row] : (self.selectedBank ? self.selectedBank : @"请选择银行") ;
    cell.textLabel.font = kFont(13);
    cell.textLabel.textColor = kColor666;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;;
    cell.backgroundColor = kDefaultBGColor;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isOpen) {
        return self.dataArray.count;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.isOpen = !self.isOpen;
    if (!self.isOpen) {
        self.selectedBank = self.dataArray[indexPath.row];
    }
    [tableView reloadData];
    [self updateViewConstraints];
    [tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateViewConstraints {
    if (self.isOpen) {
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
    } else {
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
    }
    [super updateViewConstraints];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)right:(UIBarButtonItem *)btn {
    if ([btn.title isEqualToString:@"规则"]) {
        KYWebViewController *vc = [KYWebViewController new];
        vc.web_url = bankrule_url;
        vc.title = @"银行卡绑定规则";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self delbank];
    }
}

- (void)delbank {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(checkpaycode) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            DCPaymentView *payAlert = [[DCPaymentView alloc]init];
            payAlert.title = @"请输入支付密码";
            [payAlert show];
            payAlert.completeHandle = ^(NSString *inputPwd) {
                
                
                dict[@"bank_id"] = self.bank_id;
                dict[@"paymima"] = inputPwd;
                [HttpRequest postWithTokenURLString:NetRequestUrl(delbank) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
                    if ([res[@"code"] integerValue] == 1) {
                        [self back];
                    } else if ([res[@"code"] integerValue] == 3) {
                        PayChangeViewController *vc = [PayChangeViewController new];
                        vc.showNotice = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } failure:nil RefreshAction:nil];
            };
            
        } else {
            
            PayChangeViewController *vc = [PayChangeViewController new];
            vc.showNotice = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:nil RefreshAction:nil];
    
    
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


- (UIView *)viewWithTitle:(NSString *)title {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UITextField *tf = [[UITextField alloc] init];
    
    [view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    UIView *aview = [UIView new];
    
    aview.frame = CGRectMake(0, 0, 115, 60);
    
    UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(15, 0, 100, 60)];
    
    label.font = kFont(15);
    label.textColor = kColor333;
    label.text = title;
    
    [aview addSubview:label];
    
    tf.leftView = aview;
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    return view;
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
