//
//  TheStoreModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/1/15.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheStoreModel : NSObject

@property (nonatomic, copy ) NSString *business_id;

@property (nonatomic, copy ) NSString *logo;

@property (nonatomic, copy ) NSString *name;

@property (nonatomic, copy ) NSString *enterStoreString;

@property (nonatomic, copy ) NSString *sale_num;

@property (nonatomic, copy ) NSString *good_num;

@property (copy , nonatomic )NSArray *shopPictureArray;

@property (copy , nonatomic )NSString *type;

@property (assign , nonatomic )NSInteger ratio;

@property (assign , nonatomic )NSInteger multiple;

@property (nonatomic,copy) NSString *sell_total;

@property (nonatomic,assign) NSInteger sign;    //是否收藏了店铺：1未收藏，2已收藏

@end
