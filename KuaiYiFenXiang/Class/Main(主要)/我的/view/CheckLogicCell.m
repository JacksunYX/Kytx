//
//  CheckLogicCell.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/5/16.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "CheckLogicCell.h"

@implementation CheckLogicModel

@end

@interface CheckLogicCell ()
{
    UIImageView *goodImg;
    UILabel     *goodName;
    UILabel     *describe;  //描述
    UILabel     *goodPrice;
    UILabel     *originalPrice;
}

@end

@implementation CheckLogicCell

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
        [self setUI];
        self.contentView.backgroundColor = kWhiteColor;
    }
    return self;
}

-(void)setUI
{
    goodImg = [UIImageView new];
    goodImg.backgroundColor = hwrandomcolor;
    
    goodName = [UILabel new];
    goodName.font = Font(13);
    goodName.textColor = HexColor(525252);
    
    describe = [UILabel new];
    describe.font = Font(10);
    describe.textColor = HexColor(999999);
    
    goodPrice = [UILabel new];
    goodPrice.font = Font(13);
    goodPrice.textColor = kColord40;
    
    originalPrice = [UILabel new];
    originalPrice.font = Font(10);
    originalPrice.textColor = HexColor(999999);
    
    UIView *line = [UIView new];
    line.backgroundColor = HexColor(999999);
    
    [self.contentView sd_addSubviews:@[
                                       goodImg,
                                       goodName,
                                       describe,
                                       goodPrice,
                                       originalPrice,
                                       line,
                                       
                                       ]];
    goodImg.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(75)
    .widthEqualToHeight()
    ;
    
    goodName.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(goodImg, 10)
    .heightIs(15)
    ;
    [goodName setSingleLineAutoResizeWithMaxWidth:ScreenW/2];
    goodName.text = @"芒果爱莲芒果爱莲芒果爱莲芒果爱莲芒果爱莲芒果爱莲芒果爱莲";
    
    describe.sd_layout
    .topSpaceToView(goodName, 5)
    .leftEqualToView(goodName)
    .heightIs(10)
    ;
    [describe setSingleLineAutoResizeWithMaxWidth:ScreenW/2];
    describe.text = @"同城配送";
    
    goodPrice.sd_layout
    .bottomSpaceToView(self.contentView, 15)
    .leftEqualToView(goodName)
    .heightIs(10)
    ;
    [goodPrice setSingleLineAutoResizeWithMaxWidth:ScreenW/2];
    goodPrice.text = @"￥60.00";
    
    originalPrice.sd_layout
    .centerYEqualToView(goodPrice)
    .leftSpaceToView(goodPrice, 5)
    .heightIs(10)
    ;
    [originalPrice setSingleLineAutoResizeWithMaxWidth:ScreenW/2];
    originalPrice.text = @"￥80.00";
    

    line.sd_layout
    .widthRatioToView(originalPrice, 1)
    .centerYEqualToView(originalPrice)
    .leftEqualToView(originalPrice)
    .heightIs(0.5)
    ;
    
}

-(void)setModel:(CheckLogicModel *)model
{
    _model = model;
}












@end
