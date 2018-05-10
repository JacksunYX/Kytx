//
//  ShopInfoViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/3/2.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "KYInfoTableViewCell.h"
#import "AreaModel.h"
#import "ShopIndustryModel.h"
#import "KYAddressModel.h"

@interface ShopInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITextField *tf0;
@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UITextField *tf3;
@property (nonatomic, strong) UITextField *tf4;
@property (nonatomic, strong) UITextField *tf5;
@property (nonatomic, strong) UITextField *tf6;
@property (nonatomic, strong) UITextField *tf7;
@property (nonatomic, strong) UITextField *tf8;
@property (nonatomic, strong) UITextField *tf9;
@property (nonatomic, strong) UITextField *tf10;
@property (nonatomic, strong) UITextField *tf11;

@property (nonatomic, strong) UITextField *ratioTf;

@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) ShopIndustryModel *pmodel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, strong) NSMutableArray<AreaModel *> *temp2;
@property (nonatomic, strong) NSMutableArray<AreaModel *> *temp3;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker1;
@property (nonatomic, strong) UIDatePicker *datePicker2;
@property (nonatomic, strong) UIView *cover;

@property (nonatomic, strong) NSArray<AreaModel *> *provinceArray;
@property (nonatomic, strong) NSArray<AreaModel *> *cityArray;
@property (nonatomic, strong) NSArray<AreaModel *> *districtArray;

@property (nonatomic, strong) NSArray<ShopIndustryModel *> *pArray;
@property (nonatomic, strong) NSMutableArray <ShopIndustryModel *>*sArray;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger cat_id;

@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;

@property (nonatomic, assign) NSInteger ratio;

//2.0新增
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *identifyTextField;

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    self.title = @"店铺信息";
    [self configUI];
    [self loadData];
}

- (void)loadData {
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"area.plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:docPath];
    if (!arr || arr.count == 0) {
        [HttpRequest postWithURLString:NetRequestUrl(arealist) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                NSArray *temp = res[@"result"];
                [temp writeToFile:docPath atomically:YES];
                [self loadData];
            }
        } failure:nil RefreshAction:nil];
    } else {
        self.areaArray = [AreaModel mj_objectArrayWithKeyValuesArray:arr];
        
        NSMutableArray *province = [NSMutableArray array];
        NSMutableArray *city = [NSMutableArray array];
        NSMutableArray *district = [NSMutableArray array];
        NSMutableArray *town = [NSMutableArray array];
        
        for (AreaModel *temp in self.areaArray) {
            switch (temp.level.integerValue) {
                case 1:
                    [province addObject:temp];
                    break;
                case 2:
                    [city addObject:temp];
                    break;
                case 3:
                    [district addObject:temp];
                    break;
                case 4:
                    [town addObject:temp];
                    break;
                default:
                    break;
            }
        }
        
        self.provinceArray = province;
        self.cityArray = city;
        self.districtArray = district;
        
        _temp2 = [NSMutableArray array];
        AreaModel *model = province.firstObject;
        for (AreaModel *temp in city) {
            if ([model.area_id isEqualToString:temp.parent_id]) {
                
                [_temp2 addObject:temp];
            }
        }
        
        _temp3 = [NSMutableArray array];
        AreaModel *model2 = city.firstObject;
        
        for (AreaModel *temp in district) {
            if ([model2.area_id isEqualToString:temp.parent_id]) {
                
                [_temp3 addObject:temp];
            }
        }
    }
    
    if (!self.dataArray) {
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [HttpRequest postWithTokenURLString:NetRequestUrl(shopIndustry) parameters:dict1 isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                NSArray *temp = res[@"result"];
                self.dataArray = [ShopIndustryModel mj_objectArrayWithKeyValuesArray:temp];
                [self fillTF];
                NSMutableArray *array = [NSMutableArray array];
                for (ShopIndustryModel *model in self.dataArray) {
                    if (model.pid == 0) {
                        [array addObject:model];
                    }
                }
                self.pArray = [array copy];
            }
        } failure:nil RefreshAction:nil];
    }
    
    
}

- (void)fillTF {
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [HttpRequest postWithTokenURLString:NetRequestUrl(shopInfo) parameters:dict2 isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            NSDictionary *result = res[@"result"];
            result = [self validDict:result];
            
            self.tf0.text = [result[@"type"] isEqualToString:@"offline"] ? @"个人店" : @"企业店";
            
            self.tf1.text = result[@"username"];
            self.tf2.text = result[@"mobile"];

//            self.identify = result[@"card_num"];
//            //从前4位到后4位加*
//            NSMutableString *identify = [result[@"card_num"] mutableCopy];
//            if (identify.length == 18) {
//                [identify replaceCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
//            }
//
//            self.tf3.text = identify;
            
            self.tf4.text = @"已上传";
            NSString *str;
            for (ShopIndustryModel *model in self.dataArray) {
                if (model.shop_id == [result[@"cat_id"] integerValue]) {
                    str = [model.title stringByAppendingString:@"   "];
                    break;
                }
            }
            
            for (ShopIndustryModel *model in self.dataArray) {
                if (model.shop_id == [result[@"category"] integerValue]) {
                    self.tf5.text = [str stringByAppendingString:model.title];
                    break;
                }
            }
            self.tf6.text = result[@"name"];
            self.tf7.text = result[@"mobile_phone"];
            // 地址
            NSString *pro;
            NSString *city;
            NSString *dis;
            
            for (AreaModel *model in self.areaArray) {
                if ([model.area_id isEqualToString:result[@"province"]]) {
                    pro = model.name;
                    self.province = model.area_id;
                }
                
                if ([model.area_id isEqualToString:result[@"city"]]) {
                    city = model.name;
                    self.city = model.area_id;
                }
                
                if ([model.area_id isEqualToString:result[@"district"]]) {
                    dis = model.name;
                    self.district = model.area_id;
                }
            }
            
            AreaModel *model;
            _temp2 = [NSMutableArray array];
            for (AreaModel *temp in self.provinceArray) {
                if (temp.area_id.integerValue == self.province.integerValue) {
                    model = temp;
                }
            }
            for (AreaModel *temp in self.cityArray) {
                if ([model.area_id isEqualToString:temp.parent_id]) {
                    
                    [_temp2 addObject:temp];
                }
            }
            
            _temp3 = [NSMutableArray array];
            AreaModel *model2;
            
            for (AreaModel *tmodel in self.cityArray) {
                if (tmodel.area_id.integerValue == self.city.integerValue) {
                    model2 = tmodel;
                }
            }
            
            for (AreaModel *temp in self.districtArray) {
                if ([model2.area_id isEqualToString:temp.parent_id]) {
                    
                    [_temp3 addObject:temp];
                }
            }
            self.tf8.text = [NSString stringWithFormat:@"%@ %@ %@", pro, city, dis];
            self.tf9.text = result[@"address"];
            // 时间
            NSInteger hour = [result[@"starttime"] integerValue] / 3600;
            NSInteger min = ([result[@"starttime"] integerValue] / 60 - 60 * hour);
            self.start_time = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)min];
            
            hour = [result[@"endtime"] integerValue] / 3600;
            min = ([result[@"endtime"] integerValue] / 60 - 60 * hour);
            self.end_time = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)min];
            self.tf10.text = [[self.start_time stringByAppendingString:@" - "] stringByAppendingString:self.end_time];
            self.ratio = [result[@"ratio"] integerValue];
            self.tf11.text = [@(self.ratio).description stringByAppendingString:@"%"];
        }
    } failure:nil RefreshAction:nil];
}

- (void)configUI {
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT-55)];
    
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, 55 * 13);
    scroll.backgroundColor = kDefaultBGColor;
    [self.view addSubview:scroll];
    
    for (int i = 0; i < 12; i++) {
        UIView *aview = [self viewWithTitle:self.titleArray[i] index:i];
        [scroll addSubview:aview];
        
        if (i == 3) {
            aview.frame = CGRectMake(0, 55*i, SCREEN_WIDTH, 0);
        }else{
            if (i>3) {
                aview.frame = CGRectMake(0, 55*(i-1), SCREEN_WIDTH, 55);
            }else{
                aview.frame = CGRectMake(0, 55*i, SCREEN_WIDTH, 55);
            }
            
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_offset(55);
    }];
    
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)save:(UIButton *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"starttime"] = self.start_time;
    dict[@"endtime"] = self.end_time;
    dict[@"ratio"] = @(self.ratio).description;
    dict[@"province"] = self.province;
    dict[@"city"] = self.city;
    dict[@"district"] = self.district;
    dict[@"address"] = self.tf9.text;
    //2.0新增
    dict[@"username"] = self.tf1.text;
    dict[@"mobile"] = self.tf2.text;
//    if ([self.tf3.text containsString:@"*"]) {
//        dict[@"card_num"] = self.identify;
//    }else{
//        dict[@"card_num"] = self.tf3.text;
//    }
    
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(editshopinfo) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:nil RefreshAction:nil];
    
}

#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.sArray.count) {
        return self.sArray.count;
    }
    return self.pArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (self.sArray.count) {
            cell.textLabel.text = self.sArray[indexPath.row].title;
        } else {
            cell.textLabel.text = self.pArray[indexPath.row].title;
        }
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        if (!self.sArray.count) {
            
            ShopIndustryModel *smodel = self.pArray[indexPath.row];
            self.pmodel = smodel;
            NSMutableArray *temp = [NSMutableArray array];
            self.cat_id = smodel.shop_id;
            for (ShopIndustryModel *model in self.dataArray) {
                if (model.pid == smodel.shop_id) {
                    [temp addObject:model];
                }
            }
            ShopIndustryModel *tempmodel = [ShopIndustryModel new];
            tempmodel.title = @"向上一级";
            [temp insertObject:tempmodel atIndex:0];
            self.sArray = temp;
            UILabel *aview = tableView.tableHeaderView;
            aview.text = @"选择分类";
            
            self.table1.tableHeaderView = aview;
        } else {
            UILabel *aview = tableView.tableHeaderView;
            aview.text = @"选择行业";
            if (indexPath.row == 0) {
            } else {
               self.tf4.text = [[self.pmodel.title stringByAppendingString:@"   "] stringByAppendingString: self.sArray[indexPath.row].title];
                [self tap3:nil];
            }
            [self.sArray removeAllObjects];
        }
        [self.table1 reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)tap3:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.table1.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        
        [self.cover removeFromSuperview];
        [self.table1 removeFromSuperview];
        self.cover = nil;
        self.table1 = nil;
    }];
    [self.view endEditing:YES];
}

- (UIView *)viewWithTitle:(NSString *)title index:(int)index {
    UIView *view = [UIView new];
    
    view.backgroundColor = kWhiteColor;
    
    if (index == 3) {
        return view;
    }
    UILabel *label = [UILabel new];
    
    label.text = title;
    label.textColor = kColor666;
    label.font = kFont(15);
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(120);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    
    tf.textColor = kColor333;
    tf.font = kFont(15);
    tf.backgroundColor = kWhiteColor;
    if (index == 1 || index == 2|| index == 11 || index == 8 || index == 9 || index == 10) {
        if (index == 11) {
            tf.textColor = kColord40;
        }
        tf.delegate = self;
        tf.userInteractionEnabled = YES;
    } else {
        tf.userInteractionEnabled = NO;
    }
    [view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.centerY.equalTo(label);
        make.right.equalTo(view).offset(-15);
    }];
    
    if (index != 11) {
        UIView *line = [UIView new];
        line.backgroundColor = kDefaultBGColor;
        
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view);
            make.left.equalTo(view).offset(15);
            make.right.equalTo(view).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    
    if (index == 1 ||index == 2 ||index == 10 || index == 11) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+index;
        [btn setBackgroundImage:[UIImage imageNamed:@"修改信息icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-15);
        }];
    }
    
    switch (index) {
        case 0:
            self.tf0 = tf;
            break;
        case 1:
            self.tf1 = tf;
            break;
        case 2:
            self.tf2 = tf;
            break;
        case 3:
            self.tf3 = tf;
            break;
        case 4:
            self.tf4 = tf;
            break;
        case 5:
            self.tf5 = tf;
            break;
        case 6:
            self.tf6 = tf;
            break;
        case 7:
            self.tf7 = tf;
            break;
        case 8:
            self.tf8 = tf;
            break;
        case 9:
            self.tf9 = tf;
            break;
        case 10:
            self.tf10 = tf;
            break;
        case 11:
            self.tf11 = tf;
            break;
        default:
            break;
    }
    
    return view;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.tf9] || [textField isEqual:self.ratioTf]||textField == self.tf1||textField == self.tf2) {
        
//        if (textField == self.tf1) {
//            [self changeNickname];
//        }
//
//        if (textField == self.tf2) {
//            [self changePhonenumber];
//        }
//
//        if (textField == self.tf3) {
//            [self changeIdentify];
//        }
        
//        if (textField == self.tf3) {
//
//            kStringIsEmpty(self.identify)?:[self.tf3 setText:self.identify];
//            self.identify = @"";
//        }
        
        return YES;
    } else {
        
        if ([textField isEqual:self.tf8]) {
            [self show];
        }
        
        if ([textField isEqual:self.tf10]) {
            [self showDatePicker];
        }
        
        if ([textField isEqual:self.tf11]) {
            [self showRatio:nil];
        }
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.ratioTf]) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
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

//修改入驻人姓名
-(void)changeNickname
{
    MCWeakSelf;
    UIAlertView *alertview = [[UIAlertView alloc]initWithMessage:@"请输入新的入驻人姓名" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) { //确定
            weakSelf.tf1.text = weakSelf.nicknameTextField.text;
        }
    }];
    self.nicknameTextField = [alertview textFieldAtIndex:0];
    [_nicknameTextField becomeFirstResponder];
    _nicknameTextField.delegate = self;
}

//修改入驻人手机号
-(void)changePhonenumber
{
    MCWeakSelf;
    UIAlertView *alertview = [[UIAlertView alloc]initWithMessage:@"请输入新的入驻人手机号" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) { //确定
            weakSelf.tf2.text = weakSelf.phoneNumTextField.text;
        }
    }];
    self.phoneNumTextField = [alertview textFieldAtIndex:0];
    _phoneNumTextField.delegate = self;
}

//修改入驻人身份证
-(void)changeIdentify
{
    MCWeakSelf;
    UIAlertView *alertview = [[UIAlertView alloc]initWithMessage:@"请输入新的入驻人身份证" cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertview showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) { //确定
            weakSelf.tf3.text = weakSelf.identifyTextField.text;
        }
    }];
    self.identifyTextField = [alertview textFieldAtIndex:0];
    _identifyTextField.delegate = self;
}

- (void)showRatio:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入新的让利比" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    MCWeakSelf
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        weakSelf.ratioTf = textField;
        textField.textColor = kColord40;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = @(self.ratio).description;
        textField.delegate = self;
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
            self.tf11.text = str;
        } else {
            self.ratio = [str integerValue];
//            self.tf6.text = [NSString stringWithFormat:@"%.2f", self.tf5.text.floatValue * self.ratio/100];
            self.tf11.text = [str stringByAppendingString:@"%"];
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDatePicker {
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [self.cover addGestureRecognizer:tap1];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    _datePicker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH/2, 250)];
    _datePicker1.datePickerMode = UIDatePickerModeTime;
    _datePicker1.backgroundColor = kWhiteColor;
//    _datePicker1.minuteInterval = 5;
    
    _datePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT, SCREEN_WIDTH/2, 250)];
    _datePicker2.datePickerMode = UIDatePickerModeTime;
    _datePicker2.backgroundColor = kWhiteColor;
//    _datePicker2.minuteInterval = 5;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker1];
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker2];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cover.alpha = 0.4;
        self.datePicker1.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH/2, 250);
        self.datePicker2.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-250, SCREEN_WIDTH/2, 250);
    } completion:nil];
}

- (void)tap1:(UITapGestureRecognizer *)tap {
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"HH:mm";
    NSString *time1 = [matter stringFromDate:self.datePicker1.date];
    NSString *time2 = [matter stringFromDate:self.datePicker2.date];
    
    self.tf10.text = [NSString stringWithFormat:@"%@ - %@", time1, time2];
    
    NSInteger hour = [time1 componentsSeparatedByString:@":"].firstObject.integerValue;
    NSInteger min = [time1 componentsSeparatedByString:@":"].lastObject.integerValue;
    
    self.start_time = @(hour * 3600 + min * 60).description;
    
    hour = [time2 componentsSeparatedByString:@":"].firstObject.integerValue;
    min = [time2 componentsSeparatedByString:@":"].lastObject.integerValue;
    
    self.end_time = @(hour * 3600 + min * 60).description;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.datePicker1.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH/2, 250);
        self.datePicker2.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT, SCREEN_WIDTH/2, 250);
    } completion:^(BOOL finished) {
        
        [self.cover removeFromSuperview];
        [self.datePicker1 removeFromSuperview];
        [self.datePicker2 removeFromSuperview];
        self.cover = nil;
        self.datePicker1 = nil;
        self.datePicker2 = nil;
    }];
    [self.view endEditing:YES];
}

//在当前页面上显示省市区选择页
- (void)show {
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cover addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
    _picker.backgroundColor = kWhiteColor;
    _picker.delegate = self;
    _picker.dataSource = self;
    
    NSInteger p =0 ;
    NSInteger c=0;
    NSInteger d=0;
    
    for (AreaModel *model in self.provinceArray) {
        if ([model.area_id isEqualToString:self.province]) {
            p = [self.provinceArray indexOfObject:model];
        }
    }
    
    for (AreaModel *model in self.temp2) {
        if ([model.area_id isEqualToString:self.city]) {
            c = [self.temp2 indexOfObject:model];
        }
    }
    
    for (AreaModel *model in self.temp3) {
        if ([model.area_id isEqualToString:self.district]) {
            d = [self.temp3 indexOfObject:model];
        }
    }
    
    [_picker selectRow:p inComponent:0 animated:YES];
    [_picker selectRow:c inComponent:1 animated:YES];
    [_picker selectRow:d inComponent:2 animated:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_picker];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cover.alpha = 0.4;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
    } completion:nil];
}

#pragma mark - pickerview代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.temp2.count;
    } else if (component == 2) {
        return self.temp3.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray[row].name;
    } else if (component == 1) {
        return self.temp2[row].name;
    } else if (component == 2) {
        return self.temp3[row].name;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    AreaModel *parentModel;
    if (component == 0) {
        parentModel = self.provinceArray[row];
        [self.temp2 removeAllObjects];
        for (AreaModel *model in self.cityArray) {
            if ([model.parent_id isEqualToString:parentModel.area_id]) {
                [self.temp2 addObject:model];
            }
        }
        
        [self.temp3 removeAllObjects];
        for (AreaModel *model in self.districtArray) {
            if ([model.parent_id isEqualToString:self.temp2.firstObject.area_id]) {
                [self.temp3 addObject:model];
            }
        }
    }
    
    if (component == 1) {
        parentModel = self.temp2[row];
        [self.temp3 removeAllObjects];
        for (AreaModel *model in self.districtArray) {
            if ([model.parent_id isEqualToString:parentModel.area_id]) {
                [self.temp3 addObject:model];
            }
        }
    }
    [pickerView reloadAllComponents];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        NSInteger row1 = [self.picker selectedRowInComponent:0];
        NSString *pro = self.provinceArray[row1].name;
        
        NSInteger row2 = [self.picker selectedRowInComponent:1];
        NSString *city = self.temp2[row2].name;
        
        NSInteger row3 = [self.picker selectedRowInComponent:2];
        NSString *dis = self.temp3[row3].name;
        
        self.province = self.provinceArray[row1].area_id;
        self.city = self.temp2[row2].area_id;
        self.district = self.temp3[row3].area_id;
        
        self.tf8.text = [[pro stringByAppendingString:city] stringByAppendingString:dis];
        
        [self.cover removeFromSuperview];
        [self.picker removeFromSuperview];
        self.cover = nil;
        self.picker = nil;
//        self.temp2 = nil;
//        self.temp3 = nil;
    }];
    [self.view endEditing:YES];
}

- (void)click:(UIButton *)sender {

    switch (sender.tag) {
//        case 1001:
//        {
//            [self changeNickname];
//        }
//            break;
//
//        case 1002:
//        {
//            [self changePhonenumber];
//        }
//            break;
//
//        case 1003:
//        {
//            [self changeIdentify];
//        }
//            break;
            
        case 1010:
        {
            [self showDatePicker];
        }
            break;
            
        case 1011:
        {
            [self showRatio:sender];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"店铺类型", @"入驻人姓名：", @"入驻人手机号：", @"入驻人身份证：", @"身份证件照：", @"行业类型：", @"店铺名称：", @"店铺电话：", @"店铺区域：", @"详细地址：", @"营业时间：", @"店铺让利比："];
    }
    return _titleArray;
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
