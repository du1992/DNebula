//
//  DIndicatorView.m
//  InterstellarNotes
//
//  Created by DUCHENGWEN on 2019/1/11.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DIndicatorView.h"

@implementation DIndicatorView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor=AppAlphaColor(0,0,0, 0.7);
    }
    return self;
}

//开始动画
-(void)startAllAnimation{
    if (self.hidden==NO) {
        return;
    }
    self.hidden=NO;
    [self basicAllAnimation];
}

-(void)basicAllAnimation{
    CABasicAnimation*scaleAnimationX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimationX.fromValue = [NSNumber numberWithFloat: 0];
    scaleAnimationX.toValue = [NSNumber numberWithFloat: 1];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimationX.duration = 1;    // 持续时间
    scaleAnimationX.repeatCount = 20;//设置动画的执行次数
    scaleAnimationX.cumulative = NO;
    scaleAnimationX.removedOnCompletion = NO;
    scaleAnimationX.fillMode = kCAFillModeForwards;
    self.layer.anchorPoint=CGPointMake(0.5, 0);
    //    self.frame = CGRectMake(0,0,SCREEN_WIDTH, 3);
    [self.layer addAnimation:scaleAnimationX forKey:@"Scale.x"];
}

//删除动画
-(void)removeAllAnimation{
    if (self.layer) {
        [self.layer removeAllAnimations];
        self.hidden=YES;
    }
    
}
// 恢复
- (void)resumeLayer{
    if (self.hidden==YES) {
        return;
    }
    if (self.layer) {
        [self.layer removeAllAnimations];
        
    }
    [self basicAllAnimation];
}

@end


