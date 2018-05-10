//
//  AddressViewController.h
//  KuaiYiFenXiang
//
//  Created by 李遨东 on 2018/1/31.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 删除地址后的回调

 @param deletedAddress_id 返回删除的地址id
 */
typedef void (^deleteAddress)(NSString *deletedAddress_id);


/**
 编辑地址后的回调

 @param editeAddress_id 返回编辑后的地址
 */
typedef void(^editeAddress)(NSString *editeAddress_id);

@class KYAddressModel;
@interface AddressViewController : UIViewController
@property (nonatomic, copy) void(^didSelectedAddressHander)(KYAddressModel *model);

@property (nonatomic,copy) deleteAddress deleteAddressBlock;

@property (nonatomic,copy) editeAddress editeAddressBlock;

@property (nonatomic,assign) NSInteger titleType;   //标题类型







@end
