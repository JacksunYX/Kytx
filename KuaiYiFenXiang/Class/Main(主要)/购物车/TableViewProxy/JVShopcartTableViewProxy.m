//
//  JVShopcartTableViewProxy.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartTableViewProxy.h"

#import "JVShopcartBrandModel.h"
#import "JVShopcartCell.h"
#import "JVShopcartHeaderView.h"
#import "JVShopcartFooterView.h"

#import "DCEmptyCartView.h"

@interface JVShopcartTableViewProxy ()<RefreshFootViewDelegate>
@property (nonatomic,strong) JVShopcartFooterView *shopcartFooterView;
@end

@implementation JVShopcartTableViewProxy

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (kArrayIsEmpty(self.dataArray)) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (kArrayIsEmpty(self.dataArray)) {
        return 0;
    }else{
        JVShopcartBrandModel *brandModel = self.dataArray[section];
        NSArray *productArray = brandModel.products;
        return productArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JVShopcartCell *cell = [JVShopcartCell mainTableViewCellWithTableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
    NSArray *productArray = brandModel.products;
    
    
    if (productArray.count > indexPath.row) {
        cell.JVShopcartProductModel=productArray[indexPath.row];
    }
    
    __weak __typeof(self) weakSelf = self;
    cell.shopcartCellBlock = ^(BOOL isSelected){
        if (weakSelf.shopcartProxyProductSelectBlock) {
            weakSelf.shopcartProxyProductSelectBlock(isSelected, indexPath);
        }
    };
    
    cell.shopcartCellDidClickBlock = ^{
        NSLog(@"跳转");
        
        JVShopcartProductModel *model = brandModel.products[indexPath.row];
        if (weakSelf.didSelectedRowBlock) {
            weakSelf.didSelectedRowBlock(model);
        }
    };
    
    //点击商品加号减号按钮的回调方法
    cell.shopcartCellEditBlock = ^(NSInteger count){
        
        if (weakSelf.shopcartProxyChangeCountBlock) {
            
            weakSelf.shopcartProxyChangeCountBlock(count, indexPath);
            
        }
        
        //在进行商品相应的数量的变化时 刷新整个页面
        [tableView reloadData];
        
        //如果直接对相应的行数进行刷新会造成行数刷新跳动
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.row];
        //        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    
    //赋值Block，并将捕获的值赋值给UILabel
    cell.returnValueBlock = ^(UITableViewCell *deletecell){
        JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
        JVShopcartProductModel *model = brandModel.products[indexPath.row];
        if (weakSelf.shopcartProxyDeleteBlock) {
            weakSelf.shopcartProxyDeleteBlock(indexPath,model);
        }
        
    };
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (kArrayIsEmpty(self.dataArray)) {
        DCEmptyCartView *emptyCartView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DCEmptyCartView"];
        emptyCartView.contentView.backgroundColor = [UIColor whiteColor];
        emptyCartView.collectionButtonClickBlock  = ^{
            NSLog(@"点击了我的收藏");
            if (self.didSelectedBlankPageButton) {
                self.didSelectedBlankPageButton(@"点击了我的收藏");
            }
        };
        emptyCartView.browseButtonClickBlock  = ^{
            NSLog(@"点击了逛一逛");
            if (self.didSelectedBlankPageButton) {
                self.didSelectedBlankPageButton(@"点击了逛一逛");
            }
        };
        return emptyCartView;
    }else{
        JVShopcartHeaderView *shopcartHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JVShopcartHeaderView"];
        
        if (self.dataArray.count > section) {
            JVShopcartBrandModel *brandModel = self.dataArray[section];
            [shopcartHeaderView configureShopcartHeaderViewWithBrandName:brandModel.brandName brandSelect:brandModel.isSelected];
        }
        
        __weak __typeof(self) weakSelf = self;
        shopcartHeaderView.shopcartHeaderViewBlock = ^(BOOL isSelected){
            if (weakSelf.shopcartProxyBrandSelectBlock) {
                weakSelf.shopcartProxyBrandSelectBlock(isSelected, section);
            }
        };
        
        return shopcartHeaderView;
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (kArrayIsEmpty(self.dataArray)) {
        JVShopcartFooterView *shopcartFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JVShopcartFooterView"];
        shopcartFooterView.didSelectedJVShopcartFooterView = ^(NSString *goodidstring) {
            if (self.didSelectedJVShopcartTableViewProxy) {
                self.didSelectedJVShopcartTableViewProxy(goodidstring);
            }
        };
        shopcartFooterView.delegate = self;
        self.shopcartFooterView = shopcartFooterView;
        return shopcartFooterView;
        
    }else{
        if (section==self.dataArray.count-1) {
            
            JVShopcartFooterView *shopcartFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JVShopcartFooterView"];
            shopcartFooterView.didSelectedJVShopcartFooterView = ^(NSString *goodidstring) {
                if (self.didSelectedJVShopcartTableViewProxy) {
                    self.didSelectedJVShopcartTableViewProxy(goodidstring);
                }
            };
            shopcartFooterView.delegate = self;
            self.shopcartFooterView = shopcartFooterView;
            return shopcartFooterView;
            
        }else{
            return nil;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (kArrayIsEmpty(self.dataArray)) {
        return 300;
    }else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger datacount = self.shopcartFooterView.dataSource.count;
    if (kArrayIsEmpty(self.dataArray)) {
        if (datacount) {
            NSInteger x = datacount % 2;
            CGFloat cellH = ((SCREEN_WIDTH - 5)/2 + 80); //cell高度
            CGFloat marginY = 4;    //y轴间距
            if (x) {    //奇数
                x = datacount / 2 + 1; //记得+1
            }else{  //偶数
                x = datacount / 2 ; //直接得到行数
            }
//            return SCREEN_HEIGHT*2+20;
            return 50 + x * cellH + (x - 1) * marginY;
        }else{
            return 0;
        }
    }else{
        
        if (section==self.dataArray.count-1) {
            if (datacount) {
                NSInteger x = datacount % 2;
                CGFloat cellH = ((SCREEN_WIDTH - 5)/2 + 80); //cell高度
                CGFloat marginY = 4;    //y轴间距
                if (x) {    //奇数
                    x = datacount / 2 + 1; //记得+1
                }else{  //偶数
                    x = datacount / 2 ; //直接得到行数
                }
                //            return SCREEN_HEIGHT*2+20;
                return 50 + x * cellH + (x - 1) * marginY;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (kArrayIsEmpty(self.dataArray)) {
        return 0;
    }else{
        
        JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
        
        NSArray *productArray = brandModel.products;
        
        JVShopcartProductModel *productModel = productArray[indexPath.row];
        //
        return [JVShopcartCell cellHight:productModel];
        
        //        // 获取cell高度
        //        return [tableView cellHeightForIndexPath:indexPath model:productModel keyPath:@"JVShopcartProductModel" cellClass:[JVShopcartCell class] contentViewWidth:[self cellContentViewWith]];
        
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"滑动了");
    if (self.scrollViewDidScrolledBlock) {
        self.scrollViewDidScrolledBlock(scrollView);
    }
}

//适配不同的机型大小
- (CGFloat)cellContentViewWith
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    
    return width;
}

//侧滑 删除 收藏按钮 显示几个就创建几个
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
        JVShopcartProductModel *model = brandModel.products[indexPath.row];
        if (self.shopcartProxyDeleteBlock) {
            self.shopcartProxyDeleteBlock(indexPath,model);
        }
    }];
    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移入\n收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
        JVShopcartProductModel *model = brandModel.products[indexPath.row];
        if (self.shopcartProxyStarBlock) {
            self.shopcartProxyStarBlock(indexPath,model);
        }
    }];
    [deleteAction setBackgroundColor:[UIColor redColor]];
    [starAction setBackgroundColor:[UIColor orangeColor]];
    return @[deleteAction, starAction];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //这里不直接用点击事件进行传递
//    JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
//    JVShopcartProductModel *model = brandModel.products[indexPath.row];
//    if (self.didSelectedRowBlock) {
//        self.didSelectedRowBlock(model);
//    }
}


#pragma RefreshFootViewDelegate
//刷新首部数据
-(void)haveloadHeadData
{
    NSLog(@"刷新一下");
    if (self.shopcartProxyTopRefreshBlock) {
        self.shopcartProxyTopRefreshBlock();
    }
}

//刷新更多数据
-(void)haveLoadFootData:(BOOL)finishLoad
{
    NSLog(@"加载一下:%d",finishLoad);
    if (self.shopcartProxyBottomRefreshBlock) {
        self.shopcartProxyBottomRefreshBlock(finishLoad);
    }
}

@end

