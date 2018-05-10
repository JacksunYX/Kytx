//
//  CancelOrderPopoverView.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelOrderPopoverView : UIView
@property (nonatomic, copy) void(^didClickOktHandler)(NSString *selectstring);
@end
