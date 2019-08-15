//
//  YCPhotoBrowserCellHelper.m
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/2/1.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "YCPhotoBrowserCellHelper.h"
#import  "UIImageView+WebCache.h"

@interface YCPhotoBrowserCellHelper ()
@property(nonatomic,strong)id                   imagesOrURL;
@property(nonatomic,assign)YCPhotoSourceType    sourceType;
@property(nonatomic,strong)NSDictionary         *relaceParameter;
@property(nonatomic,strong)UIImage              *placeholder;

@end

@implementation YCPhotoBrowserCellHelper

+ (instancetype)helperWithPhotoSourceType:(YCPhotoSourceType)sourceType imagesOrURL:(id)imagesOrURL  urlReplacing:(NSDictionary *)parameter{
    YCPhotoBrowserCellHelper *helper = [[YCPhotoBrowserCellHelper alloc] init];
    helper.imagesOrURL = imagesOrURL;
    helper.sourceType = sourceType;
    helper.relaceParameter = parameter;
    return helper;
}

- (NSURL *)downloadURL{
    // 1. 本地图片
    if (self.sourceType == YCPhotoSourceType_Image) {
        return nil;
    }
    
    // 2. 网络图片
    NSURL *url = (NSURL *)self.imagesOrURL;
    
    if (self.sourceType == YCPhotoSourceType_AlterURL){
        url = [self getBigImageURL:url];
    }
    return url;
}

- (UIImage *)localImage{
    UIImage *image = (UIImage *)self.imagesOrURL;
    return image;
}

- (UIImage *)placeholderImage{
    if (self.sourceType == YCPhotoSourceType_AlterURL){
        NSURL *url = (NSURL *)self.imagesOrURL;
        UIImage *smallImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:url.absoluteString];
        return smallImage;
    }
    return self.placeholder;
}
- (void)setPlaceholderImage:(UIImage *)image{
    self.placeholder = image;
}

- (BOOL)isLoaclImage{
    return self.sourceType == YCPhotoSourceType_Image;
}

- (NSURL *)getBigImageURL:(NSURL *)samllURL{
    __block NSString *bigURLString = samllURL.absoluteString;
    [self.relaceParameter enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull value, BOOL * _Nonnull stop) {
        bigURLString = [bigURLString stringByReplacingOccurrencesOfString:value withString:key];
    }];
    return [NSURL URLWithString:bigURLString];
}

@end
