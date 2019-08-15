//
//  ZRRefreshHeader.h
//  ZRRefreshDemo
//
//  Created by GKY on 2017/9/1.
//  Copyright © 2017年 Run. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRRefreshAnimationConfig.h"

/**
 刷新控件状态
 */
typedef NS_ENUM(NSUInteger, ZRRefreshState) {
    ZRRefreshStateIdle = 0, //闲置状态
    ZRRefreshStateRefreshing,//正在刷新状态
};

/**
 正在刷新的回调
 */
typedef void(^ZRRefreshHeaderRefreshingHandler)(void);

@interface ZRRefreshHeader : UIView

/**
 正在刷新回调
 */
@property (nonatomic,copy) ZRRefreshHeaderRefreshingHandler refreshingHandler;
/**
 刷新显示文字 默认Loading
 */
@property (nonatomic,copy) NSString *text;
/**
 刷新显示文字颜色,默认 [UIColor redColor]
 */
@property (nonatomic,strong) UIColor *textColor;
/**
 刷新显示文字字体 [UIFont systemFontOfSize:50]
 */
@property (nonatomic,strong) UIFont *textFont;
/**
 正在刷新时的线条颜色 默认
 */
@property (nonatomic,strong) UIColor *refresingLineColor;
/**
 控件的当前状态
 */
@property (nonatomic,readonly) ZRRefreshState refreshState;
/**
 最大下拉距离,下拉超过这个值且停止拖拽后开始刷新,
 默认 80.f
 */
@property (nonatomic,assign) CGFloat maxDropHeight;

@property (nonatomic,readonly,getter=isRefreshing) BOOL refreshing;

/**
 动画属性配置
 */
@property (nonatomic,strong) ZRRefreshAnimationConfig *animationConfig;

+ (instancetype)refreshHeaderWithRefreshingHandler: (ZRRefreshHeaderRefreshingHandler)handler;
+ (instancetype)refreshHeaderWithAnimationConfig: (ZRRefreshAnimationConfig *)animationConfig refreshingHandler: (ZRRefreshHeaderRefreshingHandler)handler;
//刷新文字
- (void)reloadPath;
/**
 开始刷新
 */
- (void)beginRefreshing;

/**
 结束刷新
 */
- (void)endRefreshing;
@end
