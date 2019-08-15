//
//  YCCycleProgressView.m
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/2/1.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "YCCycleProgressView.h"

@implementation YCCycleProgressView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    
    CGFloat cycleRadius = rect.size.width * 0.5 - 1;
    UIBezierPath *cyclePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x + 1, rect.origin.y + 1, rect.size.width - 2, rect.size.height - 2) cornerRadius:cycleRadius];
    cyclePath.lineWidth = 2;
    [[UIColor colorWithWhite:1.0 alpha:0.8] setStroke];
    [cyclePath stroke];
    
    CGFloat radius = rect.size.width * 0.5 - 5;
    CGFloat startAngle = (CGFloat) - M_PI_2;
    
    CGFloat endAngle = (CGFloat)(2 * M_PI * self.progress) + startAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    //绘制一条道中心的线，形成扇形
    [path addLineToPoint:center];
    [path closePath];
    
    [[UIColor colorWithWhite:1.0 alpha:0.8] setFill];
    [path fill];
}


@end
