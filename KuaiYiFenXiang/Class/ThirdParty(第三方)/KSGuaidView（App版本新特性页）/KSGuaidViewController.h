//
//  KSGuaidViewController.h
//  KSGuaidViewDemo
//
//  Created by Mr.kong on 2017/5/24.
//  Copyright © 2017年 Bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSGuaidViewDelegate <NSObject>

@optional

/**
 点击了中间的立即体验按钮
 */
-(void)haveClickCenterBtn;

@end

@interface KSGuaidViewController : UIViewController

@property (nonatomic, strong) NSArray<NSString*>* imageNames;

@property (nonatomic, copy) dispatch_block_t shouldHidden;

@property (nonatomic ,weak) id<KSGuaidViewDelegate> delegate;

@end

UIKIT_EXTERN NSString * const kLastNullImageName;

UIKIT_EXTERN NSString * const kImageNamesArray;

UIKIT_EXTERN NSString * const kHiddenBtnImageName;

UIKIT_EXTERN NSString * const kHiddenBtnCenter;

