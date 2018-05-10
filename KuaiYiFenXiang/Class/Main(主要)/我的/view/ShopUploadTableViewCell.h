//
//  ShopUploadTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/27.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopUploadTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^clickHandler) (NSInteger index);

- (UIButton *)btn1;
- (UIButton *)btn2;
- (UIButton *)btn3;
@end
