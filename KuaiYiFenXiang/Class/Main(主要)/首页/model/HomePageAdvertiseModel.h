//
//  HomePageAdvertiseModel.h
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageAdvertiseModel : NSObject

@property (nonatomic, copy) NSString *ad_id;
@property (nonatomic, copy) NSString *image;        //主图
@property (nonatomic, copy) NSString *son_image;    //子图
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *click_count;  //点击量
@property (nonatomic, copy) NSString *is_show;      //是否显示
@property (nonatomic, copy) NSString *add_time;     //添加时间

@end


@interface AdvertiseSonModel : NSObject
@property (nonatomic, copy) NSString *son_id;   //当前id
@property (nonatomic, copy) NSString *image;    //图片
@property (nonatomic, copy) NSString *goods_id; //商品id
@property (nonatomic, copy) NSString *p_id;     //父id
@property (nonatomic, copy) NSString *hidden;   //是否显示

@end
