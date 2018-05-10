//
//  OrderListTableViewCell.m
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/1.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "KYHeader.h"

@interface OrderListTableViewCell ()

@property (nonatomic, strong) UIButton *storeNameBtn;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *deliverLabel;
@property (nonatomic, strong) UILabel *ensureLabel;
@property (nonatomic, strong) UILabel *ensureStatuesLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *old_priceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) UILabel *itemCountLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation OrderListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的订单店铺icon"]];
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.left.top.equalTo(self.contentView).offset(15);
            
        }];
        
//        _storeNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [_storeNameBtn setBackgroundImage:[KYHeader imageWithColor:kWhiteColor] forState:UIControlStateNormal];
//        [_storeNameBtn setTitle:@"快益分享商城>" forState:UIControlStateNormal];
//        [_storeNameBtn setTitleColor:kColor333 forState:UIControlStateNormal];
//        _storeNameBtn.titleLabel.font = kFont(13);
//
//        [self.contentView addSubview:_storeNameBtn];
//        [_storeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(icon);
//            make.left.equalTo(icon.mas_right).offset(5);
//        }];
//
//        _conditionLabel = [UILabel new];
//
//        _conditionLabel.text = @"待付款";
//        _conditionLabel.font = [UIFont systemFontOfSize:13];
//        _conditionLabel.textColor = [UIColor colorWithHexString:@"d40000"];
//
//        [self.contentView addSubview:_conditionLabel];
//        [_conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(icon);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        
        UIView *bgview = [UIView new];
        
        bgview.backgroundColor = BACKVIEWCOLOR;
        
        [self.contentView addSubview:bgview];
        [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(100);
        }];
        
        _itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_img01"]];
        
        [bgview addSubview:_itemImageView];
        [_itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgview);
            make.size.mas_equalTo(CGSizeMake(75, 75));
            make.left.equalTo(bgview).offset(15);
        }];
    
        _itemNameLabel = [UILabel new];
        
        _itemNameLabel.text = @"";
        _itemNameLabel.font = kFont(13);
        _itemNameLabel.textColor = kColor333;
        _itemNameLabel.numberOfLines = 2;
        
        [bgview addSubview:_itemNameLabel];
        [_itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_itemImageView.mas_right).offset(10);
            make.top.equalTo(_itemImageView).offset(5);
            make.width.mas_equalTo(ScaleWidth(210));
        }];
        
        _deliverLabel = [UILabel new];
        
        _deliverLabel.text = @"";
        _deliverLabel.font = kFont(11);
        _deliverLabel.textColor = kColor666;
        _deliverLabel.numberOfLines = 1;
        [bgview addSubview:_deliverLabel];
        [_deliverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_itemImageView.mas_right).offset(10);
            make.top.equalTo(_itemNameLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(ScaleWidth(210));
        }];
        
        _ensureLabel = [UILabel new];
        
        _ensureLabel.text = @" 七天退款 ";
        _ensureLabel.font = kFont(11);
        _ensureLabel.textColor = kWhiteColor;
        _ensureLabel.backgroundColor = [UIColor colorWithHexString:@"d40000"];
        _ensureLabel.layer.cornerRadius = 3;
        _ensureLabel.layer.masksToBounds = YES;
        
        [bgview addSubview:_ensureLabel];
        [_ensureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_itemImageView.mas_right).offset(10);
            make.bottom.equalTo(_itemImageView);
        }];
        
        _ensureStatuesLabel = [UILabel new];
        
        _ensureStatuesLabel.text = @" 退款状态 ";
        _ensureStatuesLabel.font = kFont(11);
        _ensureStatuesLabel.textColor = [UIColor colorWithHexString:@"d40000"];
        
        self.OrderListModel.pay_refund.intValue==1?[bgview addSubview:_ensureStatuesLabel]:[_ensureStatuesLabel removeFromSuperview];
        if (self.OrderListModel.pay_refund.intValue==1) {
            [_ensureStatuesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_ensureLabel);
                make.right.equalTo(bgview).offset(-15);
            }];
        } else {
        }
    
        
        
        _priceLabel = [UILabel new];
        
        _priceLabel.text = @"￥69.00";
        _priceLabel.font = kFont(13);
        _priceLabel.textColor = kColor333;
        
        [bgview addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_itemNameLabel);
            make.right.equalTo(bgview).offset(-15);
        }];
        
        _old_priceLabel = [UILabel new];
        
        _old_priceLabel.text = @"￥89.00";
        _old_priceLabel.font = kFont(11);
        _old_priceLabel.textColor = kColor666;
        
        [bgview addSubview:_old_priceLabel];
        [_old_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_deliverLabel);
            make.right.equalTo(bgview).offset(-15);
        }];
        
        UIView *line = [UIView new];
        
        line.backgroundColor = kColor666;
        
        [_old_priceLabel addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_old_priceLabel);
            make.left.right.equalTo(_old_priceLabel);
            make.height.equalTo(@1);
        }];
        
        _countLabel = [UILabel new];
        
        _countLabel.text = @"X1";
        _countLabel.font = kFont(13);
        _countLabel.textColor = kColor666;
        
        [bgview addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_old_priceLabel.mas_bottom).offset(5);
            make.right.equalTo(bgview).offset(-15);
        }];
        
//        UILabel *alabel = [UILabel new];
//
//        alabel.font = kFont(13);
//        alabel.textColor = kColor333;
//        alabel.text = @"合计：";
//
//        [self.contentView addSubview:alabel];
//        [alabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_itemImageView);
//            make.top.equalTo(bgview.mas_bottom).offset(10);
//        }];
//
//        _sumLabel = [UILabel new];
//
//        _sumLabel.text = @"￥69.00";
//        _sumLabel.font = kFont(15);
//        _sumLabel.textColor = [UIColor colorWithHexString:@"d40000"];
//
//        [self.contentView addSubview:_sumLabel];
//        [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(alabel);
//            make.left.equalTo(alabel.mas_right);
//        }];
//
//        _postLabel = [UILabel new];
//
//        _postLabel.text = @"（含运费￥0.00）";
//        _postLabel.font = kFont(13);
//        _postLabel.textColor = kColor333;
//
//        [self.contentView addSubview:_postLabel];
//        [_postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_sumLabel);
//            make.left.equalTo(_sumLabel.mas_right);
//        }];
//
//        _itemCountLabel = [UILabel new];
//
//        _itemCountLabel.text = @"共1件";
//        _itemCountLabel.font = kFont(13);
//        _itemCountLabel.textColor = kColor333;
//
//        [self.contentView addSubview:_itemCountLabel];
//        [_itemCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_sumLabel);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
//
        UIView *line1 = [UIView new];

        line1.backgroundColor = kDefaultBGColor;

        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
            make.top.equalTo(bgview.mas_bottom).offset(15);
        }];
        
//        _rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [_rightBtn setTitle:@" 去付款 " forState:UIControlStateNormal];
//        _rightBtn.layer.cornerRadius = 3;
//        _rightBtn.titleLabel.font = kFont(15);
//        _rightBtn.layer.borderWidth = 1;
//        _rightBtn.layer.borderColor = [UIColor colorWithHexString:@"d40000"].CGColor;
//        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"d40000"] forState:UIControlStateNormal];
//
//        [self.contentView addSubview:_rightBtn];
//        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(25);
//            make.right.equalTo(self.contentView).offset(-15);
//            make.top.equalTo(line1.mas_bottom).offset(10);
//        }];
//
//        _leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [_leftBtn setTitle:@" 查看物流 " forState:UIControlStateNormal];
//        _leftBtn.layer.cornerRadius = 3;
//        _leftBtn.titleLabel.font = kFont(15);
//        _leftBtn.layer.borderWidth = 1;
//        _leftBtn.layer.borderColor = kDefaultBGColor.CGColor;
//        [_leftBtn setTitleColor:kColor333 forState:UIControlStateNormal];
//
//        [self.contentView addSubview:_leftBtn];
//        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(25);
////            make.right.equalTo(self.contentView).offset(-100);
//            make.right.equalTo(_rightBtn.mas_left).offset(-15);
//            make.top.equalTo(line1.mas_bottom).offset(10);
//        }];
        
    }
    return self;
}

- (void)setOrderListModel:(OrderListModel *)OrderListModel {
    _OrderListModel = OrderListModel;
    NSString *order_amountstring=[NSString stringWithFormat:@"￥%.2f",OrderListModel.order_amount];
    kStringIsEmpty(order_amountstring)?:[self.sumLabel setText:order_amountstring];
    if (OrderListModel.pay_refund.intValue==1 && OrderListModel.business_status.intValue==0) {
        [_ensureStatuesLabel setText:@"退款中"];
    }else if (OrderListModel.pay_refund.intValue==2 && OrderListModel.business_status.intValue==1){
        [_ensureStatuesLabel setText:@"退款成功"];
    }else if (OrderListModel.pay_refund.intValue==1 && OrderListModel.business_status.intValue==2){
        [_ensureStatuesLabel setText:@"退款失败"];
    }
}
- (void)setGoodListModel:(GoodListModel *)GoodListModel{
    _GoodListModel = GoodListModel;
    
    [self.storeNameBtn setTitle:[GoodListModel.name stringByAppendingString:@">"] forState:UIControlStateNormal];
    
    kStringIsEmpty(GoodListModel.original_img)?:[self.itemImageView sd_setImageWithURL:[NSURL URLWithString:[defaultUrl stringByAppendingString:GoodListModel.original_img]]];
    kStringIsEmpty(GoodListModel.goods_name)?:[self.itemNameLabel setText:GoodListModel.goods_name];
    kStringIsEmpty(GoodListModel.goods_num)?:[self.itemCountLabel setText:[NSString stringWithFormat:@"共%@件",GoodListModel.goods_num]];
    kStringIsEmpty(GoodListModel.goods_num)?:[self.countLabel setText:[@"X" stringByAppendingString:GoodListModel.goods_num]];
    NSString *goods_pricestring=[NSString stringWithFormat:@"￥%.2f", GoodListModel.goods_price];
    kStringIsEmpty(goods_pricestring)?:[self.priceLabel setText:goods_pricestring];
    NSString *market_pricestring=[NSString stringWithFormat:@"￥%.2f", GoodListModel.market_price];
    kStringIsEmpty(market_pricestring)?:[self.old_priceLabel setText:market_pricestring];
    self.deliverLabel.text = GoodListModel.spec_key_name;
    //    self.conditionLabel.text = ;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
