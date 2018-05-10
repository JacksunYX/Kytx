//
//  DCBrandSortCell.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCBrandSortCell.h"

// Controllers

// Models
#import "DCClassMianItem.h"
#import "DCCalssSubItem.h"
// Views

// Vendors
// Categories

// Others

@interface DCBrandSortCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *brandImageView;

@end

@implementation DCBrandSortCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _brandImageView = [[UIImageView alloc] init];
    _brandImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_brandImageView];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [_brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.width - 20, self.height - 25));
    }];
}

#pragma mark - Setter Getter Methods
- (void)setSubItem:(DCCalssSubItem *)subItem
{
    _subItem = subItem;
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString:subItem.image_url]];
}

@end
