//
//  GetLocation.m
//  GlobalAuto
//
//  Created by Longxia on 16/7/8.
//  Copyright © 2016年 jmhqmc. All rights reserved.
//

#import "GetLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface GetLocation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic ,assign) CLLocationCoordinate2D FromCoords;
@property (nonatomic ,assign) BOOL isAble;
@end

@implementation GetLocation

+(GetLocation *)getLocationManager{
    static GetLocation *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[GetLocation alloc] init];
        //创建CLLocationManager对象并设置代理
        manager.locationManager = [[CLLocationManager alloc]init];
        manager.locationManager.delegate = manager;
        //设置定位精度和位置更新最小距离
        manager.locationManager.distanceFilter = 50;
        manager.locationManager.desiredAccuracy = kCLLocationAccuracyBest; //设置定位精确度
        [manager.locationManager requestWhenInUseAuthorization];
    });
    
    return manager;
}

- (void)getMyLocation{
    
    if (!self.isAble) {
        if (self.block) {
            self.block(nil);
            return;
        }
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{//用户还未决定
            NSLog(@"用户还未决定");
            self.isAble = NO;
            self.block(nil);
            break;
        }
        case kCLAuthorizationStatusRestricted:{//访问受限
            NSLog(@"访问受限");
            self.isAble = NO;
            self.block(nil);
            break;
        }
        case kCLAuthorizationStatusDenied:{//定位关闭时或用户APP授权为永不授权时调用
            NSLog(@"定位关闭或者用户未授权");
            self.isAble = NO;
            self.block(nil);
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{//获取前后台定位授权
            NSLog(@"获取前后台定位授权");
            self.isAble = YES;
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{//获得前台定位授权
            NSLog(@"获得前台定位授权");
            self.isAble = YES;

            break;
        }
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.FromCoords = manager.location.coordinate;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@(self.FromCoords.latitude) forKey:@"latitude"];
    [dict setObject:@(self.FromCoords.longitude) forKey:@"longitude"];
    
    CLGeocoder *geo = [[CLGeocoder alloc] init];
    [geo reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks.firstObject;
//        NSLog(@"%@", mark);
        NSString *firstText = [mark.administrativeArea stringByAppendingString:@" "];
        NSString *secondText = [mark.locality stringByAppendingString:@" "];
        NSString *str = [[firstText stringByAppendingString:secondText] stringByAppendingString:mark.subLocality];
        dict[@"text"] = str;
        dict[@"obj"] = mark;
        self.block(dict);
    }];
    //如果不需要实时定位，使用完即使关闭定位服务
    [self.locationManager stopUpdatingLocation];
}

@end
