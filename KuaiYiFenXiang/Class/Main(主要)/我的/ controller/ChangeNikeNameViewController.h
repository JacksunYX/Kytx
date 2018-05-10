//
//  ChangeNikeNameViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 将保存的新昵称带回

 @param newNickName 新昵称
 */
typedef void(^getSaveNickName)(NSString *newNickName);

@interface ChangeNikeNameViewController : UIViewController
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic,copy) getSaveNickName getSaveNickNameBlock;

@end
