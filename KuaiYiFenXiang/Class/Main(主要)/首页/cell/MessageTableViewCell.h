//
//  MessageTableViewCell.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/17.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageTableViewCell : UITableViewCell


/**
 *  内容模型
 */
@property(nonatomic,strong) MessageModel *MessageModel;

+(instancetype)mainTableViewCellWithTableView:(UITableView *)tableView;

@end
