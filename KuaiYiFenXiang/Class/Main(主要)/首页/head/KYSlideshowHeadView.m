//
//  DCSlideshowHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "KYSlideshowHeadView.h"

@interface KYSlideshowHeadView ()<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;


@end

@implementation KYSlideshowHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setUpUI
{
    
    NSLog(@"%@",self.imageURLStringsGroup);

    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) delegate:self placeholderImage:nil];
    _cycleScrollView.pageDotImage=[UIImage imageNamed:@"PageDotImage"];
    _cycleScrollView.currentPageDotImage=[UIImage imageNamed:@"currentPageDotImage"];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    _cycleScrollView.imageURLStringsGroup = self.imageURLStringsGroup;
    
    [self addSubview:_cycleScrollView];
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    
    __weak typeof(self) weakself = self;
    
    if (weakself.kyslideshowheadviewBlock) {
        //将自己的值传出去，完成传值
        weakself.kyslideshowheadviewBlock(index);
    }

}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setUpUI];
}

#pragma mark - Setter Getter Methods


@end
