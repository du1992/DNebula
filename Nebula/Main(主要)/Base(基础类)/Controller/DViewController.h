//
//  DViewController.h
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/9.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIndicatorView.h"
#import "DBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateTata)(DBaseModel * model,NSUInteger typeIndex);

@interface DViewController : UIViewController

/** 网络刷新是否返回*/
@property (nonatomic) BOOL isRefresh;
/** 网络反馈效果*/
@property (nonatomic,strong) DIndicatorView*indicatorAnimationView;
/** 页码 默认0*/
@property (nonatomic, assign) NSInteger page;
/** 每页条数 默认12*/
@property (nonatomic, assign) NSInteger count;
/** 数据*/
@property (nonatomic, strong) NSMutableArray      *listArray;
/** 数据回传*/
@property (nonatomic,copy) UpdateTata   updateTata;

//添加左侧返回按钮
-(void)addBackItem;
//添加右侧按钮
-(void)addRightBarButtonItem:(NSString*)title;
/** 返回*/
- (void)backButtonClicked;
@end

NS_ASSUME_NONNULL_END
