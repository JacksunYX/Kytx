//
//  WLCaptcheButton.m
//  WLButtonCountingDownDemo
//
//  Created by wayne on 16/1/14.
//  Copyright © 2016年 ZHWAYNE. All rights reserved.
//

#import "WLCaptcheButton.h"
#import "WLButtonCountdownManager.h"

@interface WLCaptcheButton ()


@end

@implementation WLCaptcheButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"***> %s [%@]", __func__, _identifyKey);
}

- (void)initialize {
    self.identifyKey        = NSStringFromClass([self class]);
    self.clipsToBounds      = YES;
    self.layer.cornerRadius = 4;
    [self addSubview:self.overlayLabel];
}

- (UILabel *)overlayLabel {
    if (!_overlayLabel) {
        _overlayLabel                 = [UILabel new];
        _overlayLabel.textColor       = self.titleLabel.textColor;
        _overlayLabel.backgroundColor = self.backgroundColor;
        _overlayLabel.font            = self.titleLabel.font;
        _overlayLabel.textAlignment   = NSTextAlignmentCenter;
        _overlayLabel.hidden          = YES;
    }
    
    return _overlayLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.overlayLabel.frame = self.bounds;
    
    if ([[WLButtonCountdownManager defaultManager] countdownTaskExistWithKey:self.identifyKey task:nil]) {
        [self shouldCountDown];
    }
}


- (void)shouldCountDown {
    self.enabled             = NO;
    self.titleLabel.alpha    = 0;
    self.overlayLabel.hidden = NO;
    self.overlayLabel.text   = self.titleLabel.text;
    [self.overlayLabel setBackgroundColor:self.disabledBackgroundColor ?: self.backgroundColor];
    [self.overlayLabel setTextColor:self.disabledTitleColor ?: self.titleLabel.textColor];
    __weak __typeof(self) weakSelf = self;
    [[WLButtonCountdownManager defaultManager] scheduledCountDownWithKey:self.identifyKey timeInterval:10 countingDown:^(NSTimeInterval leftTimeInterval) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.overlayLabel.text = [NSString stringWithFormat:@"重新发送(%@)", @(leftTimeInterval)];
    } finished:^(NSTimeInterval finalTimeInterval) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.enabled             = YES;
        strongSelf.overlayLabel.hidden = YES;
        strongSelf.titleLabel.alpha    = 1;
        [strongSelf setTitle:@"重新发送" forState:UIControlStateNormal];
        [strongSelf.overlayLabel setBackgroundColor:strongSelf.backgroundColor];
        [strongSelf.overlayLabel setTextColor:strongSelf.titleLabel.textColor];
    }];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (![[self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside] count]) {
        return;
    }
    
    [super sendAction:action to:target forEvent:event];
}

- (void)fire {
    [self shouldCountDown];
}

@end
