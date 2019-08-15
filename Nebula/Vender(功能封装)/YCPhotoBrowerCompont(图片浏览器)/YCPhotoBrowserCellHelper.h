//
//  YCPhotoBrowserCellHelper.h
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/2/1.
//  Copyright © 2018年 WellsCai. All rights reserved.
//  适配器

#import <Foundation/Foundation.h>
#import "YCPhotoBrowserConst.h"

@interface YCPhotoBrowserCellHelper : NSObject

+ (instancetype)helperWithPhotoSourceType:(YCPhotoSourceType )sourceType imagesOrURL:(id)imagesOrURL  urlReplacing:(NSDictionary *)parameter;

- (NSURL *)downloadURL;
- (UIImage *)localImage;
- (UIImage *)placeholderImage;
- (void)setPlaceholderImage:(UIImage *)image;
- (BOOL)isLoaclImage;
@end
