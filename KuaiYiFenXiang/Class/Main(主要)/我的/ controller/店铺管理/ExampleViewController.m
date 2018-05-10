//
//  ExampleViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/27.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ExampleViewController.h"


@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"示例图";
    UIImage *image;
    
    if ([self.text isEqualToString:@"身份证正面示例"]) {
        image = [UIImage imageNamed:@"身份证示例"];
    } else if ([self.text isEqualToString:@"身份证反面示例"]) {
        image = [UIImage imageNamed:@"身份证示例反面"];
    } else if ([self.text isEqualToString:@"店铺logo示例"]) {
        image = [UIImage imageNamed:@"店铺logo示例"];
    }else if ([self.text isEqualToString:@"营业执照"]) {
        image = [UIImage imageNamed:@"营业执照"];
    }else if ([self.text isEqualToString:@"开店许可证示例"]) {
        image = [UIImage imageNamed:@"经营许可"];
    }else if ([self.text isEqualToString:@"店铺示例"]) {
        image = [UIImage imageNamed:@"店铺照片"];
    }
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(690/2.0, 220));
        make.top.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
    }];
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
