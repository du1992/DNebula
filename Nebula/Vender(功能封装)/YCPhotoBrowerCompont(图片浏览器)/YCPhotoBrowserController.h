//
//  YCPhotoBrowserController.h
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/1/31.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCPhotoBrowserAnimator;
typedef NS_ENUM(NSInteger , YCIndicatorType) {
    YCIndicatorType_Number = 0,
    YCIndicatorType_dot,
};

typedef void(^LongPressBlock)(void);

@interface YCPhotoBrowserController : UIViewController

// 占位图片
@property(nonatomic,strong)UIImage                 *placeholder;
// 展示图片indexpath
@property(nonatomic,strong)NSIndexPath             *indexPath;
// 指示视图中心点
@property(nonatomic,assign)CGPoint                 indicatorCenter;
// 指示视图类型（文字和圆点）
@property(nonatomic,assign)YCIndicatorType         indicatorType;
// 长按的Block回调
@property(nonatomic,copy)LongPressBlock            longPressBlock;
// 是否展示保存图片按钮
@property(nonatomic,assign)BOOL                    isShowSaveButton;

// 有值就可以动画
@property(nonatomic,strong)YCPhotoBrowserAnimator   *browserAnimator;


//传入image
+ (instancetype)instanceWithShowImages:(NSArray<UIImage *> *)showImages;
//网络获取image
+ (instancetype)instanceWithShowImagesURLs:(NSArray<NSURL *> *)showImagesURLs urlReplacing:(NSDictionary *)parameter;

@end
