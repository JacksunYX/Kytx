//
//  PointRankTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/2/8.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointRankTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageview;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, assign) NSInteger type;

@end
