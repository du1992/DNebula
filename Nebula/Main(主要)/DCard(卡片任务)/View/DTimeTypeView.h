//
//  DTimeTypeView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^TimeUpdateTata)(NSUInteger TimeType);

@interface DTimeTypeView : UIView

/** 内容视图 */
@property(nonatomic,strong)UIView      *bottomView;
/** 倒计时按钮 */
@property(nonatomic,strong)UIButton   *countdownButton;
/** 计时按钮 */
@property(nonatomic,strong)UIButton   *timingButton;

@property (nonatomic,strong) TimeUpdateTata   updateTata;
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
