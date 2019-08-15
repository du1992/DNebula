//
//  ZRAnimationFactory.h
//  ZRRefreshDemo
//
//  Created by Run on 2017/9/6.
//  Copyright © 2017年 Run. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZRRefreshingAnimationType) {
    /*从起点按路径执行到终点*/
    ZRRefreshingAnimationTypeOriginToTerminus = 0,
    /*从中间向两边扩散*/
    ZRRefreshingAnimationTypeMidToSide,
    /*从两边向中间收缩*/
    ZRRefreshingAnimationTypeSideToMid,
    /*从左向右像虫滑动*/
    ZRRefreshingAnimationTypeWormlike,
    /*从右向左像虫滑动*/
    ZRRefreshingAnimationTypeWormlikeReserse,
    
};

@interface ZRAnimationFactory : NSObject
+ (CABasicAnimation *)pullingTrasitionAnimation;
+ (CABasicAnimation *)pullingRotationAnimation;
+ (CABasicAnimation *)pullingScaleAnimation;
+ (CABasicAnimation *)pullingOpacityAnimation;
+ (CAAnimation *)refreshingAnimationWithAnimationType: (ZRRefreshingAnimationType)animationType;

@end
