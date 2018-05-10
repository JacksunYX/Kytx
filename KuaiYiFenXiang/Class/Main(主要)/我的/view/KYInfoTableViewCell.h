//
//  KYInfoTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/23.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField *holder;

@end
