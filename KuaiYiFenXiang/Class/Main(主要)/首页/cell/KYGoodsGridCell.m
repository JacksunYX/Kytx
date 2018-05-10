//
//  KYGoodsGridCell.m
//  KuaiYiFenXiang
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "KYGoodsGridCell.h"


// Models
#import "KYGridItem.h"

@interface KYGoodsGridCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* label */
@property (strong , nonatomic)UILabel *gridLabel;
@end

@implementation KYGoodsGridCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_gridImageView];
    
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = PFR13Font;
    _gridLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_gridLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:10];
        if (SCREEN_HEIGHT == 568) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }else{
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_gridImageView. mas_bottom)setOffset:5];
    }];
}

#pragma mark - Setter Getter Methods
- (void)setGridItem:(KYGridItem *)gridItem
{
    
    _gridItem = gridItem;
    
//    [_gridImageView sd_setImageWithURL:[NSURL URLWithString:gridItem.iconImage]];
    
    [_gridImageView setImage:[UIImage imageNamed:gridItem.iconImage]];
    
    _gridLabel.text = gridItem.gridTitle;
    
}

@end
