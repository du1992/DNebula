//
//  DSliderView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/10.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSlider.h"
NS_ASSUME_NONNULL_BEGIN
@interface DSliderView : UIView

/** 内容视图 */
@property(nonatomic,strong)UIView      *bottomView;
/** 关闭按钮 */
@property(nonatomic,strong)UIButton    *closeButton;
/** 调节视图 */
@property(nonatomic,strong)JHSlider    *slider;

/**
 *  点击按钮弹出
 */
-(void)show;
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss;


@end
NS_ASSUME_NONNULL_END
