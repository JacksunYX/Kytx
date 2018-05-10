//
//  NewAddressViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "NewAddressViewController.h"
#import "KYHeader.h"
#import "HXProvincialCitiesCountiesPickerview.h"

@interface NewAddressViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong) UITextField *locTF;
@property(nonatomic, strong) UITextField *nameTF;
@property(nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextView *addressTV;
@property (nonatomic, strong) NSString *type;    //1.新增 2.编辑

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *town;

@property (nonatomic, strong) UIView *cover;

@property (nonatomic, strong) NSMutableArray<AreaModel *> *temp2;
@property (nonatomic, strong) NSMutableArray<AreaModel *> *temp3;
@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSString *desc;


//@property (nonatomic, strong) HXProvincialCitiesCountiesPickerview *regionPickerView;
@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建收货地址";
    self.view.backgroundColor = kDefaultBGColor;
    if (self.model) {
        self.desc = @"";
        for (AreaModel *model in self.provinceArray) {
            if ([model.area_id isEqualToString:self.model.province]) {
                self.province = model.area_id;
                self.desc = [[self.desc stringByAppendingString:model.name] stringByAppendingString:@" "];
            }
        }
        
        for (AreaModel *model in self.cityArray) {
            if ([model.area_id isEqualToString:self.model.city]) {
                self.city = model.area_id;
               self.desc = [[self.desc stringByAppendingString:model.name] stringByAppendingString:@" "];
            }
        }
        
        for (AreaModel *model in self.districtArray) {
            if ([model.area_id isEqualToString:self.model.district]) {
                self.district = model.area_id;
                self.desc = [self.desc stringByAppendingString:model.name];
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
    }
    
    
    [self configNavi];
    [self configUI];
}

- (void)configNavi {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} forState:UIControlStateHighlighted];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)configUI {
    UITextField *tf1 = [[UITextField alloc] init];
    tf1.font = [UIFont systemFontOfSize:15];
    tf1.text = self.model.consignee ? self.model.consignee : @"";
    tf1.backgroundColor = kWhiteColor;
    self.nameTF = tf1;
    
    UILabel *albl = [self labelWithText:@"    收货人："];
    tf1.leftView = albl;
    tf1.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:tf1];
    [tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(54);
    }];
    
    UITextField *tf2 = [[UITextField alloc] init];
    tf2.backgroundColor = kWhiteColor;
    tf2.font = [UIFont systemFontOfSize:15];
    tf2.text = self.model.mobile ? self.model.mobile : @"";
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.delegate = self;
    self.phoneTF = tf2;
    
    UILabel *blbl = [self labelWithText:@"    手机号："];
    tf2.leftView = blbl;
    tf2.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:tf2];
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(tf1.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    
    UITextField *tf3 = [[UITextField alloc] init];
    
    tf3.backgroundColor = kWhiteColor;
    tf3.font = [UIFont systemFontOfSize:15];
    tf3.text = self.desc;
    self.locTF = tf3;
//    self.locTF.delegate =self;
    tf3.placeholder = @"请输入省市区";
    
    UILabel *clbl = [self labelWithText:@"    所在地区："];
    tf3.leftView = clbl;
    tf3.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[KYHeader imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 54);
//    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(loc) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *loc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"定位redicon"]];
    [btn addSubview:loc];
    [loc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn).offset(15);
        make.size.mas_equalTo(CGSizeMake(12.5, 15));
        make.top.equalTo(btn).offset(9);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"定位";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = kColor999;
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loc.mas_bottom).offset(5);
        make.centerX.equalTo(loc);
    }];
    
    //垂直分割线
    UIView *line = [UIView new];
    line.backgroundColor = kWhite(0.8);
    [btn addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.equalTo(btn).offset(10);
        make.bottom.equalTo(btn).offset(-10);;
        make.left.equalTo(btn);
    }];
    
    tf3.rightView = btn;
    tf3.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:tf3];
    [tf3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(tf2.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    
    
    
    UIView *bg = [UIView new];
    bg.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(tf3.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    UILabel *dlbl = [self labelWithText:@"    详细地址："];
    [bg addSubview:dlbl];
    [dlbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bg);
        make.top.equalTo(bg).offset(20);
    }];
    
    UITextView *tv = [[UITextView alloc] init];
//    tv.backgroundColor = [UIColor greenColor];
    self.addressTV = tv;
    tv.text = self.model.address ? self.model.address : @"";
    tv.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tv.font = [UIFont systemFontOfSize:15];
    [bg addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dlbl.mas_right);
        make.top.equalTo(dlbl);
        make.right.bottom.equalTo(bg);
    }];
    
    UIView *aview = [UIView new];
    aview.backgroundColor = kWhiteColor;
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(tv.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *defaultLabel = [self labelWithText:@"    设为默认收货地址"];
    [aview addSubview:defaultLabel];
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aview);
        make.top.bottom.equalTo(aview);
    }];
    
    UISwitch *swi = [[UISwitch alloc] init];
    [aview addSubview:swi];
    [swi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aview);
        make.right.equalTo(aview).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    swi.on = self.is_default ? YES : NO;
    [swi addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tf1.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UIView *line2 = [UIView new];
    line2.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tf2.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UIView *line3 = [UIView new];
    line3.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tf3.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [abtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    abtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:abtn];
    [abtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tf3);
        make.height.equalTo(tf3);
        make.width.mas_equalTo(220);
    }];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (![textField isEqual:self.locTF]) {
//
//        return YES;
//    }
//    [self show];
//    return NO;
//}


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

- (void)valueChange:(UISwitch *)sender {
    self.is_default = sender.isOn ? YES:NO;
}

- (void)editMode {
    self.title = @"编辑收货地址";
    self.type = @"2";
}

- (UILabel *)labelWithText:(NSString *)text{
    UILabel *label = [UILabel new];
    label.textColor = kColor666;
    label.font = [UIFont systemFontOfSize:15];
    label.text = text;
    label.frame = CGRectMake(0, 0, 100, 54);

    return label;
}

- (void)save {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if ([self.type isEqualToString:@"2"]) {
        dict[@"address_id"] = self.model.address_id;
        
    } else {
        self.type = @"1";
    }
    
    dict[@"consignee"] = self.nameTF.text;
    dict[@"mobile"] = self.phoneTF.text;
    dict[@"province"] = self.province;
    dict[@"city"] = self.city;
    dict[@"district"] = self.district;
    dict[@"address"] =self.addressTV.text;
    dict[@"is_default"] = self.is_default ? @"1":@"0";
    dict[@"type"] = self.type;

    
    [HttpRequest postWithTokenURLString:NetRequestUrl(addaddress) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
//        NSLog(@"%@", res);
        if ([res[@"code"] integerValue] == 1) {
            if (self.refreshHandler) {
                self.refreshHandler();
                GCDAfter1s(^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }
    } failure:^(NSError *error) {
        
    } RefreshAction:^{
        
    }];
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
    
    NSInteger p = 0;
    NSInteger c = 0;
    NSInteger d = 0;
    
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


- (void)tap:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
        self.picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        NSString *firstText = @"";
        NSString *secondText = @"";
        NSString *thirdText = @"";
        //省
        NSInteger row1 = [self.picker selectedRowInComponent:0];
        NSString *pro = self.provinceArray[row1].name;
        firstText = [pro stringByAppendingString:@" "];
        self.province = self.provinceArray[row1].area_id;
        
        //市
        NSInteger row2 = [self.picker selectedRowInComponent:1];
        if (!kArrayIsEmpty(self.temp2)) {
            NSString *city = self.temp2[row2].name;
            secondText = [city stringByAppendingString:@" "];
            self.city = self.temp2[row2].area_id;
        }else{
            self.city = @"";
        }

        //区
        NSInteger row3 = [self.picker selectedRowInComponent:2];
        if (!kArrayIsEmpty(self.temp3)) {
            thirdText = self.temp3[row3].name;
            self.district = self.temp3[row3].area_id;
        }else{
            self.district = @"";
        }
        
        self.locTF.text = [[firstText stringByAppendingString:secondText] stringByAppendingString:thirdText];
        
        [self.cover removeFromSuperview];
        [self.picker removeFromSuperview];
        self.cover = nil;
        self.picker = nil;
//        self.temp2 = nil;
//        self.temp3 = nil;
        
    }];
}

- (void)loc {
    GetLocation *loc = [GetLocation getLocationManager];
    [loc getMyLocation];
    __weak NewAddressViewController *weakself = self;
    loc.block = ^(NSDictionary *dict) {
        CLPlacemark *mark = dict[@"obj"];
        weakself.province = mark.administrativeArea;
        weakself.city = mark.locality;
        weakself.district = mark.subLocality;
        weakself.locTF.text = dict[@"text"];
        
        for (AreaModel *model in weakself.provinceArray) {
            if ([model.name isEqualToString:mark.administrativeArea]) {
                weakself.province = model.area_id;
            }
        }
        
        for (AreaModel *model in weakself.cityArray) {
            if ([model.name isEqualToString:mark.locality]) {
                weakself.city = model.area_id;
            }
        }
        
        for (AreaModel *model in weakself.districtArray) {
            if ([model.name isEqualToString:mark.subLocality]) {
                weakself.district = model.area_id;
            }
        }
        
        [self.temp2 removeAllObjects];
        for (AreaModel *model in self.cityArray) {
            if ([model.parent_id isEqualToString:weakself.province]) {
                [self.temp2 addObject:model];
            }
        }
        
        [self.temp3 removeAllObjects];
        for (AreaModel *model in self.districtArray) {
            if ([model.parent_id isEqualToString:weakself.city]) {
                [self.temp3 addObject:model];
            }
        }
    };
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.phoneTF]) {
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

- (NSMutableArray *)temp2 {
    if (!_temp2) {
        _temp2 = [NSMutableArray array];
        AreaModel *model = self.provinceArray.firstObject;
        for (AreaModel *temp in self.cityArray) {
            if ([model.area_id isEqualToString:temp.parent_id]) {
                
                [_temp2 addObject:temp];
            }
        }
        
    }
    return _temp2;
}

- (NSMutableArray *)temp3 {
    if (!_temp3) {
        _temp3 = [NSMutableArray array];
        AreaModel *model = self.cityArray.firstObject;

        for (AreaModel *temp in self.districtArray) {
            if ([model.area_id isEqualToString:temp.parent_id]) {
                
                [_temp3 addObject:temp];
            }
        }
    }
    return _temp3;
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
