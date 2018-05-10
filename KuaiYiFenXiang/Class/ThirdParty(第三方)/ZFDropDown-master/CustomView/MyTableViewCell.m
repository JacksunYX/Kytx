//
//  MyTableViewCell.m
//  ZFDropDownDemo
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MyTableViewCell.h"
#import "ZFColor.h"

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    
    
//    self.imgView = [[UIImageView alloc] init];
//    [self.contentView addSubview:self.imgView];
//    self.imgView.sd_layout
//    .centerYEqualToView(self.contentView)
//    .leftSpaceToView(self.contentView, 10)
//    .widthIs(20)
//    .heightIs(20);
//    
//    self.txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, 146, 34)];
//    self.txtLabel.numberOfLines = 0;
//    self.txtLabel.textColor = ZFSystemBlue;
//    self.txtLabel.font = [UIFont systemFontOfSize:14.f];
//    [self.contentView addSubview:self.txtLabel];
//    
//    self.subTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 100, 34)];
//    self.subTxtLabel.numberOfLines = 0;
//    self.subTxtLabel.textColor = ZFLightGray;
//    self.subTxtLabel.font = [UIFont systemFontOfSize:13.f];
//    [self.contentView addSubview:self.subTxtLabel];
    
    
    self.txtLabel = [[UILabel alloc] init];
    self.txtLabel.numberOfLines = 0;
    self.txtLabel.textColor = [UIColor blackColor];
    self.txtLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:self.txtLabel];
    self.textLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .centerXEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self.txtLabel setSingleLineAutoResizeWithMaxWidth:100];
    
}

@end
