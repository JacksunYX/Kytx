//
//  KYMyOrderTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/30.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYMyOrderTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^checkAllOrderHandler)();
@property (nonatomic, copy) void(^clickHandler)(NSInteger type);

-(void)dot1WithText:(NSString *)text;
-(void)dot2WithText:(NSString *)text;
-(void)dot3WithText:(NSString *)text;
-(void)dot4WithText:(NSString *)text;
-(void)dot5WithText:(NSString *)text;

@end
