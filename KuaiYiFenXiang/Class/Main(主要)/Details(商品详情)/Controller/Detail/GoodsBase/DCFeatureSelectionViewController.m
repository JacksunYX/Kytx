//
//  DCFeatureSelectionViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureSelectionViewController.h"

// Controllers
#import "DCFillinOrderViewController.h"
// Models
#import "DCFeatureItem.h"
#import "DCFeatureTitleItem.h"
#import "DCFeatureList.h"
// Views
#import "PPNumberButton.h"
#import "DCFeatureItemCell.h"
#import "DCFeatureHeaderView.h"
#import "DCCollectionHeaderLayout.h"
#import "DCFeatureChoseTopCell.h"
// Vendors
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+XWTransition.h"
// Categories

// Others

#define NowScreenH ScreenH * 0.6

@interface DCFeatureSelectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate,PPNumberButtonDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSString *goodsprice;
    
    NSString *goods_specString;
    
}

/* contionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray <DCFeatureItem *> *featureAttr;
/* 选择属性 */
@property (strong , nonatomic)NSMutableArray *seleArray;
/* 选择属性 */
@property (strong , nonatomic)NSMutableArray *seleIDArray;
/* 商品选择结果Cell */
@property (weak , nonatomic)DCFeatureChoseTopCell *cell;

@property (strong , nonatomic)NSMutableDictionary *addCartDic;
@property (nonatomic, strong) NSString *store_count;
@property (nonatomic, strong) NSString *store_id;

@property (nonatomic, strong) PPNumberButton *numberButton;

@end

static NSInteger num_;

static NSString *const DCFeatureHeaderViewID = @"DCFeatureHeaderView";
static NSString *const DCFeatureItemCellID = @"DCFeatureItemCell";
static NSString *const DCFeatureChoseTopCellID = @"DCFeatureChoseTopCell";
@implementation DCFeatureSelectionViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCCollectionHeaderLayout *layout = [DCCollectionHeaderLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //自定义layout初始化
        layout.delegate = self;
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = DCMargin;
        layout.headerViewHeight = 35;
        layout.footerViewHeight = 5;
        layout.itemInset = UIEdgeInsetsMake(0, DCMargin, 0, DCMargin);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[DCFeatureItemCell class] forCellWithReuseIdentifier:DCFeatureItemCellID];//cell
        [_collectionView registerClass:[DCFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[DCFeatureChoseTopCell class] forCellReuseIdentifier:DCFeatureChoseTopCellID];
    }
    return _tableView;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpFeatureAlterView];
    
    [self setUpBase];
    
    [self setUpBottonView];
}

#pragma mark - initialize
- (void)setUpBase
{
    
    //    NSLog(@"RootAttributeArray-----%@",self.RootAttributeArray);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    _featureAttr = [DCFeatureItem mj_objectArrayWithFilename:@"ShopItem.plist"];
    _featureAttr=[NSMutableArray new];
    for (NSDictionary *dic in self.RootAttributeArray) {
        [_featureAttr addObject:[DCFeatureItem mj_objectWithKeyValues:dic]];
    }
    self.tableView.frame = CGRectMake(0, 0, ScreenW, 100);
    self.tableView.rowHeight = 250;
    self.collectionView.frame = CGRectMake(0, self.tableView.dc_bottom ,ScreenW , NowScreenH - 200);
    
    
    if (_lastSeleArray.count == 0) return;
    for (NSString *str in _lastSeleArray) {//反向遍历
        for (NSInteger i = 0; i < _featureAttr.count; i++) {
            for (NSInteger j = 0; j < _featureAttr[i].list.count; j++) {
                if ([_featureAttr[i].list[j].infoname isEqualToString:str]) {
                    _featureAttr[i].list[j].isSelect = YES;
                    [self.collectionView reloadData];
                }
            }
        }
    }
    
}

#pragma mark - 底部按钮
- (void)setUpBottonView
{
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    CGFloat buttonH = 50;
    CGFloat buttonW = ScreenW / titles.count;
    CGFloat buttonY = NowScreenH - buttonH;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *buttton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttton setTitle:titles[i] forState:0];
        buttton.backgroundColor = (i == 0) ? [UIColor redColor] : [UIColor orangeColor];
        CGFloat buttonX = buttonW * i;
        buttton.tag = i;
        buttton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.view addSubview:buttton];
        [buttton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *numLabel = [UILabel new];
    numLabel.text = @"数量";
    numLabel.font = PFR14Font;
    [self.view addSubview:numLabel];
    numLabel.frame = CGRectMake(DCMargin, NowScreenH - 90, 50, 35);
    
    self.numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), numLabel.dc_y, 110, numLabel.dc_height)];
    _numberButton.shakeAnimation = YES;
    _numberButton.minValue = 1;
    NSString *store_countstring=[self.goods_infodictionary objectForKey:@"store_count"];
    _numberButton.maxValue=store_countstring.integerValue;
    _numberButton.inputFieldFont = 20;
    _numberButton.increaseTitle = @"＋";
    _numberButton.decreaseTitle = @"－";
    num_ = (_lastNum == 0) ?  1 : _lastNum;
    _numberButton.currentNumber = num_;
    _numberButton.delegate = self;
    
    _numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        num_ = num;
    };
    [self.view addSubview:_numberButton];
}

#pragma mark - 底部按钮点击
- (void)buttomButtonClick:(UIButton *)button
{
    
    if (_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) {//未选择全属性警告
        [SVProgressHUD showInfoWithStatus:@"请选择全属性"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    [self dismissFeatureViewControllerWithTag:button.tag];
    
}

#pragma mark - 弹出弹框
- (void)setUpFeatureAlterView
{
    XWInteractiveTransitionGestureDirection direction = XWInteractiveTransitionGestureDirectionDown;
    __weak typeof(self)weakSelf = self;
    [self xw_registerBackInteractiveTransitionWithDirection:direction transitonBlock:^(CGPoint startPoint){
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf dismissFeatureViewControllerWithTag:100];
        }];
    } edgeSpacing:0];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCFeatureChoseTopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCFeatureChoseTopCellID forIndexPath:indexPath];
    _cell = cell;
    if ((_seleArray.count != _featureAttr.count && _lastSeleArray.count != _featureAttr.count) || kArrayIsEmpty(_featureAttr)) {
        kArrayIsEmpty(_featureAttr)?[cell.goodPriceLabel setText:[NSString stringWithFormat:@"¥ %@",[self.goods_infodictionary objectForKey:@"shop_price"]]]:[cell.goodPriceLabel setText:[NSString stringWithFormat:@"¥ %@",[self.goods_infodictionary objectForKey:@"shop_price"]]];
        cell.chooseAttLabel.textColor = [UIColor redColor];
        cell.chooseAttLabel.text = @"有货";
        cell.storecountLabel.text=[NSString stringWithFormat:@"库存:%@",[self.goods_infodictionary objectForKey:@"store_count"]];
        [cell.storecountLabel setTextColor:[UIColor grayColor]];
        [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,[self.goods_infodictionary objectForKey:@"original_img"]]]];
        cell.integralLabel.text = [NSString stringWithFormat:@"%.2f",[self.goods_infodictionary[@"loves"] floatValue]];
        NSLog(@"self.goods_infodictionary-----%@",self.goods_infodictionary);
    }else {
        NSLog(@"self.goods_infodictionary-----%@",self.goods_infodictionary);
        cell.chooseAttLabel.textColor = [UIColor darkGrayColor];
        NSString *attString = (_seleArray.count == _featureAttr.count) ? [_seleArray componentsJoinedByString:@"，"] : [_lastSeleArray componentsJoinedByString:@"，"];
        cell.chooseAttLabel.text = [NSString stringWithFormat:@"已选属性：%@",attString];
        cell.integralLabel.text = [NSString stringWithFormat:@"%.2f",[self.goods_infodictionary[@"loves"] floatValue]];
        //通过拼接的ID获取相应的数据
        for (NSDictionary *dic in self.Spec_goods_priceArray) {
            if([[dic allKeys] containsObject:[_seleArray componentsJoinedByString:@" "]]){
                NSMutableArray *valuearray = [[dic allValues] mutableCopy];
                for (NSDictionary *dic in valuearray) {
                    cell.goodPriceLabel.text = [NSString stringWithFormat:@"¥ %@",[dic objectForKey:@"price"]];
                    goodsprice=[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
                    goods_specString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                    //获取所选属性ID
                    NSLog(@"%@",[NSString stringWithFormat:@"已选属性ID：%@",goods_specString]);
                    NSInteger store_count = [[dic objectForKey:@"store_count"] integerValue];
                    cell.storecountLabel.text=[NSString stringWithFormat:@"库存:%ld",store_count];
                    _numberButton.maxValue = store_count;
                    if (_numberButton.currentNumber > store_count) {
                        _numberButton.currentNumber = store_count;
                    }
                    if (_numberButton.currentNumber == 0&&store_count!=0) {
                        _numberButton.currentNumber = 1;
                    }
                    [cell.storecountLabel setTextColor:[UIColor grayColor]];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",defaultUrl,[dic objectForKey:@"sku"]]];
                    [cell.goodImageView sd_setImageWithURL:url];
                    self.store_count = dic[@"store_count"];
                    self.store_id = dic[@"id"];
                }
            }
        }
    }
    
    
    __weak typeof(self)weakSelf = self;
    cell.crossButtonClickBlock = ^{
        [weakSelf dismissFeatureViewControllerWithTag:100];
    };
    return cell;
}


#pragma mark - 退出当前界面
- (void)dismissFeatureViewControllerWithTag:(NSInteger)tag
{
    
    _addCartDic = [NSMutableDictionary new];
    NSString *store_countstring=[self.goods_infodictionary objectForKey:@"store_count"];
    __weak typeof(self)weakSelf = self;
    [weakSelf dismissViewControllerAnimated:YES completion:^{
        if (kDictIsEmpty(self.goods_infodictionary)) {
            LRToast(@"无此商品");
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (![weakSelf.cell.chooseAttLabel.text isEqualToString:@"有货"] || kArrayIsEmpty(_featureAttr) ||store_countstring.integerValue>0) {//当选择全属性才传递出去
            if (_seleArray.count == 0) {
                NSLog(@"%@",self.goods_infodictionary);
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"goods_id"] forKey:@"goods_id"];
                [_addCartDic setObject:[NSString stringWithFormat:@"%ld",(long)num_] forKey:@"goods_num"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"goods_name"] forKey:@"goods_name"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"business_id"] forKey:@"business_id"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"shop_price"] forKey:@"goods_price"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"shop_price"] forKey:@"shop_price"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"postage"] forKey:@"postage"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"original_img"] forKey:@"original_img"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"store_count"] forKey:@"store_count"];
                
                NSMutableArray *numArray = [NSMutableArray arrayWithArray:_lastSeleArray];
                !weakSelf.userChooseBlock ? : weakSelf.userChooseBlock(numArray,num_,tag,_addCartDic);
            }else{
                [_addCartDic setObject:self.store_id forKey:@"goods_spec"];
                [_addCartDic setObject:[_seleArray componentsJoinedByString:@" "] forKey:@"goods_spec_key"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"goods_id"] forKey:@"goods_id"];
                [_addCartDic setObject:[NSString stringWithFormat:@"%ld",(long)num_] forKey:@"goods_num"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"goods_name"] forKey:@"goods_name"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"business_id"] forKey:@"business_id"];
                [_addCartDic setObject:goodsprice forKey:@"goods_price"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"shop_price"] forKey:@"shop_price"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"postage"] forKey:@"postage"];
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"original_img"] forKey:@"original_img"];
                //                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"store_count"] forKey:@"store_count"];
                _addCartDic[@"store_count"] = self.store_count;
                [_addCartDic setObject:[self.goods_infodictionary objectForKey:@"weight"] forKey:@"weight"];
                !weakSelf.userChooseBlock ? : weakSelf.userChooseBlock(_seleArray,num_,tag,_addCartDic);
            }
        }else{
            if (store_countstring.integerValue<=0) {
                LRToast(@"当前商品库存不足");
            }
        }
    }];
}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _featureAttr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _featureAttr[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFeatureItemCellID forIndexPath:indexPath];
    cell.content = _featureAttr[indexPath.section].list[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        DCFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID forIndexPath:indexPath];
        headerView.headTitle = _featureAttr[indexPath.section].attr;
        return headerView;
    }else {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    _featureAttr[indexPath.section].list[indexPath.row].isSelect = !_featureAttr[indexPath.section].list[indexPath.row].isSelect;
    
    //限制每组内的Item只能选中一个
    //先把该区的规格清空
    for (NSInteger j = 0; j < _featureAttr[indexPath.section].list.count; j++) {
        _featureAttr[indexPath.section].list[j].isSelect = NO;
    }
    //再把点击了的规格选定
    _featureAttr[indexPath.section].list[indexPath.row].isSelect = YES;
    
    //section，item 循环讲选中的所有Item加入数组中 ，数组mutableCopy初始化
    _seleArray = [@[] mutableCopy];
    _seleIDArray = [@[] mutableCopy];
    for (NSInteger i = 0; i < _featureAttr.count; i++) {
        for (NSInteger j = 0; j < _featureAttr[i].list.count; j++) {
            if (_featureAttr[i].list[j].isSelect == YES) {
                [_seleArray addObject:[NSString stringWithFormat:@"%@:%@",_featureAttr[i].attr.attrname,_featureAttr[i].list[j].infoname]];
                //                [_seleIDArray addObject:_featureAttr[i].list[j].infoid];
            }
        }
    }
    //刷新tableView和collectionView
    [collectionView reloadData];
    [self.tableView reloadData];
}


#pragma mark - <HorizontalCollectionLayoutDelegate>
#pragma mark - 自定义layout必须实现的方法
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    return _featureAttr[indexPath.section].list[indexPath.row].infoname;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
