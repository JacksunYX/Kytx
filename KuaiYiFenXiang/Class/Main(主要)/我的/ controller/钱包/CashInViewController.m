//
//  CashOutViewController.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/5.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "CashInViewController.h"
#import "KYHeader.h"
#import "TZImagePickerController.h"
#import "CashOutDetailViewController.h"
#import "JTSImageViewController.h"

@interface CashInViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *atf;
@property (nonatomic, strong) UITextField *btf;
@property (nonatomic, strong) UITextField *ctf;
@property (nonatomic, strong) UITextField *dtf;
@property (nonatomic, strong) UITextField *etf;
@property (nonatomic, strong) UITextField *ftf;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UITextView *tv;
@property (nonatomic, strong) NSString *selectedBank;
@property (nonatomic, strong) NSMutableDictionary *cardDict;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIImage *eximage;

@end

@implementation CashInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kDefaultBGColor;
    [self configUI];
    self.title = @"大额充值";
    self.isOpen = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavi];
    
}

- (void)configNavi {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"规则" style:UIBarButtonItemStylePlain target:self action:@selector(right:)];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"666666"]} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = item1;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kColor333}];
}

- (void)right:(UIBarButtonItem *)sender {
    KYWebViewController *vc = [KYWebViewController new];
    vc.web_url = cashiinrule_url;
    vc.name = @"大额充值规则";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configUI {
    UIView *aview = [self viewWithTitle:@"充值用户："];
    
    for (UIView *sub in aview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.atf = (UITextField *)sub;
            self.atf.delegate = self;
            self.atf.placeholder = @"输入需充值的快益账号";
            self.atf.keyboardType = UIKeyboardTypeDefault;
            break;
        }
    }
    
    [self.view addSubview:aview];
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    UIView *bview = [self viewWithTitle:@"转账金额："];
    
    for (UIView *sub in bview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.btf = (UITextField *)sub;
            self.btf.placeholder = @"输入转账总金额";
            self.btf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:bview];
    [bview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(aview.mas_bottom);
    }];
    
    UIView *temp = [UIView new];
    temp.backgroundColor = kWhiteColor;
    [self.view addSubview:temp];
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bview.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.backgroundColor = kDefaultBGColor;
    tv.font = kFont(13);
    tv.layer.cornerRadius = 5;
    tv.layer.masksToBounds = YES;
    tv.textColor = kColor999;
    tv.text = @"备注：(50字以内)";
    self.tv = tv;
    tv.delegate = self;
    
    [self.view addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bview.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(80);
        
    }];
    
    
    UIView *cview = [self viewWithTitle:@"转账卡主："];
    
    for (UIView *sub in cview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.ctf = (UITextField *)sub;
//            self.ctf.delegate = self;
            self.ctf.keyboardType = UIKeyboardTypeDefault;
            self.ctf.placeholder = @"请输入转账卡主";
            self.ctf.delegate =self;
            break;
        }
    }
    
    
    
    [self.view addSubview:cview];
    [cview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(tv.mas_bottom);
    }];
    
    
    UIView *dview = [self viewWithTitle:@"银行卡号："];
    
    for (UIView *sub in dview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.dtf = (UITextField *)sub;
            self.dtf.placeholder = @"请输入银行卡号";
            self.dtf.delegate =self;

            break;
        }
    }
    
    [self.view addSubview:dview];
    [dview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(cview.mas_bottom);
    }];
    
    UIView *eview = [self viewWithTitle:@"转账银行："];
    
    for (UIView *sub in eview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.etf = (UITextField *)sub;
            self.etf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:eview];
    [eview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
        make.top.equalTo(dview.mas_bottom);
    }];
    
    UIView *fview = [self viewWithTitle:@"转账凭证："];
    
    for (UIView *sub in fview.subviews) {
        if ([sub isKindOfClass:[UITextField class]]) {
            self.ftf = (UITextField *)sub;
            self.ftf.delegate = self;
            break;
        }
    }
    
    [self.view addSubview:fview];
    [fview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120);
        make.left.right.equalTo(self.view);
        make.top.equalTo(eview.mas_bottom);
    }];
    
    
    
    UILabel *flabel = [UILabel new];
    
    flabel.font = kFont(11);
    flabel.textColor = kColor999;
    flabel.numberOfLines = 0;
//    flabel.text = ;
    NSString *textStr =@"提示：\n1.以上信息如有变更，请及时与公司联系，最终以实际支付金额为依据。\n2.如需多次转账，请多次提交转账信息。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textStr length])];
    
    flabel.attributedText = attributedString;
    
    [self.view addSubview:flabel];
    [flabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(fview.mas_bottom).offset(15);
    }];
    
    UIView *line1 = [UIView new];
    
    line1.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(aview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    UIView *line3 = [UIView new];
    
    line3.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView *line4 = [UIView new];
    
    line4.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIView *line5 = [UIView new];
    
    line5.backgroundColor = kDefaultBGColor;
    [self.view addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(eview);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(120, 100, 160, 30) style:UITableViewStylePlain];
    self.table = table;
    //    table.backgroundColor = [UIColor redColor];
    table.backgroundColor = kDefaultBGColor;
    table.delegate = self;
    table.dataSource = self;
    table.layer.cornerRadius = 5;
    table.layer.masksToBounds = YES;
    table.layer.borderColor = kColor999.CGColor;
    table.layer.borderWidth = 0.5;
    //    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.etf.mas_centerY).offset(-15);
        make.left.equalTo(self.etf).offset(120);
        make.right.equalTo(self.etf).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *tbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn = tbtn;
    [tbtn setBackgroundImage:[UIImage imageNamed:@"转账凭证"] forState:UIControlStateNormal];
//    tbtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:tbtn];
    [tbtn addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [tbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(fview);
        make.left.equalTo(self.table);
    }];
    
    UILabel *shili = [UILabel new];
    
    shili.textColor = kColor999;
    shili.text = @"示例：";
    shili.font = kFont(15);
    
    [fview addSubview:shili];
    [shili mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(fview);
        make.top.equalTo(tbtn).offset(0);
        make.right.equalTo(fview).offset(-15-80);
    }];
    
    UIImageView *shiliimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"示例"]];
    
    shiliimage.userInteractionEnabled = YES;
    self.eximage = shiliimage.image;
    shiliimage.layer.cornerRadius = 5;
    shiliimage.layer.borderColor = kDefaultBGColor.CGColor;
    shiliimage.layer.borderWidth = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blow:)];
    [shiliimage addGestureRecognizer:tap];
    
    [fview addSubview:shiliimage];
    [shiliimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fview);
        make.right.equalTo(fview).offset(-15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    

    UIImageView *imageaaa = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"上箭头"]];
    imageaaa.transform = CGAffineTransformRotate(imageaaa.transform, M_PI);
    [self.view addSubview:imageaaa];
    [imageaaa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.etf);
        make.right.equalTo(table).offset(-5);
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [btn setBackgroundImage:[KYHeader imageWithColor:kColord40] forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44+BOTTOM_MARGIN);
    }];
    [btn addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)blow:(UITapGestureRecognizer *)sender {
    [self blowUpImage:self.eximage referenceRect:self.eximage.accessibilityFrame referenceView:[UIApplication sharedApplication].keyWindow referenceContentMode:UIViewContentModeScaleAspectFit];
}

#pragma mark - 点击放大图片
- (void)blowUpImage:(UIImage *)image referenceRect:(CGRect)referenceRect referenceView:(UIView *)referenceView referenceContentMode:(UIViewContentMode) referenContentMode {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = image;
    imageInfo.referenceRect = referenceRect;
    imageInfo.referenceView = referenceView;
    imageInfo.referenceContentMode = referenContentMode;
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    //    self.controllerMotai = YES;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"备注：(50字以内)"]) {
        textView.text = @"";
    }
    self.isOpen = NO;
    [self.table reloadData];
    [self updateViewConstraints];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView.text.length > 50 && (![text isEqualToString:@""])) {
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.btf) {
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.etf]) {
        
        return NO;
    }
    self.isOpen = NO;
    [self.table reloadData];
    [self updateViewConstraints];
    return YES;
}


- (UIView *)viewWithTitle:(NSString *)title {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UITextField *tf = [[UITextField alloc] init];
    
    [view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    UIView *aview = [UIView new];
    
    aview.frame = CGRectMake(0, 0, 115, 60);
    
    UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(15, 0, 100, 60)];
    if ([title isEqualToString:@"转账凭证："]) {
        label.hidden = YES;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
        [view addSubview:label1];
        label1.font = kFont(15);
        label1.textColor = kColor333;
        label1.text = title;
    }
    
    label.font = kFont(15);
    label.textColor = kColor333;
    label.text = title;
    
    [aview addSubview:label];
    
    tf.leftView = aview;
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.isOpen ? self.dataArray[indexPath.row] : (self.selectedBank ? self.selectedBank : @"请选择银行") ;
    cell.textLabel.font = kFont(13);
    cell.textLabel.textColor = kColor666;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;;
    cell.backgroundColor = kDefaultBGColor;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isOpen) {
        return self.dataArray.count;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:tableView];
    self.isOpen = !self.isOpen;
    if (!self.isOpen) {
        self.selectedBank = self.dataArray[indexPath.row];
    }
    [tableView reloadData];
    [self updateViewConstraints];
    [tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateViewConstraints {
    if (self.isOpen) {
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
    } else {
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
    }
    [super updateViewConstraints];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isOpen = NO;
    [self.table reloadData];
    [self updateViewConstraints];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"中国银行", @"农业银行", @"工商银行", @"建设银行", @"浦发银行", @"平安银行", @"邮政储蓄银行", @"光大银行", @"华夏银行", @"招商银行", @"交通银行", @"民生银行", @"兴业银行", @"中信银行", @"广发银行"];
    }
    return _dataArray;
}

- (NSMutableDictionary *)cardDict {
    if (!_cardDict) {
        NSArray *temp = @[@"104100000045",@"103100019027",@"102100004951",@"105100000033",@"310290098012",@"313584000019",@"403100000004",@"303100000006",@"304100040000",@"308584001024",@"301290011110",@"305100000013",@"309391000011",@"302521038101",@"306581000003"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [self.dataArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dict[obj] = temp[idx];
        }];
        _cardDict = dict;
    }
    
    return _cardDict;
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
            tvc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                UIImage *image = photos.firstObject;
                MCWeakSelf
//                [weakSelf uploadImage:image];
                weakSelf.image = image;
                [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
//    [self uploadImage:image];
    self.image = image;
    [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIButton *)sender {
    NSData *data = UIImageJPEGRepresentation(self.image, 1.0f);

    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (encodedImageStr == nil || [encodedImageStr isEqualToString: @""]) {
        LRToast(@"请将信息填写完整！");
        return;
    }
    
    if (self.btf.text.integerValue < 10000) {
        LRToast(@"充值金额最少为1万元！");
        return;
    }
    
    if (!self.selectedBank) {
        LRToast(@"请选择转账银行！");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"proof"] = [@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr];
    dict[@"mobile"] = self.atf.text;
    dict[@"money"] = self.btf.text;
    dict[@"content"] = [self.tv.text isEqualToString:@"备注（50字以内)"] ? @"" : self.tv.text;
    dict[@"name"] = self.ctf.text;
    dict[@"bank_number"] = self.dtf.text;
    dict[@"bank_id"] = self.cardDict[self.selectedBank];
    
    __weak CashInViewController *weakself = self;

    [HttpRequest postWithTokenURLString:NetRequestUrl(largepay) parameters:dict isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        if ([res[@"code"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:nil RefreshAction:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
