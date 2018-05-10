//
//  ShopPayViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShopPayViewController.h"
#import "GoPayViewController.h"

@interface ShopPayViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UITextField *tf5;
@property (nonatomic, strong) UITextField *tf6;
@property (nonatomic, strong) NSMutableArray *covers;
@property (nonatomic, strong) NSString *other_id;
@property (nonatomic, strong) UITextField *ratioTf;
@end

@implementation ShopPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商家代付款";
    self.view.backgroundColor = kDefaultBGColor;
    self.covers = [NSMutableArray array];
    [self configUI];
}

- (void)configUI {
    UIView *aview = [UIView new];
    aview.backgroundColor = kWhiteColor;
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
//        make.edges.equalTo(self.view);
        make.height.mas_equalTo(44*6);
    }];
    
    UILabel *label1 = [UILabel new];
    
    label1.text = @"商家：";
    label1.textColor = kColor333;
    label1.font= kFont(15);
    
    [aview addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(aview.mas_top).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf1 = [[UITextField alloc] init];
    
    tf1.text = self.shop_name;
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
    
    label2.text = @"让利比：";
    label2.textColor = kColor333;
    label2.font= kFont(15);
    
    [aview addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label1.mas_bottom).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf2 = [[UITextField alloc] init];
    
    tf2.text = [@(self.ratio).description stringByAppendingString:@"%"];
    self.tf2 = tf2;
//    tf2.userInteractionEnabled = NO;
    tf2.delegate = self;
    tf2.placeholder = @"请输入让利比";
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.textColor = kColord40;
    tf2.font = kFont(15);
    
    
    [aview addSubview:tf2];
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label2);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn1 setBackgroundImage:[UIImage imageNamed:@"修改信息icon"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(showRatio:) forControlEvents:UIControlEventTouchUpInside];
    
    [aview addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(tf2);
        make.right.equalTo(tf2);
    }];
    
    UILabel *label3 = [UILabel new];
    
    label3.text = @"用户手机号：";
    label3.textColor = kColor333;
    label3.font= kFont(15);
    
    [aview addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label2.mas_bottom).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf3 = [[UITextField alloc] init];
    
//    tf3.text = @"0.00";
    tf3.textColor = kColor333;
    tf3.font = kFont(15);
    tf3.delegate = self;
    tf3.placeholder = @"请输入用户手机号";
    self.tf3 = tf3;
    
    [aview addSubview:tf3];
    [tf3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label3);
    }];
    
    UILabel *label4 = [UILabel new];
    
    label4.text = @"用户名称：";
    label4.textColor = kColor333;
    label4.font= kFont(15);
    
    [aview addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label3.mas_bottom).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf4 = [[UITextField alloc] init];
    
    tf4.textColor = kColor333;
    self.tf4 = tf4;
//    tf4.delegate = self;
    tf4.font = kFont(15);
    tf4.userInteractionEnabled = NO;
    
    [aview addSubview:tf4];
    [tf4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label4.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label4);
    }];
    
    UILabel *label5 = [UILabel new];
    
    label5.text = @"消费金额：";
    label5.textColor = kColor333;
    label5.font= kFont(15);
    
    [aview addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label4.mas_bottom).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf5 = [[UITextField alloc] init];
    
    tf5.textColor = kColor333;
    self.tf5 = tf5;
    tf5.placeholder = @"请输入消费金额";
    tf5.delegate = self;
    tf5.font = kFont(15);
    tf5.keyboardType = UIKeyboardTypeDecimalPad;
    
    [aview addSubview:tf5];
    [tf5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label5.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label5);
    }];
    
    UILabel *left5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    
    left5.text = @"￥";
    left5.textColor = kColor333;
    left5.font = kFont(15);
    tf5.leftView = left5;
    tf5.leftViewMode = UITextFieldViewModeAlways;
    
    
    UILabel *label6 = [UILabel new];
    
    label6.text = @"代付金额：";
    label6.textColor = kColor333;
    label6.font= kFont(15);
    
    [aview addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.centerY.equalTo(label5.mas_bottom).offset(22);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    UITextField *tf6 = [[UITextField alloc] init];
    
    tf6.textColor = kColor333;
    self.tf6 = tf6;
//    tf6.delegate = self;
    tf6.font = kFont(15);
    tf6.userInteractionEnabled = NO;
    
    [aview addSubview:tf6];
    [tf6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label6.mas_right);
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(label6);
    }];
    
    UILabel *left6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    
    left6.text = @"￥";
    left6.textColor = kColor333;
    left6.font = kFont(15);
    tf6.leftView = left6;
    tf6.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(44);
        make.left.equalTo(label1);
        make.right.equalTo(tf1);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(88);
        make.left.equalTo(label2);
        make.right.equalTo(tf2);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line3 = [UIView new];
    line3.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(88+44);
        make.left.equalTo(label3);
        make.right.equalTo(tf3);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line4 = [UIView new];
    line4.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(88+44+44);
        make.left.equalTo(label3);
        make.right.equalTo(tf3);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line5 = [UIView new];
    line5.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview.mas_top).offset(88+44+44+44);
        make.left.equalTo(label3);
        make.right.equalTo(tf3);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
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

- (void)click:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSLog(@"输入的金额：%@",self.tf5.text);
    if (self.tf5.text.floatValue < 1) {
        LRToast(@"最低金额为1哦~");
        return;
    }
    
    if (self.tf5.text.floatValue == 0) {
        LRToast(@"请输入消费金额");
        return;
    }
    dict[@"money"] = self.tf5.text;
    dict[@"business_id"] = self.buisness_id;
    dict[@"mobile"] = self.tf3.text;
    dict[@"username"] = self.tf4.text;
    if ([self.tf4.text isEqualToString:@""]) {
        LRToast(@"请输入正确的手机号码");
        return;
    }
    dict[@"other_id"] = self.other_id;
    dict[@"ratio"] = @(self.ratio).description;
    [HttpRequest postWithTokenURLString:NetRequestUrl(doShopPay) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            GoPayViewController *vc = [GoPayViewController new];
            vc.type = @"4";
            vc.price = self.tf6.text;
            vc.tn = res[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:nil RefreshAction:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![textField isEqual:self.tf2]) {
        return YES;
        
    } else {
        [self showRatio:nil];
        return NO;
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.tf3]) {
        NSString *str = textField.text;
        if (range.length == 0) {
            // 增加
            str = [str stringByAppendingString:string];
            if (str.length == 11) {
                [self reuqestName:str];
            }else {
                self.tf4.text = @"";
            }
        } else {
            //删除
            if (range.location == 0) {
                return YES;
            }
            str = [str substringToIndex:range.location];
            if (str.length == 11) {
                [self reuqestName:str];
            }else {
                self.tf4.text = @"";
            }
        }
        
        
        
    } else if ([textField isEqual:self.tf5]) {
        
        NSString *str = textField.text;
        if (range.length == 0) {
            // 增加
            
            NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"."];
            if (![arr containsObject:string]) {
                return NO;
            }
            
            str = [str stringByAppendingString:string];
            
            self.tf6.text = [NSString stringWithFormat:@"%.2f", str.floatValue * self.ratio/100];
        } else {
            //删除
            if (range.location == 0) {
                self.tf6.text = @"0.00";
                return YES;
            }
            str = [str substringToIndex:range.location];
            self.tf6.text = [NSString stringWithFormat:@"%.2f", str.floatValue * self.ratio/100];
        }
    } else if ([textField isEqual:self.ratioTf]) {
        NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (![arr containsObject:string]) {
            
            return NO;
        }
    }
    return YES;
}

- (void)showRatio:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入新的让利比" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    MCWeakSelf
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        weakSelf.ratioTf = textField;
        weakSelf.ratioTf.delegate = weakSelf;
        textField.textColor = kColord40;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = @(self.ratio).description;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = alert.textFields.firstObject.text;
        if ([str hasPrefix:@"0"]) {
            LRToast(@"请输入正确的让利比");
            return ;
        }
        if (str.integerValue <= 0 || str.integerValue > self.upperRatio) {
            NSString *str = [NSString stringWithFormat:@"让利比范围在0~%ld之间，请重新输入！", self.upperRatio];
            LRToast(str);
            return ;
        }
        if ([[str substringFromIndex:str.length - 1] isEqualToString:@"%"]) {
            self.tf2.text = str;
        } else {
            self.ratio = [str integerValue];
            self.tf6.text = [NSString stringWithFormat:@"%.2f", self.tf5.text.floatValue * self.ratio/100];
            self.tf2.text = [str stringByAppendingString:@"%"];
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reuqestName:(NSString *)text {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = text;
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopName) parameters:dict isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            self.tf4.text = res[@"result"][@"nickname"];
            self.other_id = res[@"result"][@"other_id"];
        }else{
            LRToast(res[@"msg"]);
            self.tf3.text = @"";
            return ;
        }
    } failure:nil RefreshAction:nil];
    
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
