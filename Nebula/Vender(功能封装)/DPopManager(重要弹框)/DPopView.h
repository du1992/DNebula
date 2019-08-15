//
//  DPopView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/24.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPopModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface DPopView : UIView
/** 点击按钮回调*/
typedef void (^completionHandlerBlock)(void);

/**
 *  初始化Alert
 */
- (instancetype _Nullable )initWithinitModel:(DPopModel *)model;

/**
 *  点击确定
 */
@property (nullable, nonatomic, copy)completionHandlerBlock insideBlock;
/**
 *  消失
 */
@property (nullable, nonatomic, copy)completionHandlerBlock shutBlock;

/** 图片 */
@property (strong, nonatomic) UIImageView * _Nonnull imageView;



@end
NS_ASSUME_NONNULL_END
