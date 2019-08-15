//
//  DHomeView.m
//  D_notebook
//
//  Created by DUCHENGWEN on 2016/12/7.
//  Copyright © 2016年 DCW. All rights reserved.
//

#import "DHomeCorrugatedView.h"



@implementation UIView (FrameStuff)

- (void)setY:(CGFloat)y {
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)setX:(CGFloat)x {
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setWidth:(CGFloat)width {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

@end





@interface DHomeCorrugatedView ()

@property (nonatomic, assign) CGRect defaultTopViewRect;

@end


@implementation DHomeCorrugatedView

- (instancetype)initWithFrame:(CGRect)frame andTopView:(UIView *)topView {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
       
        [self setTopView:topView];
        [self.topView setClipsToBounds:YES];
        [self addSubview:self.topView];
        [self.topView  addSubview:self.headerView];

        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
        
        [self setStrechs:YES];
        [self setParallax:YES];
        
        self.parallaxWeight = 0.5f;
        self.defaultTopViewRect = self.topView.frame;
    }
    return self;
}

- (DWaveView *)headerView{
    
    if (!_headerView) {
        _headerView = [[DWaveView alloc] initWithFrame:CGRectMake(0,_topView.frame.size.height-10,_topView.frame.size.width,10)];
        _headerView.backgroundColor = AppColor(36,169, 225);
       [_headerView startWaveAnimation];
    }
    return _headerView;
}


- (void)addSubview:(UIView *)view {
    if (view == self.scrollView || view == self.topView) {
        [super addSubview:view];
    } else {
        [self.scrollView addSubview:view];
    }
}

- (void)setContentSize:(CGSize)size {
    [self.scrollView setContentSize:size];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        if (!self.strechs) return;
        
        float diff = -scrollView.contentOffset.y;
        float oldH = self.defaultTopViewRect.size.height;
        float oldW = self.defaultTopViewRect.size.width;
        
        float newH = oldH + diff;
        float newW = oldW*newH/oldH;
        
        _headerView.frame= CGRectMake(0,newH-10,newW, 10);
        [self.topView setFrame:CGRectMake(0, 0, newW, newH)];
        [self.topView setCenter:CGPointMake(self.center.x, self.topView.center.y)];
    }
    
    else {
        if (!self.parallax) return;
        
        float diff = scrollView.contentOffset.y;
        [self.topView setY:-diff * self.parallaxWeight];
    }
}
@end
