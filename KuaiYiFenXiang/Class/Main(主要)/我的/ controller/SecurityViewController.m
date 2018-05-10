//
//  SecurityViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "SecurityViewController.h"
#import "KYHeader.h"
#import "SettingTableViewCell.h"
#import "ChangeNikeNameViewController.h"
#import "AssureViewController.h"
#import "MessageNotiViewController.h"
#import "IDAuthViewController.h"
#import "IDAuthDoneViewController.h"
#import "TZImagePickerController.h"
#import "KYPhoneViewController.h"
#import "SafeViewController.h"
#import "enterNavigationController.h"
#import "YYFNavigationController.h"



@interface SecurityViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate, TZImagePickerControllerDelegate>
@property(strong, nonatomic)UITableView *table;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy) NSString *iconImage;

@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *pname;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) NSInteger role;


@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)loadData {
    [HttpRequest postWithTokenURLString:NetRequestUrl(userinfo) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            
            self.role = [res[@"result"][@"role"] integerValue];
            
            if ([res[@"result"][@"role"] integerValue] == 1 || [res[@"result"][@"role"] integerValue] == 2) {
                //用户
                self.titleArray = @[@[@"头像",@"手机",@"昵称",@"推荐人",@"店铺名"],@[@"消息设置",@"账户安全"],@[@"清除缓存",@"应用版本"]];
            } else if ([res[@"result"][@"role"] integerValue] == 3 || [res[@"result"][@"role"] integerValue] == 4) {
                //商家
                self.titleArray = @[@[@"头像",@"手机",@"昵称",@"推荐人",@"店铺名"],@[@"消息设置",@"账户安全"],@[@"清除缓存",@"应用版本"]];
            } else {
                self.titleArray = @[@[@"头像",@"手机",@"昵称",@"推荐人",@"店铺名"],@[@"消息设置",@"账户安全"],@[@"清除缓存",@"应用版本"]];
            }
            if ([res[@"code"] integerValue] == 1) {
                self.iconImage = kStringIsEmpty(res[@"result"][@"head_pic"]) ? @"": [defaultUrl stringByAppendingString: res[@"result"][@"head_pic"]];
                self.mobile = res[@"result"][@"mobile"];
                self.nickname = res[@"result"][@"nickname"];
                self.pname = res[@"result"][@"pname"];
                self.shopName = res[@"result"][@"shopname"];
                
            }
            
            [self.table reloadData];
    
        }
        
    } failure:nil RefreshAction:nil];
}


- (void)configUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVI_HEIGHT-44-BOTTOM_MARGIN) style:UITableViewStylePlain];
    
    table.tableFooterView = [UIView new];
    table.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    
    [self.view addSubview:table];
    
    table.dataSource = self;
    
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    
    table.delegate = self;
    
    table.showsVerticalScrollIndicator = NO;
    
    self.table = table;
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    exitBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    
//    exitBtn.backgroundColor = [UIColor colorWithHexString:@"d40000"];
    [exitBtn setBackgroundImage:[KYHeader imageWithColor:[UIColor colorWithHexString:@"d40000"]] forState:UIControlStateNormal];
    [self.view addSubview: exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44+BOTTOM_MARGIN);
    }];
    [exitBtn addTarget:self action:@selector(signout:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 退出登录
- (void)signout:(UIButton *)sender {
    [USER_DEFAULT setObject:@"" forKey:@"token"];
    [USER_DEFAULT setObject:@"" forKey:@"user_id"];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isLogin = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
//    YYFTabBarViewController *tab = (YYFTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    tab.selectedIndex = 4;
//    [self presentViewController:[[YYFNavigationController alloc] initWithRootViewController:[[enterNavigationController alloc]init]] animated:YES completion:nil];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        UIView *a = [UIView new];
        a.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        return a;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
//        if (self.role == 1 || self.role == 2 || self.role == 0) {
            return 2;
//        }
//        return 3;
    } else if (section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
    
     if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 0 && indexPath.row == 3) || (indexPath.section == 0 && indexPath.row == 4)) {
         
     } else {
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         
     };
         
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的-头像"]];
        [icon sd_setImageWithURL:[NSURL URLWithString:self.iconImage] placeholderImage:[UIImage imageNamed:@"我的-头像"]];
        icon.layer.cornerRadius = 25;
        icon.layer.masksToBounds = YES;
        [cell.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-40);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }else if (indexPath.section == 0) {
        UILabel *label = [UILabel new];
        switch (indexPath.row) {
            case 1:
                label.text = self.mobile;
                
                break;
            case 2:
                label.text = self.nickname;
                
                break;
            case 3:
            {
                if (kStringIsEmpty(self.pname)) {
                    label.text = @"";
                }else{
                    label.text = self.pname;
                }
            }
                break;
            case 4:
            {
                if (kStringIsEmpty(self.shopName)) {
                    label.text = @"";
                }else{
                    label.text = self.shopName;
                }
            }
                break;
                
            default:
                break;
        }
        
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-40);
        }];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"当前版本V%@",[UIDevice appVersion]];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-20);
        }];
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
        return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self choosePhoto];
                break;
            case 1:
//                [self choosePhone];
                break;
            case 2:
                [self chageNickName];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                // 消息通知
                [self messageSetting];
                break;
            case 1:{
//                if (self.role == 1 || self.role ==2) {
                    // 账户安全
                    [self assure];
//                } else {
//                    // 实名认证
//                    [self authDone];
//
//                }
            }
                break;
            case 2:
                // 账户安全
                [self assure];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                // 清除缓存
                [self removeCahce];
                break;
            case 1:
                
                break;

                
            default:
                break;
        }
    }
}

- (void)choosePhone {
    KYPhoneViewController *vc = [KYPhoneViewController new];
    vc.phone = self.mobile;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 消息通知
- (void)messageSetting {
    MessageNotiViewController *vc = [MessageNotiViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 账户安全
- (void)assure {
    SafeViewController *vc = [SafeViewController new];
    vc.type = self.role;
    vc.mobile = self.mobile;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 修改昵称
- (void)chageNickName {
    ChangeNikeNameViewController *vc = [[ChangeNikeNameViewController alloc] init];
    vc.nickname = self.nickname;
    
    vc.getSaveNickNameBlock = ^(NSString *newNickName) {
        self.nickname = newNickName;
        [self.table reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 实名认证
//- (void)idAuth {
//    IDAuthViewController *vc = [IDAuthViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 已经实名认证
//- (void)authDone {
//    IDAuthDoneViewController *vc = [IDAuthDoneViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}

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
            tvc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                UIImage *image = photos.firstObject;
                MCWeakSelf
                [weakSelf uploadImage:image];
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
    [self uploadImage:image];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)images {
    NSData *data = UIImageJPEGRepresentation(images, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"heading"] = [@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr];
    __weak SecurityViewController *weakself = self;
    
    [HttpRequest postWithTokenURLString:NetRequestUrl(uploadimage) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        [weakself loadData];
    } failure:nil RefreshAction:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// 清除缓存
- (void)removeCahce {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定清除缓存数据" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] cleanDisk];
        dispatch_async(dispatch_get_main_queue(), ^{
            LRToast(@"清理缓存成功~");
        });
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:okAction];           // A
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@[@"头像",@"手机",@"昵称",@"推荐人",@"店铺名"],@[@"消息设置",@"实名认证",@"账户安全"],@[@"清除缓存",@"应用版本"]];
    }
    return _titleArray;
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
