//
//  MineBaseViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineBaseViewController : UIViewController
@property (nonatomic, strong) NSString *tn;
@property (nonatomic, strong) NSString *info;

-(void)doBalancePay:(NSString *)orderstring andorder_amount:(NSString *)order_amount andtypestring:(NSString *)typestring;
- (void)doAPPayAnmount:(CGFloat)price;
-(void)doUPPay;
- (NSDictionary *)validDict:(NSDictionary *)dict;
- (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
