//
//  DPopManager.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPopModel.h"
#import "DPopView.h"

NS_ASSUME_NONNULL_BEGIN



@interface DPopManager : UIView



/** 显示时点击背景是否移除弹框，默认为NO。 */
@property (nonatomic) BOOL isClickBGDismiss;
/** 显示时是否监听屏幕旋转，默认为NO */
@property (nonatomic) BOOL isObserverOrientationChange;
/** 显示时背景的透明度，取值(0.0~1.0)，默认为0.5 */
@property (nonatomic) CGFloat popBGAlpha;

/// 动画相关属性参数
/** 显示时动画时长，>= 0。不设置则使用默认的动画时长 */
@property (nonatomic) CGFloat popAnimationDuration;
/** 隐藏时动画时长，>= 0。不设置则使用默认的动画时长 */
@property (nonatomic) CGFloat dismissAnimationDuration;
/** 显示完成回调 */
@property (nullable, nonatomic, copy) void(^popComplete)(void);
/** 移除完成回调 */
@property (nullable, nonatomic, copy) void(^dismissComplete)(void);

/**
 *  点击确定
 */
@property (nullable, nonatomic, copy)completionHandlerBlock insideBlock;


/**
 通过自定义视图来构造弹框视图
  */
- (nullable instancetype)initWithPopModel:(DPopModel*)popModel;

/**
 显示弹框
 */
- (void)pop;

/**
 移除弹框
 */
- (void)dismiss;






@end
NS_ASSUME_NONNULL_END
