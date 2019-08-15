//
//  ZRRefreshAnimationConfig.h
//  ZRRefreshDemo
//
//  Created by Run on 2017/9/6.
//  Copyright © 2017年 Run. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRAnimationFactory.h"

@interface ZRRefreshAnimationConfig : NSObject

+ (instancetype)animationConfig;

//-------下拉动画设置
/**
 水平平移随机范围,默认为150，
 平移值为 (- randomness)  ~ (randomness - 2) 范围内的偶数
 */
@property (nonatomic) CGFloat randomness;

/**
 旋转角度,默认M_PI_4
 */
@property (nonatomic) CGFloat angle;

/*缩放
 */
@property (nonatomic) CATransform3D scale;
/*
 动画到底后的透明度 0~1 ，默认 0.5
 */
@property (nonatomic) CGFloat alpha;
/**
 下拉动画,根据参数自动生成
 */
@property (nonatomic,strong,readonly) CAAnimation *pullingAnimation;
//--------刷新动画设置
/**
 动画类型
 */
@property (nonatomic) ZRRefreshingAnimationType animationType;
@property (nonatomic) CGFloat repeatCount;

@property (nonatomic) CGFloat duration;

@property (nonatomic) BOOL autoreverses;
/**
 正在刷新的动画
 */
@property (nonatomic,strong,readonly) CAAnimation *refreshingAnimation;
//可以忽略，用于获取配置视图高度
@property (nonatomic,copy) CGFloat (^viewHeightHandler)(void);
@end
