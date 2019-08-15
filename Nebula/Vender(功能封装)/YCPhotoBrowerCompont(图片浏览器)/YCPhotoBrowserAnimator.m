//
//  YCPhotoBrowserAnimator.m
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/2/25.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "YCPhotoBrowserAnimator.h"
#import "YCPhotoBrowserConst.h"
#import "UIImageView+WebCache.h"


@interface YCPhotoBrowserAnimator(){
    BOOL         _isPresented;
}

@end
@implementation YCPhotoBrowserAnimator

- (instancetype)initWithPresentedDelegate:(id<AnimatorPresentedDelegate>)delegate{
    if (self = [super init]) {
        self.presentedDelegate = delegate;
    }
    return self;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    _isPresented ?[self animationForPresentedView:transitionContext]:[self animationForDismissView:transitionContext];
}

#pragma mark - <UIViewControllerTransitioningDelegate>
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _isPresented = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresented = NO;
    return self;
}

#pragma mark -
- (void)animationForPresentedView:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (!self.presentedDelegate) return;
    
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentedView];
    
    UIImageView *imageView = [self.presentedDelegate imageViewWithIndexPath:self.indexPath];
    
    UIImage *image = imageView.image;
    CGFloat h = ScreenW / image.size.width * image.size.height;
    CGFloat y = 0.0f;
    if (h > ScreenH) {
        y = 0;
    } else {
        y = (ScreenH - h) * 0.5;
    }
    CGRect endRect = CGRectMake(0, y, ScreenW, h);
    
    UIImageView *animationView = [[UIImageView alloc] init];
    animationView.image = imageView.image;
    animationView.frame = [imageView.superview convertRect:imageView.frame  toView:[UIApplication sharedApplication].keyWindow];

    animationView.contentMode = UIViewContentModeScaleAspectFill;
    animationView.clipsToBounds = YES;
    
    [transitionContext.containerView addSubview:animationView];
    
    presentedView.alpha = 0.0f;
    transitionContext.containerView.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        animationView.frame = endRect;
    }completion:^(BOOL finished) {
        [animationView removeFromSuperview];
        presentedView.alpha = 1.0f;
        transitionContext.containerView.backgroundColor = [UIColor clearColor];
        [transitionContext completeTransition:YES];
    }];
}

- (void)animationForDismissView:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (!self.presentedDelegate) return;
    
    UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [dismissView removeFromSuperview];

    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    [transitionContext.containerView addSubview:backView];

    
    UIImageView *animationView = [self.dismissedDelegate imageViewForDimissView];
    [transitionContext.containerView addSubview:animationView];
    NSIndexPath *indexPath = [self.dismissedDelegate indexPathForDimissView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        UIImageView *imageView = [self.presentedDelegate imageViewWithIndexPath:indexPath];
        CGRect endRect = [imageView.superview convertRect:imageView.frame  toView:[UIApplication sharedApplication].keyWindow];
        animationView.frame = endRect;
        backView.alpha = 0.0f;

    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
