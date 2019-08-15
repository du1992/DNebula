//
//  DCardView.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/23.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DCardView.h"
#import "DCardLayoutView.h"

@interface DCardView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    DCardLayoutView *_layout;
    NSInteger _curIndex;
}
@end

static CGFloat itemWidth = 130;
static CGFloat itemHight = 190;


@implementation DCardView

- (NSInteger)currentIndex {
    return _curIndex;
}

- (instancetype)initWithFrame:(CGRect)frame {
    _layout = [[DCardLayoutView alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView {
    _curIndex = 1;
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = NO;
    
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

#pragma mark collection协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    return _imgDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    DCardModel*model=_imgDatas[indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[model getCoverImage]];
    cell.backgroundView.contentMode=UIViewContentModeScaleAspectFill;
    cell.backgroundView.clipsToBounds = YES;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 8;
    cell.layer.borderWidth=0.1;
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    return cell;
}

// 设置每个块的宽、高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(itemWidth, itemHight);
}

// 四个边缘的间隙
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _curIndex = indexPath.row;
    DCardModel*model=_imgDatas[indexPath.row];
    if (self.updateTata) {
        self.updateTata(model, _curIndex);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger scrIndex = scrollView.contentOffset.x/(itemWidth + 10);
    // 当停止拖拽时，view不在滑动时才执行，还在滑动则调用scrollViewDidEndDecelerating
    if(!decelerate){
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        _curIndex = scrIndex + 1;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger scrIndex = scrollView.contentOffset.x/(itemWidth + 10);
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    _curIndex = scrIndex + 1;
}

@end
