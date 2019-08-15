//
//  DPopModel.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/**
 显示时动画弹框样式
 */
typedef NS_ENUM(NSInteger, DAnimationPopStyle) {
    DAnimationPopStyleNO = 0,               ///< 无动画
    DAnimationPopStyleScale,                ///< 缩放动画，先放大，后恢复至原大小
    DAnimationPopStyleShakeFromTop,         ///< 从顶部掉下到中间晃动动画
    DAnimationPopStyleShakeFromBottom,      ///< 从底部往上到中间晃动动画
    DAnimationPopStyleShakeFromLeft,        ///< 从左侧往右到中间晃动动画
    DAnimationPopStyleShakeFromRight,       ///< 从右侧往左到中间晃动动画
    DAnimationPopStyleCardDropFromLeft,     ///< 卡片从顶部左侧开始掉落动画
    DAnimationPopStyleCardDropFromRight,    ///< 卡片从顶部右侧开始掉落动画
};

/**
 移除时动画弹框样式
 */
typedef NS_ENUM(NSInteger, DAnimationDismissStyle) {
    DAnimationDismissStyleNO = 0,               ///< 无动画
    DAnimationDismissStyleScale,                ///< 缩放动画
    DAnimationDismissStyleDropToTop,            ///< 从中间直接掉落到顶部
    DAnimationDismissStyleDropToBottom,         ///< 从中间直接掉落到底部
    DAnimationDismissStyleDropToLeft,           ///< 从中间直接掉落到左侧
    DAnimationDismissStyleDropToRight,          ///< 从中间直接掉落到右侧
    DAnimationDismissStyleCardDropToLeft,       ///< 卡片从中间往左侧掉落
    DAnimationDismissStyleCardDropToRight,      ///< 卡片从中间往右侧掉落
    DAnimationDismissStyleCardDropToTop,        ///< 卡片从中间往顶部移动消失
};


/**
 弹框样式
 */
typedef NS_ENUM(NSInteger, DPopViewType) {
    DCityPopView = 0,               ///< 城市弹框
    DReturnPopView,                 ///< 回归弹框
    DSharePopView,                  ///< 分享弹框
    DFoundPopView,                  ///< 发现提示弹框
};


@interface DPopModel : NSObject

@property(nonatomic)DAnimationPopStyle     popStyle;
@property(nonatomic)DAnimationDismissStyle dismissStyle;
@property(nonatomic)DPopViewType           popViewType;
@property(nonatomic)BOOL                   isSingle;

@property (nonatomic,strong)  UIColor  *   buttonColor;    //按钮颜色
@property (nonatomic,strong)  NSString *   buttonTitle;    //按钮标题
@property (nonatomic, strong) NSString *   popContent;     //描述
@property (nonatomic, strong) UIImage  *   popImage;       //图片
@property (nonatomic, strong) UIImage  *   iconImage;      //图标

@end
NS_ASSUME_NONNULL_END
