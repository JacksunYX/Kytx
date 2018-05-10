//
//  RegisterSuccessfulPopoversView.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterSuccessfulPopoversView : UIView

-(void)drawView:(NSString*)titleString;

@property (nonatomic, copy) dispatch_block_t alertViewDidCloseBlock;


@end
