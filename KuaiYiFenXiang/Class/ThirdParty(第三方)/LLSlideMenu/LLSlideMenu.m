//
//  LLSideMune.m
//  LLSideMenuDemo
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 LiLei. All rights reserved.
//

#import "LLSlideMenu.h"
#import "UIView+SetRect.h"
#import "LLDisplayLayer.h"
#import "LLCircleLayer.h"

#define LL_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define LL_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LLSlideMenu ()<UIGestureRecognizerDelegate>



// 菜单显示的View
@property (nonatomic, strong) UIView *displayView;

// 点击关闭菜单的Button
@property (nonatomic, strong) UIButton *closeMenuButton;

// displayLayer
@property (nonatomic, strong) LLDisplayLayer *displayLayer;

// circleLayer
@property (nonatomic, strong) LLCircleLayer *circleLayer;

@property (nonatomic, assign) BOOL isOverLoad;



@property (nonatomic, strong) UISwipeGestureRecognizer * recognizer;

@property (nonatomic, strong) UITapGestureRecognizer * singleRecognizer;

@end

@implementation LLSlideMenu


//=====================
// 初始化
//=====================
- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT)];
    if (self) {
        
        [self setUserInteractionEnabled:YES];
        
        
        //视图添加左滑手势   左滑执行关闭操作
        self.recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        self.recognizer.delegate=self;
        [self addGestureRecognizer:self.recognizer];
        
        
        self.singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ll_closeSlideMenu)];
        //点击的次数
        self.singleRecognizer.numberOfTapsRequired = 1; // 单击
        self.singleRecognizer.delegate=self;//这句不要漏掉
        //给self.view添加一个手势监测；
        [self addGestureRecognizer:self.singleRecognizer];
        
        
        
        [self initSetUpView];
        
    }
    
    
    return self;
    
    
}

#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

//避免tableview上下滑动和自己添加的手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}



//=====================
// 初始化界面
//=====================
- (void)initSetUpView {
    _isOverLoad = NO;
    [self.layer addSublayer:self.displayLayer];
    _displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, LL_SCREEN_HEIGHT)];
    //    _displayView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.displayView];
    
    // 隐藏
    self.hidden = YES;
    // 动画管理
    _ll_animManager = [LLAnimationManager new];
    _ll_animManager.isAnimating = NO;
    _ll_animManager.llSildeMenu = self;
    _ll_animManager.circleLayer = _circleLayer;
    _ll_isOpen = NO;
    
    // 设置默认弹力大小和关键帧数量
    _ll_animManager.springDamping = 20.f;
    _ll_animManager.springVelocity = 15.f;
    _ll_animManager.springNumOfFrames = 60;
}



//=====================
// 设置View宽度
//=====================
- (void)setLl_menuWidth:(CGFloat)ll_menuWidth {
    _ll_menuWidth = ll_menuWidth;
    _displayView.width = ll_menuWidth;
    self.closeMenuButton.x = ll_menuWidth;
    self.closeMenuButton.width = LL_SCREEN_WIDTH - ll_menuWidth;
    self.displayLayer.bgWidth = ll_menuWidth;
    
    _ll_animManager.layer = _displayLayer;
    _ll_animManager.circleLayer = self.circleLayer;
}

//=====================
// 设置滑动偏移距离
//=====================
- (void)setLl_distance:(CGFloat)ll_distance {
    _ll_distance = ll_distance;
    self.hidden = NO;
    self.displayLayer.distance = ll_distance;
    _displayLayer.isAnimating = NO;
    _ll_animManager.isAnimating = NO;
    [_displayLayer setNeedsDisplay];
}

//=================================
// 添加menu背景色
//=================================
- (void)setLl_menuBackgroundColor:(UIColor *)ll_menuBackgroundColor {
    _ll_menuBackgroundColor = ll_menuBackgroundColor;
    _displayLayer.menuBgColor = ll_menuBackgroundColor;
}

//=================================
// 添加menu背景图片
//=================================
- (void)setLl_menuBackgroundImage:(UIImage *)ll_menuBackgroundImage {
    _ll_menuBackgroundImage = ll_menuBackgroundImage;
    _displayLayer.menuBgColor = [UIColor colorWithPatternImage:ll_menuBackgroundImage];
}

//=================================
// 设置弹力程度和关键帧数量
//=================================
- (void)setLl_springDamping:(CGFloat)ll_springDamping {
    _ll_springDamping = ll_springDamping;
    _ll_animManager.springDamping = ll_springDamping;
}

- (void)setLl_springVelocity:(CGFloat)ll_springVelocity {
    _ll_springVelocity = ll_springVelocity;
    _ll_animManager.springVelocity = ll_springVelocity;
}

- (void)setLl_springFramesNum:(NSInteger)ll_springFramesNum {
    _ll_springFramesNum = ll_springFramesNum;
    _ll_animManager.springNumOfFrames = ll_springFramesNum;
}


//=====================
// 关闭菜单
//=====================
- (void)ll_closeSlideMenu {
    if (_ll_animManager.isAnimating) {
        return;
    }
    _displayLayer.isAnimating = YES;
    _closeMenuButton.hidden = YES;
    _ll_animManager.isAnimating = YES;
    [_ll_animManager endAnimate];
}

//=====================
// 打开菜单
//=====================
- (void)ll_openSlideMenu {
    if (_ll_animManager.isAnimating) {
        return;
    }
    self.hidden = NO;
    _displayLayer.isAnimating = NO;
    _closeMenuButton.hidden = NO;
    _ll_animManager.isAnimating = YES;
    [_ll_animManager startAnimate];
}

//=================================
// 添加View直接添加到displayView上
//=================================
- (void)addSubview:(UIView *)view {
    if (view != _displayView && view != _closeMenuButton) {
        [_displayView addSubview:view];
    } else {
        [super addSubview:view];
    }
}

- (BOOL)ll_isAnimating {
    return _ll_animManager.isAnimating;
}


//#pragma 懒加载
//- (UIButton *)closeMenuButton {
//    if (!_closeMenuButton) {
//        _closeMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT)];
//        _closeMenuButton.hidden = YES;
//        [_closeMenuButton addTarget:self action:@selector(ll_closeSlideMenu) forControlEvents:UIControlEventTouchUpInside];
//        [_closeMenuButton  setUserInteractionEnabled:YES];
//
//
//        //视图添加左滑手势   左滑执行关闭操作
//        self.recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//        [_closeMenuButton addGestureRecognizer:self.recognizer];
//
//
//
//        [self addSubview:_closeMenuButton];
//
//
//
//    }
//    return _closeMenuButton;
//}

//监听滑动手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        [self ll_closeSlideMenu];
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
    }
}




- (LLDisplayLayer *)displayLayer {
    if (!_displayLayer) {
        _displayLayer = [[LLDisplayLayer alloc] init];
        [_displayLayer setFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT)];
        // layer添加阴影
        _displayLayer.shadowOffset = CGSizeMake(0, 3);
        _displayLayer.shadowRadius = 5.0;
        _displayLayer.shadowColor = [UIColor blackColor].CGColor;
        _displayLayer.shadowOpacity = 0.6;
    }
    return _displayLayer;
}

- (LLCircleLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[LLCircleLayer alloc] init];
        [_circleLayer setFrame:CGRectMake(0, 0, _displayView.width, _displayView.height)];
        _circleLayer.radius = 0;
        _circleLayer.center = _displayView.center;
        _displayView.layer.mask = self.circleLayer;
    }
    return _circleLayer;
}

@end
