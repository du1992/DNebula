//
//  YCPhotoBrowserController.m
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/1/31.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "YCPhotoBrowserController.h"
#import "YCPhotoBrowserCell.h"
#import "YCPhotoBrowserConst.h"
#import "YCPhotoBrowserCellHelper.h"
#import "YCPhotoBrowserAnimator.h"
#import "UIView+YCExtension.h"

@interface YCPhotoBrowserController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,YCPhotoBrowserCellDelegate,AnimatorDismissedDelegate>
{
    long           _imagesCount;
    YCPhotoSourceType   _photoSourceType;
}
@property(nonatomic,strong)NSArray                  *showImagesOrURLs;
@property(nonatomic,strong)NSDictionary             *relaceParameter;

@property(nonatomic,strong)UICollectionView         *collectionView;
@property(nonatomic,strong)UIPageControl            *pageControl;
@property(nonatomic,strong)UILabel                  *indicatorLabel;
@end

@implementation YCPhotoBrowserController

static NSString *const PhotoBrowserCellID = @"PhotoBrowserCell";

#pragma mark - 初始化
+ (instancetype)instanceWithShowImages:(NSArray<UIImage *> *)showImages{
    NSAssert(showImages, @"showImages can‘t be nil!");
    [showImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj isKindOfClass:[UIImage class]], @"showImages must be UIImage!");
    }];
    return [[YCPhotoBrowserController alloc] initWithPhotoSourceType:YCPhotoSourceType_Image ShowImagesOrURLs:showImages urlReplacing:nil];
}
+ (instancetype)instanceWithShowImagesURLs:(NSArray<NSURL *> *)showImagesURLs urlReplacing:(NSDictionary *)parameter{
    NSAssert(showImagesURLs, @"showImagesURLs can‘t be nil!");
    [showImagesURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([obj isKindOfClass:[NSString class]]||[obj isKindOfClass:[NSURL class]], @"showImagesURLs must be NSString or NSURL!");
    }];
    
    YCPhotoSourceType sourceType = parameter ?YCPhotoSourceType_AlterURL:YCPhotoSourceType_URL;
    return [[YCPhotoBrowserController alloc] initWithPhotoSourceType:sourceType ShowImagesOrURLs:showImagesURLs urlReplacing:parameter];
}

- (instancetype)initWithPhotoSourceType:(YCPhotoSourceType )sourceType ShowImagesOrURLs:(NSArray *)showImagesOrURLs  urlReplacing:(NSDictionary *)parameter{
    if (self = [super init]) {
        _showImagesOrURLs = [showImagesOrURLs copy];
        _relaceParameter = [parameter copy];
        _photoSourceType = sourceType;
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _imagesCount = _showImagesOrURLs.count;
        _isShowSaveButton = NO;
        
        _indicatorType = YCIndicatorType_dot;
        _indicatorCenter = CGPointMake(ScreenW * 0.5, ScreenH - 50);
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    self.view.width += 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.indicatorLabel];

    [self.collectionView registerClass:YCPhotoBrowserCell.class forCellWithReuseIdentifier:PhotoBrowserCellID];
    [self.collectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    if (_imagesCount >= 0) {
        if (_indicatorType == YCIndicatorType_dot) {
            self.pageControl.hidden = NO;
        }else{
            self.indicatorLabel.hidden = NO;
        }
    }
}

#pragma mark - UICollectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoBrowserCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.isShowSaveButton = self.isShowSaveButton;
    
    // Cell适配器
    YCPhotoBrowserCellHelper *helper = [YCPhotoBrowserCellHelper helperWithPhotoSourceType:_photoSourceType imagesOrURL:self.showImagesOrURLs[indexPath.row] urlReplacing:self.relaceParameter];
    [helper setPlaceholderImage:self.placeholder];
    
    // 通过helper来处理逻辑,cell只需知道要设置本地图片或网络图片
    if (helper.isLoaclImage) {
        [cell setImage:helper.localImage];
    }else{
        [cell setImageWithURL:helper.downloadURL placeholderImage:helper.placeholderImage];
    }
    
    return cell;
}
#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取当前偏移量
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    self.pageControl.currentPage = page;
    self.indicatorLabel.text = [NSString stringWithFormat:@"%d/%ld",page + 1,_imagesCount];
    [self.indicatorLabel sizeToFit];
}

#pragma mark - YCPhotoBrowserCellDelegate
- (void)longPressPhotoBrowserCell:(YCPhotoBrowserCell *)cell{
    if (self.longPressBlock) {
        self.longPressBlock();
    }
}

- (void)singleTapPhotoBrowserCell:(YCPhotoBrowserCell *)cell{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AnimatorDismissedDelegate
- (NSIndexPath *)indexPathForDimissView{
    YCPhotoBrowserCell  *cell = self.collectionView.visibleCells.firstObject;
    return [self.collectionView indexPathForCell:cell];
}

- (UIImageView *)imageViewForDimissView{
    UIImageView *animationView = [[UIImageView alloc] init];
    YCPhotoBrowserCell  *cell = self.collectionView.visibleCells.firstObject;
    animationView.image = cell.imageView.image;
    animationView.frame = cell.imageView.frame;
    animationView.contentMode = UIViewContentModeScaleAspectFill;
    animationView.clipsToBounds = YES;
    return animationView;
}

#pragma mark - 属性
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = self.view.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        _pageControl.numberOfPages = _imagesCount;
        _pageControl.center = _indicatorCenter;
        _pageControl.hidden = YES;
    }
    return _pageControl;
}
- (UILabel *)indicatorLabel{
    if (!_indicatorLabel) {
        _indicatorLabel = [[UILabel alloc] init];
        _indicatorLabel.font = [UIFont systemFontOfSize:20];
        _indicatorLabel.textColor = [UIColor whiteColor];
        _indicatorLabel.center = _indicatorCenter;
        _indicatorLabel.hidden = YES;
    }
    return _indicatorLabel;
}

- (void)setBrowserAnimator:(YCPhotoBrowserAnimator *)browserAnimator{
    NSAssert(browserAnimator.presentedDelegate, @"please set presentedDelegate!");

    _browserAnimator = browserAnimator;
    _browserAnimator.dismissedDelegate = self;
    _browserAnimator.indexPath = self.indexPath;
    
    self.transitioningDelegate = browserAnimator;
    self.modalPresentationStyle = UIModalPresentationCustom;
}


@end
