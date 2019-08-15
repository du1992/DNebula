//
//  ZRRefreshAnimationConfig.m
//  ZRRefreshDemo
//
//  Created by Run on 2017/9/6.
//  Copyright © 2017年 Run. All rights reserved.
//

#import "ZRRefreshAnimationConfig.h"

@implementation ZRRefreshAnimationConfig
@synthesize refreshingAnimation = _refreshingAnimation;
@synthesize pullingAnimation = _pullingAnimation;

+ (instancetype)animationConfig{
    return [[self alloc]init];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _randomness = 150.f;
        _angle = M_PI_4;
        _scale = CATransform3DMakeScale(0.1, 0.1, 1);
        _alpha = 0.5f;
        _repeatCount = HUGE_VALF;
        _duration = 3.f;
        _autoreverses = YES;
        _animationType = ZRRefreshingAnimationTypeMidToSide;
    }
    return self;
}
- (CAAnimation *)pullingAnimation{

    CGFloat viewHeight = 0;
    if (_viewHeightHandler) {
        viewHeight = _viewHeightHandler();
    }
    int translationX = arc4random_uniform(_randomness) * 2 - _randomness;
    CABasicAnimation *translation = [ZRAnimationFactory pullingTrasitionAnimation];
    translation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(translationX,viewHeight / 2, 0)];

    CABasicAnimation  *rotationAnimation = [ZRAnimationFactory pullingRotationAnimation];
    rotationAnimation.fromValue = @(_angle);
    
    CABasicAnimation *scaleAnimation = [ZRAnimationFactory pullingScaleAnimation];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:_scale];
    
//    CABasicAnimation *opacityAnimation = [ZRAnimationFactory pullingOpacityAnimation];
//    opacityAnimation.toValue = @(_alpha);
    
    NSMutableArray *animations = [NSMutableArray arrayWithObjects:translation,rotationAnimation,scaleAnimation, nil];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.duration = 1;
    _pullingAnimation = animationGroup;
    
    return _pullingAnimation;
}
- (CAAnimation *)refreshingAnimation{
    //if (!_refreshingAnimation) {
    _refreshingAnimation = [ZRAnimationFactory refreshingAnimationWithAnimationType:_animationType];
    _refreshingAnimation.repeatCount = _repeatCount;
    _refreshingAnimation.duration = _duration;
    _refreshingAnimation.autoreverses = _autoreverses;
    //}
    return _refreshingAnimation;
}
@end
