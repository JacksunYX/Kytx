//
//  StoreManagementViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "StoreManagementViewController.h"
#import "KYHeader.h"
#import "ShareApplicationViewController.h"
#import "UserRegisterViewController.h"
#import "ShopRegisterViewController.h"
#import <CoreImage/CoreImage.h>
#import "ShopAgreementViewController.h"
#import "StoreDisplayViewController.h"
#import "UserPayViewController.h"
#import "ShopInfoViewController.h"
#import "ShopPayViewController.h"
#import "PublishShopViewController.h"
#import "OnlineOrderViewController.h"
#import "OfflineOrderViewController.h"

#import "ComingViewController.h"

@interface StoreManagementViewController ()
@property (nonatomic, assign) NSInteger shop_status;
@property (nonatomic, strong) NSMutableArray *covers;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *travel_numLabel;
@property (nonatomic, strong) UILabel *order_numLabel;
@property (nonatomic, strong) UILabel *sale_numLabel;
@property (nonatomic, strong) UIImageView *iconimageview;
@property (nonatomic, assign) NSInteger ratio;
@property (nonatomic, assign) NSInteger mutiply;
@property (nonatomic, assign) NSInteger upperRatio;
@end

@implementation StoreManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的店铺";
    self.view.backgroundColor = kDefaultBGColor;
    
    [self configNavi];
    [self configUI];
    self.covers = [NSMutableArray array];
    
}

- (void)loadData {
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopnum) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            NSDictionary *dict = res[@"result"];
            
            NSDictionary *shopdict = dict[@"shops"];
            
            self.upperRatio = [shopdict[@"return_shop_ratio"] integerValue];
            self.nameLabel.text = shopdict[@"name"];
            self.moneyLabel.text = [@"月销售额度（限）：" stringByAppendingString:shopdict[@"monthMoney"]];
            self.shop_id = shopdict[@"business_id"];
            kStringIsEmpty(shopdict[@"logo"])?:[self.iconimageview sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:shopdict[@"logo"]]]];
            self.ratio = [shopdict[@"ratio"] integerValue];
            self.mutiply = [shopdict[@"double"] integerValue];
            NSDictionary *countdict = dict[@"count"];
            
            self.travel_numLabel.text = [countdict[@"travel_num"] description];
            self.order_numLabel.text = [countdict[@"ordel_num"] description];
            self.sale_numLabel.text = [[countdict[@"sale_num"] description] stringByAppendingString:@"元"];
        }
    } failure:nil RefreshAction:nil];
}

- (void)showCategory {
    ShopAgreementViewController *vc = [ShopAgreementViewController new];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)loadStatus {
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopinfo) parameters:[NSMutableDictionary dictionary] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        for (UIView *view in self.covers) {
            [view removeFromSuperview];
        }
        [self.covers removeAllObjects];
   
        if ([res[@"code"] integerValue] == 1) {
            NSString *user_id = [USER_DEFAULT objectForKey:@"user_id"];
            if (user_id) {
                BOOL showCategory = [USER_DEFAULT objectForKey:@"showcategory"];
                if (!showCategory) {
                    [self showCategory];
                }
            }
            [self loadData];
        } else if ([res[@"code"] integerValue] == 2) {
//            NSLog(@"开店");
            UIView *cover = [UIView new];
            cover.backgroundColor = [UIColor whiteColor];
            cover.alpha = 0.3;
            [self.view addSubview:cover];
            [cover mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];
            [label setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
            [label setTitle:@"免费申请分享商家" forState:UIControlStateNormal];
            [label setTitleColor:kWhiteColor forState:UIControlStateNormal];
            label.titleLabel.font = kFont(17);
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            [self.view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.width.mas_equalTo(SCREEN_WIDTH - 80);
                make.height.mas_equalTo(50);
            }];
            [label addTarget:self action:@selector(click:) forControlEvents: UIControlEventTouchUpInside];
            [self.covers addObject:cover];
            [self.covers addObject:label];
        } else if ([res[@"code"] integerValue] == 3) {
            //            NSLog(@"审核中");
            UIView *cover = [UIView new];
            cover.backgroundColor = [UIColor blackColor];
            cover.alpha = 0.3;
            [self.view addSubview:cover];
            [cover mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            UIView *aview = [UIView new];
            aview.backgroundColor = kWhiteColor;
            [self.view addSubview:aview];
            [aview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(190, 125));
            }];
            
            
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"等待中"]];
            [aview addSubview:imageview];
            [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(aview);
                make.top.equalTo(aview).offset(25);
                make.size.mas_equalTo(CGSizeMake(31.5, 40));
            }];
            
            UILabel *label = [UILabel new];
            
            label.text = @"等待审核";
            label.textColor = kColor333;
            label.font = kFont(15);
            
            [aview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(aview);
                make.top.equalTo(imageview.mas_bottom).offset(15);
            }];
            [self.covers addObject:cover];
            [self.covers addObject:aview];
        } else if ([res[@"code"] integerValue] == 5) {
            // 审核不通过
            UIView *cover = [UIView new];
            cover.backgroundColor = [UIColor whiteColor];
            cover.alpha = 0.3;
            [self.view addSubview:cover];
            [cover mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];
            [label setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
            [label setTitle:@"审核未通过，去修改" forState:UIControlStateNormal];
            [label setTitleColor:kWhiteColor forState:UIControlStateNormal];
            label.titleLabel.font = kFont(17);
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            [self.view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.width.mas_equalTo(SCREEN_WIDTH - 80);
                make.height.mas_equalTo(50);
            }];
            [label addTarget:self action:@selector(click3:) forControlEvents: UIControlEventTouchUpInside];
            [self.covers addObject:cover];
            [self.covers addObject:label];
            
        }else if ([res[@"code"] integerValue] == 6) {
            // 数据错误
            LRToast(@"数据错误！请联系客服！");
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else if ([res[@"code"] integerValue] == 7) {
            // 去支付
            UIView *cover = [UIView new];
            cover.backgroundColor = [UIColor whiteColor];
            cover.alpha = 0.3;
            [self.view addSubview:cover];
            [cover mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            UIButton *label = [UIButton buttonWithType:UIButtonTypeCustom];
            [label setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
            [label setTitle:@"继续支付" forState:UIControlStateNormal];
            [label setTitleColor:kWhiteColor forState:UIControlStateNormal];
            label.titleLabel.font = kFont(17);
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            [self.view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.width.mas_equalTo(SCREEN_WIDTH - 80);
                make.height.mas_equalTo(50);
            }];
            [label addTarget:self action:@selector(click2:) forControlEvents: UIControlEventTouchUpInside];
            [self.covers addObject:cover];
            [self.covers addObject:label];
            
            
        }
    } failure:nil RefreshAction:nil];
}

- (void)click2:(UIButton *)btn {
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopreject) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
//        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
            NSDictionary *dict = res[@"result"];
            if ([dict[@"license"] isEqualToString:@""]) {
                // 个人店
                UserRegisterViewController *vc = [UserRegisterViewController new];
                vc.dict = dict;
                vc.type1 = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                // 企业店
                ShopRegisterViewController *vc = [ShopRegisterViewController new];
                vc.dict = dict;
                vc.type1 = @"1";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:nil RefreshAction:nil];
}

- (void)click3:(UIButton *)btn {
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopreject) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
//        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
            
            NSDictionary *dict = res[@"result"];
            
            if (![dict[@"type"] isEqualToString:@"online"]) {
                // 个人店
                UserRegisterViewController *vc = [UserRegisterViewController new];
                vc.dict = dict;
                vc.noPay = YES;
                vc.type1 = @"2";
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                // 企业店
                ShopRegisterViewController *vc = [ShopRegisterViewController new];
                vc.dict = dict;
                vc.noPay = YES;
                vc.type1 = @"2";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:nil RefreshAction:nil];
}


- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"白色箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self loadStatus];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}


- (void)configUI {
    UIImageView *bgimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的店铺bg"]];
    bgimageView.userInteractionEnabled = YES;
    [self.view addSubview:bgimageView];
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(ScaleWidth(170));
    }];
    
    
    
    
    UIImageView *iconimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"店铺logo"]];
    [bgimageView addSubview:iconimageview];
    [iconimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScaleWidth(60), ScaleWidth(60)));
        make.bottom.equalTo(bgimageView).offset(-ScaleHeight(30));
        make.left.equalTo(bgimageView).offset(ScaleWidth(15));
    }];
    self.iconimageview = iconimageview;
    
    UILabel *namelabel = [UILabel new];
    
    namelabel.font = [UIFont systemFontOfSize:15];
//    namelabel.text = @"一家店铺";
    self.nameLabel = namelabel;
    namelabel.textColor = kWhiteColor;
    
    [bgimageView addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconimageview.mas_centerY).offset(-ScaleHeight(10));
        make.left.equalTo(iconimageview.mas_right).offset(ScaleWidth(10));
    }];
    
    UILabel *countlabel = [UILabel new];
    
    countlabel.font = [UIFont systemFontOfSize:13];
    countlabel.text = @"月销售额度（限）：500000";
    self.moneyLabel = countlabel;
    countlabel.textColor = kWhiteColor;
    
    [bgimageView addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconimageview.mas_centerY).offset(ScaleHeight(10));
        make.left.equalTo(iconimageview.mas_right).offset(ScaleWidth(10));
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"进入店铺" forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [bgimageView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScaleWidth(60), ScaleHeight(20)));
        make.right.equalTo(bgimageView).offset(-15);
        make.centerY.equalTo(iconimageview);
    }];
    [btn addTarget:self action:@selector(enterStore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *aview = [UIView new];
    
    aview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:aview];
    
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(bgimageView.mas_bottom);
        make.height.mas_equalTo(ScaleHeight(70));
    }];
    
    UILabel *visitorlabel = [self labelWithTitle:@"今日访客"];
    
    [aview addSubview:visitorlabel];
    [visitorlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.bottom.equalTo(aview).offset(-ScaleHeight(10));
    }];
    
    UILabel *orderlabel = [self labelWithTitle:@"今日订单"];
    
    [aview addSubview:orderlabel];
    [orderlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(aview);
        make.bottom.equalTo(aview).offset(-ScaleHeight(10));
    }];
    
    UILabel *selllabel = [self labelWithTitle:@"今日销售额"];
    
    [aview addSubview:selllabel];
    [selllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(aview);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.bottom.equalTo(aview).offset(-ScaleHeight(10));
    }];
    
    UILabel *visitorlabel_count = [self labelWithTitle:@""];
    self.travel_numLabel = visitorlabel_count;
    
    [aview addSubview:visitorlabel_count];
    [visitorlabel_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.equalTo(aview).offset(ScaleHeight(15));
    }];
    
    UILabel *orderlabel_count = [self labelWithTitle:@""];
    self.order_numLabel = orderlabel_count;
    [aview addSubview:orderlabel_count];
    [orderlabel_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(aview);
        make.top.equalTo(aview).offset(ScaleHeight(15));
    }];
    
    UILabel *selllabel_count = [self labelWithTitle:@""];
    self.sale_numLabel = selllabel_count;
    [aview addSubview:selllabel_count];
    [selllabel_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(aview);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.equalTo(aview).offset(ScaleHeight(15));
    }];
    
    UIView *line1 = [self vline];
    [aview addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview);
        make.left.equalTo(visitorlabel.mas_right);
        make.height.mas_equalTo(ScaleHeight(35));
        make.width.equalTo(@1);
    }];
    
    UIView *line2 = [self vline];
    [aview addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview);
        make.right.equalTo(selllabel.mas_left);
        make.height.mas_equalTo(ScaleHeight(35));
        make.width.equalTo(@1);
    }];
    
    UIView *bview = [UIView new];
    
    bview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bview];
    [bview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(aview.mas_bottom).offset(10);
        make.height.mas_equalTo(ScaleHeight(220));
    }];
    
    UILabel *mana = [UILabel new];
    
    mana.text = @"店铺管理";
    mana.font = kFont(15);
    mana.textColor = kColor333;
    
    [bview addSubview:mana];
    [mana mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bview).offset(15);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kDefaultBGColor;
    [bview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bview);
        make.top.equalTo(mana.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    UIButton *btn1 = [self buttonWithTitle:@"店铺信息"];
    
    [bview addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bview);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *btn2 = [self buttonWithTitle:@"发布商品"];
    
    [bview addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *btn3 = [self buttonWithTitle:@"店铺线上订单"];
    
    [bview addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn2.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *btn4 = [self buttonWithTitle:@"店铺线下订单"];
    
    [bview addSubview:btn4];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bview);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.top.equalTo(btn1.mas_bottom).offset(15);
        make.height.mas_equalTo(60);
    }];
    
    [btn1 addTarget:self action:@selector(storeInfo:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(onlineOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(offlineOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bottom1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [bottom1 setTitle:@"生成收款二维码" forState:UIControlStateNormal];
    [bottom1 setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"ff9914"]] forState:UIControlStateNormal];
    bottom1.titleLabel.font = kFont(15);
    [self.view addSubview:bottom1];
    [bottom1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(ScaleHeight(45)+BOTTOM_MARGIN);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    [bottom1 addTarget:self action:@selector(leftBot:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bottom2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [bottom2 setTitle:@"商家代付款" forState:UIControlStateNormal];
    [bottom2 setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    bottom2.titleLabel.font = kFont(15);
    [self.view addSubview:bottom2];
    [bottom2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(ScaleHeight(45)+BOTTOM_MARGIN);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    [bottom2 addTarget:self action:@selector(rightBot:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)click:(UIButton *)sender {
//    ShareApplicationViewController *vc = [[ShareApplicationViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    ComingViewController *vc = [ComingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 生成二维码
- (void)leftBot:(UIButton *)sender {
    UIView *cover = [UIView new];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removecover:)];
    [cover addGestureRecognizer:tap];
    
    [self.covers addObject:cover];
    
    UIImageView *red = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"红包"]];
    [window addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.size.mas_equalTo(CGSizeMake(200.5, 487/2.0));
    }];
    red.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [self.covers addObject:red];
    
    [UIView animateWithDuration:0.3 animations:^{
        cover.alpha = 0.3;
        red.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = [NSString stringWithFormat:@"%@,%@,%@,%ld,%ld",@"usercash", self.nameLabel.text, self.shop_id, (long)self.ratio, (long)self.mutiply];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    UIImage *newimage = [self createNonInterpolatedUIImageFormCIImage:image withSize:106];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:newimage];
    [red addSubview:imageview1];
    [imageview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(red);
        make.size.mas_equalTo(CGSizeMake(106, 106));
        make.bottom.equalTo(red).offset(-40);
    }];
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (void)removecover:(UITapGestureRecognizer *)tap {
    for (UIView *view in self.covers) {
        [UIView animateWithDuration:0.3 animations:^{
//            view.transform = CGAffineTransformMakeScale(0.1, 0.1);
            view.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [view removeFromSuperview];
                
            }
        }];
    }
    [self.covers removeAllObjects];
    
//    UserPayViewController *vc = [UserPayViewController new];
//    vc.user_name = @"18696135507";
//    vc.shop_name = self.nameLabel.text;
//    vc.ratio = self.ratio;
//    vc.mutiply = self.mutiply;
//    vc.business_id = self.shop_id;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBot:(UIButton *)sender {
    // 商家代付款
    ShopPayViewController *vc = [ShopPayViewController new];
    vc.shop_name = self.nameLabel.text;
    vc.ratio = self.ratio;
    vc.buisness_id = self.shop_id;
    vc.upperRatio = self.upperRatio;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)storeInfo:(UIButton *)sender {
    ShopInfoViewController *vc = [ShopInfoViewController new];
    vc.upperRatio = self.upperRatio;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)publish:(UIButton *)sender {
    PublishShopViewController *vc = [PublishShopViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)onlineOrder:(UIButton *)sender {
    OnlineOrderViewController *vc = [OnlineOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)offlineOrder:(UIButton *)sender {
    OfflineOrderViewController *vc = [OfflineOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor greenColor];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:title]];
    [btn addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(btn).offset(5);
        make.size.mas_equalTo(CGSizeMake(ScaleWidth(35), ScaleWidth(35)));
    }];
    
    UILabel *lable = [UILabel new];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor = kColor666;
    lable.text = title;
    [btn addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(imageview.mas_bottom).offset(10);
    }];
    
    return btn;
}

- (UIView *)vline {
    UIView *a = [UIView new];
    a.backgroundColor = kDefaultBGColor;
    return a;
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    label.textColor = kColor333;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - 进入店铺
- (void)enterStore:(UIButton *)sender {
    StoreDisplayViewController *vc = [StoreDisplayViewController new];
    vc.business_idstring = self.shop_id;
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
