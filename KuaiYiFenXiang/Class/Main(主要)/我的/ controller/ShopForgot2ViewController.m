//
//  ShopForgot2ViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/9.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShopForgot2ViewController.h"
#import "KYHeader.h"
#import "ShopForgot3ViewController.h"

@interface ShopForgot2ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *alabel;
@property (nonatomic, strong) UILabel *blabel;
@property (nonatomic, strong) UILabel *clabel;
@property (nonatomic, strong) UILabel *dlabel;
@property (nonatomic, strong) UILabel *elabel;
@property (nonatomic, strong) UILabel *flabel;

@property (nonatomic, strong) UITextField *tf;

@end

@implementation ShopForgot2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新支付密码";
    
    self.view.backgroundColor = kDefaultBGColor;
    
    UILabel *label = [UILabel new];
    label.text = @"请输入6位支付密码";
    label.font = kFont(15);
    label.textColor = kColor666;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
    }];
    
    _alabel = [self labelwithNone];
    [self.view addSubview:_alabel];
    [_alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-87.5);
        make.top.equalTo(self.view).offset(80);
    }];
    
    _blabel = [self labelwithNone];
    [self.view addSubview:_blabel];
    [_blabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-52.5);
        make.top.equalTo(self.view).offset(80);
    }];
    
    _clabel = [self labelwithNone];
    [self.view addSubview:_clabel];
    [_clabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-17.5);
        make.top.equalTo(self.view).offset(80);
    }];
    
    _dlabel = [self labelwithNone];
    [self.view addSubview:_dlabel];
    [_dlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(17.5);
        make.top.equalTo(self.view).offset(80);
    }];
    
    _elabel = [self labelwithNone];
    [self.view addSubview:_elabel];
    [_elabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(52.5);
        make.top.equalTo(self.view).offset(80);
    }];
    
    _flabel = [self labelwithNone];
    [self.view addSubview:_flabel];
    [_flabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(87.5);
        make.top.equalTo(self.view).offset(80);
    }];
    
    
    UITextField *tf = [[UITextField alloc] init];
    tf.delegate = self;
    [self.view addSubview:tf];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_top).offset(-10);
    }];
    
    self.tf = tf;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tf.text = @"";
    self.alabel.text = @"-";
    self.blabel.text = @"-";
    self.clabel.text = @"-";
    self.dlabel.text = @"-";
    self.elabel.text = @"-";
    self.flabel.text = @"-";
    [self.tf becomeFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    NSLog(@"=========%@", NSStringFromRange(range));
    //    NSLog(@"---------%@", string);
    if (range.length == 0) {
        // 增加
        if (range.location == 0) {
            self.alabel.text = string;
        } else if (range.location == 1) {
            self.blabel.text = string;
        } else if (range.location == 2) {
            self.clabel.text = string;
        } else if (range.location == 3) {
            self.dlabel.text = string;
        } else if (range.location == 4) {
            self.elabel.text = string;
        } else if (range.location == 5) {
            self.flabel.text = string;
        }
    } else {
        //删除
        if (range.location == 0) {
            self.alabel.text = @"-";
        } else if (range.location == 1) {
            self.blabel.text = @"-";
        } else if (range.location == 2) {
            self.clabel.text = @"-";
        } else if (range.location == 3) {
            self.dlabel.text = @"-";
        } else if (range.location == 4) {
            self.elabel.text = @"-";
        } else if (range.location == 5) {
            self.flabel.text = @"-";
        }
    }
    
    if (range.location == 5) {
        ShopForgot3ViewController *vc = [ShopForgot3ViewController new];
        vc.pwd = [self.tf.text stringByAppendingString:string];
        vc.idStr = self.idStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

- (UILabel *)labelwithNone {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:35];
    label.textColor = kColord40;
    label.text = @"-";
    return label;
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
