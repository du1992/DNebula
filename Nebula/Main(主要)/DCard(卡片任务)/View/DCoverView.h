//
//  DCoverView.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/26.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCardView.h"
#import "DCardModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface DCoverView : UIView

/** 内容视图 */
@property(nonatomic,strong)UIView      *bottomView;
/** 卡片视图 */
@property(nonatomic,strong)DCardView   *cardView;
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
