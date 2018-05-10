//
//  UserPayViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/28.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "UserPayViewController.h"
#import "GoPayViewController.h"

@interface UserPayViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf2;

@end

@implementation UserPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"用户付款";
    [self configUI];
}

- (void)configUI {
    UIView *aview = [UIView new];
    aview.backgroundColor = kWhiteColor;
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(60*4);
    }];
    
    UILabel *label1 = [UILabel new];
    
    label1.text = @"用户名：";
    label1.textColor = kColor333;
    label1.font= kFont(15);
    
    [aview addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(aview.mas_top).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    
    UITextField *tf1 = [[UITextField alloc] init];
    
    tf1.text = self.user_name;
    tf1.textColor = kColor333;
    tf1.font = kFont(15);
    tf1.userInteractionEnabled = NO;
    
    [aview addSubview:tf1];
    [tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label1);
    }];
    
    UILabel *label2 = [UILabel new];
    
    label2.text = @"消费总额：";
    label2.textColor = kColor333;
    label2.font= kFont(15);
    
    [aview addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label1.mas_bottom).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    
    UITextField *tf2 = [[UITextField alloc] init];
    
//    tf2.text = self.user_name;
    self.tf2 = tf2;
    tf2.delegate = self;
    tf2.placeholder = @"请输入消费总额";
    tf2.keyboardType = UIKeyboardTypeDecimalPad;
    tf2.textColor = kColord40;
    tf2.font = kFont(15);
    
    UILabel *left = [UILabel new];
    left.frame = CGRectMake(0, 0, 20, 60);
    left.textColor = kColord40;
    left.text = @"￥";
    tf2.leftView = left;
    tf2.leftViewMode = UITextFieldViewModeAlways;
    
    [aview addSubview:tf2];
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label2);
    }];
    
    UILabel *label3 = [UILabel new];
    
    label3.text = @"获得积分：";
    label3.textColor = kColor333;
    label3.font= kFont(15);
    
    [aview addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label2.mas_bottom).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    
    UITextField *tf3 = [[UITextField alloc] init];
    
    tf3.text = @"0.00";
    tf3.textColor = kColor333;
    tf3.font = kFont(15);
    tf3.userInteractionEnabled = NO;
    self.tf3 = tf3;
    
    [aview addSubview:tf3];
    [tf3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label3);
    }];
    
    UILabel *label4 = [UILabel new];
    
    label4.text = @"收款方：";
    label4.textColor = kColor333;
    label4.font= kFont(15);
    
    [aview addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label3.mas_bottom).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    
    UITextField *tf4 = [[UITextField alloc] init];
    
    tf4.text = self.shop_name;
    tf4.textColor = kColor333;
    tf4.font = kFont(15);
    tf4.userInteractionEnabled = NO;
    
    [aview addSubview:tf4];
    [tf4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label4.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label4);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(60);
        make.left.equalTo(label1);
        make.right.equalTo(tf1);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(120);
        make.left.equalTo(label2);
        make.right.equalTo(tf2);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(180);
        make.left.equalTo(label3);
        make.right.equalTo(tf3);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积分说明"]];
    [self.view addSubview:imageview1];
    [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(260);
        make.height.mas_equalTo(ScaleHeight(150));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(44+BOTTOM_MARGIN);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)click:(UIButton *)sender {
    if ([self.tf2.text hasPrefix:@"."] || [self.tf2.text hasSuffix:@"."]) {
        LRToast(@"请输入正确的金额");
        return;
    }
    if (self.tf2.text.floatValue == 0) {
        LRToast(@"请输入消费金额");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"money"] = self.tf2.text;
    dict[@"business_id"] = self.business_id;
    [HttpRequest postWithTokenURLString:NetRequestUrl(userPay) parameters:dict isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            GoPayViewController *vc = [GoPayViewController new];
            vc.type = @"4";
            vc.price = self.tf2.text;
            vc.tn = res[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:nil RefreshAction:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.tf2]) {
        NSString *str = textField.text;
        if (range.length == 0) {
            // 增加
            NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"."];
            if (![arr containsObject:string]) {
                return NO;
            }
            str = [str stringByAppendingString:string];
            self.tf3.text = [NSString stringWithFormat:@"%.4f", str.floatValue / 100 * self.mutiply * self.ratio/100];
        } else {
            //删除
            if (range.location == 0) {
                self.tf3.text = @"0.0000";
                return YES;
            }
            str = [str substringToIndex:range.location];
            self.tf3.text = [NSString stringWithFormat:@"%.4f", str.floatValue / 100 * self.mutiply * self.ratio/100];
        }
    }
    return YES;
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
