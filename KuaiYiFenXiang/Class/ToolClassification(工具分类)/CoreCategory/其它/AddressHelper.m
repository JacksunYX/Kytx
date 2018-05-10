//
//  AddressHelper.m
//  KuaiYiFenXiang
//
//  Created by IMAC on 2018/4/13.
//  Copyright © 2018年 YiHeHengRui. All rights reserved.
//

#import "AddressHelper.h"
#import "AreaModel.h"
#import "KYAddressModel.h"
#import "KYHeader.h"


@interface AddressHelper ()
{
    NSArray *areaArray;     //地域数组
    NSArray *adressArray;   //地址数组
}
@end

@implementation AddressHelper

-(void)getArearList
{
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"area.plist"];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:docPath];
    if (!arr || arr.count == 0) {
        [HttpRequest postWithURLString:NetRequestUrl(arealist) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
            if ([res[@"code"] integerValue] == 1) {
                NSArray *temp = res[@"result"];
                [temp writeToFile:docPath atomically:YES];
                areaArray = [AreaModel mj_objectArrayWithKeyValuesArray:temp];
            }
        } failure:nil RefreshAction:nil];
    }else{
        areaArray = [AreaModel mj_objectArrayWithKeyValuesArray:arr];
    }
}

-(void)getAdressList
{
    [HttpRequest postWithTokenURLString:NetRequestUrl(getaddress) parameters:[@{} mutableCopy] isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        adressArray = [KYAddressModel mj_objectArrayWithKeyValuesArray:res[@"result"]];
        
    } failure:^(NSError *error) {
        NSLog(@"获取地址列表失败");
    } RefreshAction:nil];
}

// 删除沙盒里的文件
+(void)deleteAreaFile:(NSString *)fileName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath = [paths.lastObject stringByAppendingPathComponent:fileName];
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"区域文件删除成功");
        }else {
            NSLog(@"区域文件删除失败");
        }
    }
}




@end
