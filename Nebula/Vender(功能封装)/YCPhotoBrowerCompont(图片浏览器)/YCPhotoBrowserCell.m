//
//  YCPhotoBrowserCell.m
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/1/31.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "YCPhotoBrowserCell.h"
#import "YCCycleProgressView.h"
#import "UIView+YCExtension.h"
#import "UIImageView+WebCache.h"


@interface YCPhotoBrowserCell()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView             *scrollView;
@property (nonatomic,strong)YCCycleProgressView      *progressView;
@property (nonatomic,strong)UIButton                 *saveButton;
@property(nonatomic,strong,readwrite)UIImageView     *imageView;

@end

@implementation YCPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        
        [self addGestureRecognizer];
    }
    return self;
}
- (void)setupUI{
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.progressView];
    [self.scrollView addSubview:self.imageView];
}

- (void)addGestureRecognizer{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image{
    self.progressView.hidden = NO;
    if (image)  [self setupImageViewFrame:image];
    [self.imageView sd_setImageWithURL:url placeholderImage:image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        // 默认给它个0.01
        if (progress < 0.01) progress = 0.01;
        self.progressView.progress = progress;

    } completed:^(UIImage * _Nullable downloadImage, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // error 证明网络出错
        [self setupImageViewFrame:error?image:downloadImage];
        self.progressView.hidden = error?NO:YES;
    }];
}
- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
    [self setupImageViewFrame:image];
}

- (void)setupImageViewFrame:(UIImage *)image{
    if (!image)return;
    CGFloat width = ScreenW;
    CGFloat height = width / image.size.width * image.size.height;
    CGFloat y = 0;
    if (height > ScreenH) {
        y = 0;
    } else {
        y = (ScreenH - height) * 0.5;
    }
    self.imageView.frame = CGRectMake(0, y, width, height);
}

#pragma mark - UIScrollViewDelegate
// 返回一个放大或者缩小的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

// 视图放大或缩小
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = self.imageView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark - GestureRecognizer
- (void)singleTap:(UIGestureRecognizer *)recognizer{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(singleTapPhotoBrowserCell:)]) {
        [self.delegate singleTapPhotoBrowserCell:self];
    }
}

- (void)doubleTap:(UIGestureRecognizer *)recognizer{
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else{
        CGPoint touchPoint = [recognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xSize = self.bounds.size.width / newZoomScale;
        CGFloat ySize = self.bounds.size.height / newZoomScale;
        //把从scrollView里截取的矩形区域缩放到整个scrollView当前可视的frame里面
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xSize/2, touchPoint.y - ySize/2, xSize,ySize) animated:YES];
    }
}
- (void)longPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(longPressPhotoBrowserCell:)]) {
            [self.delegate longPressPhotoBrowserCell:self];
        }
    }
}

#pragma mark - 属性
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.contentView.bounds;
        _scrollView.width -= 20;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.maximumZoomScale = 3.0;
    }
    return _scrollView;
}
- (YCCycleProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[YCCycleProgressView alloc] init];
        _progressView.bounds = CGRectMake(0, 0, 60, 60);
        _progressView.center = self.contentView.center;
        _progressView.hidden = YES;
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.contentView.bounds;

    }
    return _imageView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _saveButton;
}
@end
