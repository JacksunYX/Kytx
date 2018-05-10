//
//  UserRegisterViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "KYInfoTableViewCell.h"
#import "AreaModel.h"
#import "ShopIndustryModel.h"
#import "KYAddressModel.h"
#import "UploadTableViewCell.h"
#import "GoPayViewController.h"
#import "ExampleViewController.h"
#import "StoreManagementViewController.h"

@interface UserRegisterViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSString *_name;
    NSString *_phone;
    NSString *_idcard;
    NSString *_shopname;
    NSString *_shopPhone;
    NSString *_address;
    
    UIButton *leftBtn;  //返回键
}
@property(strong, nonatomic) UITableView *table;
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) ShopIndustryModel *pmodel;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeHolderArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, strong) NSMutableArray<AreaModel *> *temp2;
@property (nonatomic, strong) NSMutableArray<AreaModel *> *temp3;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker1;
@property (nonatomic, strong) UIDatePicker *datePicker2;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, assign) BOOL isChoosed;
@property (nonatomic, assign) NSInteger shop_id;

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

@property (nonatomic, strong)UITextField *nameF;
@property (nonatomic, strong)UITextField *phoneF;
@property (nonatomic, strong)UITextField *idcardF;
@property (nonatomic, strong)UITextField *shopnameF;
@property (nonatomic, strong)UITextField *shopPhoneF;
@property (nonatomic, strong)UITextField *addressF;

@property (nonatomic, assign) BOOL hasPhoto1;
@property (nonatomic, assign) BOOL hasPhoto2;
@property (nonatomic, assign) BOOL hasPhoto3;

@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.title = @"填写基本信息";
    [self configUI];
    [self loadData];
}

- (void)configUI {
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.backgroundColor = kWhiteColor;
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [UIView new];
    _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _table.separatorColor = [UIColor colorWithHexString:@"cccccc"];
    _table.showsVerticalScrollIndicator = NO;
    [_table registerClass:[KYInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_table registerClass:[UploadTableViewCell class] forCellReuseIdentifier:@"cell3"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(17);
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:UIImageNamed(@"BACK") forState:UIControlStateNormal];
    [leftBtn setImage:UIImageNamed(@"BACK") forState:UIControlStateDisabled];
    [leftBtn sizeToFit];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //关闭全屏滑动
    self.fd_interactivePopDisabled = YES;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkDict {
    if (!self.dict) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dict = [self validDict:self.dict];
        _name = self.dict[@"username"];
        _phone = self.dict[@"mobile"];
        _idcard = self.dict[@"card_num"];
        self.cat_id = [self.dict[@"cat_id"] integerValue];
        self.shop_id = [self.dict[@"category"] integerValue];
        _shopname = self.dict[@"name"];
        _shopPhone = self.dict[@"mobile_phone"];
        _address = self.dict[@"address"];
        _province = self.dict[@"province"];
        _city = self.dict[@"city"];
        _district = self.dict[@"district"];
        
        self.start_time = self.dict[@"starttime"];
        self.end_time = self.dict[@"endtime"];
        
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
        
//        kShowHUDAndActivity;
        __block NSInteger i= 0;
        
        MCWeakSelf
        UploadTableViewCell *cell7 = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
        UIButton *btn1 = [cell7 btn1];
        if (!kStringIsEmpty(self.dict[@"idcardz"])) {
            [btn1 sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:self.dict[@"idcardz"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                i++;
                weakSelf.hasPhoto1 = YES;
                if (i == 3) {
                    kHiddenHUD;
                }
            }];
        }
        
        for (UIView *sub in btn1.subviews) {
            if ([sub isKindOfClass:[UILabel class]]) {
                [sub removeFromSuperview];
            }
        }
        UIButton *btn2 = [cell7 btn2];
        if (!kStringIsEmpty(self.dict[@"idcardb"])) {
            [btn2 sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:self.dict[@"idcardb"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                i++;
                weakSelf.hasPhoto2 = YES;
                if (i == 3) {
                    kHiddenHUD;
                }
            }];
        }
        
        for (UIView *sub in btn2.subviews) {
            if ([sub isKindOfClass:[UILabel class]]) {
                [sub removeFromSuperview];
            }
        }
        UIButton *btn3 = [cell7 btn3];
        if (!kStringIsEmpty(self.dict[@"logo"])) {
            [btn3 sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:self.dict[@"logo"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                i++;
                weakSelf.hasPhoto3 = YES;
                if (i == 3) {
                    kHiddenHUD;
                }
            }];
        }
        
        for (UIView *sub in btn3.subviews) {
            if ([sub isKindOfClass:[UILabel class]]) {
                [sub removeFromSuperview];
            }
        }
        [self.table reloadData];
    });
}

- (void)submit {
    
    NSString *name;
    NSString *phone;
    NSString *idcard;
    NSString *shopname;
    NSString *shopPhone;
    NSString *address;
    NSString *cat_id;
    NSString *new_id;
    NSString *province;
    NSString *city;
    NSString *district;
    NSString *starttime;
    NSString *endtime;
    UIImage *fimage;
    UIImage *bimage;
    UIImage *logoimage;
    
    name = _name;
    
    phone = _phone;
    
    idcard = _idcard;
    
    cat_id = @(self.cat_id).description;
    new_id = @(self.shop_id).description;
    
    shopname = _shopname;
    
    shopPhone = _shopPhone;
    
    province = self.province;
    city = self.city;
    district = self.district;
    
    address = _address;
    
    starttime = self.start_time;
    endtime = self.end_time;
    
    if (kStringIsEmpty(name)) {
        LRToast(@"请输入入驻人姓名");
        return;
    }
    
    if (kStringIsEmpty(phone)) {
        LRToast(@"请输入入驻人手机号");
        return;
    }
    
    if (kStringIsEmpty(idcard)) {
        LRToast(@"请输入身份证");
        return;
    }
    
    if (kStringIsEmpty(cat_id)) {
        LRToast(@"请输入行业类型");
        return;
    }
    
    if (kStringIsEmpty(shopname)) {
        LRToast(@"请输入店铺名称");
        return;
    }
    
    if (kStringIsEmpty(shopPhone)) {
        LRToast(@"请输入店铺电话");
        return;
    }
    
    if (kStringIsEmpty(province)) {
        LRToast(@"请选择店铺区域");
        return;
    }
    
    if (kStringIsEmpty(address)) {
        LRToast(@"请输入详细地址");
        return;
    }
    
    if (kStringIsEmpty(starttime)) {
        LRToast(@"请选择营业时间");
        return;
    }
    
    UploadTableViewCell *cell7 = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    UIButton *btn1 = [cell7 btn1];
    fimage = [btn1 imageForState:UIControlStateNormal];
    
    UIButton *btn2 = [cell7 btn2];
    bimage = [btn2 imageForState:UIControlStateNormal];
    
    UIButton *btn3 = [cell7 btn3];
    logoimage = [btn3 imageForState:UIControlStateNormal];
    
    if (self.hasPhoto1 && self.hasPhoto2 && self.hasPhoto3) {
        
    } else {
        LRToast(@"请将信息填写完整后再提交！");
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"资料填写是否正确，确认信息将保存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[@"type"] = @"2";
        dict[@"username"] = name;
        dict[@"name"] = shopname;
        dict[@"address"] = address;
        dict[@"mobile"] = phone;
        dict[@"starttime"] = starttime;
        dict[@"endtime"] = endtime;
        dict[@"cat_id"] = cat_id;
        dict[@"category"] = new_id;
        dict[@"mobile_phone"] = shopPhone;
        dict[@"province"] = province;
        dict[@"city"] = city;
        dict[@"district"] = district;
        dict[@"card_num"] = idcard;
        dict[@"type1"] = self.type1;
        
        
        NSData *data1 = UIImageJPEGRepresentation(fimage, 1.0f);
        NSString *encodedImageStr1 = [data1 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        dict[@"idcardz"] = [@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr1];
        NSData *data2 = UIImageJPEGRepresentation(bimage, 1.0f);
        NSString *encodedImageStr2 = [data2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        dict[@"idcardb"] = [@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr2];
        
        NSData *data3 = UIImageJPEGRepresentation(logoimage, 1.0f);
        NSString *encodedImageStr3 = [data3 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        dict[@"logo"] = [@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr3];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.userInteractionEnabled = YES;
        hud.label.text = @"提交中...";
        hud.removeFromSuperViewOnHide = YES;
        leftBtn.enabled = NO;
        
        [HttpRequest postWithTokenURLString:NetRequestUrl(openshop) parameters:dict isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                
                GCDAfter1s(^{
                    
                    [hud hideAnimated:YES];
                    leftBtn.enabled = YES;
                    
                    for (UIViewController *vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[StoreManagementViewController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                    
                });
                
            }
        } failure:nil RefreshAction:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.table]) {
        
        return self.titleArray.count;
    }
    
    if (self.sArray.count) {
        return self.sArray.count;
    }
    return self.pArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.table]) {
        if (indexPath.row != 9) {
            KYInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.name = self.titleArray[indexPath.row];
            cell.placeholder = self.placeHolderArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.holder.delegate = self;
            if (indexPath.row == 6) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            if (indexPath.row == 0) {
                self.nameF = cell.holder;
                cell.holder.text = _name ? _name : nil;
            }else if (indexPath.row == 1) {
                self.phoneF = cell.holder;
                cell.holder.text = _phone ? _phone : nil;
            }else if (indexPath.row == 2) {
                self.idcardF = cell.holder;
                cell.holder.text = _idcard ? _idcard : nil;
            }else if (indexPath.row == 3) {
                if (self.shop_id) {
                    for (ShopIndustryModel *tempm in self.dataArray) {
                        if (tempm.shop_id == self.shop_id) {
                            cell.holder.text = tempm.title;
                            break;
                        }
                    }
                }
            } else if (indexPath.row == 4) {
                self.shopnameF = cell.holder;
                cell.holder.text = _shopname ? _shopname : nil;
            }else if (indexPath.row == 5) {
                self.shopPhoneF = cell.holder;
                cell.holder.text = _shopPhone ? _shopPhone : nil;
            }else if (indexPath.row == 6) {
                self.addressF = cell.holder;
                if (self.dict) {
                    NSString *province;
                    NSString *city;
                    NSString *dis;
                    
                    for (AreaModel *amodel in self.areaArray) {
                        if ([amodel.area_id isEqualToString:self.province]) {
                            province = amodel.name;
                        }
                        if ([amodel.area_id isEqualToString:self.city]) {
                            city = amodel.name;
                        }
                        if ([amodel.area_id isEqualToString:self.district]) {
                            dis = amodel.name;
                        }
                    }
                    
                    cell.holder.text = [NSString stringWithFormat:@"%@ %@ %@", province, city, dis];
                }
            }else if (indexPath.row == 7) {
                self.addressF = cell.holder;
                cell.holder.text = _address;
            }else if (indexPath.row == 8) {
                if (self.dict) {
                    NSInteger hour = [self.dict[@"starttime"] integerValue] / 3600;
                    NSInteger min = ([self.dict[@"starttime"] integerValue] / 60 - 60 * hour);
                    NSString *start_time = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)min];
                    
                    hour = [self.dict[@"endtime"] integerValue] / 3600;
                    min = ([self.dict[@"endtime"] integerValue] / 60 - 60 * hour);
                    NSString *end_time = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)min];
                    cell.holder.text = [NSString stringWithFormat:@"%@ ~ %@", start_time, end_time];
                }
            }
            return cell;
            
        } else {
            UploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            MCWeakSelf
            cell.clickHandler = ^(NSInteger index) {
                if (index <=3) {
                    self.index = index;
                    [weakSelf choosePhoto];
                } else {
                    ExampleViewController *vc = [ExampleViewController new];
                    if (index == 4) {
                        vc.text = @"身份证正面示例";
                    } else if (index == 5) {
                        vc.text = @"身份证反面示例";
                    }else if (index == 6) {
                        vc.text = @"店铺示例";
                    }
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            return cell;
        }
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (self.sArray.count) {
            cell.textLabel.text = self.sArray[indexPath.row].title;
        } else {
            cell.textLabel.text = self.pArray[indexPath.row].title;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.table]) {
        
        if (indexPath.row != self.titleArray.count - 1) {
            return 55;
        }
        return 300;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.table1]) {
        
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
                self.shop_id = self.sArray[indexPath.row].shop_id;
                KYInfoTableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                cell.holder.text = [[self.pmodel.title stringByAppendingString:@"   "] stringByAppendingString: self.sArray[indexPath.row].title];
                [self tap3:nil];
            }
            [self.sArray removeAllObjects];
        }
        [self.table1 reloadSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.table1 scrollToTop];

    } else {
        if (indexPath.row == 9) {
            return;
        }
        KYInfoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.holder resignFirstResponder];
        cell.holder.userInteractionEnabled = NO;
        if (indexPath.row == 3) {
            [self showCategory];
            //            return NO;
        } else if (indexPath.row == 6) {
            [self show];
            //            return NO;
            
        } else if (indexPath.row == 8) {
            [self showDatePicker];
            //            return NO;
        } else {
            cell.holder.userInteractionEnabled = YES;
            [cell.holder becomeFirstResponder];
        }
    }
}

- (void)choosePhoto
{
    //    self.currentImageView = (UIImageView *)tap.view;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            TZImagePickerController *tvc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
            tvc.allowPickingVideo = NO;
            tvc.allowPickingOriginalPhoto = NO;
            tvc.allowTakePicture = NO;
            tvc.maxImagesCount = 1;
            MCWeakSelf
            tvc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                UIImage *image = photos.firstObject;
                image = [weakSelf imageSizeWithScreenImage:image];
                [weakSelf putImage:image atIndex:self.index];
                
            };
            
            [self presentViewController:tvc animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
        
    }];
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [self imageSizeWithScreenImage:info[UIImagePickerControllerOriginalImage]];;
    [self putImage:image atIndex:self.index];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)putImage:(UIImage *)image atIndex:(NSInteger)index {
    UploadTableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    UIButton *btn;
    if (index == 1) {
        btn = [cell btn1];
        self.hasPhoto1 = YES;
    } else if (index == 2) {
        btn = [cell btn2];
        self.hasPhoto2 = YES;
    } else if (index == 3) {
        btn = [cell btn3];
        self.hasPhoto3 = YES;
    }
    for (UIView *sub in btn.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            [sub removeFromSuperview];
        }
    }
    [btn setImage:image forState:UIControlStateNormal];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - textfield代理
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.nameF]) {
        _name = textField.text;
    } else if ([textField isEqual:self.phoneF]) {
        _phone = textField.text;
    } else if ([textField isEqual:self.idcardF]) {
        _idcard = textField.text;
    } else if ([textField isEqual:self.shopnameF]) {
        _shopname = textField.text;
    } else if ([textField isEqual:self.shopPhoneF]) {
        _shopPhone = textField.text;
    } else if ([textField isEqual:self.addressF]) {
        _address = textField.text;
    }
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
        [self checkDict];
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

- (void)showCategory {
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.alpha = 0.0;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3:)];
    [self.cover addGestureRecognizer:tap3];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(50, 200, SCREEN_WIDTH-100, 300) style:UITableViewStylePlain];
    self.table1.delegate = self;
    self.table1.dataSource = self;
    self.table1.backgroundColor = kWhiteColor;
    self.table1.showsVerticalScrollIndicator = NO;
    self.table1.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.table1.layer.cornerRadius = 5;
    self.table1.layer.masksToBounds = YES;
    self.table1.tableFooterView = [UIView new];
    UILabel *aview = [UILabel new];
    aview.text = @"选择行业";
    aview.backgroundColor = kWhiteColor;
    aview.frame = CGRectMake(0, 0, SCREEN_WIDTH-100, 60);
    aview.font = [UIFont boldSystemFontOfSize:17];
    aview.textAlignment = NSTextAlignmentCenter;
    self.table1.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.table1.separatorColor = [UIColor colorWithHexString:@"cccccc"];
    
    self.table1.tableHeaderView = aview;
    [[UIApplication sharedApplication].keyWindow addSubview:self.table1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cover.alpha = 0.4;
        self.table1.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
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
    _datePicker1.minuteInterval = 5;
    
    _datePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT, SCREEN_WIDTH/2, 250)];
    _datePicker2.datePickerMode = UIDatePickerModeTime;
    _datePicker2.backgroundColor = kWhiteColor;
    _datePicker2.minuteInterval = 5;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker1];
    [[UIApplication sharedApplication].keyWindow addSubview:_datePicker2];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cover.alpha = 0.4;
        self.datePicker1.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH/2, 250);

        self.datePicker2.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-250, SCREEN_WIDTH/2, 250);
    } completion:nil];
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

- (void)tap1:(UITapGestureRecognizer *)tap {
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"HH:mm";
    NSString *time1 = [matter stringFromDate:self.datePicker1.date];
    NSString *time2 = [matter stringFromDate:self.datePicker2.date];
    
    KYInfoTableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    cell.holder.text = [NSString stringWithFormat:@"%@ - %@", time1, time2];
    
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
        
        //        self.locTF.text = [[pro stringByAppendingString:city] stringByAppendingString:dis];
        KYInfoTableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        cell.holder.text = [[pro stringByAppendingString:city] stringByAppendingString:dis];
        
        [self.cover removeFromSuperview];
        [self.picker removeFromSuperview];
        self.cover = nil;
        self.picker = nil;
//        [self.temp2 removeAllObjects];
//        [self.temp3 removeAllObjects];

    }];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"入驻人姓名：", @"入驻人手机号：", @"入驻人身份证：", @"行业类型：", @"店铺名称：", @"店铺电话：", @"店铺区域：", @"详细地址：", @"营业时间：", @"上传身份证照："];
    }
    return _titleArray;
}

- (NSArray *)placeHolderArray {
    if (!_placeHolderArray) {
        _placeHolderArray = @[@"请输入姓名", @"请输入手机号", @"请输入身份证号", @"请选择分类/行业", @"自定义+个人店", @"请输入您的店铺电话", @"请选择店铺区域", @"请输入您的详细地址", @"请选择营业时间", @"略略略"];
    }
    return _placeHolderArray;
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
