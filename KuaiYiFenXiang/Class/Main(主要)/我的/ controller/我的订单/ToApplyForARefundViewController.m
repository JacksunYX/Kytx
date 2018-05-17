//
//  HouseRentingViewController.m
//  NewProject
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#import "ToApplyForARefundViewController.h"
#import "MyOrderListViewController.h"
#import "NSString+Category.h"
@interface ToApplyForARefundViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ZFDropDownDelegate>{
    UITableView *mytableview;
    UILabel * refundtypeLabel;
    UILabel * refundreasonLabel;
}
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UILabel *defaulttextLabel;
@property (nonatomic, strong) ZFDropDown * dropDown;
@property (nonatomic, strong) ZFTapGestureRecognizer * tap;
@property (nonatomic, strong) NSArray *refundtypeArray;
@end
@implementation ToApplyForARefundViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [mytableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"申请退款";
    mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    mytableview.delegate=self;
    mytableview.dataSource=self;
    [self.view addSubview:mytableview];
    
    //设置登录按钮
    YYFButton *submitBtn=[[YYFButton alloc]init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.sd_layout
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(40);
    
    NSLog(@"shipping_status:%@",_shipping_status);
    if (_shipping_status.integerValue == 0) {
        self.refundtypeArray = @[@"仅退款"];
    }else{
       self.refundtypeArray = @[@"仅退款",@"退货退款"];
    }
    
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            return 80;
        }else{
            return 50;
        }
    } else if(indexPath.section==1){
        return  120;
    }else if(indexPath.section==2){
        return  [self getPickerViewFrame].size.height+30;
    }else{
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //防止cell重建引起卡顿
    // 定义唯一标识
    static NSString *CellIdentifier = @"Cell";
    // 通过唯一标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }



    if (indexPath.section==0) {
        [cell.textLabel setFont:PFR15Font];
        [cell.detailTextLabel setFont:PFR15Font];
        if (indexPath.row==0) {
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.attributedText = [NSString RichtextString:@"* 退款类型" andstartstrlocation:0 andendstrlocation:1 andchangcoclor:[UIColor redColor] andchangefont:PFR15Font];
           
            refundtypeLabel=[[UILabel alloc]init];
            [refundtypeLabel setFont:PFR15Font];
            [refundtypeLabel setTextColor:[UIColor lightGrayColor]];
            [self.isshowRefundPopView isEqualToString:@"YES"]?[refundtypeLabel setText:@"请选择"]:[refundtypeLabel setText:@"仅退款"];
            self.refundtypeArray.count == 2?[refundtypeLabel setText:@"请选择"]:[refundtypeLabel setText:@"仅退款"];
            [refundtypeLabel setTextAlignment:NSTextAlignmentRight];
            [cell.contentView addSubview:refundtypeLabel];
            refundtypeLabel.sd_layout
            .centerYEqualToView(cell.contentView)
            .rightSpaceToView(cell.contentView, 50)
            .autoHeightRatio(0);
            [refundtypeLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
            
            CGFloat width = 88;
            CGFloat height = 0;
            CGFloat xPos =  SCREEN_WIDTH - width - 20;
            CGFloat yPos = 45;
            self.dropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(xPos, yPos, width, height) pattern:kDropDownPatternCustom];
            self.dropDown.delegate = self;
            self.dropDown.cornerRadius=5.0;
            self.dropDown.borderStyle = kDropDownTopicBorderStyleNone;
            [self.view addSubview:self.dropDown];
            self.tap = [[ZFTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [self.view addGestureRecognizer:self.tap];

        }else if (indexPath.row==1){
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.attributedText = [NSString RichtextString:@"* 退款原因" andstartstrlocation:0 andendstrlocation:1 andchangcoclor:[UIColor redColor] andchangefont:PFR15Font];

            refundreasonLabel=[[UILabel alloc]init];
            [refundreasonLabel setFont:PFR15Font];
            [refundreasonLabel setTextColor:[UIColor lightGrayColor]];
            [refundreasonLabel setText:@"请选择"];
            [refundreasonLabel setTextAlignment:NSTextAlignmentRight];
            [cell.contentView addSubview:refundreasonLabel];
            refundreasonLabel.sd_layout
            .centerYEqualToView(cell.contentView)
            .rightSpaceToView(cell.contentView, 10)
            .autoHeightRatio(0);
            [refundreasonLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];

        }else{
            UILabel *celltitlwlabel = [UILabel new];
            celltitlwlabel.text = @"* 退款金额：";
//            [SXColorLabel setAnotherColor:[UIColor blackColor]];
//            [SXColorLabel setAnotherFont:PFR18Font];
//            SXColorLabel *celltitlwlabel  = [[SXColorLabel alloc]init];
//            [celltitlwlabel setAnotherColor:[UIColor lightGrayColor]];
//            [celltitlwlabel setAnotherFont:PFR15Font];
//            celltitlwlabel.attributedText = [NSString RichtextString:[NSString stringWithFormat:@"* 退款金额:(最多¥%@ ,不含运费)",self.refundamountString] andstartstrlocation:0 andendstrlocation:1 andchangcoclor:[UIColor redColor] andchangefont:PFR15Font];
//            celltitlwlabel.text =[NSString stringWithFormat:@"* 退款金额:  [<(最多¥%@ ,不含运费)>]",self.refundamountString];
            
            [cell.contentView addSubview:celltitlwlabel];
            celltitlwlabel.sd_layout
            .topSpaceToView(cell.contentView, 10)
            .leftSpaceToView(cell.contentView, 20)
//            .rightSpaceToView(cell.contentView, 20)
            .autoHeightRatio(0);
//            celltitlwlabel.isAttributedContent = YES;
            [celltitlwlabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - 40];
       
            UILabel *moneylabel=[[UILabel alloc]init];
            [moneylabel setFont:PFR26Font];
            [moneylabel setText:[NSString stringWithFormat:@"¥ %@",self.refundamountString]];
            [moneylabel setTextColor:[UIColor redColor]];
            [cell.contentView addSubview:moneylabel];
            moneylabel.sd_layout
            .bottomSpaceToView(cell.contentView, 10)
            .leftSpaceToView(cell.contentView, 20)
            .autoHeightRatio(0);
            [moneylabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
            
        }

    } else if(indexPath.section==1){

        [SXColorLabel setAnotherColor:[UIColor blackColor]];
        [SXColorLabel setAnotherFont:PFR18Font];
        SXColorLabel *celltitlwlabel  = [[SXColorLabel alloc]init];
        [celltitlwlabel setAnotherColor:[UIColor lightGrayColor]];
        [celltitlwlabel setAnotherFont:PFR15Font];
        celltitlwlabel.text = @"退款说明:  [<(200字以内,可不填)>]";
        [cell.contentView addSubview:celltitlwlabel];
        celltitlwlabel.sd_layout
        .topSpaceToView(cell.contentView, 10)
        .leftSpaceToView(cell.contentView, 20)
        .autoHeightRatio(0);
        [celltitlwlabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];

        self.feedbackTextView=[[UITextView alloc]init];
        self.feedbackTextView.layer.borderColor = [BACKVIEWCOLOR CGColor];
        self.feedbackTextView.layer.borderWidth = 1.0f;
        self.feedbackTextView.layer.cornerRadius = 3.0f;
        CAGradientLayer *la = [[CAGradientLayer alloc]init];
        [self.feedbackTextView.layer addSublayer:la];
        self.feedbackTextView.delegate=self;
//        [self.feedbackTextView setBackgroundColor:BACKVIEWCOLOR];
        [self.feedbackTextView setFont:PFR13Font];
        [cell.contentView addSubview:self.feedbackTextView];
        self.feedbackTextView.sd_layout
        .topSpaceToView(celltitlwlabel, 10)
        .leftSpaceToView(cell.contentView, 10)
        .widthIs(SCREEN_WIDTH-20)
        .heightIs(60);

        self.defaulttextLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 6, SCREEN_WIDTH, 20)];
        self.defaulttextLabel.enabled = NO;
        self.defaulttextLabel.text = @"请输入退款说明";
        self.defaulttextLabel.font =  PFR13Font;
        self.defaulttextLabel.textColor = hwcolor(192, 189, 189);
        [self.feedbackTextView addSubview:self.defaulttextLabel];

        ///字数限制
//        UILabel *spaceconstraintsLabel  = [[UILabel alloc]init];
//        spaceconstraintsLabel.enabled = NO;
//        spaceconstraintsLabel.text = @"字数限制(200字)";
//        spaceconstraintsLabel.font =  PFR13Font;
//        spaceconstraintsLabel.textColor = hwcolor(192, 189, 189);
//        [self.feedbackTextView addSubview:spaceconstraintsLabel];
//        spaceconstraintsLabel.sd_layout
//        .bottomSpaceToView(self.feedbackTextView, 10)
//        .rightSpaceToView(self.feedbackTextView, 10)
//        .autoHeightRatio(0);
//        [spaceconstraintsLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];

    }else if(indexPath.section==2){

        [SXColorLabel setAnotherColor:[UIColor blackColor]];
        [SXColorLabel setAnotherFont:PFR18Font];

        SXColorLabel *PictureistruthLabel  = [[SXColorLabel alloc]init];
        [PictureistruthLabel setAnotherColor:[UIColor lightGrayColor]];
        [PictureistruthLabel setAnotherFont:PFR15Font];

        PictureistruthLabel.text = @"上传凭证  [<请上传JPG/PNG格式的照片,1M之内，最多5张>]";
        [cell.contentView addSubview:PictureistruthLabel];
        PictureistruthLabel.sd_layout
        .topSpaceToView(cell.contentView, 10)
        .leftSpaceToView(cell.contentView, 10)
        .autoHeightRatio(0);
        [PictureistruthLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];

        self.showInView=cell.contentView;

        /** 初始化collectionView */
        [self initPickerView];
        //设置图片选择器
        [self updatePickerViewFrameY:40];

        __weak __typeof (mytableview) weakSelf = mytableview ;

        self.deletephotoblock = ^{

            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
            [weakSelf reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        };

    }else{

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0&&indexPath.row==0) {
        [self.isshowRefundPopView isEqualToString:@"NO"]?:[self.dropDown show];
    }else{
        [self.dropDown resignDropDownResponder];
        if (indexPath.section==0&&indexPath.row==1) {
            CDZPickerBuilder *builder = [CDZPickerBuilder new];
            builder.showMask = YES;
            builder.cancelTextColor = UIColor.redColor;
            [CDZPicker showSinglePickerInView:[HttpRequest getCurrentVC].view withBuilder:builder strings:@[@"协商一致退款",@"未按约定时间发货",@"拍错/多拍/不想要",@"缺货",@"其它"] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
                NSLog(@"strings:%@ indexs:%@",strings,indexs);
                [refundreasonLabel setText:strings[0]];
            }cancel:^{
                //your code
            }];
        }
    }
}

/**
 *  self.view添加手势取消dropDown第一响应
 */
- (void)tapAction{
    [self.dropDown resignDropDownResponder];
}
#pragma mark - ZFDropDownDelegate
- (CGFloat)dropDown:(ZFDropDown *)dropDown heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
    return @[@"",@""];
}
- (UITableViewCell *)dropDown:(ZFDropDown *)dropDown tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = @"UITableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    [cell.textLabel setFont:PFR12Font];
    if (indexPath.row==0) {
        cell.textLabel.text = self.refundtypeArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
    }else if (indexPath.row==1) {
        cell.textLabel.text = self.refundtypeArray[indexPath.row];
        cell.backgroundColor= [UIColor whiteColor];
    }else{
        
    }
    return cell;
}


- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [refundtypeLabel setText:self.refundtypeArray[indexPath.row]];
}
- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count{
    return  self.refundtypeArray.count;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    //这个判断相当于是textfield中的点击return的代理方法
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    //在输入过程中 判断加上输入的字符 是否超过限定字数
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];

    if (str.length  > 0) {
        [self.defaulttextLabel setHidden:YES];
    }else{
        [self.defaulttextLabel setHidden:NO];
    }

    if (str.length > 200)
    {
//        textView.text = [textView.text substringToIndex:50];

        LRToast(@"字数限制(200字)");

        return NO;
    }

    return YES;
    
}

-(void)submitBtnClick{
    
    if ([refundtypeLabel.text isEqualToString:@"请选择"]||[refundreasonLabel.text isEqualToString:@"请选择"]) {
        LRToast(@"请填写完整退款信息");
    }else{
        
    NSMutableDictionary *requestdic=[NSMutableDictionary new];
    [requestdic setObject:self.refundordersnString forKey:@"order_sn"];
    [requestdic setObject:self.refundamountString forKey:@"money"];
    [requestdic setObject:refundtypeLabel.text forKey:@"way"];
    [requestdic setObject:refundreasonLabel.text forKey:@"qita"];
    [requestdic setObject:self.feedbackTextView.text forKey:@"shuoming"];
    for (int i=0; i<self.imageArray.count; i++) {
        NSData *data = UIImageJPEGRepresentation(self.imageArray[i], 1.0f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [requestdic setObject:[@"data:image/jpeg;base64," stringByAppendingString:encodedImageStr] forKey:[NSString stringWithFormat:@"images%d",i+1]];
    }
    NSLog(@"%@",self.imageArray);
    [HttpRequest postWithTokenURLString:NetRequestUrl(refund) parameters:requestdic
                           isShowToastd:(BOOL)YES
                              isShowHud:(BOOL)YES
                       isShowBlankPages:(BOOL)NO
                                success:^(id responseObject)  {
                                    
                                    NSString *codeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]]; ;
//                                    NSDictionary *result=[responseObject objectForKey:@"result"];
                                    
                                    if (codeStr.intValue==1) {
                                        
                                        GCDAfter1s(^{
                                            MyOrderListViewController *molvc=[[MyOrderListViewController alloc]init];
                                            molvc.index=5;
                                            [self.navigationController pushViewController:molvc animated:YES];
                                        });
                                        
                                    }
                                    
                                } failure:^(NSError *error) {
                                    //打印网络请求错误
                                    NSLog(@"%@",error);
                                    
                                } RefreshAction:^{
                                    //执行无网络刷新回调方法
                                    
                                }];
    }
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


















