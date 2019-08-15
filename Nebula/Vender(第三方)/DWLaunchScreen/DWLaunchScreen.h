//
//  DWLaunchScreen.h
//  DWLaunchScreen
//
//  Created by dwang_sui on 2016/11/14.
//  Copyright © 2016年 dwang. All rights reserved.
//
/*****************************Github:https://github.com/dwanghello/DWLaunchScreenTest********************/
/*****************************邮箱:dwang.hello@outlook.com***********************************************/
/*****************************QQ:739814184**************************************************************/
/*****************************QQ交流群:577506623*********************************************************/
/*****************************codedata官方群:157937068***************************************************/


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIView+Extension.h"
#import "UIImageView+GIFExtension.h"

//skip显示位置
typedef enum : NSUInteger {
    /** 右上 */
    RightTop,
    /** 左上 */
    LeftTop,
    /** 左下 */
    LeftBotton,
    /** 右下 */
    RightBotton
} SkipLocation;

/** 消失动画方式 */
typedef enum : NSUInteger {
    /** 渐变 */
    DWGradient,
    /** 放大 */
    DWAmplification,
    /** 缩小 */
    DWNarrow,
    /** 横切 */
    DWCrosscutting,
} DisappearType;

@protocol DWLaunchScreenDelegate <NSObject>

@optional
- (void)dw_didSelectImageView;

@end

@interface DWLaunchScreen : UIView

/************************************SKIP按钮*******************************/
/** skip按钮/建议不修改 */
@property (weak, nonatomic)     UIButton          *skip;

/** 是否显示跳过按钮 */
@property (assign, nonatomic)   BOOL               skipHide;

/** 是否显示倒计时时间/默认显示 */
@property(assign, nonatomic)    BOOL               skipTimerHide;

/** skip背景颜色 */
@property (strong, nonatomic)   UIColor           *skipBgColor;

/** skip字体颜色 */
@property (strong, nonatomic)   UIColor           *skipTitleColor;

/** skip显示文字 */
@property (copy, nonatomic)     NSString          *skipString;

/** 字体大小/默认14 */
@property (assign, nonatomic)   NSInteger          skipFont;

/** 是否对skip切圆/默认YES */
@property (assign, nonatomic)   BOOL               skipBounds;

/** skip圆角尺寸/默认宽度的1/6 */
@property (assign, nonatomic)   NSInteger          skipRadius;

/** skip显示位置/默认右上方 */
@property (assign, nonatomic)   SkipLocation       skipLocation;


/***********************************logo图片**********************************/
/** logo图片 */
@property (strong, nonatomic)   UIImage           *logoImage;


/***********************************设置数据**********************************/
/** 显示时长/默认3.0f */
//@property (assign, nonatomic)   NSInteger          accordingLength;

/** 消失动画时长/默认0.5f */
//@property (assign, nonatomic)   NSTimeInterval     deleteLength;

/** 消失动画方式/默认渐变消失 */
@property(assign, nonatomic)    DisappearType      disappearType;

/** 放大(默认3.0)/缩小(默认0.1)比例 */
@property(assign, nonatomic)    double             proportion;


/***********************************delegate**********************************/
/** 点击图片 */
@property (assign, nonatomic) id<DWLaunchScreenDelegate>delegate;

/**
 设置启动页数据

 @param content URL/UIImage/NSString
 @param window 主window
 @param error 错误信息
 @return 当前视图
 */
- (instancetype)dw_LaunchScreenContent:(id)content window:(UIWindow *)window withError:(void(^)(NSError *error))error;

+(void)endAnimation;

@end
