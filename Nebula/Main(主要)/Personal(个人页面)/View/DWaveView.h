//
//  DWaveView.h
//  D_notebook
//
//  Created by DUCHENGWEN on 2016/12/13.
//  Copyright © 2016年 DCW. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^JSWaveBlock)(CGFloat currentY);

@interface DWaveView : UIView
/**
 *  浪弯曲度
 */
@property (nonatomic, assign) CGFloat waveCurvature;
/**
 *  浪速
 */
@property (nonatomic, assign) CGFloat waveSpeed;
/**
 *  浪高
 */
@property (nonatomic, assign) CGFloat waveHeight;
/**
 *  实浪颜色
 */
@property (nonatomic, strong) UIColor *realWaveColor;
/**
 *  遮罩浪颜色
 */
@property (nonatomic, strong) UIColor *maskWaveColor;

@property (nonatomic, copy) JSWaveBlock waveBlock;

- (void)stopWaveAnimation;

- (void)startWaveAnimation;



@end
