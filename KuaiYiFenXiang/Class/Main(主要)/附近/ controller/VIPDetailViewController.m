//
//  VIPDetailViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/25.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "VIPDetailViewController.h"
#import "VIPOrderViewController.h"

@interface VIPDetailViewController ()

@end

@implementation VIPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"VIP礼包详情";
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-50)];
    [self.view addSubview:scroll];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:self.model.original_img]]];
    
    [scroll addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(scroll);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(ScaleWidth(340));
    }];
    
    UIView *aview = [UIView new];
    
    aview.backgroundColor = kWhiteColor;
    
    [scroll addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scroll);
        make.top.equalTo(imageview.mas_bottom);
    }];
    
    UILabel *titleLabel = [UILabel new];
    
    titleLabel.text = self.model.goods_name;
    titleLabel.textColor = kColor333;
    titleLabel.font = kFont(15);
    titleLabel.numberOfLines = 0;
    
    [aview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(15);
        make.top.equalTo(aview).offset(15);
        make.right.equalTo(aview).offset(-100);
    }];
    
    UILabel *priceLabel = [UILabel new];
    
    priceLabel.textColor = kColord40;
    priceLabel.text = @"￥399.00";
    priceLabel.font = kFont(15);
    
    [aview addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
    }];
    
    UIImageView *jifen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"积"]];
    
    [aview addSubview:jifen];
    [jifen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel);
        make.top.equalTo(priceLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.bottom.equalTo(aview).offset(-15);
    }];
    
    UILabel *pointLabel = [UILabel new];
    
    pointLabel.text = @"3.99分";
    pointLabel.textColor = kColor333;
    pointLabel.font = kFont(12);
    
    [aview addSubview:pointLabel];
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jifen.mas_right).offset(10);
        make.centerY.equalTo(jifen);
    }];
    
    UILabel *numLabel = [UILabel new];
    
    numLabel.text = [self.model.sales_sum stringByAppendingString:@"人已购"];
    numLabel.textColor = kColor999;
    numLabel.font = kFont(13);
    
    [aview addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(aview).offset(-15);
        make.centerY.equalTo(titleLabel.mas_bottom);
    }];
    
    UIImageView *aimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"标题"]];
    
    [scroll addSubview:aimageView];
    [aimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scroll);
        make.top.equalTo(aview.mas_bottom).offset(15);
        make.height.mas_equalTo(ScaleWidth(44));
    }];
    
    UIImageView *firstimg;
    for (int i = 0; i < self.model.detail_img.count; i++) {
        UIImageView *timageview = [[UIImageView alloc] init];
        
        [timageview sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:self.model.detail_img[i]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [timageview mas_updateConstraints:^(MASConstraintMaker *make) {
//                NSLog(@"图片加载完成");
                make.height.mas_equalTo(SCREEN_WIDTH * (image.size.height/image.size.width));
                
            }];
        }];
        [scroll addSubview:timageview];
        [timageview mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(aimageView.mas_bottom);
            } else {
                make.top.equalTo(firstimg.mas_bottom);
            }
            make.left.right.equalTo(scroll);
            //如果是后面要根据加载完的图片来改变高度，最好一开始不要给高度，可能会造成约束重复
//            make.height.mas_equalTo(300);
            if (i == self.model.detail_img.count - 1) {
                make.bottom.equalTo(scroll).offset(-15);
            }
        }];
        firstimg = timageview;
        
        
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"立即购买" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(15);
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

- (void)click:(UIButton *)sender {
    VIPOrderViewController *vc = [VIPOrderViewController new];
    //    vc.address = self.address;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
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
