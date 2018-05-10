//
//  ChangeNikeNameViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ChangeNikeNameViewController.h"
#import "KYHeader.h"
#import "NSString+Category.h"

@interface ChangeNikeNameViewController ()
@property (nonatomic, strong) UITextField *tf;


@end

@implementation ChangeNikeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self configUI];
}

- (void)configUI {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"保存" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateHighlighted];
    
    self.navigationItem.rightBarButtonItem = item;
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.placeholder = @"请输入昵称，长度为4-12个字节";
    tf.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    tf.layer.borderWidth = 0.5;
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
//    a.backgroundColor = [UIColor redColor];
    tf.leftView = a;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = self.nickname ? self.nickname : @"";
    self.tf = tf;
    
    [self.view addSubview:tf];
    [tf becomeFirstResponder];
    
}

- (void)save {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSInteger textlength = [NSString_Category calculateLengthWithStr:self.tf.text];
    
    if (textlength < 4||textlength > 12) {
        LRToast(@"昵称长度为4-12个字节")
        return;
    }
    [self.tf.text isValidIP];
    dict[@"nickname"] = self.tf.text;
    [HttpRequest postWithTokenURLString:NetRequestUrl(changenickname) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            if (self.getSaveNickNameBlock) {
                self.getSaveNickNameBlock(self.tf.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:nil RefreshAction:nil];
    
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
