//
//  ZRAnimationFactory.m
//  ZRRefreshDemo
//
//  Created by Run on 2017/9/6.
//  Copyright © 2017年 Run. All rights reserved.
//

#import "ZRAnimationFactory.h"

@implementation ZRAnimationFactory

#pragma mark - pullingAnimation
+ (CABasicAnimation *)pullingTrasitionAnimation{

    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    positionAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    return positionAnimation;
}
+ (CABasicAnimation *)pullingRotationAnimation{
    CABasicAnimation *rotationAnimaiton = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimaiton.toValue = @(0);
    return rotationAnimaiton;
}

+ (CABasicAnimation *)pullingScaleAnimation{
    CABasicAnimation *scaleAniamtion = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAniamtion.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    return scaleAniamtion;
}

+ (CABasicAnimation *)pullingOpacityAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //opacityAnimation.fromValue = @1;
    return opacityAnimation;
}
#pragma mark - refreshingAnimation
+ (CAAnimation *)refreshingAnimationWithAnimationType: (ZRRefreshingAnimationType)animationType{
    CAAnimation *animation;
    switch (animationType) {
        case ZRRefreshingAnimationTypeOriginToTerminus: animation = [self refreshingOriginToTerminus]; break;
        case ZRRefreshingAnimationTypeMidToSide: animation = [self refreshingMidToSide]; break;
        case ZRRefreshingAnimationTypeSideToMid: animation = [self refreshingSideToMid]; break;
        case ZRRefreshingAnimationTypeWormlike: animation = [self refreshingWormlike]; break;
        case ZRRefreshingAnimationTypeWormlikeReserse: animation = [self refreshingWormlikeReserse]; break;
    }
    return animation;
}

/**
 从起点按路径执行到终点
 
 @return 动画
 */

+ (CAAnimation *)refreshingOriginToTerminus{
    CABasicAnimation *endAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimaiton.fromValue = @0;
    endAnimaiton.toValue = @1;
    return endAnimaiton;
}

/**
 从中间向两边扩散

 @return 动画
 */
+ (CAAnimation *)refreshingMidToSide{
    CABasicAnimation *endAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimaiton.fromValue = @0.5;
    endAnimaiton.toValue = @1;
    
    CABasicAnimation *startAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimaiton.fromValue = @0.5;
    startAnimaiton.toValue = @0;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAnimaiton,startAnimaiton];
    return group;
}
/**
 从两边向中间收缩
 
 @return 动画
 */
+ (CAAnimation *)refreshingSideToMid{
    CABasicAnimation *endAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimaiton.fromValue = @1;
    endAnimaiton.toValue = @0.5;
    
    CABasicAnimation *startAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimaiton.fromValue = @0;
    startAnimaiton.toValue = @0.5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAnimaiton,startAnimaiton];

    return group;
}
/**
 从左向右像虫滑动
 
 @return 动画
 */
+ (CAAnimation *)refreshingWormlike{
    CABasicAnimation *endAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimaiton.fromValue = @0;
    endAnimaiton.toValue = @1;
    
    CABasicAnimation *startAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimaiton.fromValue = @0;
    startAnimaiton.toValue = @1;
    startAnimaiton.beginTime = 0.2;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAnimaiton,startAnimaiton];
    return group;
}
/**
 从右向左像虫滑动
 
 @return 动画
 */
+ (CAAnimation *)refreshingWormlikeReserse{
    CABasicAnimation *endAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimaiton.fromValue = @1;
    endAnimaiton.toValue = @0;
    endAnimaiton.beginTime = 0.2;
    
    CABasicAnimation *startAnimaiton = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimaiton.fromValue = @1;
    startAnimaiton.toValue = @0;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAnimaiton,startAnimaiton];
    return group;
}

@end
