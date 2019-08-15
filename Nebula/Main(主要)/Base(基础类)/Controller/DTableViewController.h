//
//  DTableViewController.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DTableViewController : DViewController

@property (nonatomic, strong) DTableView         *tableView;

@property (nonatomic,strong) UIImageView *emptyImageView;

//初始化区头
-(void)initializeTableHeaderView;
//添加头部刷新
-(void)addHeadRefresh;

//数据加载
-(void)seacrhTable:(BOOL)isRemove;
//结束网络刷新动画
-(void)endNetworkRequest;





@end

NS_ASSUME_NONNULL_END
