//
//  JHSlider.m
//  JHKit
//
//  Created by HaoCold on 2017/12/25.
//  Copyright © 2017年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JHSlider.h"

#define kJHMinScale 0.5
#define kJHMaxScale 1.1
#define kJHDuration 0.3

@interface JHSlider()
@property (nonatomic,  strong) UILabel *trackingLabel;
@property (nonatomic,  strong) UIView *trackingBackgroundView;
@property (nonatomic,  strong) UILabel *leftLabel;
@property (nonatomic,  strong) UIView *leftView;
@property (nonatomic,  strong) UILabel *rightLabel;
@property (nonatomic,  strong) UIView *rightView;

@property (nonatomic,  assign) BOOL  maxFlag;
@property (nonatomic,  assign) BOOL  minFlag;

@property (nonatomic,  assign) CGFloat  height;
@end

@implementation JHSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _height = CGRectGetHeight(frame);
        [self xx_setup];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"minimumValue"];
    [self removeObserver:self forKeyPath:@"maximumValue"];
}

#pragma mark - private

- (void)xx_setup
{
    _trackingLabelOffsetX = 0;
    _trackingLabelOffsetY = 10;
    _trackingBackgroundViewOffsetX = 0;
    _trackingBackgroundViewOffsetY = 10;
    
    [self addSubview:self.trackingBackgroundView];
    [self addSubview:self.trackingLabel];
    [self addSubview:self.leftLabel];
    [self addSubview:self.leftView];
    [self addSubview:self.rightLabel];
    [self addSubview:self.rightView];
    
    [self addObserver:self forKeyPath:@"minimumValue" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"maximumValue" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)xx_beginUpdateFrame
{
    [self xx_showAnimation];
    [self xx_updateFrame];
}

- (void)xx_updateFrame
{
    
    if ([_trackingLabelTextFormat length]) {
        _trackingLabel.text = [NSString stringWithFormat:_trackingLabelTextFormat,self.value];
        NSInteger transparency=[_trackingLabel.text intValue];
        if (self.transparencyUpdateTata) {
            self.transparencyUpdateTata(transparency);
        }
        NSLog(@"透明度==%ld",(long)transparency);
    }
    
    // rect
    CGRect thumbRect = [self thumbRectForBounds:self.bounds trackRect:[self trackRectForBounds:self.bounds] value:self.value];
    
    // _trackingBackgroundView's frame empty
    if (CGRectIsEmpty(_trackingBackgroundView.frame)) {
        
        CGPoint trackingLabelCenter = CGPointMake(CGRectGetMidX(thumbRect), thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
        
        // max , min
        CGFloat maxX = trackingLabelCenter.x + CGRectGetWidth(_trackingLabel.frame)*0.5 + _trackingLabelOffsetX;
        CGFloat minX = trackingLabelCenter.x - CGRectGetWidth(_trackingLabel.frame)*0.5 + _trackingLabelOffsetX;
        
        //
        if (maxX >= CGRectGetWidth(self.bounds) && _maxFlag == NO) {
            _maxFlag = YES;
            
            _trackingLabel.center = CGPointMake(CGRectGetMidX(thumbRect) + _trackingLabelOffsetX, thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
            CGRect trackingLabelFrame = _trackingLabel.frame;
            trackingLabelFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(trackingLabelFrame);
            _trackingLabel.frame = trackingLabelFrame;
            
        }
        else if (minX <= 0 && _minFlag == NO) {
            _minFlag = YES;
            
            _trackingLabel.center = CGPointMake(CGRectGetMidX(thumbRect) + _trackingLabelOffsetX, thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
            CGRect trackingLabelFrame = _trackingLabel.frame;
            trackingLabelFrame.origin.x = 0;
            _trackingLabel.frame = trackingLabelFrame;
            
        }else if (maxX < CGRectGetWidth(self.bounds) && minX > 0){
            _maxFlag = _minFlag = NO;
            
            _trackingLabel.center = CGPointMake(CGRectGetMidX(thumbRect) + _trackingLabelOffsetX, thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
        }
        
    }else{
        
        // center
        CGPoint trackingBackgroundViewCenter = CGPointMake(CGRectGetMidX(thumbRect), thumbRect.origin.y - _trackingBackgroundView.frame.size.height*0.5 - _trackingBackgroundViewOffsetY);
        CGPoint trackingLabelCenter = CGPointMake(CGRectGetMidX(thumbRect), thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
        
        // max , min
        CGFloat maxX = MAX((trackingLabelCenter.x + CGRectGetWidth(_trackingLabel.frame)*0.5 + _trackingLabelOffsetX), (trackingBackgroundViewCenter.x + CGRectGetWidth(_trackingBackgroundView.frame)*0.5 + _trackingBackgroundViewOffsetX));
        CGFloat minX = MIN((trackingLabelCenter.x - CGRectGetWidth(_trackingLabel.frame)*0.5 + _trackingLabelOffsetX), (trackingBackgroundViewCenter.x - CGRectGetWidth(_trackingBackgroundView.frame)*0.5 + _trackingBackgroundViewOffsetX));

        //
        if (maxX >= CGRectGetWidth(self.bounds) && _maxFlag == NO) {
            _maxFlag = YES;
            
            _trackingBackgroundView.center = CGPointMake(CGRectGetMidX(thumbRect) + _trackingBackgroundViewOffsetX, thumbRect.origin.y - _trackingBackgroundView.frame.size.height*0.5 - _trackingBackgroundViewOffsetY);
            CGRect trackingBackgroundViewFrame = _trackingBackgroundView.frame;
            trackingBackgroundViewFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(trackingBackgroundViewFrame);
            _trackingBackgroundView.frame = trackingBackgroundViewFrame;
            
            _trackingLabel.center = CGPointMake(_trackingBackgroundView.center.x + _trackingLabelOffsetX, thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
            
        }
        else if (minX <= 0 && _minFlag == NO) {
            _minFlag = YES;
            
            _trackingBackgroundView.center = CGPointMake(CGRectGetMidX(thumbRect) + _trackingBackgroundViewOffsetX, thumbRect.origin.y - _trackingBackgroundView.frame.size.height*0.5 - _trackingBackgroundViewOffsetY);
            CGRect trackingBackgroundViewFrame = _trackingBackgroundView.frame;
            trackingBackgroundViewFrame.origin.x = 0;
            _trackingBackgroundView.frame = trackingBackgroundViewFrame;
            
            _trackingLabel.center = CGPointMake(_trackingBackgroundView.center.x + _trackingLabelOffsetX, thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
            
        }else if (maxX < CGRectGetWidth(self.bounds) && minX > 0){
            _maxFlag = _minFlag = NO;
            
            _trackingBackgroundView.center = CGPointMake(CGRectGetMidX(thumbRect) + _trackingBackgroundViewOffsetX, thumbRect.origin.y - _trackingBackgroundView.frame.size.height*0.5 - _trackingBackgroundViewOffsetY);
            _trackingLabel.center = CGPointMake(_trackingBackgroundView.center.x + _trackingLabelOffsetX, thumbRect.origin.y - _trackingLabel.frame.size.height*0.5 - _trackingLabelOffsetY);
        }
        
    }
    
#if 0
    NSLog(@"self.bounds:%@",NSStringFromCGRect(self.bounds));
    NSLog(@"thumbRect  :%@",NSStringFromCGRect(thumbRect));
    NSLog(@"bgView     :%@",NSStringFromCGRect(_trackingBackgroundView.frame));
    NSLog(@"Label      :%@",NSStringFromCGRect(_trackingLabel.frame));
#endif
}

- (void)xx_showAnimation
{
    _trackingBackgroundView.hidden = _trackingLabel.hidden = NO;

    //
    _trackingBackgroundView.transform = CGAffineTransformScale(_trackingBackgroundView.transform, kJHMinScale, kJHMinScale);
    _trackingLabel.transform = CGAffineTransformScale(_trackingLabel.transform, kJHMinScale, kJHMinScale);
    
    //
    [UIView animateWithDuration:kJHDuration animations:^{
        _trackingBackgroundView.transform = CGAffineTransformIdentity;
        _trackingLabel.transform = CGAffineTransformIdentity;
        _trackingBackgroundView.alpha = 1;
        _trackingLabel.alpha = 1;
    }];
    
}

- (void)xx_hideAnimation{
    
    //
    _trackingBackgroundView.transform = CGAffineTransformScale(_trackingBackgroundView.transform, kJHMaxScale, kJHMaxScale);
    _trackingLabel.transform = CGAffineTransformScale(_trackingLabel.transform, kJHMaxScale, kJHMaxScale);
    
    //
    [UIView animateWithDuration:kJHDuration animations:^{
        _trackingBackgroundView.transform = CGAffineTransformScale(_trackingBackgroundView.transform, kJHMinScale, kJHMinScale);
        _trackingLabel.transform = CGAffineTransformScale(_trackingLabel.transform, kJHMinScale, kJHMinScale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kJHDuration animations:^{
            _trackingBackgroundView.alpha = 0;
            _trackingLabel.alpha = 0;
        }];
    }];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"minimumValue"]) {
        _leftLabel.text = [change[NSKeyValueChangeNewKey] stringValue];
    }
    else if ([keyPath isEqualToString:@"maximumValue"]){
        _rightLabel.text = [change[NSKeyValueChangeNewKey] stringValue];
    }
}

#pragma mark - UIControl Event

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL flag = [super beginTrackingWithTouch:touch withEvent:event];
    if (flag) {
        [self xx_beginUpdateFrame];
    }
    return flag;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL flag = [super continueTrackingWithTouch:touch withEvent:event];
    if (flag) {
        [self xx_updateFrame];
    }
    return flag;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    [self xx_updateFrame];
    [self xx_hideAnimation];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [super cancelTrackingWithEvent:event];
    [self xx_hideAnimation];
}

#pragma mark - setter & getter

- (UILabel *)trackingLabel{
    if (!_trackingLabel) {
        _trackingLabel = [[UILabel alloc] init];
        _trackingLabel.hidden = YES;
    }
    return _trackingLabel;
}

- (UIView *)trackingBackgroundView{
    if (!_trackingBackgroundView) {
        _trackingBackgroundView = [[UIView alloc] init];
        _trackingBackgroundView.hidden = YES;
    }
    return _trackingBackgroundView;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(-_height, 0, _height, _height);
        label.text = @(self.minimumValue).stringValue;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = 1;
        label.hidden = YES;
        _leftLabel = label;
    }
    return _leftLabel;
}

- (UIView *)leftView{
    if (!_leftView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(-2*_height, 0, _height, _height);
        view.hidden = YES;
        _leftView = view;
    }
    return _leftView;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, _height, _height);
        label.text = @(self.maximumValue).stringValue;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = 1;
        label.hidden = YES;
        _rightLabel = label;
    }
    return _rightLabel;
}

- (UIView *)rightView{
    if (!_rightView) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(CGRectGetWidth(self.bounds)+_height, 0, _height, _height);
        view.hidden = YES;
        _rightView = view;
    }
    return _rightView;
}

@end
