//
//  ModfiPhoneViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ModfiPhoneViewController.h"
#import "KYHeader.h"
#import "SecurityViewController.h"

@interface ModfiPhoneViewController ()
@property (nonatomic, strong) UITextField *aview;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIImageView *alert;
@end

@implementation ModfiPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换绑定手机号";
    self.view.backgroundColor =kDefaultBGColor;
    
    UITextField *view = [[UITextField alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@44);
    }];
    view.placeholder = @"请输入手机号";
    view.font = kFont(15);
    self.aview = view;
    
    UIView *aview = [UIView new];
    aview.frame = CGRectMake(0, 0, 15, 40);
    aview.backgroundColor = kWhiteColor;
    view.leftView = aview;
    view.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *btn = [UIButton    buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(view.mas_bottom).offset(30);
        make.height.equalTo(@44);
        make.width.mas_equalTo(270);
    }];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [UILabel new];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"*更换绑定手机号后，登录的手机号也更新为最新的手机号"];
    [att addAttributes:@{NSFontAttributeName : [UIColor colorWithHexString:@"d40000"]} range:NSMakeRange(0, 1)];
    [label setAttributedText:att];
    label.font = kFont(12);
    label.textColor = kColor666;
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.aview.mas_bottom).offset(10);
    }];
}


- (void)click:(UIButton *)sender {
    [self.view endEditing:YES];
    ModfiPhoneViewController *vc= [ModfiPhoneViewController new];
    vc.phone = self.phone;
    vc.code = self.aview.text;
    [HttpRequest postWithTokenURLString:NetRequestUrl(changmobile) parameters:[@{@"type" : @"3", @"mobile1" : self.aview.text} mutableCopy] isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            [self back];
            
        }
    } failure:nil RefreshAction:nil];
}

- (void)back {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.cover];
    [window addSubview:self.alert];
    [self.alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(190, 120));
        make.centerX.equalTo(window);
        make.centerY.equalTo(window);
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.cover.alpha = 0.4;
        self.alert.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tap:nil];
        });
    }];
    
}

- (UIView *)cover {
    if (!_cover) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_cover addGestureRecognizer:tap];
        _cover = view;
        
    }
    return _cover;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.alert.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self.cover removeFromSuperview];
        [self.alert removeFromSuperview];
        self.cover = nil;
        self.alert = nil;
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[SecurityViewController class]]) {
                
                
                [self.navigationController popToViewController:vc animated:YES];
                break;
                
            }
        }

    }];
}

- (UIImageView *)alert {
    if (!_alert) {
        _alert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wancheng"]];
        _alert.transform = CGAffineTransformMakeScale(0.3, 0.3);
    }
    return _alert;
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
