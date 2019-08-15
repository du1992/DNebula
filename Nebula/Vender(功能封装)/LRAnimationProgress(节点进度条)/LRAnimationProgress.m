//
//  LRAnimationProgress.m
//  LRAnimateProcessView
//
//  Created by luris on 2018/5/10.
//  Copyright © 2018年 luris. All rights reserved.
//

#import "LRAnimationProgress.h"

// 动画时间
const NSTimeInterval LRStripesAnimationTime     = 0.03f;
const NSTimeInterval LRProgressAnimationTime    = 0.5f;


@interface LRAnimationProgress ()

@property (nonatomic, assign) BOOL  canDrawNodes;           // 是否可以画节点

@property (nonatomic, assign) CGFloat  stripesOffset;       // 条纹偏移量
@property (nonatomic, assign) CGFloat  targetProgress;      // 目标进度
@property (nonatomic, assign) CGFloat  numberOfHighlightNodes;      // 选中节点个数

@property (nonatomic, strong) NSArray *tintColors;          // 进度条渐变颜色

@property (nonatomic, strong) NSTimer *stripesTimer;        // 条纹动画计时器
@property (nonatomic, strong) NSTimer *progressTimer;       // 进度条动画计时器


@end

@implementation LRAnimationProgress
@synthesize progress = _progress;


- (instancetype)initWithFrame:(CGRect)frame
{
    // 最小高度 14.0f
//    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, (frame.size.height>14)?frame.size.height:14);
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefaultProperty];
    }
    
    return self;
}


- (void)configDefaultProperty
{
    // 进度
    _progressTintColor = self.backgroundColor;
    _progressViewInset = 0;
    _progressCornerRadius = self.bounds.size.height*0.5;
    _targetProgress = 0;
    // 条纹
    _stripesAnimated = NO;
    _stripesAnimationVelocity = 1.0f;
    _stripesOrientation = LRStripesOrientationRight;
    _stripesWidth = 10.0f;
    _stripesColor = [LRColorWithRGB(0xffffff ) colorWithAlphaComponent:0.2f];
    _stripesDelta = 5.0f;
    _hideStripes = NO;
    _stripesOffset = 0;
    // 轨迹
    _hideTrack = NO;
    _trackTintColor = LRColorWithRGB(0xd4d4d4);
    
    // 节点
    _nodeColor = _trackTintColor;
    _nodeHighlightColor = _progressTintColor;
    _hideAnnulus = YES;
    _canDrawNodes = NO;
}



#pragma mark --- Public Method

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    @synchronized (self){
        
        [self stopProgressTimer];
        
        if (progress > 1.0f){
            progress = 1.0f;
        }
        else if (progress < 0.0f){
            progress = 0.0f;
        }
        
        _numberOfHighlightNodes = floorf(progress * _numberOfNodes + 0.5);
        
        // 如果进度，没有跑完，但节点个数却等于总节点个数，则减去1.
        if (progress < 1.0 && _numberOfHighlightNodes == _numberOfNodes) {
            _numberOfHighlightNodes -= 1;
        }
        
        if (progress > 0.0 && _numberOfHighlightNodes == 0) {
            _numberOfHighlightNodes +=1;
        }
        
        
        if (animated){
            _targetProgress = progress;
            CGFloat increment = ((_targetProgress - _progress) * LRStripesAnimationTime) / LRProgressAnimationTime;
            [self startProgressTimer:[NSNumber numberWithFloat:increment]];
        }
        else{
            _progress = progress;
            [self setNeedsDisplay];
        }
    }
}

#pragma mark --- Private Method

- (void)startStripeAnimationTimer
{
    if (!_stripesTimer){
        _stripesTimer= [NSTimer timerWithTimeInterval:LRStripesAnimationTime
                                               target:self
                                             selector:@selector(setNeedsDisplay)
                                             userInfo:nil
                                              repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_stripesTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopStripeAnimationTimer
{
    if (_stripesTimer && [_stripesTimer isValid]) {
        [_stripesTimer invalidate];
        _stripesTimer = nil;
    }
}

- (void)startProgressTimer:(NSNumber *)increment
{
    if (!_progressTimer) {
        _progressTimer = [NSTimer timerWithTimeInterval:LRStripesAnimationTime
                                                 target:self
                                               selector:@selector(updateProgress:)
                                               userInfo:increment
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    }
}


- (void)stopProgressTimer
{
    if (_progressTimer && [_progressTimer isValid]){
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}


- (void)updateProgress:(NSTimer *)timer
{
    CGFloat increment = [timer.userInfo floatValue];
    
    _progress += increment;
    
    if ((increment < 0 && _progress <= _targetProgress) || (increment > 0 && _progress >= _targetProgress)){
        [self stopProgressTimer];
        _progress = _targetProgress;
    }
    
    [self setNeedsDisplay];
}


#pragma mark --- Draw Rect

- (void)drawRect:(CGRect)rect
{
    if (self.isHidden){
        return;
    }
    
    // 当超过两条条纹宽度时，偏移量重置 ,防止条纹跑完了
    self.stripesOffset = (!_stripesAnimated || fabs(self.stripesOffset) > (2 * self.stripesWidth - 1)) ? 0 : fabs(self.stripesAnimationVelocity) + self.stripesOffset;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 以下画图，顺序不可以改.否则效果不一样.
    
    CGFloat rectH = rect.size.height;
    CGFloat rectW = rect.size.width;
    
    CGFloat progressX = 0;
    CGFloat progressY = 0;
    CGFloat progressH = rectH;
    CGFloat offsetNodeH = 6.0f; // 节点高度与总高度的偏差

    // 存在节点
    if (_canDrawNodes) {
        progressH = rectH - 10;     // 有节点，默认进度条高度 为总高度减去10
        progressX = rectH*0.5; // 进度条开始位置 高度偏差的一半给位置。
        progressY = (rectH - progressH) * 0.5;
        
        if (!_hideAnnulus) {
            // 圆环的细节，放在底部
            // 圆环的高度，默认为进度条起始位置的2倍。
            CGFloat cycleH = progressX * 2;
            CGFloat cycleX = 0; // 从 0 开始
            // 若圆环高度大于总高度，默认为总高度减去2
            if (cycleH >= rectH) {
                cycleH = rectH - 2;
                cycleX = progressX - cycleH*0.5; // 重新计算圆环起始位置
            }
            
            // 圆环的 y
            CGFloat cycleY = (rectH - cycleH)*0.5;

            // 每个节点的间距。
            CGFloat annulus =  ceilf((rect.size.width - _numberOfNodes*cycleH)/(_numberOfNodes - 1))-(_numberOfNodes==2?2:1);
            
            [self drawCycle:context x:cycleX y:cycleY h:cycleH space:annulus];
        }
    }
    
    
    if (!_hideTrack) {
        // 背景轨迹
        [self drawTrack:context rect:CGRectMake(progressX, progressY, rectW - progressX*2, progressH)];
    }
    
    
    CGRect progressRect = CGRectMake(progressX , progressY, (rectW - progressX*2)*_progress, progressH);
    // 进度条
    [self drawProgress:context rect:progressRect];
    
    if (!_hideStripes) {
        // 条纹
        [self drawStripes:context rect:progressRect];
    }
    
    
    if (_canDrawNodes) {
        // 节点
        CGFloat pointH = rectH - offsetNodeH;
        CGFloat pointX = progressX - pointH*0.5;
        CGFloat pointY = (rectH - pointH)*0.5;
        CGFloat space =  floorf((rectW - progressX*2 - (_numberOfNodes - 1)*pointH)/(_numberOfNodes - 1));
        
        [self drawPoint:context x:pointX y:pointY h:pointH space:space];
    }
}


- (void)drawPoint:(CGContextRef)context
                x:(CGFloat )x
                y:(CGFloat )y
                h:(CGFloat )h
            space:(CGFloat )space
{
    CGContextSaveGState(context);
    {
        UIBezierPath *nodes = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < _numberOfNodes; i++)
        {
            UIBezierPath *point = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(i *(space + h)+ x, y, h, h) cornerRadius:h *0.5];
            if (i < _numberOfHighlightNodes) {
                [(UIColor *)self.progressTintColors.firstObject set];
                [point fill];
                
                [[UIColor colorWithRed:180.0/255.0 green:30.0/255.0 blue:39.0/255.0 alpha:1.0] set];
                [point stroke];
            }
            else{
                [self.trackTintColor set];
                [point fill];
            }
            
            [nodes appendPath:point];
        }
    }
    CGContextRestoreGState(context);
    
}


- (void)drawCycle:(CGContextRef)context
                x:(CGFloat )x
                y:(CGFloat )y
                h:(CGFloat )h
            space:(CGFloat )space
{
    CGContextSaveGState(context);
    {
        UIBezierPath *nodes = [UIBezierPath bezierPath];
        
        for (NSInteger i = 0; i < _numberOfNodes; i++)
        {
            UIBezierPath *node = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(i * (space + h) + x, y, h, h)];
            [self.trackTintColor set];
            [node stroke];
            [nodes appendPath:node];
        }
    }
    CGContextRestoreGState(context);
    
}

- (void)drawTrack:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    {
        // 画轨迹
        UIBezierPath *trackRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_progressCornerRadius];
        [_trackTintColor set];
        [trackRect fill];
    }
    CGContextRestoreGState(context);
}

- (void)drawProgress:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    {
        UIBezierPath *progress = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_progressCornerRadius];
        
        NSUInteger colorCount = [_tintColors count];
        
        if (colorCount > 0) {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextAddPath(context, [progress CGPath]);
            CGContextClip(context);
            
            CFArrayRef colorRefs  = (__bridge CFArrayRef)_tintColors;
            
            CGFloat delta      = 1.0f/colorCount;
            CGFloat semi_delta = delta/2.0f;
            CGFloat locations[colorCount];
            
            for (NSInteger i = 0; i < colorCount; i++)
            {
                locations[i] = delta * i + semi_delta;
            }
            
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorRefs, locations);
            
            CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)), CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect), CGRectGetMinY(rect)), (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
            
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
            // 不能释放，否则_tintColors，也会一起被释放。__bridge桥接，只完成类型转换
            //            CFRelease(colorRefs);
        }
        else{
            [_progressTintColor set];
            [progress fill];
        }
    }
    CGContextRestoreGState(context);
    
}



/**
 画条纹
 
 @param context 上下文
 @param rect rect
 */
- (void)drawStripes:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    {
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        
        NSInteger start = -_stripesWidth;
        NSInteger end   = rect.size.width/(2*_stripesWidth) + (2*_stripesWidth);
        
        //
        for (NSInteger i = start; i <= end; i++)
        {
            UIBezierPath *stripe = [self createStripeWithOrigin:CGPointMake(i * 2 * _stripesWidth + self.stripesOffset, 0) rect:rect];
            [stripes appendPath:stripe];
        }
        
        // 用来剪切内部的所有的条纹内容
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_progressCornerRadius];
        
        CGContextAddPath(context, [clipPath CGPath]);
        CGContextClip(context);
        
        CGContextSaveGState(context);
        {
            // 剪切所有条纹
            CGContextAddPath(context, [stripes CGPath]);
            CGContextClip(context);
            
            CGContextSetFillColorWithColor(context, [_stripesColor CGColor]);
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    
    CGContextRestoreGState(context);
}


- (UIBezierPath *)createStripeWithOrigin:(CGPoint)origin rect:(CGRect)rect
{
    CGFloat height     = _canDrawNodes?(CGRectGetHeight(rect)+10):CGRectGetHeight(rect);
    UIBezierPath *StripeRect = [UIBezierPath bezierPath];
    
    [StripeRect moveToPoint:origin];
    [StripeRect addLineToPoint:CGPointMake(origin.x + _stripesWidth, origin.y)];
    [StripeRect addLineToPoint:CGPointMake(origin.x + _stripesWidth - _stripesDelta, origin.y + height)];
    [StripeRect addLineToPoint:CGPointMake(origin.x - _stripesDelta, origin.y + height)];
    [StripeRect addLineToPoint:origin];
    [StripeRect closePath];
    
    return StripeRect;
}



#pragma mark --- Setter && Getter

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setHideTrack:(BOOL)hideTrack
{
    _hideTrack = hideTrack;
}

- (void)setHideStripes:(BOOL)hideStripes
{
    _hideStripes = hideStripes;
    if (hideStripes) {
        [self stopStripeAnimationTimer];
    }
}

- (void)setStripesColor:(UIColor *)stripesColor
{
    if (stripesColor) {
        _stripesColor = stripesColor;
    }
}

- (void)setStripesDelta:(NSInteger)stripesDelta
{
    _stripesDelta = stripesDelta;
}


- (void)setStripesWidth:(NSInteger)stripesWidth
{
    if (stripesWidth > 0) {
        _stripesWidth = stripesWidth;
    }
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    if (trackTintColor) {
        _trackTintColor = trackTintColor;
        _nodeColor = trackTintColor;
    }
}

- (void)setStripesAnimated:(BOOL)stripesAnimated
{
    _stripesAnimated = stripesAnimated;
    if (stripesAnimated) {
        // 开启条纹滚动计时器
        [self startStripeAnimationTimer];
    }
    else{
        // 关闭
        [self stopStripeAnimationTimer];
    }
}


- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if (progressTintColor) {
        _progressTintColor = progressTintColor;
        _nodeHighlightColor = progressTintColor;
    }
}


- (void)setProgressTintColors:(NSArray *)progressTintColors
{
    if ((progressTintColors.count > 0) && (_progressTintColors != progressTintColors)) {
        _progressTintColors = progressTintColors;
        
        NSMutableArray *colors  = [NSMutableArray arrayWithCapacity:[progressTintColors count]];
        for (UIColor *color in progressTintColors)
        {
            [colors addObject:(id)color.CGColor];
        }
        _tintColors = [colors copy];
    }
}

- (void)setProgressViewInset:(CGFloat)progressViewInset
{
    _progressViewInset = progressViewInset;
}

- (void)setStripesOrientation:(LRStripesOrientation)stripesOrientation
{
    _stripesOrientation = stripesOrientation;
}

- (void)setProgressCornerRadius:(CGFloat)progressCornerRadius
{
    _progressCornerRadius = progressCornerRadius;
}

- (void)setStripesAnimationVelocity:(double)stripesAnimationVelocity
{
    _stripesAnimationVelocity = stripesAnimationVelocity;
}


- (void)setNumberOfNodes:(NSInteger)numberOfNodes
{
    if (numberOfNodes < 2 || numberOfNodes > 11) {
        NSLog(@"numberOfNodes must set number between 2 and 5.");
        _canDrawNodes = NO;
        return;
    }
    _numberOfNodes = numberOfNodes;
    _canDrawNodes = YES;
}



- (CGFloat)progress
{
    @synchronized(self){
        return _progress;
    }
}



- (void)dealloc
{
    [self stopProgressTimer];
    [self stopStripeAnimationTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
