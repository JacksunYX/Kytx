//
//  AdvertiseSonNewCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/26.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "AdvertiseSonNewCell.h"

@interface AdvertiseSonNewCell()
{
    //左边
    UIView *leftBackView;
    UIImageView *leftImg;
    UILabel *leftGoodName;
    UILabel *leftOriginalPrice;
    UILabel *leftCurrentPrice;
    UIImageView *leftAddShopCartImg;
    UIView *leftGrayline;
    
    //右边
    UIView *rightBackView;
    UIImageView *rightImg;
    UILabel *rightGoodName;
    UILabel *rightOriginalPrice;
    UILabel *rightCurrentPrice;
    UIImageView *rightAddShopCartImg;
    UIView *rightGrayline;
    UIView *rightBottomView;
    
}
@property (nonatomic,strong) GeneralGoodsModel *leftModel;
@property (nonatomic,strong) GeneralGoodsModel *rightModel;

@end

@implementation AdvertiseSonNewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    [self addleftViews];
    
    [self addrightViews];
}

-(void)addleftViews
{
    leftBackView = [UIView new];
    leftImg = [UIImageView new];
    leftImg.userInteractionEnabled = YES;
//    leftImg.backgroundColor = hwrandomcolor;
    
    leftGoodName = [UILabel new];
    leftGoodName.font = PFR13Font;
    leftGoodName.textColor = [UIColor blackColor];
    leftGoodName.numberOfLines = 2;
//    leftGoodName.backgroundColor = hwrandomcolor;
    
    leftOriginalPrice = [UILabel new];
    leftOriginalPrice.font = PFR10Font;
    leftOriginalPrice.textColor = [UIColor grayColor];
    leftOriginalPrice.textAlignment = NSTextAlignmentCenter;
    leftOriginalPrice.numberOfLines = 1;
//    leftOriginalPrice.backgroundColor = hwrandomcolor;
    
    leftCurrentPrice = [UILabel new];
    leftCurrentPrice.font = PFR13Font;
    leftCurrentPrice.textColor = [UIColor redColor];
    leftCurrentPrice.textAlignment = NSTextAlignmentCenter;
    leftCurrentPrice.numberOfLines = 1;
//    leftCurrentPrice.backgroundColor = hwrandomcolor;
    
    leftAddShopCartImg = [UIImageView new];
//    leftAddShopCartImg.backgroundColor = hwrandomcolor;
    
    leftGrayline = [UIView new];
    leftGrayline.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:leftBackView];
    leftBackView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs((ScreenW - 5)/2)
    ;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick:)];
    leftTap.numberOfTapsRequired = 1;
    [leftBackView addGestureRecognizer:leftTap];
    
    [leftBackView sd_addSubviews:@[
                                       
                                   leftImg,

                                       ]];
    
    [self sdLeftView];
}

-(void)addrightViews
{
    rightBackView = [UIView new];
    rightImg = [UIImageView new];
    rightImg.userInteractionEnabled = YES;
//    rightImg.backgroundColor = hwrandomcolor;
    
    rightGoodName = [UILabel new];
    rightGoodName.font = PFR13Font;
    rightGoodName.textColor = [UIColor blackColor];
    rightGoodName.numberOfLines = 2;
//    rightGoodName.backgroundColor = hwrandomcolor;
    
    rightOriginalPrice = [UILabel new];
    rightOriginalPrice.font = PFR10Font;
    rightOriginalPrice.textColor = [UIColor grayColor];
    rightOriginalPrice.textAlignment=NSTextAlignmentCenter;
    rightOriginalPrice.numberOfLines = 1;
//    rightOriginalPrice.backgroundColor = hwrandomcolor;
    
    rightCurrentPrice = [UILabel new];
    rightCurrentPrice.font = PFR13Font;
    rightCurrentPrice.textColor = [UIColor redColor];
    rightCurrentPrice.textAlignment = NSTextAlignmentCenter;
    rightCurrentPrice.numberOfLines = 1;
//    rightCurrentPrice.backgroundColor = hwrandomcolor;
    
    rightAddShopCartImg = [UIImageView new];
//    rightAddShopCartImg.backgroundColor = hwrandomcolor;
    
    rightGrayline = [UIView new];
    rightGrayline.backgroundColor = [UIColor grayColor];
    
    
    [self.contentView addSubview:rightBackView];
    rightBackView.sd_layout
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs((ScreenW - 5)/2)
    ;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick:)];
    rightTap.numberOfTapsRequired = 1;
    [rightBackView addGestureRecognizer:rightTap];
    
    [rightBackView sd_addSubviews:@[
                                       
                                    rightImg,
                                       
                                       ]];
    
    [self sdrightView];
}

//加载数据
-(void)setDataLeft:(GeneralGoodsModel *)leftModel right:(GeneralGoodsModel *)rightModel
{
    _leftModel = leftModel;
    _rightModel = rightModel;
    if (leftModel) {
        [leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName, leftModel.original_img]] placeholderImage:nil];
        
        [leftGoodName setText:leftModel.goods_name];
        
        //中划线
        NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", leftModel.market_price] attributes:attribtDic];
        [leftOriginalPrice setAttributedText:attribtStr];
        
        [leftCurrentPrice setText:[NSString stringWithFormat:@"¥ %@", leftModel.shop_price]];
        
        [leftAddShopCartImg setImage:[UIImage imageNamed:@"addshoppingcarimage"]];
    }
    
    if (rightModel) {
        [self setRightViewHidden:NO];
        [rightImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName, rightModel.original_img]] placeholderImage:nil];
        
        [rightGoodName setText:rightModel.goods_name];
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", rightModel.market_price] attributes:attribtDic];
        [rightOriginalPrice setAttributedText:attribtStr];
        
        [rightCurrentPrice setText:[NSString stringWithFormat:@"¥ %@", rightModel.shop_price]];
        
        [rightAddShopCartImg setImage:[UIImage imageNamed:@"addshoppingcarimage"]];
    }else{
        [self setRightViewHidden:YES];
    }
    
    //一定要调用布局方法进行布局
//    [self layoutSubviews];
}

-(void)setRightViewHidden:(BOOL)hide
{
    rightImg.hidden = hide;
    rightGoodName.hidden = hide;
    rightOriginalPrice.hidden = hide;
    rightCurrentPrice.hidden = hide;
    rightAddShopCartImg.hidden = hide;
    rightGrayline.hidden = hide;
    rightBottomView.hidden = hide;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
//    [self sdLeftView];
    
//    [self sdrightView];
    
}

-(void)sdLeftView
{
    CGFloat cellW = (ScreenW - 5)/2;
    
    leftImg.sd_layout
    .topSpaceToView(leftBackView, 9)
    .leftSpaceToView(leftBackView, 5)
    .widthIs(cellW - 5)
    .heightIs(cellW - 5);
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = kWhiteColor;
    [leftBackView addSubview:bottomView];
    bottomView.sd_layout
    .leftEqualToView(leftImg)
    .rightEqualToView(leftImg)
    .topSpaceToView(leftImg, 0)
    .heightIs(80)
    ;
    
    [bottomView sd_addSubviews:@[
                                 leftGoodName,
                                 leftCurrentPrice,
                                 leftOriginalPrice,
                                 leftGrayline,
                                 leftAddShopCartImg,
                                 ]];
    
    leftGoodName.sd_layout
    .topSpaceToView(bottomView, 5)
    .leftEqualToView(bottomView)
    .widthIs(cellW - 5)
    .heightIs(30)
    ;
    
    leftCurrentPrice.sd_layout
    .topSpaceToView(leftGoodName, 5)
    .leftEqualToView(leftGoodName)
    .heightIs(30)
    ;
    [leftCurrentPrice setSingleLineAutoResizeWithMaxWidth:cellW/2];
    
    leftOriginalPrice.sd_layout
    .leftSpaceToView(leftCurrentPrice, 5)
    .bottomEqualToView(leftCurrentPrice)
    .heightIs(30)
    ;
    [leftCurrentPrice setSingleLineAutoResizeWithMaxWidth:60];

    leftGrayline.sd_layout
    .centerYEqualToView(leftOriginalPrice)
    .centerXEqualToView(leftOriginalPrice)
    .heightIs(1)
    .widthIs(40);

    leftAddShopCartImg.sd_layout
    .centerYEqualToView(leftCurrentPrice)
    .rightSpaceToView(bottomView, 5)
    .widthIs(19)
    .heightIs(17)
    ;
    
}

-(void)sdrightView
{
    CGFloat cellW = (ScreenW - 5)/2;
    
    rightImg.sd_layout
    .topSpaceToView(rightBackView, 9)
    .rightSpaceToView(rightBackView, 5)
    .widthIs(cellW - 5)
    .heightIs(cellW - 5);
    
    rightBottomView = [UIView new];
    rightBottomView.backgroundColor = kWhiteColor;
    [rightBackView addSubview:rightBottomView];
    rightBottomView.sd_layout
    .leftEqualToView(rightImg)
    .rightEqualToView(rightImg)
    .topSpaceToView(rightImg, 0)
    .heightIs(80)
    ;
    [rightBottomView sd_addSubviews:@[
                                 rightGoodName,
                                 rightCurrentPrice,
                                 rightOriginalPrice,
                                 rightGrayline,
                                 rightAddShopCartImg,
                                 ]];
    
    
    rightGoodName.sd_layout
    .topSpaceToView(rightBottomView, 5)
    .leftEqualToView(rightBottomView)
    .widthIs(cellW - 5)
    .heightIs(30)
    ;
    
    rightCurrentPrice.sd_layout
    .topSpaceToView(rightGoodName, 5)
    .leftEqualToView(rightGoodName)
    .heightIs(30)
    ;
    [rightCurrentPrice setSingleLineAutoResizeWithMaxWidth:cellW/2];
    
    rightOriginalPrice.sd_layout
    .leftSpaceToView(rightCurrentPrice, 5)
    .bottomEqualToView(rightCurrentPrice)
    .heightIs(30)
    ;
    [rightOriginalPrice setSingleLineAutoResizeWithMaxWidth:60];
    
    rightGrayline.sd_layout
    .centerYEqualToView(rightOriginalPrice)
    .centerXEqualToView(rightOriginalPrice)
    .heightIs(1)
    .widthIs(40);
    
    rightAddShopCartImg.sd_layout
    .centerYEqualToView(rightCurrentPrice)
    .rightSpaceToView(rightBottomView, 5)
    .widthIs(19)
    .heightIs(17)
    ;
    
}

-(void)leftClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击了第%ld行的左边",self.tag);
    if ([self.delegate respondsToSelector:@selector(clickHandleGoodsData:)]) {
        [self.delegate clickHandleGoodsData:self.leftModel];
    }
}

-(void)rightClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击了第%ld行的右边",self.tag);
    if (_rightModel) {  //不为空时才回调
        if ([self.delegate respondsToSelector:@selector(clickHandleGoodsData:)]) {
            [self.delegate clickHandleGoodsData:self.rightModel];
        }
    }
}

@end
