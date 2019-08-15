//
//  LRAnimationProgress.h
//  LRAnimateProcessView
//
//  Created by luris on 2018/5/10.
//  Copyright © 2018年 luris. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LRColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 条纹倾斜方向
 
 - LRStripesOrientationRight: 向右
 - LRStripesOrientationLeft: 向左
 - LRStripesOrientationVertical: 竖直
 */
typedef NS_ENUM (NSUInteger, LRStripesOrientation)
{
    LRStripesOrientationRight       = 0,
    LRStripesOrientationLeft        = 1,
    LRStripesOrientationVertical    = 2,
};


@interface LRAnimationProgress : UIView

#pragma mark --- Configuring Progress

/**
 进度 atomic 原子性，
 */
@property (atomic, assign)CGFloat   progress;


/**
 设置进度
 
 @param progress 进度
 @param animated 是否需要动画
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;



/**
 进度条颜色数组，多组颜色会设置成渐变色
 设置该属性后， 属性progressTintColor将会失效
 */
@property (nonatomic, strong) NSArray  *progressTintColors;


/**
 进度条颜色
 default is view backgroundColor.
 */
@property (nonatomic, strong)UIColor   *progressTintColor;


/**
 进度条是否内嵌
 default  is  0.
 */
@property (nonatomic, assign)CGFloat    progressViewInset;


/**
 圆角
 default is half of height.
 */
@property (nonatomic, assign)CGFloat    progressCornerRadius;


#pragma mark --- Configuring Stripes


/**
 条纹是否运动
 defau  is NO.
 */
@property (nonatomic, getter = isStripesAnimated)BOOL stripesAnimated;


/**
 条纹运动位移
 default is 1
 */
@property (nonatomic, assign)double stripesAnimationVelocity;



/**
 条纹倾斜方向
 default is LRStripesOrientationRight
 */
@property (nonatomic, assign)LRStripesOrientation stripesOrientation;


/**
 条纹宽度
 default is 10.0f
 */
@property (nonatomic, assign)NSInteger stripesWidth;


/**
 条纹颜色
 default is purple color
 */
@property (nonatomic, strong)UIColor *stripesColor;


/**
 条纹的倾斜角度
 default is 5.0f
 */
@property (nonatomic, assign)NSInteger stripesDelta;


/**
 是否隐藏条纹
 default is NO
 */
@property (nonatomic, assign)BOOL hideStripes;


#pragma mark --- Configuring Track

/**
 是否隐藏轨迹
 default is NO
 */
@property (nonatomic, assign)BOOL hideTrack;


/**
 轨迹颜色
 default is black color
 */
@property (nonatomic, strong)UIColor  *trackTintColor;


#pragma mark --- Configuring Node


/**
 节点个数
 you can set number of nodes between 2 and 5.
 
 */
@property (nonatomic, assign)NSInteger numberOfNodes;


/**
 节点颜色
 default is track tint color.
 if no track tint color,you need set a color.
 */
@property (nonatomic, strong)UIColor   *nodeColor;


/**
 节点高亮颜色
 node had been selected.
 default is progress tint color.
 if no progress tint color, you need set a color.
 */
@property (nonatomic, strong)UIColor   *nodeHighlightColor;


/**
 节点周围的圆环效果
 default is YES.
 */
@property (nonatomic, assign)BOOL hideAnnulus;

- (instancetype)initWithFrame:(CGRect)frame;

@end

