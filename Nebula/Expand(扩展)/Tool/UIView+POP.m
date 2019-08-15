//
//  UIView+POP.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/28.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "UIView+POP.h"

@implementation UIView (POP)

/** 弹簧动画 */
- (void)springPopAnimation{
    self.transform=CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/3.0 animations: ^{
            
            self.transform=CGAffineTransformMakeScale(1.5,1.5);
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            
            self.transform=CGAffineTransformMakeScale(0.8,0.8);
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            
            self.transform=CGAffineTransformMakeScale(1.0,1.0);
            
        }];
        
    }completion:nil];
    
    
    
}



@end
