//
//  YCPhotoBrowserCell.h
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/1/31.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCPhotoBrowserConst.h"

@class YCPhotoBrowserCell;
@protocol YCPhotoBrowserCellDelegate <NSObject>
@optional
- (void)longPressPhotoBrowserCell:(YCPhotoBrowserCell *)cell;
- (void)singleTapPhotoBrowserCell:(YCPhotoBrowserCell *)cell;
@end

@interface YCPhotoBrowserCell : UICollectionViewCell
@property(nonatomic,weak)id<YCPhotoBrowserCellDelegate>        delegate;
@property(nonatomic,strong,readonly)UIImageView              *imageView;
@property(nonatomic,assign)BOOL                                isShowSaveButton;


// 提供对外两种设置image的方法（本地和网络）
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)image;
- (void)setImage:(UIImage *)image;

@end
