//
//  RecordDetailViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/6.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "KYHeader.h"

@interface RecordDetailViewController ()

@property (nonatomic, strong) NSString *atext;
@property (nonatomic, strong) NSString *btext;
@property (nonatomic, strong) NSString *ctext;
@property (nonatomic, strong) NSString *dtext;
@property (nonatomic, strong) NSString *etext;
@property (nonatomic, strong) NSString *ftext;
@property (nonatomic, strong) NSString *gtext;
@property (nonatomic, strong) NSString *imageurl;


@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"充值详情";
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = self.record_id;
    [HttpRequest postWithTokenURLString:NetRequestUrl(recorddetail) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            NSDictionary *dict = res[@"result"];
            NSDateFormatter *matter = [[NSDateFormatter alloc] init];
            matter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            
            self.atext = [matter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dict[@"add_time"] floatValue]]];
            self.btext = dict[@"mobile"];
            self.ctext = dict[@"name"];
            self.dtext = dict[@"money"];
            self.etext = dict[@"bank_name"];
            self.ftext = dict[@"bank_number"];
            self.imageurl = [defaultUrl stringByAppendingString:dict[@"proof"]];
            self.gtext = dict[@"comment"];
            [self configUI];
        }
    } failure:nil RefreshAction:nil];
}

- (void)configUI {
    UIView *aview = [UIView new];
    
    aview.layer.cornerRadius = 5;
    aview.layer.masksToBounds = YES;
    
    aview.backgroundColor = kWhiteColor;
    
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(10);
        if (self.type == 2) {
            make.height.mas_equalTo(500);
        } else {
            make.height.mas_equalTo(455);
        }
    }];
    
    
    NSString *str;
    if (self.type == 0) {
        str = @"正在审核";
    } else if (self.type == 1) {
        str = @"审核通过";
    } else {
        str = @"审核不通过";
    }
    UILabel *alabel = [self labelWithText333:str];
    
    [aview addSubview:alabel];
    [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(aview).offset(25);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = kColor999;
    [aview addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alabel.mas_bottom).offset(25);
        make.height.mas_equalTo(1);
        make.left.equalTo(aview).offset(15);
        make.right.equalTo(aview).offset(-15);
    }];
    
    UILabel *bllabel = [self labelWithText666:@"充值时间："];
    
    [aview addSubview:bllabel];
    [bllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(35);
        make.top.equalTo(line.mas_bottom).offset(25);
    }];
    
    UILabel *brlabel = [self labelWithText333:self.atext];
    
    [aview addSubview:brlabel];
    [brlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bllabel.mas_right).offset(25);
        make.top.equalTo(bllabel);
    }];
    
    UILabel *cllabel = [self labelWithText666:@"充值账户："];
    
    [aview addSubview:cllabel];
    [cllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bllabel);
        make.top.equalTo(bllabel.mas_bottom).offset(25);
    }];
    
    UILabel *crlabel = [self labelWithText333:self.btext];
    
    [aview addSubview:crlabel];
    [crlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(brlabel);
        make.top.equalTo(cllabel);
    }];
    
    UILabel *dllabel = [self labelWithText666:@"转账卡主："];
    
    [aview addSubview:dllabel];
    [dllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bllabel);
        make.top.equalTo(cllabel.mas_bottom).offset(25);
    }];
    
    UILabel *drlabel = [self labelWithText333:self.ctext];
    
    [aview addSubview:drlabel];
    [drlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(brlabel);
        make.top.equalTo(dllabel);
    }];
    
    UILabel *ellabel = [self labelWithText666:@"转账金额："];
    
    [aview addSubview:ellabel];
    [ellabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(35);
        make.top.equalTo(dllabel.mas_bottom).offset(25);
    }];
    
    UILabel *erlabel = [self labelWithText333:self.dtext];
    
    [aview addSubview:erlabel];
    [erlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ellabel.mas_right).offset(25);
        make.top.equalTo(ellabel);
    }];
    
    UILabel *fllabel = [self labelWithText666:@"转账银行："];
    
    [aview addSubview:fllabel];
    [fllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(35);
        make.top.equalTo(ellabel.mas_bottom).offset(25);
    }];
    
    UILabel *frlabel = [self labelWithText333:self.etext];
    
    [aview addSubview:frlabel];
    [frlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fllabel.mas_right).offset(25);
        make.top.equalTo(fllabel);
    }];
    
    UILabel *gllabel = [self labelWithText666:@"银行卡号："];
    
    [aview addSubview:gllabel];
    [gllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(35);
        make.top.equalTo(fllabel.mas_bottom).offset(25);
    }];
    
    UILabel *grlabel = [self labelWithText333:self.ftext];
    
    [aview addSubview:grlabel];
    [grlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gllabel.mas_right).offset(25);
        make.top.equalTo(gllabel);
    }];
    
    UILabel *hllabel = [self labelWithText666:@"转账凭证："];
    
    [aview addSubview:hllabel];
    [hllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview).offset(35);
        make.top.equalTo(gllabel.mas_bottom).offset(25);
    }];
    
    UIImageView *hrlabel = [[UIImageView alloc] init];
    [hrlabel sd_setImageWithURL:[NSURL URLWithString:self.imageurl]];
    
    [aview addSubview:hrlabel];
    [hrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hllabel.mas_right).offset(25);
        make.top.equalTo(hllabel);
        make.size.mas_equalTo(CGSizeMake(130, 80));
    }];

    if (self.type == 2) {
        
        UILabel *illabel = [self labelWithText666:@"退款理由："];
        
        [aview addSubview:illabel];
        [illabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(aview).offset(35);
            make.top.equalTo(hrlabel.mas_bottom).offset(25);
        }];
        
        UILabel *irlabel = [self labelWithText333:self.gtext];
        irlabel.numberOfLines = 0;
        [aview addSubview:irlabel];
        [irlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(illabel.mas_right).offset(25);
            make.top.equalTo(illabel);
        }];
    }
    
}

- (UILabel *)labelWithText333:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = kFont(15);
    label.textColor = kColor333;
    return label;
}

- (UILabel *)labelWithText666:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = kFont(15);
    label.textColor = kColor666;
    return label;
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
